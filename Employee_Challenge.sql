--Challenge Deliverable #1a Retirement Titles
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
--INTO retirement_titles
FROM employees as e
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

--Challenge Deliverable #1b Unique Titles
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

--Challenge Deliverable #1c Retiring Titles
SELECT COUNT (ut.emp_no),
	ut.title
--INTO retiring_titles
FROM retirement_titles as rt
INNER JOIN unique_titles as ut
ON (rt.emp_no = ut.emp_no)
WHERE (rt.to_date = '9999-01-01')
GROUP BY ut.title
ORDER BY COUNT(ut.emp_no) DESC;

--Challenge Deliverable #1c Retiring Titles
SELECT COUNT (ut.emp_no), ut.title
FROM unique_titles as ut
GROUP BY ut.title;
--Challenge Deliverable #1c Retiring Titles
-- SELECT count (ut.emp_no),
-- 	ut.title
-- --INTO retiring_titles
-- FROM unique_titles as ut
-- GROUP BY ut.title
-- ORDER BY COUNT(ut.emp_no) DESC;

--Deliverable 2a Mentorship Eligibility
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
SELECT * FROM mentorship_eligibility;

--Deliverable 3a Total Employees of Retirement Age
SELECT COUNT(ut.emp_no)
FROM unique_titles as ut;

--Total Employees
SELECT COUNT (ce.emp_no)
FROM current_emp as ce;
--Total recors in ERD
SELECT * 
FROM dept_emp as de;
--Total current employees in ERD
SELECT * 
FROM dept_emp as de
WHERE (de.to_date = '9999-01-01');

--Deliverable 3b Total Employees of Mentorship Age
SELECT COUNT (me.emp_no)
FROM mentorship_eligibility as me;

--Deliverable 3c Total Employees of Retirement Age by Department
SELECT COUNT (ri.emp_no),
	d.dept_name
--INTO retiring_dept
FROM retirement_info as ri
INNER JOIN dept_emp as de
ON ri.emp_no=de.emp_no
INNER JOIN departments as d
ON de.dept_no=d.dept_no
WHERE (de.to_date = '9999-01-01')
GROUP BY d.dept_name
ORDER BY COUNT (ri.emp_no) DESC;

SELECT * FROM retiring_dept;


--Deliverable 3d Total Employees of Mentorship Age by Department - Create Table
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	d.dept_name
--INTO mentee_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no=de.emp_no
INNER JOIN departments as d
ON de.dept_no=d.dept_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no DESC;
--Deliverable 3d Create Summary Table Employees Eligible for Mentorship Program
SELECT COUNT (me.emp_no), me.dept_name
from mentee_eligibility as me
GROUP BY me.dept_name;