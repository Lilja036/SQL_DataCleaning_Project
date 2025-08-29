

select *
from layoffs;

-- 1.Remove duplicates --
-- 2.Standardize the data -- like if there are issues with spelling
-- 3.NUll or Blank values --
-- 4.Remove any columns -- like empty (but remove it from the copy of data

#Created a copy (layoffs_staging) to preserve the original data.

create table layoffs_staging
like layoffs;                                                             #copy columns from layoffs table and store in 

select * 
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;

select *
from layoffs_staging;


-- 1. Removing Duplicates 

select *,
row_number() over(partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

-- Used a Common Table Expression (CTE) with ROW_NUMBER() to identify duplicates 
with duplicate_cte as
(
select *,
row_number() 
over(partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select * 
from duplicate_cte
where row_num>1;

-- Created layoffs_staging2 to store cleaned data with row_num.

-- create table layoffs_staging2
-- like layoffs_staging;                           //not the right way of creating table now because it would not contain row_no column

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2;

insert into layoffs_staging2
select *, 
row_number()
 over(partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging; 

select *
from layoffs_staging2
where row_num>1;

-- Deleting duplicates where row_num > 1.
delete                                  
from layoffs_staging2
where row_num>1;


-- 2.Standardizing data
-- 1.Removing extra white spaces using TRIM function
select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company= trim(company);

-- Standardizing variations e.g., "Crypto Currency" to "Crypto"
select distinct(industry)
from layoffs_staging2                                         
order by 1;

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry='Crypto'
where industry like 'Crypto%';

--  check location column and everything is fine
select distinct(location)                            
from layoffs_staging2
order by 1;

-- Removing trailing dots e.g., "United States." to "United States"
select distinct(country)                                  
from layoffs_staging2
order by 1;

select distinct(country) 
from layoffs_staging2
where country like 'United States%';

select distinct(country), trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country=trim(trailing '.' from country)
where country like 'United States%' ;

-- Converting text dates to standard DATE format
select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date`=str_to_date(`date`,'%m/%d/%Y');                    

select `date`
from layoffs_staging2
order by 1;

-- chainging text data type to date data type
alter table layoffs_staging2                                    
modify column `date` date;


-- Removing Null/Blank values

select * 
from layoffs_staging2
where industry is null
or
industry = ' ';

select * 
from layoffs_staging2
where company='Airbnb';                     # as Airbnb is a travel company, so populate the empty value of industry for Airbnb company with travel

select *
from layoffs_staging2 as t1
join layoffs_staging2 as t2                # self join on the same company where in t1 industry is null for the same company and t2 the industry in not null
   on t1.company=t2.company
where (t1.industry is null or t1.industry = ' ')
and t2.industry is not null;

update layoffs_staging2
set industry = null
where industry = ' ';
   
-- Populated NULLs in industry using a self-join on company
update layoffs_staging2 as t1
join layoffs_staging2 as t2
    on t1.company=t2.company
set t1.industry=t2.industry
where (t1.industry is null or t1.industry = ' ') 
and t2.industry is not null;

select * 
from layoffs_staging2
where company='Bally%';                             # industry is empty, bcz no same company 


-- 4. Remove any columns or rows
select * 
from layoffs_staging2
where total_laid_off is null
and 
percentage_laid_off is null;                      #not enough information to fill them and not sure whether to delete them

delete 
from layoffs_staging2
where total_laid_off is null
and 
percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;