/** Data Cleaning for Dirty Cafe Sales
Kaggle dataset: https://www.kaggle.com/datasets/ahmedmohamed2003/cafe-sales-dirty-data-for-cleaning-training

Below are the steps I will take to clean the data:
    1. Remove Dupes
    2. Standardize
    3. NULL/blank values
    4. Remove Any Columns

But first, I need to import the .csv file into my database cafe_sales as table dirty_cafe_sales, which is proving difficult.
There are a lot of blanks, UNKNOWN, and ERROR values in the data that make columns difficult to cast.

Ordinarily, I would clean these up in the .csv BEFORE I try to import it into MySQL Workbench.
However, since the point of this exercise is to practice cleaning via SQL, I am going to import all columns as text regardless
    of original data type, and I will cast them to the correct data types at the end of the exercise.
**/


SELECT * FROM cafe_sales.dirty_cafe_sales;


-- Start by creating a staging table so we can make changes to a copy of the dataset without affecting the original.
CREATE TABLE cafe_sales_staging
LIKE dirty_cafe_sales;

SELECT * FROM cafe_sales_staging;

INSERT cafe_sales_staging
SELECT *
FROM dirty_cafe_sales;


-- 1. Remove Dupes

-- Check whether there are duplicates among the Transaction IDs
SELECT DISTINCT `Transaction ID`
FROM cafe_sales_staging
ORDER BY 1;

/** 10,000 rows returned, meaning every transaction ID is unique
Since each transaction ID is unique, it would be very hard to verify whether two transactions are duplicates of each other
EVEN IF every other column in the entries are exactly the same.

It is entirely possible that two separate customers purchased the same exact quantity of an item using the same payment method at the same location on the same day.
IF the transaction date ALSO had a timestamp, duplicates might be easier to identify in cases where the timestamps were exactly the same down to the millisecond.
So in this case, I would rather keep all transactions.
**/


-- 2. Standardize

SELECT * FROM cafe_sales_staging;

-- Check that column values do not have variations or any extraneous spaces or trailing punctuation
SELECT `Transaction ID`, TRIM(`Transaction ID`)
FROM cafe_sales_staging
WHERE `Transaction ID` != TRIM(`Transaction ID`);

SELECT DISTINCT Item
FROM cafe_sales_staging;

SELECT DISTINCT `Payment Method`
FROM cafe_sales_staging;

SELECT DISTINCT `Payment Method`
FROM cafe_sales_staging;

SELECT DISTINCT Location
FROM cafe_sales_staging;

-- Change Date Formatting for Transaction Date
SELECT `Transaction Date`, str_to_date(`Transaction Date`, '%m/%d/%Y')
FROM cafe_sales_staging;

SELECT DISTINCT `Transaction Date`
FROM cafe_sales_staging
WHERE `Transaction DATE` NOT LIKE '%/%/%';

-- Change any blanks, ERRORs, or UNKNOWNs in Transaction Date column to NULL
UPDATE cafe_sales_staging
SET `Transaction Date` = NULL
WHERE `Transaction DATE` NOT LIKE '%/%/%';

-- Change date formatting
UPDATE cafe_sales_staging
SET `Transaction Date` = STR_TO_DATE(`Transaction Date`, '%m/%d/%Y');

-- Change data type for Transaction Date column
ALTER TABLE cafe_sales_staging
MODIFY COLUMN `Transaction Date` DATE;

SELECT * FROM cafe_sales_staging;


-- 3. NULL/blank values

/** I want to standardize any blanks, UNKNOWN, and ERROR values to NULL.

I have considered whether to keep the distinctions between UNKNOWN and ERROR so as to track potential
"malfunctions" in the system.

In a real world setting, this would be useful information! For example, seeing a lot of errors suddenly pop up
for certain types of transactions might indicate a system glitch. An unknown might be an item that was
entered manually because it's not yet in the POS system or because a discount was applied manually.

But here we are dealing a small dataset where each transaction has few attributes, so I'm just going to
standardize everything to null and complete missing fields on transactions where I have enough info to do so.

Just in case, I will make these changes on a new table.
**/
CREATE TABLE cafe_sales_staging2
LIKE cafe_sales_staging;

SELECT * FROM cafe_sales_staging2;

INSERT cafe_sales_staging2
SELECT *
FROM cafe_sales_staging;

SELECT *
FROM cafe_sales_staging2
WHERE Item = 'UNKNOWN'
	OR Item = 'ERROR'
    OR Item = '';
    
UPDATE cafe_sales_staging2
SET Item = NULL
WHERE Item = 'UNKNOWN'
	OR Item = 'ERROR'
    OR Item = '';

SELECT DISTINCT Item FROM cafe_sales_staging2; -- Now all items that are blank, unknow, or error are NULL

-- I will return later to the Item section to fill in some of those nulls where I know the pricing matches a specific item

-- Now I will handle errors/blanks/unknowns in Quantity
-- Later I can return to fill in missing data. The reason I'm standardizing to nulls before filling in missing data is because
-- it will make more complex queries dealing with missing values easier to set up in the future.
SELECT DISTINCT Quantity FROM cafe_sales_staging2;

SELECT *
FROM cafe_sales_staging2
WHERE Quantity = 'UNKNOWN'
	OR Quantity = 'ERROR'
    OR Quantity = '';
    
UPDATE cafe_sales_staging2
SET Quantity = NULL
WHERE Quantity = 'UNKNOWN'
	OR Quantity = 'ERROR'
    OR Quantity = '';
    
SELECT DISTINCT Quantity FROM cafe_sales_staging2;

ALTER TABLE cafe_sales_staging2
MODIFY COLUMN Quantity INT;

SELECT * FROM cafe_sales_staging2;

-- Unknowns in price per unit
SELECT DISTINCT `Price Per Unit` FROM cafe_sales_staging2;

SELECT *
FROM cafe_sales_staging2
WHERE `Price Per Unit` = 'UNKNOWN'
	OR `Price Per Unit` = 'ERROR'
    OR `Price Per Unit` = '';
    
UPDATE cafe_sales_staging2
SET `Price Per Unit` = NULL
WHERE `Price Per Unit` = 'UNKNOWN'
	OR `Price Per Unit` = 'ERROR'
    OR `Price Per Unit` = '';
    
ALTER TABLE cafe_sales_staging2
MODIFY COLUMN `Price Per Unit` FLOAT;

-- Resolve Unknowns in Total Spent
SELECT DISTINCT `Total Spent` FROM cafe_sales_staging2;

SELECT *
FROM cafe_sales_staging2
WHERE `Total Spent` = 'UNKNOWN'
	OR `Total Spent` = 'ERROR'
    OR `Total Spent` = '';
    
UPDATE cafe_sales_staging2
SET `Total Spent` = NULL
WHERE `Total Spent` = 'UNKNOWN'
	OR `Total Spent` = 'ERROR'
    OR `Total Spent` = '';
    
ALTER TABLE cafe_sales_staging2
MODIFY COLUMN `Total Spent` FLOAT;

-- Resolve Unknowns in Payment Method
SELECT DISTINCT `Payment Method` FROM cafe_sales_staging2;

SELECT *
FROM cafe_sales_staging2
WHERE `Payment Method` = 'UNKNOWN'
	OR `Payment Method` = 'ERROR'
    OR `Payment Method` = '';
    
UPDATE cafe_sales_staging2
SET `Payment Method` = NULL
WHERE `Payment Method` = 'UNKNOWN'
	OR `Payment Method` = 'ERROR'
    OR `Payment Method` = '';
    
-- Resolve Unknowns in Location
SELECT DISTINCT `Location` FROM cafe_sales_staging2;

SELECT *
FROM cafe_sales_staging2
WHERE `Location` = 'UNKNOWN'
	OR `Location` = 'ERROR'
    OR `Location` = '';
    
UPDATE cafe_sales_staging2
SET `Location` = NULL
WHERE `Location` = 'UNKNOWN'
	OR `Location` = 'ERROR'
    OR `Location` = '';
    
SELECT * FROM cafe_sales_staging2;