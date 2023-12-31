--DIFICULTAD: Muy fácil

--1.Devuelve todas las películas

SELECT * FROM MOVIES


--2. Devuelve todos los géneros existentes

SELECT * FROM GENRES


--3. Devuelve la lista de todos los estudios de grabación que estén activos

SELECT * FROM STUDIOS WHERE STUDIO_ACTIVE = 1


--4. Devuelve una lista de los 20 últimos miembros en anotarse al videoclub

SELECT * FROM MEMBERS
ORDER BY MEMBER_ID DESC
LIMIT 21;


--DIFICULTAD: Fácil

--5. Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor.

SELECT MOVIE_DURATION, COUNT(*) AS FRECUENCY
FROM MOVIES
GROUP BY DURATION
ORDER BY FRECUENCY DESC
LIMIT 20;


--6. Devuelve las películas del año 2000 en adelante que empiecen por la letra A.

SELECT *
FROM MOVIES
WHERE MOVIE_LAUNCH_DATE > '1999-12-31'
AND MOVIE_NAME LIKE 'A%';


--7. Devuelve los actores nacidos un mes de Junio

SELECT *
FROM ACTORS
WHERE EXTRACT(MONTH FROM ACTOR_BIRTH_DATE) = 6;


--8. Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos.

SELECT *
FROM ACTORS
WHERE EXTRACT(MONTH FROM ACTOR_BIRTH_DATE) <> 6
AND ACTOR_DEAD_DATE IS NULL;


--9. Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos

SELECT DIRECTOR_NAME, DATEDIFF(YEAR, DIRECTOR_BIRTH_DATE, TODAY()) AS "AGE"
FROM DIRECTORS
WHERE DATEDIFF(YEAR, DIRECTOR_BIRTH_DATE, TODAY()) <=50
AND DIRECTOR_DEAD_DATE IS NULL;


--10. Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido

SELECT ACTOR_NAME
FROM ACTORS
WHERE YEAR(CURDATE())-YEAR(ACTOR_BIRTH_DATE) <= 50
AND ACTOR_DEAD_DATE IS NOT NULL;


--11. Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos

SELECT DIRECTOR_NAME
FROM DIRECTORS
WHERE YEAR(CURDATE())-YEAR(DIRECTOR_BIRTH_DATE) <= 40
AND DIRECTOR_DEAD_DATE IS NULL;


--12. Indica la edad media de los directores vivos

SELECT AVG(YEAR(CURDATE()) - YEAR(DIRECTOR_BIRTH_DATE)) AS AVERAGE_AGE
FROM DIRECTORS
WHERE DIRECTOR_DEAD_DATE IS NULL;


--13. Indica la edad media de los actores que han fallecido

SELECT AVG(YEAR(CURDATE()) - YEAR(ACTOR_BIRTH_DATE)) AS AVERAGE_AGE
FROM ACTORS
WHERE ACTOR_DEAD_DATE IS NOT NULL;


--DIFICULTAD: Media

--14. Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado

SELECT MOVIES.MOVIE_NAME, STUDIOS.STUDIO_NAME
FROM MOVIES
INNER JOIN STUDIOS ON MOVIES.STUDIO_ID = STUDIOS.STUDIO_ID;


--15. Devuelve los miembros que alquilaron al menos una película entre el año 2010 y el 2015

SELECT DISTINCT 
	MEMBER_NAME
FROM
	MEMBERS
INNER JOIN MEMBERS_MOVIE_RENTAL ON
	MEMBERS.MEMBER_ID = MEMBERS_MOVIE_RENTAL.MEMBER_ID
WHERE
	YEAR(MEMBER_RENTAL_DATE) BETWEEN 2010 AND 2015;


--16. Devuelve cuantas películas hay de cada país

SELECT NATIONALITIES.NATIONALITY_NAME, COUNT(MOVIES.NATIONALITY_ID) AS NATIONALITY_FREQUENCY
FROM NATIONALITIES
INNER JOIN MOVIES ON NATIONALITIES.NATIONALITY_ID = MOVIES.NATIONALITY_ID
GROUP BY NATIONALITIES.NATIONALITY_NAME;


--17. Devuelve todas las películas que hay de género documental

SELECT
	MOVIE_NAME
FROM
	MOVIES
INNER JOIN GENRES ON
	MOVIES.GENRE_ID = GENRES.GENRE_ID
WHERE GENRE_NAME = 'Documentary'

--SUBCONSULTA:

SELECT 
    *
FROM 
    MOVIES 
WHERE 
    GENRE_ID = (SELECT GENRE_ID FROM GENRES WHERE GENRE_NAME = 'Documentary')


--18. Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos

SELECT
	MOVIE_NAME
FROM
	MOVIES
INNER JOIN DIRECTORS ON
	MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
WHERE YEAR(DIRECTORS.DIRECTOR_BIRTH_DATE) >= 1980 AND DIRECTORS.DIRECTOR_DEAD_DATE IS NULL;


--19. Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros del videoclub y los directores.

SELECT

    M.MEMBER_NAME,

    D.DIRECTOR_NAME,

    D.DIRECTOR_BIRTH_PLACE

FROM

    MEMBERS M

INNER JOIN DIRECTORS D ON

    M.MEMBER_TOWN = D.DIRECTOR_BIRTH_PLACE


--20. Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo

SELECT
	MOVIE_NAME,
	YEAR(MOVIE_LAUNCH_DATE) AS RELEASE_YEAR
FROM
	MOVIES
INNER JOIN STUDIOS ON
	MOVIES.STUDIO_ID = STUDIOS.STUDIO_ID
WHERE
	STUDIO_ACTIVE = 0


--21. Devuelve una lista de las últimas 10 películas que se han alquilado

SELECT
	*
FROM
	MOVIES
INNER JOIN PUBLIC.MEMBERS_MOVIE_RENTAL ON
	MEMBERS_MOVIE_RENTAL.MOVIE_ID = MOVIES.MOVIE_ID
ORDER BY MEMBER_RENTAL_DATE
DESC 
LIMIT 10;


--22. Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT

    D.DIRECTOR_NAME,
    COUNT(M.MOVIE_NAME) AS MOVIE_COUNTER
FROM
    MOVIES M
INNER JOIN DIRECTORS D ON
    M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE DATEDIFF(YEAR, D.DIRECTOR_BIRTH_DATE, M.MOVIE_LAUNCH_DATE) < 41
GROUP BY D.DIRECTOR_NAME;


--23. Indica cuál es la media de duración de las películas de cada director

SELECT
    D.DIRECTOR_NAME,
    AVG(M.MOVIE_DURATION) AS AVERAGE_MOVIE_DURATION
FROM
    MOVIES M
INNER JOIN DIRECTORS D ON
    M.DIRECTOR_ID = D.DIRECTOR_ID
GROUP BY D.DIRECTOR_NAME;


--24. Indica cuál es el nombre y la duración mínima de las películas que han sido alquiladas en los últimos 2 años por los miembros del videoclub (La "fecha de ejecución" en este script es el 25-01-2019)

SELECT
    M.MOVIE_NAME,
    M.MOVIE_DURATION
FROM
    MOVIES M
INNER JOIN PUBLIC.MEMBERS_MOVIE_RENTAL R ON
    M.MOVIE_ID = R.MOVIE_ID
WHERE 2019-YEAR(R.MEMBER_RENTAL_DATE)=2
ORDER BY M.MOVIE_DURATION ASC
LIMIT 1;


--25. Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra "The" en cualquier parte del título

SELECT
    D.DIRECTOR_NAME,
    COUNT(M.MOVIE_NAME)
FROM
    MOVIES M
INNER JOIN DIRECTORS D ON
    M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE M.MOVIE_LAUNCH_DATE >= '1960-01-01' AND M.MOVIE_LAUNCH_DATE <= '1989-12-31'
AND UPPER(M.MOVIE_NAME) LIKE '%THE%'
GROUP BY D.DIRECTOR_NAME;


--DIFICULTAD: Difícil

--26. Lista nombre, nacionalidad y director de todas las películas

SELECT
    M.MOVIE_NAME,
    N.NATIONALITY_NAME AS NATIONALITY,
    D.DIRECTOR_NAME
FROM
    MOVIES M
INNER JOIN DIRECTORS D ON
    M.DIRECTOR_ID = D.DIRECTOR_ID
INNER JOIN NATIONALITIES N ON
    M.NATIONALITY_ID = N.NATIONALITY_ID;


--27. Muestra las películas con los actores que han participado en cada una de ellas

SELECT
    M.MOVIE_NAME,
    A.ACTOR_NAME
FROM
    MOVIES_ACTORS MA
INNER JOIN MOVIES M ON
    M.MOVIE_ID = MA.MOVIE_ID
INNER JOIN ACTORS A ON
	A.ACTOR_ID = MA.ACTOR_ID 
ORDER BY MOVIE_NAME


--28. Indica cual es el nombre del director del que más películas se han alquilado INCOMPLETO

SELECT
    D.DIRECTOR_NAME,
    COUNT(MMR.MEMBER_RENTAL_DATE) AS RENTAL_COUNTER
FROM
    MOVIES M
INNER JOIN DIRECTORS D ON
    M.DIRECTOR_ID = D.DIRECTOR_ID
INNER JOIN MEMBERS_MOVIE_RENTAL MMR ON
    M.MOVIE_ID = MMR.MOVIE_ID 
GROUP BY D.DIRECTOR_NAME
ORDER BY RENTAL_COUNTER DESC
LIMIT 1;


--29. Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado

SELECT
    SUM(A.AWARD_WIN) AS AWARDS_WIN,
    S.STUDIO_NAME
FROM
    MOVIES M
INNER JOIN STUDIOS S ON
    M.STUDIO_ID = S.STUDIO_ID
INNER JOIN AWARDS A ON
    A.MOVIE_ID = M.MOVIE_ID
GROUP BY
    S.STUDIO_NAME


--30. Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)

SELECT
    AC.ACTOR_NAME,
    SUM(A.AWARD_ALMOST_WIN) AS AWARD_NOMINATION
FROM
    PUBLIC.MOVIES M
INNER JOIN PUBLIC.AWARDS A ON
    A.MOVIE_ID = M.MOVIE_ID
INNER JOIN PUBLIC.MOVIES_ACTORS MA ON
    MA.MOVIE_ID = M.MOVIE_ID
INNER JOIN PUBLIC.ACTORS AC ON
    AC.ACTOR_ID = MA.ACTOR_ID
GROUP BY
    AC.ACTOR_NAME


--31. Indica cuantos actores y directores hicieron películas para los estudios no activos

SELECT
    COUNT(DISTINCT M.DIRECTOR_ID) AS DIRECTOR_NUMBER,
    COUNT(DISTINCT MA.ACTOR_ID) AS ACTOR_NUMBER
FROM
    STUDIOS S
INNER JOIN MOVIES M ON
    M.STUDIO_ID = S.STUDIO_ID
INNER JOIN MOVIES_ACTORS MA ON
    MA.MOVIE_ID = M.MOVIE_ID
WHERE
    S.STUDIO_ACTIVE = FALSE


--32. Indica el nombre, ciudad, y teléfono de todos los miembros del videoclub que hayan alquilado películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50


SELECT
	ME.MEMBER_NAME,
	ME.MEMBER_TOWN,
	ME.MEMBER_PHONE
FROM
	MEMBERS ME
INNER JOIN MEMBERS_MOVIE_RENTAL MMR 
ON
	ME.MEMBER_ID = MMR.MEMBER_ID
INNER JOIN MOVIES M
ON
	M.MOVIE_ID = MMR.MOVIE_ID 
INNER JOIN AWARDS A
ON
	A.MOVIE_ID = M.MOVIE_ID
WHERE
	A.AWARD_ALMOST_WIN = (SELECT COUNT(*) FROM AWARDS WHERE AWARDS.AWARD_ALMOST_WIN > 150)
	AND A.AWARD_WIN = (SELECT COUNT(*) FROM AWARDS WHERE AWARDS.AWARD_WIN < 50);



SELECT MEM.MEMBER_NAME, MEM.MEMBER_TOWN, MEM.MEMBER_PHONE FROM MEMBERS MEM
INNER JOIN MEMBERS_MOVIE_RENTAL MMR
ON MEM.MEMBER_ID = MMR.MEMBER_ID 
INNER JOIN MOVIES M 
ON MMR.MOVIE_ID = M.MOVIE_ID 
INNER JOIN AWARDS AW
ON M.MOVIE_ID = AW.MOVIE_ID 
WHERE AW.AWARD_NOMINATION >150 AND AW.AWARD_WIN < 50


--33. Comprueba si hay errores en la BD entre las películas y directores (un director fallecido en el 76 no puede dirigir una película en el 88)

SELECT
	D.DIRECTOR_NAME,
	D.DIRECTOR_DEAD_DATE,
	MAX(M.MOVIE_LAUNCH_DATE) AS LAST_MOVIE
FROM
	DIRECTORS D
INNER JOIN MOVIES M 
ON
	D.DIRECTOR_ID = M.DIRECTOR_ID
WHERE
	D.DIRECTOR_DEAD_DATE < M.MOVIE_LAUNCH_DATE
GROUP BY D.DIRECTOR_NAME, D.DIRECTOR_DEAD_DATE;
	

-- 34. Utilizando los datos de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)

UPDATE

    DIRECTORS

SET

    DIRECTOR_DEAD_DATE =(

    SELECT

        MAX(DATEADD(YEAR, 1, M.MOVIE_LAUNCH_DATE)) AS POST_MOVIE_LAUNCH_DATE

    FROM

        MOVIES M

    INNER JOIN DIRECTORS D ON

        M.DIRECTOR_ID = D.DIRECTOR_ID

    WHERE

        D.DIRECTOR_DEAD_DATE IS NOT NULL

        AND D.DIRECTOR_DEAD_DATE < M.MOVIE_LAUNCH_DATE

        AND D.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID

    GROUP BY

        DIRECTOR_NAME,

        DIRECTOR_DEAD_DATE)

WHERE

    DIRECTOR_ID IN (

    SELECT

        DISTINCT D.DIRECTOR_ID

    FROM

        MOVIES M

    INNER JOIN DIRECTORS D ON

        M.DIRECTOR_ID = D.DIRECTOR_ID

    WHERE

        D.DIRECTOR_DEAD_DATE IS NOT NULL

        AND D.DIRECTOR_DEAD_DATE < M.MOVIE_LAUNCH_DATE )


[11:41] Pablo Martínez

-- Utilizando MERGE

 

MERGE

INTO

    PUBLIC.DIRECTORS D

        USING (

    SELECT

        DIRECTOR_ID,

        DATEADD(YEAR,

        1,

        MAX(M.MOVIE_LAUNCH_DATE)) AS DIRECTOR_DEAD_DATE

    FROM

        PUBLIC.DIRECTORS D

    INNER JOIN PUBLIC.MOVIES M ON

        D.DIRECTOR_ID = M.DIRECTOR_ID

    WHERE

        D.DIRECTOR_DEAD_DATE IS NOT NULL

        AND M.MOVIE_LAUNCH_DATE > D.DIRECTOR_DEAD_DATE

    GROUP BY

        D.DIRECTOR_ID

        

        ) TOT(DIRECTOR_ID,

    DIRECTOR_DEAD_DATE) ON

    D.DIRECTOR_ID = TOT.DIRECTOR_ID

    WHEN MATCHED THEN

UPDATE

SET

    D.DIRECTOR_DEAD_DATE = TOT.DIRECTOR_DEAD_DATE

 




--DIFICULTAD: Berserk mode (enunciados simples, mucha diversión...)



-- 35. Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película

 
SELECT DIRECTOR_NAME, GROUP_CONCAT(GENRE_NAME) AS FAVORITE_GENRE FROM (SELECT
			D.DIRECTOR_NAME,
			D.DIRECTOR_ID,
			G.GENRE_NAME,
			G.GENRE_ID,
			COUNT(G.GENRE_NAME) AS NUM_MOVIES
	FROM
			MOVIES M
	INNER JOIN GENRES G ON 
			M.GENRE_ID = G.GENRE_ID
	INNER JOIN DIRECTORS D ON
			M.DIRECTOR_ID = D.DIRECTOR_ID
	GROUP BY
			G.GENRE_ID,
			G.GENRE_NAME,
			D.DIRECTOR_NAME,
			D.DIRECTOR_ID
	ORDER BY
			D.DIRECTOR_ID) GROUPID INNER JOIN 	
	
			(SELECT
		N_MOVIES.DIRECTOR_ID,
		MAX(N_MOVIES.NUM_MOVIES) AS MAX_MOVIES
	FROM
		(
		SELECT
			D.DIRECTOR_NAME,
			D.DIRECTOR_ID,
			G.GENRE_NAME,
			G.GENRE_ID,
			COUNT(G.GENRE_NAME) AS NUM_MOVIES
		FROM
			MOVIES M
		INNER JOIN GENRES G ON 
			M.GENRE_ID = G.GENRE_ID
		INNER JOIN DIRECTORS D ON
			M.DIRECTOR_ID = D.DIRECTOR_ID
		GROUP BY
			G.GENRE_NAME,
			G.GENRE_ID ,
			D.DIRECTOR_NAME,
			D.DIRECTOR_ID
		ORDER BY
			D.DIRECTOR_ID) N_MOVIES
	GROUP BY
		NMOVIES.DIRECTOR_ID) MAX_VALUE ON MAX_VALUE.DIRECTOR_ID = GROUPID.DIRECTOR_ID AND MAX_VALUE.MAX_MOVIES = GROUPID.NUM_MOVIES
	GROUP BY DIRECTOR_NAME


--36. Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas

SELECT
	MAX_NATIONALITIES.STUDIO_NAME,
	GROUP_CONCAT(MAX_NATIONALITIES.NATIONALITY_NAME) AS NATIONALITY_NAME
FROM
	(
	SELECT
		NUM_NATIONALITIES.STUDIO_NAME,
		NUM_NATIONALITIES.NATIONALITY_NAME,
		MAX(NUM_NATIONALITIES.NUM_NATIONALITIES) AS MAX_NATIONALITIES
	FROM
		(
		SELECT
			S.STUDIO_ID,
			S.STUDIO_NAME,
			N.NATIONALITY_ID,
			N.NATIONALITY_NAME,
			COUNT(N.NATIONALITY_NAME) AS NUM_NATIONALITIES
		FROM
			STUDIOS S
		INNER JOIN MOVIES M ON
			S.STUDIO_ID = M.STUDIO_ID
		INNER JOIN NATIONALITIES N ON
			M.NATIONALITY_ID = N.NATIONALITY_ID
		GROUP BY
			S.STUDIO_ID,
			S.STUDIO_NAME,
			N.NATIONALITY_ID
		ORDER BY
			S.STUDIO_ID) NUM_NATIONALITIES
	GROUP BY
		NUM_NATIONALITIES.STUDIO_NAME,
		NUM_NATIONALITIES.NATIONALITY_NAME) MAX_NATIONALITIES
GROUP BY
	MAX_NATIONALITIES.STUDIO_NAME


--37. Indica cuál fue la primera película que alquilaron los miembros del videoclub cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad

SELECT
    MOVIERENTALS.MOVIE_NAME,
    MOVIERENTALS.MEMBER_NAME
FROM
    (
    SELECT
        MO.MOVIE_NAME,
        MMR.MOVIE_ID,
        MMR.MEMBER_ID,
        MMR.MEMBER_RENTAL_DATE,
        M.MEMBER_NAME,
        TO_NUMBER(SUBSTRING(M.MEMBER_PHONE FROM LENGTH(MEMBER_PHONE))) AS "LAST_DIGIT"
    FROM
        MOVIES MO
    INNER JOIN
    MEMBERS_MOVIE_RENTAL MMR
    ON
        MO.MOVIE_ID = MMR.MOVIE_ID
    INNER JOIN MEMBERS M ON
        MMR.MEMBER_ID = M.MEMBER_ID
    WHERE
        TO_NUMBER(SUBSTRING(M.MEMBER_PHONE FROM LENGTH(MEMBER_PHONE))) IN (
        SELECT
            NATIONALITY_ID
        FROM
            NATIONALITIES

 

)
    GROUP BY
        MO.MOVIE_NAME,
        MMR.MOVIE_ID,
        MMR.MEMBER_ID,
        MMR.MEMBER_RENTAL_DATE,
        M.MEMBER_NAME,
        LAST_DIGIT
    ORDER BY
        M.MEMBER_NAME

 

) MOVIERENTALS
INNER JOIN

    (
    SELECT
        MEMBER_ID,
        MIN(MEMBER_RENTAL_DATE) AS "FIRST_RENTAL"
    FROM
        (
        SELECT
            MO.MOVIE_NAME,
            MMR.MOVIE_ID,
            MMR.MEMBER_ID,
            MMR.MEMBER_RENTAL_DATE,
            M.MEMBER_NAME,
            TO_NUMBER(SUBSTRING(M.MEMBER_PHONE FROM LENGTH(MEMBER_PHONE))) AS "LAST_DIGIT"
        FROM
            MOVIES MO
        INNER JOIN
    MEMBERS_MOVIE_RENTAL MMR
    ON
            MO.MOVIE_ID = MMR.MOVIE_ID
        INNER JOIN MEMBERS M ON
            MMR.MEMBER_ID = M.MEMBER_ID
        WHERE
            TO_NUMBER(SUBSTRING(M.MEMBER_PHONE FROM LENGTH(MEMBER_PHONE))) IN (
            SELECT
                NATIONALITY_ID
            FROM
                NATIONALITIES

 

)
        GROUP BY
            MO.MOVIE_NAME,
            MMR.MOVIE_ID,
            MMR.MEMBER_ID,
            MMR.MEMBER_RENTAL_DATE,
            M.MEMBER_NAME,
            LAST_DIGIT
        ORDER BY
            M.MEMBER_NAME
    )
    GROUP BY
        MEMBER_ID) FIRSTRENTALS ON
    MOVIERENTALS.MEMBER_ID = FIRSTRENTALS.MEMBER_ID AND MOVIERENTALS.MEMBER_RENTAL_DATE = FIRSTRENTALS.FIRST_RENTAL
GROUP BY
    MOVIERENTALS.MOVIE_NAME,
    MOVIERENTALS.MEMBER_NAME
    
    
    -- FIN DE LOS EJERCICIOS --