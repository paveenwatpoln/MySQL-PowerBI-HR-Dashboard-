-- -------------------------- QUESTIONS --------------------------

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    gender,
    COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
	round(avg(datediff(termdate, hire_date))/365,0) AS avg_length_employmentYEAR
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY department, gender
ORDER BY department, gender;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle;

-- 8. Which department has the highest turnover rate?
/*
"Turnover rate" typically refers to the rate at which employees leave a company or department and need to be replaced. 
It can be calculated as the number of employees who leave over a given time period divided by the average number of employees in the company or department over that same time period.
*/
SELECT 
	department, 
    COUNT(*) AS count,
    SUM(CASE WHEN termdate <= curdate() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) AS terminated_count,
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) AS active_count,
    (SUM(CASE WHEN termdate <= curdate() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END)/ COUNT(*)) AS terminated_rate
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY terminated_rate DESC;


-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT
	year,
    hire,
    termination,
    hire-termination AS net_change,
    round((hire-termination)/hire * 100, 2) AS pct_change
FROM(
	SELECT 
		YEAR(hire_date) AS year,
        COUNT(*) AS hire,
        SUM(CASE WHEN termdate <= curdate() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) AS termination
	FROM hr
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
    ) AS subquery
ORDER BY year;

-- 11. What is the tenure distribution for each department?
SELECT *
FROM hr;

SELECT 
	department,
    ROUND(AVG(datediff(termdate, hire_date)/365), 0) AS avg_tenure
FROM hr
WHERE age >= 18 AND termdate <> '0000-00-00' AND termdate <= curdate()
GROUP BY department
ORDER BY avg_tenure DESC;
