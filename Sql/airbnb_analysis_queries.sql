-- Airbnb Capstone Project
-- Author: Islam Elsheikh
-- Database: PostgreSQL
-- Schema: s_islamelsheikh
-- Table: airbnb_cleaned
-- Description: SQL queries used to support the Airbnb pricing analysis




SELECT COUNT(*)
FROM s_islamelsheikh.airbnb_cleaned;


-- Query 1: Compare average Airbnb price and listing count across cities
-- Purpose: Identify which cities are the most expensive on average
SELECT city,
       ROUND(AVG(price)::numeric, 2) AS avg_price,
       COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY city
ORDER BY avg_price DESC;




-- Query 2: Compare average price and listing count by room type
-- Purpose: Understand how accommodation type affects pricing
SELECT room_type,
       ROUND(AVG(price)::numeric, 2) AS avg_price,
       COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY room_type
ORDER BY avg_price DESC;



-- Query 3: Compare Superhosts and Regular Hosts
-- Purpose: Check whether the Superhost badge is associated with price, rating, and cleanliness
SELECT host_is_superhost,
       ROUND(AVG(price)::numeric, 2) AS avg_price,
       ROUND(AVG(rating)::numeric, 2) AS avg_rating,
       ROUND(AVG(cleanliness_rating)::numeric, 2) AS avg_cleanliness,
       COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY host_is_superhost;



-- Query 4: Compare Business Hosts and Individual Hosts
-- Purpose: Examine whether business-managed listings are more expensive and how they perform in ratings
SELECT biz,
       ROUND(AVG(price)::numeric, 2) AS avg_price,
       ROUND(AVG(rating)::numeric, 2) AS avg_rating,
       COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY biz;


-- Query 5: Compare average price by city and day type
-- Purpose: Explore whether weekday and weekend pricing differs across cities
SELECT city,
       day_type,
       ROUND(AVG(price)::numeric, 2) AS avg_price,
       COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY city, day_type
ORDER BY city, day_type;




-- Query 6: Compare average price by city and day type
-- Purpose: Examine whether weekend and weekday pricing differs across cities
SELECT city,
       day_type,
       ROUND(AVG(price)::numeric, 2) AS avg_price,
       COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY city, day_type
ORDER BY city, day_type;


-- Query 7: Compare average price by guest capacity
-- Purpose: Explore how listing capacity is associated with price
SELECT person_capacity,
       ROUND(AVG(price)::numeric, 2) AS avg_price,
       COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY person_capacity
ORDER BY person_capacity;




-- Query 8: Compare average price by number of bedrooms
-- Purpose: Explore how bedroom count is associated with price
SELECT bedrooms,
       ROUND(AVG(price)::numeric, 2) AS avg_price,
       COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY bedrooms
ORDER BY bedrooms;



-- Query 9: Compare average price across city-center distance bands
-- Purpose: Check how average price changes as listings move farther from the city center

WITH distance_bands AS (
    SELECT
        CASE
            WHEN dist >= 0 AND dist < 1 THEN '0-1 km'
            WHEN dist >= 1 AND dist < 2 THEN '1-2 km'
            WHEN dist >= 2 AND dist < 5 THEN '2-5 km'
            WHEN dist >= 5 AND dist < 10 THEN '5-10 km'
            ELSE '10+ km'
        END AS dist_band,
        price
    FROM s_islamelsheikh.airbnb_cleaned
)
SELECT
    dist_band,
    ROUND(AVG(price)::numeric, 2) AS avg_price,
    COUNT(*) AS listings
FROM distance_bands
GROUP BY dist_band
ORDER BY
    CASE dist_band
        WHEN '0-1 km' THEN 1
        WHEN '1-2 km' THEN 2
        WHEN '2-5 km' THEN 3
        WHEN '5-10 km' THEN 4
        WHEN '10+ km' THEN 5
    END;


SELECT COUNT(*) AS rows_with_dist
FROM s_islamelsheikh.airbnb_cleaned
WHERE dist IS NOT NULL;



-- Query 10: Compare average price across attraction levels
-- Purpose: Examine whether more attractive areas are associated with higher prices
SELECT
    CASE
        WHEN attr_index_norm < 25 THEN 'Low'
        WHEN attr_index_norm < 50 THEN 'Medium-Low'
        WHEN attr_index_norm < 75 THEN 'Medium-High'
        ELSE 'High'
    END AS attraction_level,
    ROUND(AVG(price)::numeric, 2) AS avg_price,
    COUNT(*) AS listings
FROM s_islamelsheikh.airbnb_cleaned
GROUP BY attraction_level
ORDER BY
    CASE attraction_level
        WHEN 'Low' THEN 1
        WHEN 'Medium-Low' THEN 2
        WHEN 'Medium-High' THEN 3
        WHEN 'High' THEN 4
    END;


