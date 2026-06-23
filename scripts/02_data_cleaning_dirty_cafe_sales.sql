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

