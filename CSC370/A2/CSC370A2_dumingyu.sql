--1-------------------
SELECT MOVIE
FROM STARREDIN
WHERE CELEB = 'Tom Cruise'
INTERSECT
SELECT MOVIE
FROM STARREDIN
WHERE CELEB LIKE 'Pen%C%'

--2-----------------------------------------------------------
SELECT DISTINCT CELEB
FROM STARREDIN
WHERE MOVIE IN 
(SELECT MOVIE FROM STARREDIN WHERE CELEB = 'Nicolas Cage') 
AND NOT CELEB = 'Nicolas Cage'

--3----------------------------------------------------------------
SELECT DISTINCT CELEB AS costar, MOVIE
FROM STARREDIN
WHERE CELEB IN (SELECT CELEB1 
				FROM RELATIONSHIPS 
				WHERE CELEB2 = 'Tom Cruise')
  AND MOVIE IN (SELECT DISTINCT MOVIE
  				FROM STARREDIN
  				WHERE CELEB IN(SELECT CELEB2
  							   FROM RELATIONSHIPS
  							   WHERE CELEB1 = 'Tom Cruise')
  				INTERSECT
  				SELECT DISTINCT MOVIE
  				FROM STARREDIN
  				WHERE CELEB = 'Tom Cruise')

--4--------------------------------------------------------------------------------
SELECT CELEB1, CELEB2, MOVIE
FROM STARREDIN, RELATIONSHIPS
WHERE STARREDIN.CELEB = RELATIONSHIPS.CELEB1 AND CELEB1 < CELEB2
INTERSECT
SELECT CELEB1, CELEB2, MOVIE
FROM STARREDIN, RELATIONSHIPS
WHERE STARREDIN.CELEB = RELATIONSHIPS.CELEB2 AND CELEB1 < CELEB2

--5---------------------------------------------------------------------------------------
SELECT CELEB, COUNT(CELEB)
FROM STARREDIN
GROUP BY CELEB HAVING COUNT(CELEB)>=10
ORDER BY COUNT(CELEB) DESC

--6---------------------------------------------------------------------------------------
CREATE VIEW Celeb1Rels AS
SELECT celeb1 AS A, celeb2 AS B
FROM Relationships
WHERE celeb1 < celeb2;

CREATE VIEW Celeb2Rels AS
SELECT celeb1 AS B, celeb2 AS C
FROM Relationships
WHERE celeb1 < celeb2;

SELECT A AS celeb1, C AS celeb2, B AS celeb3
FROM Celeb1Rels NATURAL JOIN Celeb2Rels;

DROP VIEW Celeb1Rels;
DROP VIEW Celeb2Rels;

--7---------------------------------------------------------------------------------------
CREATE VIEW moviecount AS
SELECT starname, cnt
FROM (SELECT celeb AS starname, count(MOVIE)AS cnt FROM STARREDIN GROUP BY CELEB);

INSERT INTO moviecount(starname)
SELECT celeb AS starname FROM((SELECT celeb1 AS celeb FROM ENEMIES) UNION (SELECT CELEB2 AS celeb FROM enemies)) minus (SELECT distinct celeb FROM starredin);

SELECT celeb1, celeb2,n1,n2
FROM ENEMIES, (SELECT starname AS st1, cnt AS n1 FROM moviecount ) NATURAL JOIN (SELECT starname AS st2, cnt AS n2 FROM moviecount )
WHERE enemies.CELEB1=st1 AND enemies.CELEB2=st2;

DROP VIEW moviecount;
--8---------------------------------------------------------------------------------------
SELECT CELEB, COUNT(CELEB)
FROM RELEASES
GROUP BY CELEB HAVING COUNT(CELEB)>=2
ORDER BY COUNT(CELEB) DESC

--9---------------------------------------------------------------------------------------
SELECT CELEB
FROM STARREDIN
INTERSECT
SELECT CELEB
FROM RELEASES

--10----------------------------------------------------------------------------------------------
SELECT CELEB, COUNT(DISTINCT MOVIE) AS number_of_movies, COUNT(DISTINCT ALBUM) AS number_of_albums
FROM STARREDIN JOIN RELEASES USING(CELEB)
GROUP BY CELEB

--11--------------------------------------------------------------------------------------
SELECT CELEB1, CELEB2, STARTED, ENDED
FROM RELATIONSHIPS
WHERE STARTED = (SELECT MIN(STARTED)
					FROM RELATIONSHIPS)
AND CELEB1 < CELEB2
UNION
SELECT CELEB1, CELEB2, STARTED, ENDED
FROM RELATIONSHIPS
WHERE STARTED = (SELECT MAX(STARTED)
					FROM RELATIONSHIPS)
AND CELEB1 < CELEB2