-- Data Cleaning

-- Standardizing the Date Format
select*
from housing_data;

SELECT SaleDate, STR_TO_DATE(SaleDate, '%M %d, %Y') AS Sale_Date
FROM housing_data;


SET SQL_SAFE_UPDATES = 0;


alter table housing_data
add SaleDateConverted Date;

update housing_data
set SaleDateConverted = STR_TO_DATE(SaleDate, '%M %d, %Y');

-- Adding Null in the empty spaces in the whole data. This is the problem with the MySQL WorkBench
SELECT OwnerName
FROM housing_data
WHERE TRIM(OwnerName) = '';

SELECT COUNT(*) AS Blank_OwnerNames
FROM housing_data
WHERE TRIM(OwnerName) = '';

SELECT OwnerName, LENGTH(OwnerName) AS RawLength, LENGTH(TRIM(OwnerName)) AS TrimmedLength
FROM housing_data
WHERE TRIM(OwnerName) = ''
LIMIT 20;

UPDATE housing_data
SET OwnerName = NULL
WHERE OwnerName = '';

SELECT COUNT(*) AS Null_OwnerNames
FROM housing_data
WHERE OwnerName IS NULL;

-- Convert all empty strings to NULL
UPDATE housing_data SET
    ParcelID = NULLIF(TRIM(ParcelID), ''),
    LandUse = NULLIF(TRIM(LandUse), ''),
    PropertyAddress = NULLIF(TRIM(PropertyAddress), ''),
    SaleDate = NULLIF(TRIM(SaleDate), ''),
    LegalReference = NULLIF(TRIM(LegalReference), ''),
    SoldAsVacant = NULLIF(TRIM(SoldAsVacant), ''),
    OwnerName = NULLIF(TRIM(OwnerName), ''),
    OwnerAddress = NULLIF(TRIM(OwnerAddress), ''),
    TaxDistrict = NULLIF(TRIM(TaxDistrict), '');



SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(ParcelID) AS null_ParcelID,
  COUNT(*) - COUNT(LandUse) AS null_LandUse,
  COUNT(*) - COUNT(PropertyAddress) AS null_PropertyAddress,
  COUNT(*) - COUNT(SaleDate) AS null_SaleDate,
  COUNT(*) - COUNT(LegalReference) AS null_LegalReference,
  COUNT(*) - COUNT(SoldAsVacant) AS null_SoldAsVacant,
  COUNT(*) - COUNT(OwnerName) AS null_OwnerName,
  COUNT(*) - COUNT(OwnerAddress) AS null_OwnerAddress,
  COUNT(*) - COUNT(TaxDistrict) AS null_TaxDistrict
FROM housing_data;



UPDATE housing_data
SET
  UniqueID = NULLIF(TRIM(UniqueID), ''),
  ParcelID = NULLIF(TRIM(ParcelID), ''),
  LandUse = NULLIF(TRIM(LandUse), ''),
  PropertyAddress = NULLIF(TRIM(PropertyAddress), ''),
  SaleDate = NULLIF(TRIM(SaleDate), ''),
  SalePrice = NULLIF(TRIM(SalePrice), ''),
  LegalReference = NULLIF(TRIM(LegalReference), ''),
  SoldAsVacant = NULLIF(TRIM(SoldAsVacant), ''),
  OwnerName = NULLIF(TRIM(OwnerName), ''),
  OwnerAddress = NULLIF(TRIM(OwnerAddress), ''),
  Acreage = NULLIF(TRIM(Acreage), ''),
  TaxDistrict = NULLIF(TRIM(TaxDistrict), ''),
  LandValue = NULLIF(TRIM(LandValue), ''),
  BuildingValue = NULLIF(TRIM(BuildingValue), ''),
  TotalValue = NULLIF(TRIM(TotalValue), ''),
  YearBuilt = NULLIF(TRIM(YearBuilt), ''),
  Bedrooms = NULLIF(TRIM(Bedrooms), ''),
  FullBath = NULLIF(TRIM(FullBath), ''),
  HalfBath = NULLIF(TRIM(HalfBath), '');

SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT(UniqueID) AS null_UniqueID,
  COUNT(*) - COUNT(ParcelID) AS null_ParcelID,
  COUNT(*) - COUNT(LandUse) AS null_LandUse,
  COUNT(*) - COUNT(PropertyAddress) AS null_PropertyAddress,
  COUNT(*) - COUNT(SaleDate) AS null_SaleDate,
  COUNT(*) - COUNT(SalePrice) AS null_SalePrice,
  COUNT(*) - COUNT(LegalReference) AS null_LegalReference,
  COUNT(*) - COUNT(SoldAsVacant) AS null_SoldAsVacant,
  COUNT(*) - COUNT(OwnerName) AS null_OwnerName,
  COUNT(*) - COUNT(OwnerAddress) AS null_OwnerAddress,
  COUNT(*) - COUNT(Acreage) AS null_Acreage,
  COUNT(*) - COUNT(TaxDistrict) AS null_TaxDistrict,
  COUNT(*) - COUNT(LandValue) AS null_LandValue,
  COUNT(*) - COUNT(BuildingValue) AS null_BuildingValue,
  COUNT(*) - COUNT(TotalValue) AS null_TotalValue,
  COUNT(*) - COUNT(YearBuilt) AS null_YearBuilt,
  COUNT(*) - COUNT(Bedrooms) AS null_Bedrooms,
  COUNT(*) - COUNT(FullBath) AS null_FullBath,
  COUNT(*) - COUNT(HalfBath) AS null_HalfBath
FROM housing_data;

select*
from housing_data;

-- Populating the property address data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.PropertyAddress,b.PropertyAddress)
from housing_data as a
join housing_data as b
	on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;
    

UPDATE housing_data AS a
JOIN housing_data AS b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;

-- Breaking out Address into individual columns (Address, City, State)

select PropertyAddress
from housing_data;

SELECT 
  SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1) as Address,
  SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1) , length(PropertyAddress) AS Address
FROM housing_data;

alter table housing_data
add PropertySplitAddress varchar(255);

update housing_data
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) - 1);

alter table housing_data
add PropertySplitCity varchar(255);

update housing_data
set PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) + 1);

select*
from housing_data;


-- Changing OwnerAddress using Trim and Substring_Index

select OwnerAddress
from housing_data;

SELECT
  TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)) AS Address,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS City,
  TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS State
FROM housing_data;


alter table housing_data
add column OwnerSplitAddress varchar(255);

update housing_data
set OwnerSplitAddress = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1));

alter table housing_data
add column OwnerSplitCity varchar(255);

update housing_data
set OwnerSplitCity =   TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));

alter table housing_data
add column OwnerSplitState varchar(255);

update housing_data
set OwnerSplitState =   TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

select*
from housing_data;


-- Change Y and N to Yes and No in SoldAsVacant Column

select distinct (SoldAsVacant), count(SoldAsVacant)
from housing_data
group by SoldAsVacant
order by 2;

select SoldAsVacant, 
	case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
    else SoldAsVacant
    end
from housing_data;

update housing_data
set SOldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
    else SoldAsVacant
    end;

-- Removing Duplicates

with RowNumCTE as(
select*,
	row_number() over(
    partition by ParcelID,
				 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 order by
					UniqueID
                    ) row_num

from housing_data
)
DELETE
from RowNumCTE
where row_num >1;

-- Delete unused columns

select*
from housing_data;

alter table housing_data
drop column OwnerAddress,
drop column	PropertyAddress,
drop column TaxDistrict,
drop column SaleDate;



