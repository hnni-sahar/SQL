
-- Use the CustomerDB database
USE CustomerDB;
GO

-- Step 1: Change the data type of the "loyalty_score" column to DECIMAL(3,1)
ALTER TABLE [customer_behavior]
ALTER COLUMN loyalty_score DECIMAL(3,1);

-- Preview the data
SELECT *
FROM [customer_behavior];

--------------------------------------------------------------------------------
-- 1. How many unique customers does the store have?

SELECT COUNT(DISTINCT user_id) AS unique_customers
FROM [customer_behavior];

--------------------------------------------------------------------------------
-- 2. How many customers are there in each region?

SELECT region, COUNT(*) AS customer_count
FROM [customer_behavior]
GROUP BY region;

--------------------------------------------------------------------------------
-- 3. How many customers are there in each age group?

SELECT 
  age_group,
  COUNT(*) AS customer_count
FROM (
  SELECT 
    CASE 
      WHEN age < 20 THEN '<20'
      WHEN age BETWEEN 20 AND 29 THEN '20-29'
      WHEN age BETWEEN 30 AND 39 THEN '30-39'
      WHEN age BETWEEN 40 AND 49 THEN '40-49'
      WHEN age BETWEEN 50 AND 59 THEN '50-59'
      ELSE '60+'
    END AS age_group
  FROM [customer_behavior]
) AS sub
GROUP BY age_group
ORDER BY age_group;


--------------------------------------------------------------------------------
-- 4. How many customers fall into each income range?

SELECT 
  income_level,
  COUNT(*) AS customer_count
FROM (
  SELECT 
    CASE 
      WHEN annual_income < 40000 THEN 'Low'
      WHEN annual_income BETWEEN 40000 AND 59999 THEN 'Mid-Low'
      WHEN annual_income BETWEEN 60000 AND 79999 THEN 'Mid-High'
      ELSE 'High'
    END AS income_level
  FROM [customer_behavior]
) AS sub_income
GROUP BY income_level;

--------------------------------------------------------------------------------
-- 5. How many customers belong to each loyalty segment?

SELECT
  loyalty_segment,
  COUNT(*) AS customer_count
FROM (
  SELECT
    CASE
      WHEN loyalty_score < 4 THEN 'At-Risk'
      WHEN loyalty_score >= 4 AND loyalty_score < 6 THEN 'Occasional'
      WHEN loyalty_score >= 6 AND loyalty_score < 8 THEN 'Engaged'
      WHEN loyalty_score >= 8 AND loyalty_score < 9 THEN 'Loyal'
      WHEN loyalty_score >= 9 THEN 'Champion'
    END AS loyalty_segment
  FROM [customer_behavior]
) AS sub_loyalty
GROUP BY loyalty_segment
ORDER BY customer_count DESC;

--------------------------------------------------------------------------------
-- 6. What is the average income and number of customers in each region?

SELECT 
  region,
  COUNT(*) AS customer_count,
  FORMAT(AVG(annual_income), 'N0') AS avg_income
FROM 
  [customer_behavior]
GROUP BY 
  region
ORDER BY 
  avg_income DESC,
  customer_count DESC;

--------------------------------------------------------------------------------
-- 7. What are the average and percentage of total purchases made by each age group?
WITH age_data AS (
  SELECT 
    *,
    CASE 
      WHEN age BETWEEN 20 AND 29 THEN '20-29'
      WHEN age BETWEEN 30 AND 39 THEN '30-39'
      WHEN age BETWEEN 40 AND 49 THEN '40-49'
      ELSE '50+'
    END AS age_group
  FROM customer_behavior
)

SELECT 
  age_group,
  COUNT(*) AS customer_count,
  FORMAT(AVG(purchase_amount), 'N0') AS avg_purchase,
  FORMAT(
    100.0 * SUM(purchase_amount) / 
    (SELECT SUM(purchase_amount) FROM age_data), 
    'N2'
  ) + '%' AS purchase_percent
FROM age_data
GROUP BY age_group
ORDER BY age_group;



--------------------------------------------------------------------------------
-- 8. How are customers distributed based on their purchase frequency levels?
SELECT 
  frequency_segment,
  COUNT(*) AS customer_count,
  FORMAT(AVG(loyalty_score), 'N1') AS avg_loyalty
FROM (
  SELECT *,
    CASE 
      WHEN purchase_frequency < 10 THEN 'Rare Buyer'
      WHEN purchase_frequency BETWEEN 10 AND 17 THEN 'Regular Buyer'
      WHEN purchase_frequency BETWEEN 18 AND 24 THEN 'Frequent Buyer'
      ELSE 'Super Buyer'
    END AS frequency_segment
  FROM customer_behavior
) AS freq
GROUP BY frequency_segment
ORDER BY customer_count DESC;


--------------------------------------------------------------------------------
-- 9. Which regions have the highest number of loyal customers (loyalty_score ≥ 7)?

SELECT 
  region,
  COUNT(*) AS loyal_customers
FROM customer_behavior
WHERE loyalty_score >= 7
GROUP BY region
ORDER BY loyal_customers DESC;

--------------------------------------------------------------------------------
-- 10. What is the average purchase amount and income by loyalty segment?

SELECT 
  loyalty_segment,
  COUNT(*) AS customer_count,
  FORMAT(AVG(purchase_amount), 'N0') AS avg_purchase,
  FORMAT(AVG(annual_income), 'N0') AS avg_income
FROM (
  SELECT *,
    CASE
      WHEN loyalty_score < 4 THEN 'At-Risk'
      WHEN loyalty_score >= 4 AND loyalty_score < 6 THEN 'Occasional'
      WHEN loyalty_score >= 6 AND loyalty_score < 8 THEN 'Engaged'
      WHEN loyalty_score >= 8 AND loyalty_score < 9 THEN 'Loyal'
      WHEN loyalty_score >= 9 THEN 'Champion'
    END AS loyalty_segment
  FROM customer_behavior
) AS seg
GROUP BY loyalty_segment
ORDER BY avg_purchase DESC;
