-- CREATE DATABASE EV;
USE EV;

SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

-- dim_date column
SELECT * FROM dim_date;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_date';

-- ev_makers column
SELECT * FROM ev_makers;

-- 26 unique makers
SELECT DISTINCT maker
FROM ev_makers;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ev_makers';

SELECT * FROM ev_state;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ev_state';

-- 35 unique states
SELECT DISTINCT state
FROM ev_state;

SELECT * FROM `ev_charging_stations`;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ev_charging_stations';

-- Data Cleaning

-- dim_date col
-- 1. Rename the date col
ALTER TABLE dim_date
RENAME COLUMN  `ï»¿date` TO `date` ;

-- 2. Change to DATE type
ALTER TABLE dim_date 
ADD COLUMN new_date DATETIME;

-- update new_date
UPDATE dim_date
SET new_date = STR_TO_DATE(date,'%d-%b-%y');

-- drop date col
ALTER TABLE dim_date
DROP COLUMN date;

-- rename new_date
ALTER TABLE dim_date
RENAME COLUMN new_date TO date;

-- change the position of the date col
ALTER TABLE dim_date
MODIFY COLUMN date DATE FIRST;

SELECT * FROM dim_date;

-- ev_makers
SELECT * FROM ev_makers;

-- 1. Add new col
ALTER TABLE ev_makers 
ADD COLUMN new_date DATETIME;

-- update new_date
UPDATE ev_makers
SET new_date = STR_TO_DATE(`ï»¿date`,'%d-%b-%y');

-- drop date col
ALTER TABLE ev_makers
DROP COLUMN `ï»¿date`;

-- rename new_date
ALTER TABLE ev_makers
RENAME COLUMN new_date TO date;

-- change the position of the date col
ALTER TABLE ev_makers
MODIFY COLUMN date DATE FIRST;

-- ev_state
SELECT * FROM ev_state;

-- 1. Add new col
ALTER TABLE ev_state 
ADD COLUMN new_date DATE;

-- update new_date
UPDATE ev_state
SET new_date = STR_TO_DATE(`ï»¿date`,'%d-%b-%y');

-- drop date col
ALTER TABLE ev_state
DROP COLUMN `ï»¿date`;

-- rename new_date
ALTER TABLE ev_state
RENAME COLUMN new_date TO date;

-- change the position of the date col
ALTER TABLE ev_state
MODIFY COLUMN date DATE FIRST;

-- state name 
-- DNH and DD
SELECT * FROM ev_state WHERE state LIKE '%DD%';

-- D&D and DNH
SELECT * FROM ev_stations WHERE `state name` LIKE '%D&D%';

-- Correct the Andaman & Nicobar to  Andaman & Nicobar Island
UPDATE ev_state
SET state = 'Andaman & Nicobar Island'
WHERE state = 'Andaman & Nicobar';

SELECT DISTINCT state
FROM ev_state;

-- update the state name D&D and DNH to DNH and DD
UPDATE ev_stations
SET `state name` = 'DNH and DD'
WHERE `state name` = 'D&D and DNH';

-- ev_stations
-- Update 'Andaman & Nicobar' to 'Andaman & Nicobar Island'
UPDATE ev_stations
SET `state name` = 'Andaman & Nicobar Island'
WHERE `state name` = 'Andaman & Nicobar';

-- Pondicherry to Puducherry
UPDATE ev_stations
SET `state name` = 'Puducherry'
WHERE `state name` = 'Pondicherry';

-- Jammu & Kashmir to Jammu and Kashmir
UPDATE ev_stations
SET `state name` = 'Jammu and Kashmir'
WHERE `state name` = 'Jammu & Kashmir';

SELECT * FROM ev_stations;

--  1.List the top 3 and bottom 3 makers for the fiscal years 2023 and 2024 in terms of the number of 2-wheelers sold. 
-- TOP MAKERS
SELECT d.fiscal_year, m.maker, SUM(m.electric_vehicles_sold) AS Total_2Wheelers_Sold
FROM ev_makers m
JOIN dim_date d ON m.date = d.date
WHERE m.vehicle_category = '2-Wheelers' AND d.fiscal_year = 2023
GROUP BY m.maker, d.fiscal_year
ORDER BY Total_2Wheelers_Sold DESC 
LIMIT 3;

/*1.OLA ELECTRIC - 152583
  2.OKINAWA - 96945
  3.HERO ELECTRIC - 88993 */

-- 2024
SELECT d.fiscal_year, m.maker, SUM(m.electric_vehicles_sold) AS Total_2Wheelers_Sold
FROM ev_makers m
JOIN dim_date d ON m.date = d.date
WHERE m.vehicle_category = '2-Wheelers' AND d.fiscal_year = 2024
GROUP BY m.maker, d.fiscal_year
ORDER BY Total_2Wheelers_Sold DESC 
LIMIT 3;

/* 1.OLA ELECTRIC - 322489
   2.TVS - 180743
   3.ATHER - 107552 */

-- BOTTOM MAKERS
SELECT d.fiscal_year, m.maker, SUM(m.electric_vehicles_sold) AS Total_2Wheelers_Sold
FROM ev_makers m
JOIN dim_date d ON m.date = d.date
WHERE m.vehicle_category = '2-Wheelers' AND d.fiscal_year = 2023
GROUP BY m.maker, d.fiscal_year
ORDER BY Total_2Wheelers_Sold ASC 
LIMIT 3;

/* 1.JITENDRA - 8563
   2.BEING - 11018
   3.PURE EV - 11556 */

-- 2024
SELECT d.fiscal_year, m.maker, SUM(m.electric_vehicles_sold) AS Total_2Wheelers_Sold
FROM ev_makers m
JOIN dim_date d ON m.date = d.date
WHERE m.vehicle_category = '2-Wheelers' AND d.fiscal_year = 2024
GROUP BY m.maker, d.fiscal_year
ORDER BY Total_2Wheelers_Sold ASC 
LIMIT 3;

/* 1. BATTRE ELECTRIC - 4841
   2. REVOLT - 7254
   3. KINETIC GREEN - 9585 */

/* 2.Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheeler EV sales in FY 
2024. */
-- Overall penetration rate of EV
SELECT s.state,
ROUND(SUM(s.electric_vehicles_sold) / SUM(s.total_vehicles_sold) * 100,2) AS Penetration_Rate
FROM ev_state s 
JOIN dim_date d ON s.date = d.date
WHERE d.fiscal_year = 2024
GROUP BY s.state, d.fiscal_year
ORDER BY Penetration_Rate DESC
LIMIT 5;

-- 2-Wheelers penetration rate
SELECT s.state,
ROUND(SUM(s.electric_vehicles_sold) / SUM(s.total_vehicles_sold) * 100,2) AS Penetration_Rate
FROM ev_state s 
JOIN dim_date d ON s.date = d.date
WHERE d.fiscal_year = 2024 AND s.vehicle_category = '2-Wheelers'
GROUP BY s.state, d.fiscal_year
ORDER BY Penetration_Rate DESC
LIMIT 5;

-- 4-Wheelers penetration rate
SELECT s.state,
ROUND(SUM(s.electric_vehicles_sold) / SUM(s.total_vehicles_sold) * 100,2) AS Penetration_Rate
FROM ev_state s 
JOIN dim_date d ON s.date = d.date
WHERE d.fiscal_year = 2024 AND s.vehicle_category = '4-Wheelers'
GROUP BY s.state, d.fiscal_year
ORDER BY Penetration_Rate DESC
LIMIT 5;

/*3. List the states with negative penetration (decline) in EV sales from 2022 to 2024? */
-- -> There are no states where their is continuous decline from 2022 to 2024. There are ups and downs.
-- For a better understanding calculate forecasted penetration rate 
WITH PR AS
(
	SELECT s.state, d.fiscal_year,
	ROUND(SUM(s.electric_vehicles_sold) / SUM(s.total_vehicles_sold) * 100,2) AS Penetration_Rate
	FROM ev_state s 
	JOIN dim_date d ON s.date = d.date
	GROUP BY s.state, d.fiscal_year
)
SELECT state,
MAX(CASE WHEN fiscal_year = 2022 THEN Penetration_Rate ELSE 0 END) AS PR_2022,
MAX(CASE WHEN fiscal_year = 2023 THEN Penetration_Rate ELSE 0 END) AS PR_2023,
MAX(CASE WHEN fiscal_year = 2024 THEN Penetration_Rate ELSE 0 END) AS PR_2024
FROM PR
GROUP BY state
HAVING PR_2022 > PR_2024;

-- Cross-validate the PR forcasts 
WITH PR AS
(
	SELECT s.*, d.fiscal_year,
	ROUND(SUM(s.electric_vehicles_sold) / SUM(s.total_vehicles_sold) * 100,2) AS Penetration_Rate
	FROM ev_state s 
	JOIN dim_date d ON s.date = d.date
	GROUP BY s.state, d.fiscal_year
), 
Pivot_pr AS
(
	SELECT state,
	MAX(CASE WHEN fiscal_year = 2022 THEN Penetration_Rate ELSE 0 END) AS PR_2022,
	MAX(CASE WHEN fiscal_year = 2023 THEN Penetration_Rate ELSE 0 END) AS PR_2023,
	MAX(CASE WHEN fiscal_year = 2024 THEN Penetration_Rate ELSE 0 END) AS PR_2024
	FROM PR
	GROUP BY state
),
EV_2022 AS
(
	SELECT p.state, SUM(s.electric_vehicles_sold) AS EV_22
	FROM Pivot_pr p
	JOIN ev_state s ON p.state = s.state
	JOIN dim_date d ON s.date = d.date
	WHERE d.fiscal_year = 2022
	GROUP BY p.state
),
EV_2024 AS
(
	SELECT p.state, SUM(s.electric_vehicles_sold) AS EV_24
	FROM Pivot_pr p
	JOIN ev_state s ON p.state = s.state
	JOIN dim_date d ON s.date = d.date
	WHERE d.fiscal_year = 2024
	GROUP BY p.state
),
Combined_Sales AS
(
	SELECT EV_2022.state, EV_2022.EV_22, EV_2024.EV_24, p.PR_2022, p.PR_2023, p.PR_2024
    FROM EV_2022
    JOIN EV_2024 ON EV_2022.state = EV_2024.state
    JOIN Pivot_pr p ON p.state = EV_2022.state
),
F_PR AS
(
	SELECT state, PR_2022, PR_2023, PR_2024,
	COALESCE(ROUND((POW((EV_24/EV_22),1.0/2))-1,3),0) AS CAGR
	FROM Combined_Sales
)
SELECT state,CAGR, PR_2022,PR_2023,PR_2024,
ROUND(PR_2024*POW(1+CAGR,1),3) AS PR_2025,
ROUND(PR_2024*POW(1+CAGR,1) * POW(1+ CAGR,1),3) AS PR_2026
FROM F_PR
HAVING PR_2022 > PR_2023 OR PR_2023 > PR_2024;


/*4.  What are the quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) from 2022 to 2024?*/
-- based on the question itself only focusing on quarters is not giving any value neither it is giving top 5 makers
-- Compare each quarter with its prev quarter for better understanding
SELECT d.quarter,m.maker, SUM(m.electric_vehicles_sold) AS Total_Sales
FROM ev_makers m
JOIN dim_date d ON m.date = d.date
WHERE m.vehicle_category = '4-Wheelers' AND d.fiscal_year = 2022
GROUP BY d.quarter, m.maker
ORDER BY Total_Sales DESC;

/*5.How do the EV sales and penetration rates in Delhi compare to Karnataka for 2024?*/

-- Karnataka is performing better in sales and as well as penetartion rate
WITH cte AS
(
	SELECT s.state, ROUND(SUM(s.electric_vehicles_sold)) AS Total_EV_Sales, 
    ROUND((SUM(s.electric_vehicles_sold)/SUM(s.total_vehicles_sold))*100,2) AS Penetration_Rate,
    SUM(s.total_vehicles_sold) AS Total_Vehicles_Sales
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	WHERE d.fiscal_year = 2022  AND s.state IN ('Delhi','Karnataka')
	GROUP BY s.state
)
SELECT 'Total_EV_Sales' AS Metric,
MAX(CASE WHEN state = 'Delhi' THEN Total_EV_Sales ELSE 0 END) AS Delhi,
MAX(CASE WHEN state = 'Karnataka' THEN Total_EV_Sales ELSE 0 END) AS Karnataka
FROM cte
UNION ALL
SELECT 'Penetration_Rate' AS Metric,
MAX(CASE WHEN state = 'Delhi' THEN Penetration_Rate ELSE 0 END) AS Delhi,
MAX(CASE WHEN state = 'Karnataka' THEN Penetration_Rate ELSE 0 END) AS Karnataka
FROM cte
UNION ALL
SELECT 'Total_Vehicles_Sold' AS Metric,
MAX(CASE WHEN state = 'Delhi' THEN Total_Vehicles_Sales ELSE 0 END) AS Delhi,
MAX(CASE WHEN state = 'Karnataka' THEN Total_Vehicles_Sales ELSE 0 END) AS Karnataka
FROM cte;

/*5. List down the compounded annual growth rate (CAGR) in 4-wheeler units for the top 5 makers from 2022 to 2024. */
WITH EV_2022 AS
(
	SELECT m.maker, SUM(m.electric_vehicles_sold) AS Total_Sales_22
	FROM ev_makers m 
	JOIN dim_date d ON m.date = d.date 
	WHERE m.vehicle_category  = '4-Wheelers' AND d.fiscal_year = 2022
	GROUP BY m.maker
    ORDER BY Total_Sales_22 DESC
),
EV_2024 AS
(
	SELECT m.maker, SUM(m.electric_vehicles_sold) AS Total_Sales_24
	FROM ev_makers m 
	JOIN dim_date d ON m.date = d.date 
	WHERE m.vehicle_category  = '4-Wheelers' AND d.fiscal_year = 2024
	GROUP BY m.maker
    ORDER BY Total_Sales_24 DESC
),
Combined_Sales AS
(
	SELECT EV_2022.maker, EV_2022.Total_Sales_22, EV_2024.Total_Sales_24
	FROM EV_2022 
	JOIN EV_2024 ON EV_2022.maker = EV_2024.maker
)
SELECT maker,
ROUND((POW(Total_Sales_24/Total_Sales_22,1/2))-1,2) AS CAGR
FROM Combined_Sales
ORDER BY CAGR DESC
LIMIT 5;

/*7. List down the top 10 states that had the highest compounded annual growth rate (CAGR) from 2022 to 2024 in total vehicles sold. */
WITH TS_2022 AS
(
	SELECT s.state, SUM(s.total_vehicles_sold) AS Total_Vehicles_Sold_22
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	WHERE d.fiscal_year = 2022
	GROUP BY s.state
    ORDER BY Total_Vehicles_Sold DESC
),
TS_2024 AS
(
	SELECT s.state, SUM(s.total_vehicles_sold) AS Total_Vehicles_Sold_24
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	WHERE d.fiscal_year = 2024
	GROUP BY s.state
    ORDER BY Total_Vehicles_Sold DESC
),
Combined_Sales AS
(
	SELECT TS_2022.state, TS_2022.Total_Vehicles_Sold_22, TS_2024.Total_Vehicles_Sold_24
	FROM TS_2022
	JOIN TS_2024 ON TS_2022.state = TS_2024.state
) 
SELECT state,
ROUND(((POW(Total_Vehicles_Sold_24/Total_Vehicles_Sold_22,1.0/2))-1)*100,2) AS CAGR
FROM Combined_Sales
ORDER BY CAGR DESC
LIMIT 10;

/*8.What are the peak and low season months for EV sales based on the data from 2022 to 2024? */
-- It can be seen from April the sales kind of drop and from there are like up & down compare to the first three months 
WITH cte AS
(
	SELECT MONTHNAME(d.date) AS Months, d.fiscal_year, SUM(s.electric_vehicles_sold) AS EV_Sales
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	GROUP BY MONTHNAME(d.date), d.fiscal_year
	ORDER BY MONTH(d.date)
)
SELECT Months,
SUM(CASE WHEN fiscal_year = 2022 THEN EV_Sales ELSE 0 END) AS EV_Sales_22,
SUM(CASE WHEN fiscal_year = 2023 THEN EV_Sales ELSE 0 END) AS EV_Sales_23,
SUM(CASE WHEN fiscal_year = 2024 THEN EV_Sales ELSE 0 END) AS EV_Sales_24
FROM cte
GROUP BY Months;

-- 
SELECT MONTHNAME(d.date) AS Months, SUM(s.electric_vehicles_sold) AS EV_Sales
FROM ev_state s
JOIN dim_date d ON s.date = d.date
GROUP BY MONTHNAME(d.date)
ORDER BY MONTH(d.date);

/*9. What is the projected number of EV sales (including 2-wheelers and 4-wheelers) for the top 10 states by penetration rate in 2030, 
based on the compounded annual growth rate (CAGR) from previous years? */
WITH sales_data AS
(
	SELECT s.state,
	ROUND((SUM(s.electric_vehicles_sold)/SUM(s.total_vehicles_sold))*100,2) AS Penetration_Rate
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	GROUP BY s.state
	ORDER BY Penetration_Rate DESC
	LIMIT 10
),
TS_2022 AS
(
	SELECT s1.state,
	SUM(s.electric_vehicles_sold) AS EV_Vehicles_Sold_22
	FROM sales_data s1
	JOIN ev_state s ON s1.state = s.state
	JOIN dim_date d ON s.date = d.date
	WHERE d.fiscal_year = 2022
    GROUP BY s1.state
),
TS_2024 AS
(
	SELECT s1.state,
	SUM(s.electric_vehicles_sold) AS EV_Vehicles_Sold_24
	FROM sales_data s1
	JOIN ev_state s ON s1.state = s.state
	JOIN dim_date d ON s.date = d.date
	WHERE d.fiscal_year = 2024
    GROUP BY s1.state
),
Combined_Sales AS
(
	SELECT TS_2022.state, TS_2022.EV_Vehicles_Sold_22, TS_2024.EV_Vehicles_Sold_24
	FROM TS_2022
	JOIN TS_2024 ON TS_2022.state = TS_2024.state
),
CAGR_rate AS
(
	SELECT *,
	ROUND((POW(EV_Vehicles_Sold_24/EV_Vehicles_Sold_22,1/2))-1,2) AS CAGR
	FROM Combined_Sales
	ORDER BY CAGR DESC
)
SELECT state,CAGR,
ROUND(EV_Vehicles_Sold_24 * POW(1 + (CAGR), 2030-2024), 2) AS projected_sales_2030
FROM CAGR_rate;

/*10. Estimate the revenue growth rate of 4-wheeler and 2-wheelers EVs in India for 2022 vs 2024 and 2023 vs 2024, 
assuming an average unit price. H*/
-- #Given Average Selling Price 2-Wheelers - Rs85000 and 4-Wheelers - Rs15,00,000

-- 1. 2-Wheelers
-- 2022 vs. 2024
WITH cte AS
(
	SELECT d.fiscal_year, 
	SUM(s.electric_vehicles_sold) AS Total_Units_Sold,
	SUM(s.electric_vehicles_sold) * 85000 AS Revenue
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	WHERE s.vehicle_category = '2-Wheelers' AND d.fiscal_year IN (2022,2024)
	GROUP BY d.fiscal_year
)
SELECT *,
LAG(Revenue,1,0) OVER(ORDER BY fiscal_year),
ROUND(((Revenue - LAG(Revenue,1,0) OVER(ORDER BY fiscal_year))/LAG(Revenue,1,0) OVER(ORDER BY fiscal_year))*100,2) AS Revenue_Growth_Rate
FROM cte;

-- 2023 vs. 2024
WITH cte AS
(
	SELECT d.fiscal_year, 
	SUM(s.electric_vehicles_sold) AS Total_Units_Sold,
	SUM(s.electric_vehicles_sold) * 85000 AS Revenue
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	WHERE s.vehicle_category = '2-Wheelers' AND d.fiscal_year IN (2023,2024)
	GROUP BY d.fiscal_year
)
SELECT *,
LAG(Revenue,1,0) OVER(ORDER BY fiscal_year),
ROUND(((Revenue - LAG(Revenue,1,0) OVER(ORDER BY fiscal_year))/LAG(Revenue,1,0) OVER(ORDER BY fiscal_year))*100,2) AS Revenue_Growth_Rate
FROM cte;


-- 1. 4-Wheelers
-- 2022 vs. 2024
WITH cte AS
(
	SELECT d.fiscal_year, 
	SUM(s.electric_vehicles_sold) AS Total_Units_Sold,
	SUM(s.electric_vehicles_sold) * 1500000 AS Revenue
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	WHERE s.vehicle_category = '4-Wheelers' AND d.fiscal_year IN (2022,2024)
	GROUP BY d.fiscal_year
)
SELECT *,
ROUND(((Revenue - LAG(Revenue,1,0) OVER(ORDER BY fiscal_year))/LAG(Revenue,1,0) OVER(ORDER BY fiscal_year))*100,2) AS Revenue_Growth_Rate
FROM cte;

-- 2023 vs. 2024
WITH cte AS
(
	SELECT d.fiscal_year, 
	SUM(s.electric_vehicles_sold) AS Total_Units_Sold,
	SUM(s.electric_vehicles_sold) * 85000 AS Revenue
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	WHERE s.vehicle_category = '4-Wheelers' AND d.fiscal_year IN (2023,2024)
	GROUP BY d.fiscal_year
)
SELECT *,
ROUND(((Revenue - LAG(Revenue,1,0) OVER(ORDER BY fiscal_year))/LAG(Revenue,1,0) OVER(ORDER BY fiscal_year))*100,2) AS Revenue_Growth_Rate
FROM cte;

/*11. What is the current market size of EVs and hybrid vehicles in India in terms of revenue
and units sold?*/

-- Calculating the overall EV's average selling price
SET @2W_Units_Sold =(SELECT SUM(electric_vehicles_sold) AS Units_Sold
					FROM ev_state
					WHERE vehicle_category = '2-Wheelers');

SET @4W_Units_Sold =(SELECT SUM(electric_vehicles_sold) AS Units_Sold
					FROM ev_state
					WHERE vehicle_category = '4-Wheelers');
                    
SET @2W_ASP = 85000;

SET @4W_ASP = 1500000;

SET @ASP = (SELECT ROUND(((@2W_ASP * @2W_Units_Sold) + (@4W_ASP * @4W_Units_Sold)) / (@2W_Units_Sold + @4W_Units_Sold),2));

SELECT @ASP as asp;


-- Market Size in terms of revenue
SELECT ROUND(SUM(electric_vehicles_sold) * @ASP,2) AS Revenue
FROM ev_state;

/*12. What are the market sizes for different segments (e.g., 2-Wheelers vs. 4-Wheelers) within the EV market?*/
-- 2W
SELECT SUM(electric_vehicles_sold)*@2W_ASP AS Revenue
FROM ev_state
WHERE vehicle_category = '2-Wheelers';

-- 4W
SELECT SUM(electric_vehicles_sold)*@4W_ASP AS Revenue
FROM ev_state
WHERE vehicle_category = '4-Wheelers';

/*13. What is the market size of EVs in different states or regions of India?*/
SELECT state, SUM(electric_vehicles_sold) AS Units_Sold
FROM ev_state
GROUP BY state
ORDER BY Units_Sold DESC;

-- Competitor Landscape Analysis
/*14. Who are the major players in the Indian EV market, and what are their market shares?*/
WITH t_maker AS
(
	SELECT *,
		   SUM(Units_Sold) OVER() AS Market_Size
	FROM (
		SELECT maker, 
			   SUM(electric_vehicles_sold) AS Units_Sold
		FROM ev_makers
		GROUP BY maker
	)t
)
SELECT maker,
ROUND((Units_Sold/Market_Size)*100,2) AS Percent
FROM t_maker
ORDER BY Percent DESC;

/*15. How have the market shares of different competitors changed over time?*/
WITH year_trend AS
(
	SELECT maker, fiscal_year, Units_Sold,
	SUM(electric_vehicles_sold) OVER(PARTITION BY fiscal_year) AS Market_Size
	FROM (
		SELECT m.maker, d.fiscal_year,
		m.electric_vehicles_sold,
		SUM(m.electric_vehicles_sold) AS Units_Sold
		FROM ev_makers m
		JOIN dim_date d ON m.date = d.date
		GROUP BY m.maker, d.fiscal_year
	)t
)
SELECT maker, fiscal_year,
ROUND((Units_Sold/Market_Size)*100,2) AS Pcnt
FROM year_trend
ORDER BY fiscal_year;

/*16. Which manufacturers have shown the most significant growth, and what strategies have they 
employed?*/
WITH maker_year AS
(
	SELECT maker, d.fiscal_year,
	SUM(electric_vehicles_sold) AS Units_Sold
	FROM ev_makers m
	JOIN dim_date d ON m.date = d.date
	GROUP BY maker,d.fiscal_year
	ORDER BY Units_Sold DESC
)
SELECT maker,
MAX(CASE WHEN fiscal_year = 2022 THEN Units_Sold END) AS 'YR_2022',
MAX(CASE WHEN fiscal_year = 2023 THEN Units_Sold END) AS 'YR_2023',
MAX(CASE WHEN fiscal_year = 2024 THEN Units_Sold END) AS 'YR_2024'
FROM maker_year
GROUP BY maker;

-- SECONDARY QUESTIONS
/* 1.What are the primary reasons for customers choosing 4-wheeler EVs in 
2023 and 2024 (cost savings, environmental concerns, government 
incentives)? */
-- Acc to the provided data, most used are 2W but the sales of 4W are also increasing.
-- 1. One reason might be due to increasing charging stations, government initiatives and environmental concerns.
-- To provide more clear answer look for gov. initiatives comparison between ICE vs. EV prices and etc. 

WITH overview_sales AS
(
	SELECT s.vehicle_category, d.fiscal_year, SUM(s.electric_vehicles_sold) AS EV_Sold
	FROM ev_state s
	JOIN dim_date d ON s.date = d.date
	GROUP BY s.vehicle_category, d.fiscal_year
)
SELECT vehicle_category,
MAX(CASE WHEN fiscal_year = 2022  THEN EV_Sold END) AS EV_Sold_22,
MAX(CASE WHEN fiscal_year = 2023 THEN EV_Sold END) AS EV_Sold_23,
MAX(CASE WHEN fiscal_year = 2024 THEN EV_Sold END) AS EV_Sold_24
FROM overview_sales
GROUP BY vehicle_category;

-- Charging Stations
SELECT c.`State Name`, c.`No. of Operational PCS`
FROM ev_stations c
ORDER BY c.`No. of Operational PCS` DESC;

WITH states_sales As
(
	SELECT state, vehicle_category,SUM(electric_vehicles_sold) AS EV_Sold
	FROM ev_state
	GROUP BY state, vehicle_category
)
SELECT s1.state, COALESCE(c.`No. of Operational PCS`,0) AS Charging_Stations,
MAX(CASE WHEN vehicle_category = '2-Wheelers' THEN EV_Sold END) AS '2W',
MAX(CASE WHEN vehicle_category = '4-Wheelers' THEN EV_Sold END) AS '4W'
FROM states_sales s1
LEFT JOIN ev_stations c ON s1.state = c.`State Name`
GROUP BY s1.state
ORDER BY Charging_Stations DESC;





