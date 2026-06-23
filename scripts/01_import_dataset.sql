-- Building the raw dataset table framework so it doesn't take forever
-- Keeping the columns generic for now to accommodate unusual data
USE cafe_sales;

DROP TABLE IF EXISTS dirty_cafe_sales;
CREATE TABLE dirty_cafe_sales (
    `Transaction ID` VARCHAR(255),
    `Item` VARCHAR(255),
    `Quantity` VARCHAR(255),
    `Price Per Unit` VARCHAR(255),
    `Total Spent` VARCHAR(255),
	`Payment Method` VARCHAR(255),
    `Location` VARCHAR(255),
	`Transaction Date` VARCHAR(255)
);

SELECT *
FROM dirty_cafe_sales;

-- Now using import wizard to populate the table.