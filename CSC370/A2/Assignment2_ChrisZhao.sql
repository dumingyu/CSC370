/*Question 1*/
SELECT MOVIE
FROM  (SELECT MOVIE, S1.CELEB AS Q1C1, S2.CELEB AS Q1C2
	  FROM STARREDIN S1 JOIN STARREDIN S2
	  USING (Movie)
	  )
WHERE Q1C1='Tom Cruise' AND Q1C2 LIKE'%Cruz%'; 

/*Question 2*/
SELECT C2
FROM (SELECT MOVIE, S1.CELEB AS C1, S2.CELEB AS C2
	  FROM STARREDIN S1 JOIN STARREDIN S2
	  USING (Movie)
	  )
WHERE C1='Nicolas Cage' AND C2<> 'Nicolas Cage';

/*Question 3*/
SELECT costar, MOVIE
FROM (SELECT  MOVIE, S1.CELEB AS C1, S2.CELEB AS costar 
	  FROM STARREDIN S1 JOIN STARREDIN S2
	  USING (Movie) 
	  ), RELATIONSHIPS
WHERE C1=RELATIONSHIPS.CELEB1 AND C1='Tom Cruise' AND costar=RELATIONSHIPS.CELEB2;

/*Question 4*/
SELECT C1,C2, MOVIE
FROM (SELECT MOVIE, S1.CELEB AS C1, S2.CELEB AS C2
	  FROM STARREDIN S1 JOIN STARREDIN S2
	  USING (Movie) 
	  ), RELATIONSHIPS
WHERE C1=RELATIONSHIPS.CELEB1 AND C2=RELATIONSHIPS.CELEB2 AND C1<C2;

/*Question 5*/
SELECT CELEB, count(MOVIE)
FROM STARREDIN
GROUP BY CELEB
HAVING count(MOVIE)>=10
ORDER BY count(movie) DESC;

/*Question 6*/
SELECT r1c1 AS celeb1, r2c1 AS celeb2, CELEB2 AS celeb3 
FROM (SELECT CELEB1 AS r1c1 ,CELEB2 FROM RELATIONSHIPS) R1 JOIN (SELECT CELEB1 as r2c1 ,CELEB2 FROM RELATIONSHIPS) R2 USING(celeb2) WHERE r1c1<>r2c1;

/*question 7*/
CREATE VIEW moviecount AS /*Step 1*/
SELECT starname, cnt
FROM (SELECT celeb AS starname, count(MOVIE)AS cnt FROM STARREDIN GROUP BY CELEB);

INSERT INTO moviecount(starname) /*Step 2*/
SELECT celeb AS starname FROM((SELECT celeb1 AS celeb FROM ENEMIES) UNION (SELECT CELEB2 AS celeb FROM enemies)) minus (SELECT distinct celeb FROM starredin);

SELECT celeb1, celeb2,n1,n2 /*Step 3*/
FROM ENEMIES, (SELECT starname AS st1, cnt AS n1 FROM moviecount ) NATURAL JOIN (SELECT starname AS st2, cnt AS n2 FROM moviecount )
WHERE enemies.CELEB1=st1 AND enemies.CELEB2=st2;

DROP VIEW moviecount;
/*Question 8*/
SELECT celeb, count(ALBUM)
FROM RELEASES
GROUP BY CELEB
HAVING count(ALBUM)>=2
ORDER BY count(ALBUM) DESC;

/*Question 9*/
SELECT celeb
FROM (SELECT celeb FROM STARREDIN GROUP BY celeb) UNION (SELECT celeb FROM RELEASES GROUP BY celeb);

/*Question 10*/
SELECT celeb, number_of_movies, number_of_albums
FROM (SELECT celeb, count(MOVIE) AS number_of_movies FROM STARREDIN GROUP BY celeb) join (SELECT celeb,count(ALBUM) AS number_of_albums FROM RELEASES GROUP BY celeb)
using(celeb);

/*Question 11*/
/*latest relationship*/
SELECT *
FROM relationships
WHERE started=(SELECT max(started) AS mx
	FROM RELATIONSHIPS) AND celeb1<celeb2;

/*Min relationship*/
SELECT *
FROM relationships
WHERE started=(SELECT min(started) AS mx
	FROM RELATIONSHIPS) AND celeb1<celeb2;
