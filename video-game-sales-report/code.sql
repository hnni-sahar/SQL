
-- Section1

SELECT 
    platform.platform_name, 
    AVG(region_sales.num_sales) AS Average
FROM 
    platform
JOIN 
    game_platform ON platform.id = game_platform.platform_id
JOIN 
    region_sales ON game_platform.id = region_sales.game_platform_id
GROUP BY 
    platform.platform_name
ORDER BY 
    Average DESC;

-- Section2

WITH 
platform_info AS (
    SELECT 
        game_platform.id AS game_platform_id,
        platform.platform_name,
        game_platform.release_year,
        game_platform.game_publisher_id
    FROM 
        game_platform
    JOIN 
        platform ON game_platform.platform_id = platform.id
),
game_publisher_info AS (
    SELECT 
        game_publisher.id AS game_publisher_id,
        game.game_name,
        publisher.publisher_name
    FROM 
        game_publisher
    JOIN 
        game ON game_publisher.game_id = game.id
    JOIN 
        publisher ON game_publisher.publisher_id = publisher.id
),
global_sales_info AS (
    SELECT 
        game_platform_id,
        SUM(num_sales) AS global_sales
    FROM 
        region_sales
    GROUP BY 
        game_platform_id
)
SELECT 
    gpi.game_name,
    pi.platform_name,
    pi.release_year,
    gpi.publisher_name,
    gsi.global_sales
FROM 
    platform_info pi
JOIN 
    game_publisher_info gpi ON pi.game_publisher_id = gpi.game_publisher_id
JOIN 
    global_sales_info gsi ON pi.game_platform_id = gsi.game_platform_id
ORDER BY 
    gsi.global_sales DESC
LIMIT 20; 


-- Section3

SELECT 
    g.game_name,
    COUNT(DISTINCT gp.platform_id) AS platform_count
FROM 
    game_platform gp
JOIN 
    game_publisher gpub ON gp.game_publisher_id = gpub.id
JOIN 
    game g ON gpub.game_id = g.id
GROUP BY 
    g.game_name
HAVING 
    COUNT(DISTINCT gp.platform_id) > 5
ORDER BY 
    platform_count DESC, 
    g.game_name ASC;


-- Section4

WITH genre_sales AS (
    SELECT 
        p.platform_name AS platform,
        gn.genre_name AS genre,
        SUM(rs.num_sales) AS genre_sale
    FROM 
        region_sales rs
    JOIN 
        game_platform gp ON rs.game_platform_id = gp.id
    JOIN 
        game_publisher gpub ON gp.game_publisher_id = gpub.id
    JOIN 
        game g ON gpub.game_id = g.id
    JOIN 
        genre gn ON g.genre_id = gn.id
    JOIN 
        platform p ON gp.platform_id = p.id
    GROUP BY 
        p.platform_name, gn.genre_name
),
platform_ranked AS (
    SELECT 
        platform,
        genre,
        genre_sale,
        DENSE_RANK() OVER (PARTITION BY platform ORDER BY genre_sale DESC) AS genre_in_platform_rank
    FROM 
        genre_sales
),
total_ranked AS (
    SELECT 
        platform,
        genre,
        genre_in_platform_rank,
        genre_sale,
        DENSE_RANK() OVER (ORDER BY genre_sale DESC) AS total_rank
    FROM 
        platform_ranked
)
SELECT 
    platform,
    genre,
    genre_in_platform_rank,
    genre_sale,
    total_rank
FROM 
    total_ranked
ORDER BY 
    genre_sale DESC, 
    platform ASC, 
    genre ASC;


-- Section5

WITH ranked_sales AS (
    SELECT 
        g.game_name,
        r.region_name,
        SUM(rs.num_sales) AS total_sales,
        DENSE_RANK() OVER (PARTITION BY r.region_name ORDER BY SUM(rs.num_sales) DESC) AS rank_in_region
    FROM
        region_sales rs
    JOIN
        region r ON rs.region_id = r.id
    JOIN
        game_platform gp ON rs.game_platform_id = gp.id
    JOIN
        game_publisher gpub ON gp.game_publisher_id = gpub.id
    JOIN
        game g ON gpub.game_id = g.id
    GROUP BY 
        g.game_name, r.region_name
)
SELECT 
    game_name,
    region_name,
    total_sales,
    rank_in_region
FROM 
    ranked_sales
WHERE 
    rank_in_region <= 10
ORDER BY 
    region_name ASC,
    rank_in_region ASC, 
    game_name ASC;
    
    
-- Section6

SELECT 
    g.game_name,
    GROUP_CONCAT(DISTINCT p.publisher_name ORDER BY p.publisher_name ASC SEPARATOR ',') AS publishers
FROM 
    game g
JOIN 
    game_publisher gp ON g.id = gp.game_id
JOIN 
    publisher p ON gp.publisher_id = p.id
GROUP BY 
    g.game_name
HAVING 
    COUNT(DISTINCT p.id) > 1
ORDER BY 
    g.game_name;