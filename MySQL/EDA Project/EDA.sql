-- Exploratory Data Analysis (EDA)

select*
from housing_data;

-- Staging the data
create table data_staging
like housing_data;

insert data_staging
select*
from housing_data;

select*
from data_staging;

-- 1. Checking the basic information:
SELECT COUNT(*) AS total_rows FROM data_staging;

-- We have total of 1,12,954 rows

-- 1.1 Checking columns and data types
DESCRIBE data_staging;

-- 2. Summary Statistics
-- Numeric columns:
-- Getting min, max, avg, stddev for SalePrice, Acreage, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath:

SELECT
    MIN(SalePrice) AS min_sale_price,
    MAX(SalePrice) AS max_sale_price,
    AVG(SalePrice) AS avg_sale_price,
    STD(SalePrice) AS std_sale_price,
    
    MIN(Acreage) AS min_acreage,
    MAX(Acreage) AS max_acreage,
    AVG(Acreage) AS avg_acreage,
    STD(Acreage) AS std_acreage,
    
    MIN(LandValue) AS min_land_value,
    MAX(LandValue) AS max_land_value,
    AVG(LandValue) AS avg_land_value,
    STD(LandValue) AS std_land_value,
    
    MIN(BuildingValue) AS min_building_value,
    MAX(BuildingValue) AS max_building_value,
    AVG(BuildingValue) AS avg_building_value,
    STD(BuildingValue) AS std_building_value,
    
    MIN(TotalValue) AS min_total_value,
    MAX(TotalValue) AS max_total_value,
    AVG(TotalValue) AS avg_total_value,
    STD(TotalValue) AS std_total_value,
    
    MIN(YearBuilt) AS min_year_built,
    MAX(YearBuilt) AS max_year_built,
    AVG(YearBuilt) AS avg_year_built,
    
    MIN(Bedrooms) AS min_bedrooms,
    MAX(Bedrooms) AS max_bedrooms,
    AVG(Bedrooms) AS avg_bedrooms,
    
    MIN(FullBath) AS min_full_bath,
    MAX(FullBath) AS max_full_bath,
    AVG(FullBath) AS avg_full_bath,
    
    MIN(HalfBath) AS min_half_bath,
    MAX(HalfBath) AS max_half_bath,
    AVG(HalfBath) AS avg_half_bath
FROM data_staging;

-- 3. Distribution Counts
-- Count Properties by LandUse:
SELECT LandUse, COUNT(*) AS count
FROM data_staging
GROUP BY LandUse
ORDER BY count DESC;

-- Count SoldAsVacant (Yes/No):
SELECT SoldAsVacant, COUNT(*) AS count
FROM data_staging
GROUP BY SoldAsVacant;

-- 4. Data-based Analysis
-- 4.1 Count sales per year
SELECT YEAR(SaleDateConverted) AS sale_year, COUNT(*) AS sales_count
FROM data_staging
GROUP BY sale_year
ORDER BY sale_year;

-- 4.2 Average SalePrice per year:
SELECT YEAR(SaleDateConverted) AS sale_year, AVG(SalePrice) AS avg_sale_price
FROM data_staging
GROUP BY sale_year
ORDER BY sale_year;

-- 5. Checking for missing or null values
SELECT
    SUM(CASE WHEN ParcelID IS NULL OR ParcelID = '' THEN 1 ELSE 0 END) AS missing_parcelid,
    SUM(CASE WHEN LandUse IS NULL OR LandUse = '' THEN 1 ELSE 0 END) AS missing_landuse,
    SUM(CASE WHEN SaleDate IS NULL OR SaleDate = '' THEN 1 ELSE 0 END) AS missing_saledate,
    SUM(CASE WHEN SalePrice IS NULL THEN 1 ELSE 0 END) AS missing_saleprice,
    SUM(CASE WHEN OwnerName IS NULL OR OwnerName = '' THEN 1 ELSE 0 END) AS missing_ownername,
    SUM(CASE WHEN Acreage IS NULL THEN 1 ELSE 0 END) AS missing_acreage,
    SUM(CASE WHEN YearBuilt IS NULL THEN 1 ELSE 0 END) AS missing_yearbuilt
FROM data_staging;

-- 6. Relationships & Correlations
-- 6.1 Average SalePrice by LandUse:
SELECT LandUse, AVG(SalePrice) AS avg_sale_price, COUNT(*) AS count
FROM data_staging
GROUP BY LandUse
ORDER BY avg_sale_price DESC;

-- 6.2 Average SalePrice by number of Bedrooms
SELECT Bedrooms, AVG(SalePrice) AS avg_sale_price, COUNT(*) AS count
FROM data_staging
GROUP BY Bedrooms
ORDER BY Bedrooms;

-- 7. Top owners by number od properties sold
SELECT OwnerName, COUNT(*) AS num_properties, AVG(SalePrice) AS avg_price
FROM data_staging
GROUP BY OwnerName
ORDER BY num_properties DESC
LIMIT 10;

-- 8. Basic Outlier Detection
-- Example: Find properties with SalePrice above 95th percentile

-- Calculate the total number of rows
WITH ranked AS (
    SELECT SalePrice, ROW_NUMBER() OVER (ORDER BY SalePrice) AS rn, COUNT(*) OVER () AS total_rows
    FROM data_staging
)
SELECT *
FROM data_staging
WHERE SalePrice > (
    SELECT SalePrice
    FROM ranked
    WHERE rn = FLOOR(0.95 * total_rows)
);






