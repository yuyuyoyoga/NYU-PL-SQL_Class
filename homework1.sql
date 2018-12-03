DECLARE 
 TYPE varchar2_tt IS TABLE OF VARCHAR2(255) INDEX BY PLS_INTEGER; 
 rec_columns VARCHAR2_TT; 
  v_handler utl_file.file_type;
  v_line_tx   VARCHAR2(4000);
  v_column_tx VARCHAR2(255) := ''; 
  v_char_tx   VARCHAR2(1); 
BEGIN
    begin
    v_handler := utl_file.Fopen('MASY_DIR', 'hr_employee.csv', 'r');
     loop
        begin
        
            utl_file.get_line(v_handler, v_line_tx);
            
         continue when v_line_tx like 'EMPLOYEE_ID%';  
           
            exception
                when no_data_found then
                exit;
        end;
        dbms_output.put_line(v_line_tx);
        
        for i in 1..length(v_line_tx) loop
        v_char_tx := substr(v_line_tx,i,1);
        if v_char_tx = ',' then
            rec_columns(rec_columns.count+1) := v_column_tx;
            v_column_tx := null;
            
        else
            v_column_tx := v_column_tx||v_char_tx;
        end if;
     end loop;
  
    ---add last column
    rec_columns(rec_columns.count+1) := v_column_tx;
    
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    dbms_output.put_line('Employee_id: ' || rec_columns(1));
    dbms_output.put_line('First_name: ' || rec_columns(2));
    dbms_output.put_line('Last_Name: ' || rec_columns(3));
    dbms_output.put_line('Email: ' || rec_columns(4));
    dbms_output.put_line('Hire_Date: ' || rec_columns(5));
    dbms_output.put_line('Job_ID: ' || rec_columns(6));
    dbms_output.put_line('Salary: ' || rec_columns(7));
    dbms_output.put_line('Commission_pct: ' || rec_columns(8));
    dbms_output.put_line('Manager_ID: ' || rec_columns(9));
    dbms_output.put_line('Department_ID: ' || rec_columns(10));  

    insert into hr_employee(
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    HIRE_DATE,
    JOB_ID,
    SALARY,
    COMMISSION_PCT,
    MANAGER_ID,
    DEPARTMENT_ID)
    values(
    rec_columns(1),
    rec_columns(2),
    rec_columns(3),
    rec_columns(4),
    rec_columns(5),
    rec_columns(6),
    rec_columns(7),
    rec_columns(8),
    rec_columns(9),
    rec_columns(10)
            );

    rec_columns.delete;
     end loop;
     utl_file.fclose(v_handler);
    end;
    
    
end;
