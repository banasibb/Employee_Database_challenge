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


### Retirees by Title
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
A total of 72,458 individuals are eligible for retirement. If they were to all retire at the same time, and assuming Pewlett-Hackard is staffed optimally currently, the same number of roles will need to be filled. This is a concerning outlook for the company.
The table below was created to identify the departments with the largest employee population eligible for retirement. As the results show, the Development and Production departments will be most significantly impacted by the "Silver Tsunami" with 8,361 and 7,417 individuals eligible for retirement respectively. Therefore, it is my recommendation that leadership focus their hiring efforts on filling roles in these departments as they will be most significantly impacted. 

![Chart Retirement Age Employees by Department](https://github.com/banasibb/Employee_Database_challenge/blob/1dfecf7fc19900faa9232caf56799ef206fbdf19/Deliverables%20Additional%20Tables/Retirement%20Age%20Employees%20by%20Department_cropped.png)<br />

As mentioned in the Results section of this report, there are not enough employees to support the mentorship needs of the Pewlett-Hackard company. Less than 1% of employees are eligible currently for the mentorship program, and over 30% of the workforce may retire if the "Silver Tsunami" hits. Fortunately, the departments expected to be most significantly impacted by a mass exodus of retirees are proportionally represented by the number of employees eligible to mentor new hires as shown in the table below. With that said, there is still significant cause for concern. My recommendation to leadership is that the mentorship program be extended to allow individuals to particpate based on the tenure of their employment with Pewlett-Hackard company, and not strictly based on their age. 

![Chart Mentorship Eligible Employees by Department](https://github.com/banasibb/Employee_Database_challenge/blob/1dfecf7fc19900faa9232caf56799ef206fbdf19/Deliverables%20Additional%20Tables/Mentorship%20Program%20Employees%20by%20Department_cropped.png)<br />

