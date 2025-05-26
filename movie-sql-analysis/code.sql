-- Section1
SELECT 
    m.title
FROM 
    movie m
LEFT JOIN 
    movie_genres mg
ON 
    m.movie_id = mg.movie_id
WHERE 
    mg.genre_id IS NULL;

-- Section2

SELECT 
    m.title AS Title,
    p.person_name AS `Director/Leading actor`
FROM 
    movie_cast mc
JOIN 
    movie_crew mcr ON mc.movie_id = mcr.movie_id 
                  AND mc.person_id = mcr.person_id
JOIN 
    movie m ON mc.movie_id = m.movie_id
JOIN 
    person p ON mc.person_id = p.person_id
WHERE 
    mc.cast_order = 0
    AND mcr.job = 'Director'
ORDER BY 
    m.title ASC;


-- Section3
SELECT 
    p.person_name AS Name,
    COUNT(mc.movie_id) AS count_of_movies
FROM 
    movie_cast mc
JOIN 
    person p
ON 
    mc.person_id = p.person_id
WHERE 
    mc.cast_order = 0
GROUP BY 
    p.person_id, p.person_name
ORDER BY 
    count_of_movies DESC, 
    Name ASC;




-- Section4

SELECT 
    genre.genre_name as genre,
    AVG(movie.vote_average) AS avg_rating,
    MAX(movie.vote_average) AS max_rating,
    MIN(movie.vote_average) AS min_rating
FROM 
    movie 
JOIN 
    movie_genres ON movie.movie_id = movie_genres.movie_id
JOIN 
    genre ON movie_genres.genre_id = genre.genre_id
GROUP BY 
    genre.genre_id
ORDER BY 
    avg_rating DESC;

-- Section5

SELECT p1.person_name AS "person #1", 
       p2.person_name AS "person #2", 
       COUNT(mc1.movie_id) AS "movies_played_together"
FROM movie_cast mc1
JOIN movie_cast mc2 ON mc1.movie_id = mc2.movie_id AND mc1.person_id < mc2.person_id
JOIN person p1 ON mc1.person_id = p1.person_id
JOIN person p2 ON mc2.person_id = p2.person_id
GROUP BY p1.person_name, p2.person_name
ORDER BY movies_played_together DESC, p1.person_name ASC, p2.person_name ASC
LIMIT 10;