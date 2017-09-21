-- 1. Find the movies where both Tom Cruise and Pen... C... have starred together.

SELECT MOVIE
FROM STARREDIN
WHERE CELEB LIKE 'Pen%C%'
INTERSECT
SELECT MOVIE
FROM STARREDIN
WHERE CELEB = 'Tom Cruise'

-- 2. Find all the co-stars of Nicolas Cage.

SELECT DISTINCT CELEB
FROM STARREDIN
WHERE MOVIE IN
			(SELECT MOVIE
			FROM STARREDIN
			WHERE CELEB = 'Nicolas Cage'
			)
AND NOT CELEB = 'Nicolas Cage'

-- 3. Find the movies where Tom Cruise co-starred with a celeb he is (or has been) in relationship with. The result should be (costar, movie) pairs.

SELECT CELEB AS COSTAR, MOVIE
FROM STARREDIN
WHERE MOVIE IN (SELECT DISTINCT MOVIE 
				FROM STARREDIN
				WHERE CELEB IN (SELECT CELEB2
								FROM RELATIONSHIPS
								WHERE CELEB1 = 'Tom Cruise'
								)
				INTERSECT
				SELECT DISTINCT MOVIE
				FROM STARREDIN
				WHERE CELEB = 'Tom Cruise'
				)
AND CELEB IN (SELECT CELEB2
			  FROM RELATIONSHIPS
			  WHERE CELEB1 = 'Tom Cruise') 
				
-- 4. Find the movies where a celeb co-starred with another celeb he/she is (or has been) in relationship with. The result should be (celeb1 celeb2 movie) triples.

SELECT CELEB1, CELEB2， MOVIE
FROM STARREDIN, RELATIONSHIPS
WHERE STARREDIN.CELEB = RELATIONSHIPS.CELEB1 AND CELEB1 < CELEB2
INTERSECT
SELECT CELEB1, CELEB2, MOVIE
FROM STARREDIN, RELATIONSHIPS
WHERE STARREDIN.CELEB = RELATIONSHIPS.CELEB2 AND CELEB1 < CELEB2


--5. Find how many movies each celeb has starred in. Order the results by the number of movies (in descending order). Show only the celebs who have starred in at least 10 movies.

SELECT CELEB, COUNT(CELEB)
FROM STARREDIN
GROUP BY CELEB	
HAVING COUNT(CELEB) >= 10
ORDER BY COUNT(CELEB) DESC 

--6. Find the celebs that have been in relationship with the same celeb. The result should be (celeb1, celeb2, celeb3) triples, meaning that celeb1 and celeb2 have been in relationship with celeb3.


CREATE VIEW CELEB1RELS AS 
SELECT CELEB1 AS A, CELEB2 AS B
FROM RELATIONSHIPS
WHERE CELEB1 < CELEB2;

CREATE VIEW CELEB2RELS AS 
SELECT CELEB1 AS B, CELEB2 AS C
FROM RELATIONSHIPS
WHERE CELEB1 < CELEB2;

SELECT A AS celeb1, C AS celeb2, B AS celeb3
FROM CELEB1RELS NATURAL JOIN CELEB2RELS

DROP VIEW CELEB1RELS;
DROP VIEW CELEB2RELS;



--7. For each pair of enemies give the number of movies each has starred in.
--The result should be a set of (celeb1 celeb2 n1 n2) quadruples, where n1 and n2 are the number of movies that celeb1 and celeb2 have starred in, respectively. Observe that there might be celebs with zero movies they have starred in.
			
CREATE VIEW celebMovieCount AS
SELECT starname, n
FROM (SELECT celeb AS starname, count(MOVIE)AS n FROM STARREDIN GROUP BY CELEB);

INSERT INTO celebMovieCount(starname)
SELECT celeb AS starname FROM((SELECT CELEB1 AS celeb FROM ENEMIES) UNION (SELECT CELEB2 AS celeb FROM ENEMIES)) MINUS (SELECT DISTINCT CELEB FROM STARREDIN);

SELECT celeb1, celeb2,n1,n2
FROM ENEMIES, (SELECT starname AS st1, n AS n1 FROM celebMovieCount ) NATURAL JOIN (SELECT starname AS st2, n AS n2 FROM celebMovieCount )
WHERE ENEMIES.CELEB1=st1 AND ENEMIES.CELEB2=st2;

DROP VIEW celebMovieCount;

--8. Find how many albums each celeb has released. Order the results by the number of albums (in descending order). Show only the celebs who have released at least 2 albums.

SELECT CELEB, COUNT(CELEB)
FROM RELEASES
GROUP BY CELEB HAVING COUNT(CELEB) >= 2
ORDER BY COUNT(CELEB) DESC 

--9. Find those celebs that have starred in some movie and have released some album.

SELECT CELEB
FROM STARREDIN
INTERSECT
SELECT CELEB
FROM RELEASES

--10. For each celeb that has both starred in some movie and released some album give the numbers of movies and albums he/she has starred in and released, respectively. The result should be a set of
--(celeb, number_of_movies, number_of_albums) triples.

SELECT CELEB, COUNT(DISTINCT MOVIE) AS number_of_movies, COUNT(DISTINCT ALBUM) AS number_of_albums
FROM STARREDIN JOIN RELEASES USING (CELEB)
GROUP BY CELEB

--11. Find the earliest and the latest relationship (w.r.t the start date) recorded in this database.

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







				
				
				
				
				
				
				