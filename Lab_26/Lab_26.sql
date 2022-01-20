USE employees_mod

-- Create a procedure that will provide the average salary of all employees.
DELIMITER $$
CREATE PROCEDURE avg_salary()
BEGIN
SELECT avg(salary) FROM t_salaries
LIMIT 1000;
END$$

CALL avg_salary();

-- Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, and returns their employee number.
DELIMITER $$
CREATE PROCEDURE emp_info(in first_name1 text, last_name1 text)
BEGIN
SELECT emp_no as "employee number" FROM t_employees WHERE first_name = first_name1 AND last_name = last_name1;
END$$

CALL emp_info('Mary', 'Sluis');

-- Create a function called ‘emp_info’ that takes for parameters the first and last name of an employee, and returns the salary from the newest contract of that employee. 
-- Hint: In the BEGIN-END block of this program, you need to declare and use two variables – v_max_from_date that will be of the DATE type, and v_salary, that will be of the DECIMAL (10,2) type.
DELIMITER $$
CREATE FUNCTION emp_info(first_name1 varchar(50), last_name1 varchar(50))
RETURNS DECIMAL (10,2)
DETERMINISTIC
BEGIN
	DECLARE v_salary DECIMAL (10,2);
	DECLARE v_max_from_date date;
	SELECT max(s.from_date) INTO v_max_from_date
	FROM t_employees as e
	JOIN t_salaries as s ON e.emp_no = s.emp_no
    WHERE e.first_name = first_name1 AND e.last_name = last_name1;
    SELECT s.salary INTO v_salary
    FROM t_employees as e
	JOIN t_salaries as s ON e.emp_no = s.emp_no
    WHERE e.first_name = first_name1 AND e.last_name = last_name1 AND s.from_date=v_max_from_date;
RETURN v_salary;
END$$
DELIMITER ;

SELECT emp_info('Mary', 'Sluis');

-- Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set this date to be the current date. 
-- Format the output appropriately (YY-MM-DD)  
SELECT SYSDATE();
SELECT DATE_FORMAT(SYSDATE(), '%y-%m-%d') as today;
  
DELIMITER $$
CREATE TRIGGER hire_date
BEFORE UPDATE ON t_salaries
FOR EACH ROW
BEGIN 
    IF NEW.from_date > today THEN 
		SET NEW.from_date = today; 
	END IF; 
END $$
DELIMITER ;

-- Create ‘i_hire_date’ and Drop the ‘i_hire_date’ index.
-- CREATE INDEX i_hire_date on t_employees(hire_date);
DROP INDEX i_hire_date on t_employees;

-- Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum. 
-- Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.
SELECT * from t_salaries WHERE salary > 89000;
CREATE INDEX high_salaries on t_salaries(salary);

-- Use Case statement and obtain a result set containing the employee number, first name, and last name of all employees with a number higher than 109990. 
-- Create a fourth column in the query, indicating whether this employee is also a manager, according to the data provided in the dept_manager table, or a regular employee.
SELECT e.emp_no, e.first_name, e.last_name,
CASE 
WHEN e.emp_no = m.emp_no
THEN 'Manager'
ELSE 'Nope'
END AS Manager
FROM t_employees e
LEFT JOIN t_dept_manager m
ON e.emp_no = m.emp_no
WHERE e.emp_no > 109990;

-- Extract a dataset containing the following information about the managers: employee number, first name, and last name. 
-- Add two columns at the end 
-- one showing the difference between the maximum and minimum salary of that employee, 
-- and another one saying whether this salary raise was higher than $30,000 or NOT
SELECT e.emp_no, e.first_name, e.last_name, (MAX(salary)-MIN(salary)) AS sal_diff,
CASE
	WHEN (MAX(salary)-MIN(salary)) > 30000 THEN "HIGH"
    ELSE "NOT"
END AS sal_raise
FROM t_employees e
JOIN t_dept_manager m
ON m.emp_no = e.emp_no
JOIN t_salaries s
ON s.emp_no = e.emp_no
GROUP BY emp_no;

-- Extract the employee number, first name, and last name of the first 100 employees, 
-- And add a fourth column, called “current_employee” saying “Is still employed” if the employee is still working in the company, or “Not an employee anymore” if they aren’t. 
-- Hint: You’ll need to use data from both the ‘employees’ and the ‘dept_emp’ table to solve this exercise.
SELECT e.emp_no, first_name, last_name, 
CASE WHEN  tde.to_date LIKE '9999%'
THEN "still employed" ELSE 'left'
END AS "Current status"
FROM t_employees e 
JOIN t_dept_emp tde ON e.emp_no=tde.emp_no
GROUP BY e.emp_no ORDER BY e.emp_no LIMIT 100;
