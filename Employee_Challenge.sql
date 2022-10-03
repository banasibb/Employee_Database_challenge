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