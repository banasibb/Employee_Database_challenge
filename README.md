# Employee_Database_challenge
## Overview of the Analysis
The purpose of the Employee Analysis was to leverage PostgreSQL to create an ERT containing six CSV data files with information about current and former employees of the Pewlett-Hackard company. The output was then be used to assess attributes of the workforce eligible for retirement and participation in the mentorship program. The results will inform senior leadership as to how prepared their current workforce is to train incoming employees in the event of a "silver tsunami." <br />
### Resources
- Data Sources: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv<br />
- Software: pgAdmin 4 (Version 6.12), QuickDBD ([quickdatabasediagrams.com](https://www.quickdatabasediagrams.com/))<br /><br />
The following database diagram was used to support the design of the ERT developed for this challenge: 
![Chart 1](https://github.com/banasibb/Employee_Database_challenge/blob/e1d41fd740cafcc75474d092076822a8da325999/EmployeeDB_2.png)

## Results
The SQL for this challenge is contained in the file [Employee_Database_challenge.sql](https://github.com/banasibb/Employee_Database_challenge/blob/65e4ab884626028fc264b62e5b8b573ab8b25fa5/Employee_Challenge.sql). 

There are a total of 331,603 employee records in the dept_emp ERD table. Of those, 240,124 are current employees. Within the current employee group, 72,458 individuals are eligible for retirement. This is just over 30% of the current workforce. 
### Retirement Titles
The code below was used to create the Retirement Titles table that holds all the titles of employees who were born between January 1, 1952 and December 31, 1955. 
 ```
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
  ```
The output of this analysis is here: [retirement_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/12682cfdb9abefb968f84cf8ed86310e71967639/retirement_titles.csv)<br />

### Unique Titles
Because some employees may have multiple titles in the database—for example, due to promotions, a DISTINCT ON statement was used to create a table that contains the most recent title of each employee.
```
SELECT DISTINCT ON (rt.emp_no)
	rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
LEFT JOIN dept_emp as de
ON (rt.emp_no = de.emp_no)
WHERE (de.to_date = '9999-01-01')
ORDER BY rt.emp_no, de.to_date DESC;
  ```
The output of this analysis is here: [unique_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/unique_titles.csv)<br />

### Retiring Titles
The COUNT() function was used to create a table that has the number of retirement-age employees by most recent job title. Those employees who have already left the company were excluded by using a WHERE statement to set the to_date equal to '9999-01-01'.
 ```
    SELECT COUNT (ut.emp_no),
	ut.title
--INTO retiring_titles
FROM retirement_titles as rt
INNER JOIN unique_titles as ut
ON (rt.emp_no = ut.emp_no)
WHERE (rt.to_date = '9999-01-01')
GROUP BY ut.title
ORDER BY COUNT(ut.emp_no) DESC;
  ```
The output of this analysis is here: [retiring_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/retiring_titles.csv)<br />

### Mentorship Eligibility
The mentorship-eligibility table holds the current employees who were born between January 1, 1965 and December 31, 1965. There are a total of 1,549 individuals eligible to mentor new employees. This is just 0.64% of the current workforce (1,549/240,124 current employees), and 0.92%% of the current employees who are not eligible for retirement (tot. 167,666).
```
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no=de.emp_no
INNER JOIN titles as ti
ON de.emp_no=ti.emp_no
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;
  ```
The output of this analysis is contained here: [mentorship_eligibility.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/mentorship_eligibility.csv)<br />

## Summary
Provide high-level responses to the following questions, then provide two additional queries or tables that may provide more insight into the upcoming "silver tsunami."
How many roles will need to be filled as the "silver tsunami" begins to make an impact?
Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
### Additional Insights
The following two additional tables were included to provide more insight into the upcoming "silver tsunami."

By analyzing the total employees of retirement age by department, we can determine that the 
```
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
  ```
![Chart Retirement Age Employees by Department](https://github.com/banasibb/Employee_Database_challenge/blob/1dfecf7fc19900faa9232caf56799ef206fbdf19/Deliverables%20Additional%20Tables/Retirement%20Age%20Employees%20by%20Department_cropped.png)<br />
 ```
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
  ```
![Chart Mentorship Eligible Employees by Department](https://github.com/banasibb/Employee_Database_challenge/blob/1dfecf7fc19900faa9232caf56799ef206fbdf19/Deliverables%20Additional%20Tables/Mentorship%20Program%20Employees%20by%20Department_cropped.png)<br />

