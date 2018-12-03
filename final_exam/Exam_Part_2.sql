--1. Write an anonymous block that swap the salaries for employees with highest and lowest salaries--

declare

salary_sum hr_employee.salary%type;
max_emp_id  hr_employee.employee_id%type;

begin
--1) select employee ID with highest salary and sum of max and min



    select employee_id,(select (max(salary) + min(salary)) from hr_employee) 
    into max_emp_id,salary_sum
    from hr_employee
    where salary = (select max(salary) from hr_employee);
    
--2) update the min salary to max salary
    
    update hr_employee
    set salary = salary_sum - salary
    where salary = (select min(salary) from hr_employee);
    
--3) update the max salary to min salary

    update hr_employee
    set salary = salary_sum - salary
    where employee_id = max_emp_id;
    
end;


--2. Write an anonymous block that will increase salaries for all employees based on their
--years of experience (over 30 years 20% increase, 20 to 29 years experience  10%,
--all others get 5% raise (hint: Explicit cursor , for loop & if clause)

--1) declare cursor 
declare

cursor cur_emp is select * from hr_employee;

begin

--2) if years of experience >= 30 then salary * 1.2
    for emp_rec in cur_emp loop
    
    if (sysdate - emp_rec.hire_date)/365 >= 30 then
        update hr_employee 
        set salary = salary * 1.2
        where employee_id = emp_rec.employee_id;
        
--3) if years of experience >= 20 and <30 then salary * 1.1  
    
    elsif (sysdate - emp_rec.hire_date)/365 >= 20 then
        update hr_employee 
        set salary = salary * 1.1
        where employee_id = emp_rec.employee_id;
--4) all others get 5% raise    
    else 
        update hr_employee
        set salary = salary * 1.05
        where employee_id = emp_rec.employee_id;
 --5) end    
    end if;
   
    
    end loop;
    
    exception
         when NO_DATA_FOUND then
            dbms_output.put_line('no data found');
    
end;




--3. Create a function that returns the employee with the highest salary 

create or replace function f_max_salary
return varchar2
is 

v_emp_name varchar2(255);

begin
--1)select full name
    select first_name||' '||last_name 
    into v_emp_name 
    from hr_employee
    where salary = (select max(salary) from hr_employee);
    return v_emp_name;
end;
--2) check function
select f_max_salary from dual;
select first_name||' '||last_name as "Employee_Name"
from hr_employee
where salary = (select max(salary) from hr_employee);




--4.Create a procedure that returns the employee with the lowest salary

create or replace procedure p_min_salary is

--1)table variable
type varchar_tt is table of varchar2(255) index by PLS_INTEGER;

emp_list varchar_tt;

begin
--2)select full name with min salary
    select first_name||' '||last_name 
    bulk collect
    into emp_list 
    from hr_employee
    where salary = (select min(salary)from hr_employee);

--3) print each row in the table variable
    for n in 1..emp_list.count loop
        
        dbms_output.put_line(emp_list(n));
    
        end loop;
end;

--4) check procedure

begin
p_min_salary;
end;


--5. Create a function that returns the manager full name of the employee by ID 


create or replace function f_manager_name(
i_employee_id hr_employee.employee_id%type
) return varchar2 
is

v_manager_id hr_employee.manager_id%type;
v_fullname_tx varchar(255);

begin

--1)select manager id and store it into a variable

        select manager_id 
        into v_manager_id
        from hr_employee
        where employee_id = i_employee_id;
        
--2) select full name of the manager by manager id

        select first_name||' '||last_name 
        into v_fullname_tx
        from hr_employee
        where employee_id = v_manager_id;
        return v_fullname_tx;
--3) error hanlding when employee doest not exist
         exception when OTHERS then
            dbms_output.put_line('No this Employee');
            v_fullname_tx := null;
end;

--3) check function 

select f_manager_name(20000) from dual;





--6. Create a procedure that prints all employees who report to a manager By ID 

create or replace procedure p_employee_name(
i_manager_id hr_employee.manager_id%type
)
is

type varchar_tt is table of varchar2(255) index by PLS_INTEGER;

emp_list varchar_tt;

begin
--2)select all the employees with full name and store in a table varibale by manager id
    select first_name||' '||last_name 
    bulk collect
    into emp_list 
    from hr_employee
    where manager_id = i_manager_id;

--3) print each employee name 
    for n in 1..emp_list.count loop
        
        dbms_output.put_line(emp_list(n));
    
    end loop;
end;

--4) check procedure

begin
p_employee_name(100);
end;

select first_name, last_name from hr_employee where manager_id = 100;
