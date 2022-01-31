USE employees_mod;

-- Problem1: Create a visualization that provides a breakdown between the male and female employees working in the company each year, starting from 1990.
SELECT
YEAR(d.from_date) as calendar_year,
e.gender,
COUNT(e.emp_no) as num_of_employees
FROM t_employees e
JOIN 
t_dept_emp d 
ON d.emp_no = e.emp_no
GROUP BY calendar_year, e.gender
HAVING calendar_year >= 1990;

-- Problem2: Compare the number of male managers to the number of female managers from different departments for each year, starting from 1990.
SELECT m.*, e.*, d.*
FROM t_dept_manager m
inner join t_employees e
on m.emp_no = e.emp_no
left join t_departments d
on m.dept_no =d.dept_no;

SELECT d.dept_name, ee.gender, m.from_date, m.to_date, e.calendar_year,
CASE WHEN YEAR(m.from_date) <= e.calendar_year and e.calendar_year <= YEAR(m.to_date) THEN 1
ELSE 0
END AS active_year
FROM (SELECT YEAR(hire_date) AS calendar_year
FROM t_employees
GROUP BY calendar_year) e
CROSS JOIN t_dept_manager m
JOIN t_departments d
ON m.dept_no =d.dept_no
JOIN t_employees ee
on m.emp_no = ee.emp_no
ORDER BY m.emp_no, calendar_year;

-- Problem 3: Compare the average salary of female versus male employees in the entire company until year 2002, and add a filter allowing you to see that per each department.
SELECT
e.gender, d.dept_name, AVG(s.salary) as salary, YEAR(s.from_date) as calendar_year
FROM
t_salaries s
JOIN t_employees e
ON s.emp_no = e.emp_no
JOIN t_dept_emp de 
ON de.emp_no = e.emp_no
JOIN t_departments d
ON d.dept_no = de.dept_no
GROUP BY d.dept_no, e.gender, calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no;

-- Problem 4: Create an SQL stored procedure that will allow you to obtain the average male and female salary per department within a certain salary range. Let this range be defined by two values the user can insert when calling the procedure. 
-- Finally, visualize the obtained result-set in Tableau as a double bar chart.
SELECT min(salary) FROM t_salaries;
SELECT max(salary) FROM t_salaries;

SELECT
d.dept_name, e.gender, avg(s.salary)  as salary
FROM 
t_employees e
JOIN t_salaries s
ON e.emp_no = s.emp_no
JOIN t_dept_emp de
ON de.emp_no = e.emp_no
JOIN t_departments d
ON d.dept_no = de.dept_no
GROUP BY d.dept_name, e.gender;

DROP PROCEDURE IF EXISTS avg_salary;
DELIMITER $$
CREATE PROCEDURE avg_salary (IN param_1 FLOAT, IN param_2 FLOAT)
BEGIN
SELECT
d.dept_name, e.gender, avg(s.salary)  as salary
FROM 
t_employees e
JOIN t_salaries s
ON e.emp_no = s.emp_no
JOIN t_dept_emp de
ON de.emp_no = e.emp_no
JOIN t_departments d
ON d.dept_no = de.dept_no
WHERE s.salary BETWEEN param_1 AND param_2
GROUP BY d.dept_name, e.gender;
END $$
DELIMITER ;

CALL avg_salary(50000, 90000);