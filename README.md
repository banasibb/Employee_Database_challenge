# Employee_Database_challenge
## Overview of the Analysis
The purpose of the Employee Analysis was to leverage PostgreSQL to create a database to analyze six CSV data files containing information about current and former employees of the Pewlett-Hackard company. The output would then be used to assess attributes of the workforce eligible for retirement and participation in the mentorship program. The results should inform senior leadership as to how prepared their current workforce is to train incoming employees in the event of a "silver tsunami." <br />
### Resources
- Data Sources: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv<br />
- Software: pgAdmin 4 (Version 6.12), QuickDBD ([quickdatabasediagrams.com](https://www.quickdatabasediagrams.com/))
![Chart 1](https://github.com/banasibb/Employee_Database_challenge/blob/e1d41fd740cafcc75474d092076822a8da325999/EmployeeDB_2.png)
### Assumptions
- Employees eligible for retirement have a birth date between January 1, 1952 and December 31, 1955. 
- Only current employees are eligible for retirement, and employees that have held multiple positions appeared multiple times in the data sets because each new job title created one new record for a given employee number (emp_no).
- To narrow the output to include only current employees and their most recent job title, the "to_date" field was set equal to '9999-01-01'
- Empoloyees eligible to participate in the mentorship program must have a birth date between January 1, 1965 and December 31, 1965.

## Results
[retirement_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/12682cfdb9abefb968f84cf8ed86310e71967639/retirement_titles.csv)<br />
[unique_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/unique_titles.csv)<br />
[retiring_titles.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/retiring_titles.csv)<br />
[mentorship_eligibility.csv](https://github.com/banasibb/Employee_Database_challenge/blob/746080a7c0693d1dff7dbcb2fa7e9605f37afc70/mentorship_eligibility.csv)<br />

## Summary
