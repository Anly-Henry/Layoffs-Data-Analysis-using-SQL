-- Exploratory Data Analysis

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2; 

-- Total number of companies that went 100% laid off
SELECT COUNT(company)
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC; 

-- Company that laid off more people 
SELECT Company,total_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC; 

-- Company that acquired the max fund
SELECT company,MAX(funds_raised_millions)
FROM layoffs_staging2
GROUP BY company
ORDER BY MAX(funds_raised_millions) DESC;

-- Sum of total laid of each company
SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; 

-- Duration in which the lay off took place
SELECT MIN(date),MAX(date)
FROM layoffs_staging2;

-- Industry which got hit the most 
SELECT industry,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC; 

-- The year on which there was most lay off
SELECT YEAR(date),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 2 DESC; 

SELECT stage,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 

-- Progression of Lay off or rolling sum

SELECT SUBSTRING(`date`,1,7)
FROM layoffs_staging2; 

WITH rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM rolling_Total;


-- Each compnay and their total laid off details each year
SELECT company,YEAR(`date`) AS `year` ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
; 

-- Top 5 companies and their total laid off details each year
WITH company_year AS
(
SELECT company,YEAR(`date`) AS `year` ,SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
company_year_rank AS
(
SELECT *, DENSE_RANK () OVER (PARTITION BY `year` ORDER BY total_laid_off DESC) AS rank_over
FROM company_year
WHERE `year` IS NOT NULL
)
SELECT * 
FROM company_year_rank
WHERE rank_over<=5
;