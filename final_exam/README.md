Part 1 (12 Points) - Using SAT_Scores.csv

1. Review data file SAT_Scores.csv:
  a. Create a Stage table
  b. Create normalized tables to store the data (hint: 3 tables)
  c. Create a package that will load the data from Stage to the normalized tables, with one public p_ process procedure
  
  Deliverables: DDL of the tables, and the package script

2. Process the data file:
  a. Create a sh script to
    i. to load the data via sql/loader
    ii. call you p_process procedure in the package with sqlplus
  b. Execute the script
  c. Export “select * from each_table” (should be 4 tabs in Excel)
  
  Deliverables: sh script, control file & sql file plus the output of all tables in one excel file
  
3. Write 3 views:
  a. Create a view using the normalized tables to produce the original file
  b. Create a view that shows the top-5 best schools
  c. Create another view that shows some other valuable information
  
  Deliverables: View statements, plus output for each view in one excel file


Part 2 (8 Points) – Using hr_employee table from Week 1

  1. Write an anonymous block that swap the salaries for employees with highest and lowest salaries (hint: 1 select and 2 updates) 

  2. Write an anonymous block that will increase salaries for all employees based on their years of experience (over 30 years – 20% increase, 20 to 29 years’ experience – 10%,
  all others get 5% raise (hint: Explicit cursor , for loop & if clause)

  3. Create a function that returns the employee with the highest salary
  
  4. Create a procedure that returns the employee with the lowest salary

  5. Create a function that returns the manager’s full name of the employee by ID

  6. Create a procedure that prints all employees who report to a manager By ID
  
  Deliverables: Complete code and results

Note: All code must have embedded comments (algorithm) for each logical step.
All Objects (tables/views/packages) MUST be prefixed with {your Initial}_SAT_* All code must have proper error handling (correct exceptions)
