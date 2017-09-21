--Exercise 1----------------------------------------------------
CREATE TABLE Classes(
	class CHAR(20),
	type CHAR(20),
	country CHAR(20),
	numGuns INT,
	bore INT,
	displacement INT,
	PRIMARY KEY(class)
);

CREATE TABLE Ships(
	name CHAR(20),
	class CHAR(20),
	launched CHAR(20),
	PRIMARY KEY(name)
);

CREATE TABLE Battles(
	name CHAR(20),
	date_fought CHAR(20),
	PRIMARY KEY(name)
);

CREATE TABLE Outcomes(
	ship CHAR(20),
	battle CHAR(20),
	result CHAR(20),
	PRIMARY KEY(ship)
);

INSERT INTO Classes VALUES('Bismarck','bb','Germany',8,15,42000);
INSERT INTO Classes VALUES('Kongo','bc','Japan',8,14,32000);
INSERT INTO Classes VALUES('North Carolina','bb','USA',9,16,37000);
INSERT INTO Classes VALUES('Renown','bc','Gt. Britain',6,15,32000);
INSERT INTO Classes VALUES('Revenge','bb','Gt. Britain',8,15,29000);
INSERT INTO Classes VALUES('Tennessee','bb','USA',12,14,32000);
INSERT INTO Classes VALUES('Yamato','bb','Japan',9,18,65000);

INSERT INTO ships VALUES('California','Tennessee',1921);
INSERT INTO ships VALUES('Haruna','Kongo',1915);
INSERT INTO ships VALUES('Hiei','Kongo',1914);
INSERT INTO ships VALUES('Iowa','Iowa',1943);
INSERT INTO ships VALUES('Kirishima','Kongo',1914);
INSERT INTO ships VALUES('Kongo','Kongo',1913);
INSERT INTO ships VALUES('Missouri','Iowa',1944);
INSERT INTO ships VALUES('Musashi','Yamato',1942);
INSERT INTO ships VALUES('New Jersey','Iowa',1943);
INSERT INTO ships VALUES('North Carolina','North Carolina',1941);
INSERT INTO ships VALUES('Ramilles','Revenge',1917);
INSERT INTO ships VALUES('Renown','Renown',1916);
INSERT INTO ships VALUES('Repulse','Renown',1916);
INSERT INTO ships VALUES('Resolution','Revenge',1916);
INSERT INTO ships VALUES('Revenge','Revenge',1916);
INSERT INTO ships VALUES('Royal Oak','Revenge',1916);
INSERT INTO ships VALUES('Royal Sovereign','Revenge',1916);
INSERT INTO ships VALUES('Tennessee','Tennessee',1920);
INSERT INTO ships VALUES('Washington','North Carolina',1941);
INSERT INTO ships VALUES('Wisconsin','Iowa',1944);
INSERT INTO ships VALUES('Yamato','Yamato',1941);

INSERT INTO Battles VALUES('North Atlantic','27-May-1941');
INSERT INTO Battles VALUES('Guadalcanal','15-Nov-1942');
INSERT INTO Battles VALUES('North Cape','26-Dec-1943');
INSERT INTO Battles VALUES('Surigao Strait','25-Oct-1944');

INSERT INTO Outcomes VALUES('Bismarck','North Atlantic', 'sunk');
INSERT INTO Outcomes VALUES('California','Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Duke of York','North Cape', 'ok');
INSERT INTO Outcomes VALUES('Fuso','Surigao Strait', 'sunk');
INSERT INTO Outcomes VALUES('Hood','North Atlantic', 'sunk');
INSERT INTO Outcomes VALUES('King George V','North Atlantic', 'ok');
INSERT INTO Outcomes VALUES('Kirishima','Guadalcanal', 'sunk');
INSERT INTO Outcomes VALUES('Prince of Wales','North Atlantic', 'damaged');
INSERT INTO Outcomes VALUES('Rodney','North Atlantic', 'ok');
INSERT INTO Outcomes VALUES('Scharnhorst','North Cape', 'sunk');
INSERT INTO Outcomes VALUES('South Dakota','Guadalcanal', 'ok');
INSERT INTO Outcomes VALUES('West Virginia','Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Yamashiro','Surigao Strait', 'sunk');

--Exercise 2----------------------------------------------------------------------------

--2.1---------------- 
SELECT name FROM Classes RIGHT OUTER JOIN Ships USING(class) WHERE displacement > 35000;

--2.2----------------
CREATE VIEW ex2q2 AS (SELECT ship AS name, battle FROM outcomes WHERE BATTLE = 'Guadalcanal');
CREATE VIEW ex2q21 AS (SELECT name, battle, class FROM ex2q2 FULL OUTER JOIN ships USING (name));
SELECT name, displacement, numGuns FROM ex2q21 FULL OUTER JOIN classes USING (class) WHERE BATTLE = 'Guadalcanal';
DROP VIEW ex2q21;
DROP VIEW ex2q2;

--2.3----------------
SELECT SHIP
FROM OUTCOMES
UNION
SELECT NAME
FROM SHIPS;

--2.4----------------
SELECT country FROM Classes WHERE type='bb'
INTERSECT
SELECT country FROM Classes WHERE type='bc';

--2.5-----------------
SELECT ship 
FROM Outcomes 
WHERE result <> 'damaged' AND ship IN (SELECT ship FROM Outcomes WHERE result = 'damaged');

--2.6-----------------
SELECT country FROM Classes WHERE numguns = (SELECT MAX(NUMGUNS) FROM Classes);

--2.7-Find the names of the ships whose number of guns was the largest for those ships of the same bore
CREATE VIEW EX2Q7 AS(SELECT name, numguns, bore FROM Classes NATURAL JOIN Ships);

SELECT name FROM EX2Q7 a WHERE numguns = (SELECT MAX(numguns) FROM EX2Q7 WHERE bore = a.bore);
					
DROP VIEW EX2Q7;

--2.8-Find for each class with at least three ships the number of ships of that class sunk in battle
CREATE VIEW ex2q8 AS (SELECT ship AS name, battle, result FROM outcomes);
CREATE VIEW ex2q81 AS (SELECT class, name FROM classes FULL OUTER JOIN ships USING (class));
CREATE VIEW ex2q82 AS (SELECT class, name, result FROM ships LEFT OUTER JOIN ex2q8 USING (name));
CREATE VIEW ex2q83 AS (SELECT * FROM ex2q81 FULL OUTER JOIN ex2q82 USING (name,class));

SELECT class, count(result) AS numOfSunk FROM ex2q83 GROUP BY class HAVING count(name)>=3;

DROP VIEW ex2q83;
DROP VIEW ex2q82;
DROP VIEW ex2q81;
DROP VIEW ex2q8;
  
--Exercise 3----------------------------------------------------------------------------------------

--3.1-Two of the three battleships of the Italian Vittorio Veneto class –
------Vittorio Veneto and Italia – were launched in 1940; the third ship of that class,
------Roma, was launched in 1942. Each had 15-inch guns and a displacement of
------41,000 tons. Insert these facts into the DATABASE
INSERT INTO Classes VALUES ('Vittorio Veneto'，'bb', 'Italia', NULL, 15, 41000);
INSERT INTO Ships VALUES ('Vittorio Veneto', 'Vittorio Veneto', 1940);
INSERT INTO Ships VALUES ('Itaila', 'Vittorio Veneto', 1940);
INSERT INTO Ships VALUES ('Roma', 'Vittorio Veneto', 1942);

--3.2-Delete all classes with fewer than three ships
DELETE FROM classes
WHERE class NOT IN (
	SELECT class
	FROM Ships outer join classes using(class)
	group by class
	having count(name)>=3
	);

--3.3-Modify the Classes relation so that gun bores are measured in centimeters
------(one inch = 2.5 cm) and displacements are measured in metric tons (one metric ton = 1.1 ton)
UPDATE classes
SET bore=bore*2.5, DISPLACEMENT=DISPLACEMENT*1.1;

--Exercise 4----------------------------------------------------------------------------------------

--4.1-Every class mentioned in Ships must be mentioned in Classes
ALTER TABLE Classes ADD CONSTRAINT classes_pk PRIMARY KEY(class);

CREATE TABLE Exceptions(
				row_id ROWID,
				owner VARCHAR2(30),
				table_name VARCHAR2(30),
				constraint VARCHAR2(30)
);

ALTER TABLE Ships ADD CONSTRAINT ship_to_classes_fk FOREIGN KEY(class) REFERENCES Classes(class) EXCEPTIONS INTO Exceptions;
DELETE FROM Ships WHERE class IN ( SELECT class FROM Ships, Exceptions WHERE Ships.rowid = Exceptions.row_id );
ALTER TABLE Ships ADD CONSTRAINT ship_to_classes_fk FOREIGN KEY(class) REFERENCES Classes(class);
DROP TABLE Exceptions;

--4.2-Every battle mentioned in Outcomes must be mentioned in Battles
ALTER TABLE battles ADD CONSTRAINT battles_pk PRIMARY KEY(name);
ALTER TABLE outcomes ADD CONSTRAINT o_to_b_fk
FOREIGN KEY(battle) REFERENCES battles(name)
EXCEPTIONS INTO Exceptions;
DELETE FROM outcomes
WHERE battle IN (
SELECT battle
FROM outcomes, Exceptions
WHERE outcomes.rowid = Exceptions.row_id
);
ALTER TABLE outcomes ADD CONSTRAINT o_to_b_fk
FOREIGN KEY(battle) REFERENCES battles(name);

--4.3-Every ship mentioned in Outcomes must be mentioned in Ships
ALTER TABLE ships ADD CONSTRAINT ships_pk PRIMARY KEY(name);
ALTER TABLE outcomes ADD CONSTRAINT o_to_s_fk
FOREIGN KEY(ship) REFERENCES ships(name)
EXCEPTIONS INTO Exceptions;
DELETE FROM outcomes
WHERE ship IN (
SELECT ship
FROM outcomes, Exceptions
WHERE outcomes.rowid = Exceptions.row_id
);
ALTER TABLE outcomes ADD CONSTRAINT o_to_s_fk
FOREIGN KEY(ship) REFERENCES ships(name);

--4.4-No class of ships may have guns with larger than 16-inch bore
ALTER TABLE classes ADD CONSTRAINT check_bore Check(bore<=16)
EXCEPTIONS INTO Exceptions;
ALTER TABLE ships DROP CONSTRAINT ship_to_classes_fk;DELETE FROM classes WHERE classes.bore IN ( SELECT distinct bore FROM classes,
Exceptions WHERE classes.rowid = Exceptions.row_id );
ALTER TABLE classes ADD CONSTRAINT check_bore Check(bore<=16)

--4.5-If a class of ships has more than 9 guns, then their bore must be no larger than 14 inches
ALTER TABLE classes ADD CONSTRAINT check_q6 Check(not(numguns>=9) or
bore<=14)
EXCEPTIONS INTO Exceptions;
DELETE FROM classes where class in(SELECT classes.class FROM classes,
Exceptions WHERE classes.rowid = Exceptions.row_id)

--4.6-No ship can be in battle before it is launched
CREATE OR REPLACE VIEW OutcomesView AS
SELECT ship, battle, result
FROM Outcomes O
WHERE NOT EXISTS (
SELECT *
FROM Ships S, Battles B
WHERE S.name=O.ship AND O.battle=B.name AND
S.launched > TO_NUMBER(TO_CHAR(B.date_fought, 'yyyy'))
)
WITH CHECK OPTION;

DROP VIEW OutcomesView;

--4.7-No ship can be launched before the ship that bears the name of the first ship’s class
CREATE OR REPLACE VIEW q9View AS
SELECT a.name,a.class, launched
FROM ships a
WHERE NOT EXISTS (
SELECT *
FROM Ships S, classes b
WHERE S.name=a.name AND a.CLASS=b.class and
S.launched < (select min(launched) from ships d where d.class=a.class)
)
WITH CHECK OPTION;

DROP VIEW q9View;

--4.8-No ship fought in a battle that was at a later date than another battle in which that ship was sunk
CREATE OR REPLACE VIEW a8 AS
SELECT ship, battle,d.date_fought
FROM Outcomes O,Battles d
WHERE NOT EXISTS (
SELECT *
FROM Ships S, Battles B
WHERE S.name=O.ship AND O.battle=B.name AND
TO_NUMBER(TO_CHAR(B.DATE_FOUGHT,'yyyy')) > TO_NUMBER(TO_CHAR((SELECT a.DATE_FOUGHT from battles a ,outcomes b
							where b.result='sunk' and a.name=b.battle), 'yyyy'))
)
WITH CHECK OPTION;

DROP VIEW a8;
