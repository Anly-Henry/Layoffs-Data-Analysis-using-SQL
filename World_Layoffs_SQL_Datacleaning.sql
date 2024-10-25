-- DATA CLEANING
SELECT *
FROM layoffs;

-- Task 1: Remove Duplicates if any
-- Task 2: Standardize the Data 
-- Task 3: NULL values or Blank values
-- Task 4: Remove columns or rows if not necessary 

-- Making a replica of the raw table to work with

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- Task 1: Remove Duplicates if any

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

WITH duplicate_CTE AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging)
SELECT *
FROM duplicate_CTE
WHERE row_num>1;

-- Create a table layoff_staging2 in order to remove all the rows with row_num 2

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
   `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num>1;

DELETE
FROM layoffs_staging2
WHERE row_num>1;

SELECT *
FROM layoffs_staging2;

-- Task 2: Standardize the Data 
-- Triming the company Column 
SELECT company,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

-- Spell checking the industry column 
SELECT industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry='Crypto' 
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;

-- Spell checking the location column 
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Spell checking the country column 
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country=REPLACE(country,'United States.','United States')  
WHERE country LIKE '%United States.%';

-- Changing the data type of date column from text to date
SELECT `date`, str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`=str_to_date(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;

SELECT *
FROM layoffs_staging2;

-- Task 3: NULL values or Blank values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Populating the blank values in industry column
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry='';

SELECT * 
FROM layoffs_staging2
WHERE company IN ('Airbnb', 'Carvana', 'Juul');

SELECT *,
CASE 
    WHEN company = 'Airbnb' THEN 'Travel'
    WHEN company = 'Carvana' THEN 'Transportation'
	WHEN company = 'Juul' THEN 'Consumer'
    ELSE industry 
END AS industry
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET industry = CASE 
    WHEN company = 'Airbnb' THEN 'Travel'
    WHEN company = 'Carvana' THEN 'Transportation'
    WHEN company = 'Juul' THEN 'Consumer'
    ELSE industry -- Keeps other rows unchanged
END
WHERE company IN ('Airbnb', 'Carvana','Juul');

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
FROM layoffs_staging2;

-- Task 4: Remove columns or rows if not necessary 
-- Deleting the rows that has NULL values for both total_laid_off and Percentage_laid_off 
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Droping the row_num column since its no longer required
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2; -- Finalized layoffs_staging2 table




































