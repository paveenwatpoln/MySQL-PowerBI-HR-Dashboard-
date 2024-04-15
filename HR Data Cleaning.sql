CREATE DATABASE IF NOT EXISTS humanresourcesdb;

USE humanresourcesdb;

SELECT * FROM hr;

-- -------------------------- DATA CLEANING --------------------------
-- Change employee id column name
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- Check data type
DESCRIBE hr;

SELECT 
	birthdate, 
    hire_date,
    termdate
FROM hr;

SET sql_safe_updates = 0;

-- Change date format
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Change data type from text to date
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- Check 'termdate' column
UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- ADD new column 'age'
ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate,CURDATE());

SELECT birthdate, age FROM hr;

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

-- There are rows that have minus value of age, need to exclude from analysis
SELECT COUNT(*) FROM hr WHERE age < 0;




