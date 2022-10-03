# Employee_Database_challenge
## Overview of the Analysis
The purpose of the Employee Analysis was to leverage PostgreSQL to create a database to analyze six CSV data files containing information about current and former employees of the Pewlett-Hackard company. The output would then be used to assess attributes of the workforce eligible for retirement and participation in the mentorship program. The results should inform senior leadership as to how prepared their current workforce is to train incoming employees in the event of a "silver tsunami." <br />
### Resources
- Data Sources: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv<br />
- Software: pgAdmin 4 (Version 6.12), QuickDBD ([quickdatabasediagrams.com](https://www.quickdatabasediagrams.com/))
![Chart 1](https://github.com/banasibb/Employee_Database_challenge/blob/e1d41fd740cafcc75474d092076822a8da325999/EmployeeDB_2.png)
### Assumptions
- Employees eligible for retirement have a birth date between January 1, 1952 and December 31, 1955. 
- To narrow the output to include only current employees and their most recent job title, the "to_date" field was set equal to '9999-01-01'
- Employees eligible to participate in the mentorship program must have a birth date between January 1, 1965 and December 31, 1965.

## Results

### Retirement Titles
 ```
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
  ```
[retirement_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/12682cfdb9abefb968f84cf8ed86310e71967639/retirement_titles.csv)<br />

### Unique Titles
 ```
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
  ```
[unique_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/unique_titles.csv)<br />

### Retiring Titles
 ```
    SELECT count (ut.emp_no),
	ut.title
--INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT(ut.emp_no) DESC;
  ```
[retiring_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/retiring_titles.csv)<br />

### Mentorship Eligibility
 ```
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
  ```
[mentorship_eligibility.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/mentorship_eligibility.csv)<br />

## Summary
Provide high-level responses to the following questions, then provide two additional queries or tables that may provide more insight into the upcoming "silver tsunami."
How many roles will need to be filled as the "silver tsunami" begins to make an impact?
Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
