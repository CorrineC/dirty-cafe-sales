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
