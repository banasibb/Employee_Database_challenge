--Determine retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
--Create new table to store empoyees eligible for retirement
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--Drop a table
DROP TABLE retirement_info;
--Recreate the table, this time with employee number
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;
-- Joining retirement_info and dept_emp tables using ri and de as 
-- Create aliases for retirement_info = ri and dept_emp = de
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no=de.emp_no;
-- Joining departments and dept_manager tables
-- alias for departments table is d, alias for dept_name is dn
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
--Use Left Join for retirement_info and dept_emp tables, 
--using alias for retirement_info as ri
--using alias for dept_emp as de
--creating a new table for current_emp
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
-- Check the table
SELECT * FROM retirement_info;
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
--view data in salaries table
SELECT * FROM salaries;
--make data in salaries table easier to read by using order by statement
SELECT * FROM salaries
ORDER BY to_date DESC;
--filter data and save it to a temporary table titled emp_info
SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
--List of department retirees
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
--INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--List of Sales department retirees
SELECT de.emp_no,
	de.first_name,
	de.last_name,
	de.dept_name
INTO sales_dept
FROM dept_info as de
WHERE de.dept_name = '"Sales"';

--List of Sales or Development department retirees
SELECT de.emp_no,
	de.first_name,
	de.last_name,
	de.dept_name
INTO sales_dev_dept
FROM dept_info as de
WHERE de.dept_name = '"Sales"'
	OR de.dept_name = '"Development"';
	
--Same table as above using IN condition
SELECT de.emp_no,
	de.first_name,
	de.last_name,
	de.dept_name
-- INTO sales_dev_dept
FROM dept_info as de
WHERE de.dept_name IN ('"Sales"','"Development"');

--Challenge
SELECT titles.title
FROM titles;

--New Table
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
--
SELECT COUNT(ce.emp_no),t.title
FROM current_emp as ce
LEFT JOIN titles as t
ON ce.emp_no = t.emp_no
WHERE (employees.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
GROUP BY t.title
ORDER BY t.title;
-- select * from dept_info;

--Challenge Deliverable #1 Retirement Titles
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;
--Challenge Deliverable #2 Unique Titles
SELECT DISTINCT ON (rt.emp_no)
	rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
--INTO unique_titles
FROM retirement_titles as rt
LEFT JOIN dept_emp as de
ON (rt.emp_no = de.emp_no)
WHERE (de.to_date = '9999-01-01')
ORDER BY rt.emp_no, de.to_date DESC;
drop table unique_titles;
--Challenge Deliverable #3 Retiring Titles
SELECT count (ut.title),
	ut.title
--INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;
DROP TABLE retiring_titles;
--Attempting another way
SELECT COUNT(rt.emp_no),
	ut.title
--INTO retiring_titles
FROM retirement_titles as rt
INNER JOIN unique_titles as ut
ON (rt.emp_no=ut.emp_no)
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;

--Challenge Deliverable Mentorship Eligibility
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
--INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no=de.emp_no
INNER JOIN titles as ti
ON de.emp_no=ti.emp_no
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;