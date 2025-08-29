# SQL Data Cleaning Project
This project focuses on preparing a raw dataset for analysis by handling duplicates, standardizing formats, and addressing missing values. 

# Dataset
The dataset used is a layoffs dataset containing information about company layoffs, including columns like company, industry, location, country, date, total_laid_off, percentage_laid_off, stage, and funds_raised_millions.

# Data Cleaning Steps
1. Data Import and Backup: Imported raw data and created a copy(layoffs_staging) to preserve the original data.
2. Removing Duplicates: Used a common table expression (CTE) with row_number() to identify duplicates and then delete duplicates where row_num>1.
3. Standardizing Data: Standardized variations like 'Crypto' and 'Crypto Currency' to 'Crypto'.
4. Handling NULL/Blank Values: Handled NULL values in the industry column using a self-join on the company column.

# Tools
Used SQL language for data cleaning and MYSQL Database.

After data cleaning steps, the dataset is ready for analysis.
