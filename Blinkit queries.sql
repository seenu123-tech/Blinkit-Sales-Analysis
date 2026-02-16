/* ============================================================
	View Complete Dataset
============================================================ */

SELECT * 
FROM blinkit_data;


/* ============================================================
	Total Number of Records
============================================================ */

SELECT COUNT(*) AS Total_Rows 
FROM blinkit_data;


/* ============================================================
	Check Unique Values in Item Fat Content
============================================================ */

SELECT DISTINCT `Item Fat Content`
FROM blinkit_data;


/* ============================================================
	Standardize Item Fat Content (Low Fat Variations)
============================================================ */

UPDATE blinkit_data
SET `Item Fat Content` = 'Low Fat'
WHERE LOWER(`Item Fat Content`) IN ('low fat', 'lf');


/* ============================================================
    Standardize Item Fat Content (Regular Variations)
============================================================ */

UPDATE blinkit_data
SET `Item Fat Content` = 'Regular'
WHERE LOWER(`Item Fat Content`) IN ('regular', 'reg');


/* ============================================================
    Check for NULL Values in Important Columns
============================================================ */

SELECT 
    SUM(CASE WHEN `Item Identifier` IS NULL THEN 1 ELSE 0 END) AS Null_Item_ID,
    SUM(CASE WHEN `Item Type` IS NULL THEN 1 ELSE 0 END) AS Null_Item_Type,
    SUM(CASE WHEN `Outlet Size` IS NULL THEN 1 ELSE 0 END) AS Null_Outlet_Size,
    SUM(CASE WHEN `Item Weight` IS NULL THEN 1 ELSE 0 END) AS Null_Item_Weight,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Null_Sales,
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS Null_Rating
FROM blinkit_data;


/* ============================================================
    Check for Duplicate Records
============================================================ */

SELECT *,
       COUNT(*) 
FROM blinkit_data
GROUP BY 
    `Item Fat Content`,
    `Item Identifier`,
    `Item Type`,
    `Outlet Establishment Year`,
    `Outlet Identifier`,
    `Outlet Location Type`,
    `Outlet Size`,
    `Outlet Type`,
    `Item Visibility`,
    `Item Weight`,
    Sales,
    Rating
HAVING COUNT(*) > 1;


/* ============================================================
    Validate Negative Sales Values
============================================================ */

SELECT *
FROM blinkit_data
WHERE Sales < 0;


/* ============================================================
    Validate Incorrect Rating Values
============================================================ */

SELECT *
FROM blinkit_data
WHERE Rating < 0 OR Rating > 5;


/* ============================================================
    Total Sales KPI
============================================================ */

SELECT ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_data;


/* ============================================================
    Average Sales KPI
============================================================ */

SELECT ROUND(AVG(Sales),2) AS Avg_Sales
FROM blinkit_data;


/* ============================================================
    Total Items KPI
============================================================ */

SELECT COUNT(*) AS Total_Items
FROM blinkit_data;


/* ============================================================
    Average Rating KPI
============================================================ */

SELECT ROUND(AVG(Rating),2) AS Avg_Rating
FROM blinkit_data;


/* ============================================================
    Sales by Outlet Type
============================================================ */

SELECT `Outlet Type`,
       ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_data
GROUP BY `Outlet Type`
ORDER BY Total_Sales DESC;


/* ============================================================
    Sales by Outlet Location Type
============================================================ */

SELECT `Outlet Location Type`,
       ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_data
GROUP BY `Outlet Location Type`
ORDER BY Total_Sales DESC;


/* ============================================================
    Top 5 Item Types by Sales
============================================================ */

SELECT `Item Type`,
       ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_data
GROUP BY `Item Type`
ORDER BY Total_Sales DESC
LIMIT 5;

/* ============================================================
	Bottom 5 Item Types by Sales
   (Identifying Lowest Performing Product Categories)
============================================================ */

SELECT `Item Type`,
       ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_data
GROUP BY `Item Type`
ORDER BY Total_Sales ASC
LIMIT 5;



/* ============================================================
    Sales Contribution Percentage by Outlet Type
============================================================ */

SELECT 
    `Outlet Type`,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(
        (SUM(Sales) / (SELECT SUM(Sales) FROM blinkit_data)) * 100
    ,2) AS Sales_Percentage
FROM blinkit_data
GROUP BY `Outlet Type`
ORDER BY Total_Sales DESC;


/* ============================================================
    Sales & Average Sales by Item Fat Content
============================================================ */

SELECT 
    `Item Fat Content`,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(AVG(Sales),2) AS Avg_Sales
FROM blinkit_data
GROUP BY `Item Fat Content`;


/* ============================================================
    Outlet Age Analysis (Outlet Maturity vs Sales)
============================================================ */

SELECT 
    (YEAR(CURDATE()) - `Outlet Establishment Year`) AS Outlet_Age,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Age
ORDER BY Outlet_Age;


/* ============================================================
    Sales by Outlet Size
============================================================ */

SELECT 
    `Outlet Size`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_data
GROUP BY `Outlet Size`
ORDER BY Total_Sales DESC;


/* ============================================================
    Rating Group vs Sales Analysis
============================================================ */

SELECT 
    FLOOR(Rating) AS Rating_Group,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_data
GROUP BY Rating_Group
ORDER BY Rating_Group;


/* ============================================================
    Create View for Dashboard Reporting
============================================================ */

CREATE VIEW sales_summary AS
SELECT 
    `Outlet Type`,
    `Outlet Location Type`,
    `Item Fat Content`,
    SUM(Sales) AS Total_Sales,
    AVG(Rating) AS Avg_Rating
FROM blinkit_data
GROUP BY 
    `Outlet Type`,
    `Outlet Location Type`,
    `Item Fat Content`;


/* ============================================================
    Retrieve Data from Created View
============================================================ */

SELECT * 
FROM sales_summary;
