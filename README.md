# Layoffs-Data-Analysis-using-SQL

## Table of Contents
1. [Project Description](#project-description)
2. [Technologies Used](#technologies-used)
3. [Data Cleaning](#data-cleaning)
   - [Removing Duplicates](#removing-duplicates)
   - [Standardizing Data](#standardizing-data)
   - [Handling NULL Values](#handling-null-values)
4. [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
   - [Maximum Total Laid Off Employees](#maximum-total-laid-off-employees)
   - [Total Number of Companies with 100% Layoffs](#total-number-of-companies-with-100-layoffs)
   - [Industry Impact Analysis](#industry-impact-analysis)
5. [Getting Started](#getting-started)
6. [Results](#results)
7. [Conclusion](#conclusion)
   
## Project Description
This project focuses on the analysis of layoffs data through comprehensive data cleaning and exploratory data analysis (EDA). The goal is to identify patterns and trends in layoffs across various companies and industries.

## Technologies Used
- MySQL
- SQL Workbench

## Data Cleaning
The data cleaning process includes:

**Removing Duplicates**
```sql
WITH duplicate_CTE AS (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1;
```

**Standardizing Data**
- **Trimming the Company Column:**
```sql
UPDATE layoffs_staging2
SET company = TRIM(company);
```

- **Spell Checking the Industry Column:**
```sql
UPDATE layoffs_staging2
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';
```
- **Changing the Date Column Data Type:**
```sql
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;
```
- **Handling NULL Values**
```sql
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
```
## Exploratory Data Analysis (EDA)
In this phase, various insights were derived, including:

**Maximum Total Laid Off Employees**
```sql
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2; 
```
**Total Number of Companies with 100% Layoffs**
```sql
SELECT COUNT(company)
FROM layoffs_staging2
WHERE percentage_laid_off = 1;
```
**Industry Impact Analysis**
```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC; 
```
## Getting Started
1. Clone this repository.
2. Set up your MySQL database and import the necessary data.
3. Execute the SQL scripts provided to perform data cleaning and analysis.

## Results
The analysis revealed significant trends in layoffs by industry, with visualizations showcasing the impact on various sectors. Detailed reports can be generated for specific companies and timeframes.

## Conclusion
This project illustrates the importance of data cleaning and analysis in deriving actionable insights from complex datasets. The findings can assist stakeholders in understanding market trends and making informed decisions.












