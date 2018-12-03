--sequence and trigger--
   --1)school
    create sequence seq_school
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_school
    
    CREATE or replace TRIGGER tbi_yl_sat_school
        BEFORE INSERT ON yl_sat_school
        FOR EACH ROW
    DECLARE
        v_school_ID   yl_sat_school.school_id%TYPE;
    BEGIN
        IF :new.school_id IS NULL THEN
            SELECT
                seq_school.NEXTVAL
            INTO v_school_ID
            FROM
                dual;
    
            :new.school_id := v_school_ID;
        END IF;
    END;
    
    --2)score
    create sequence seq_score
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_score
    
    CREATE or replace TRIGGER tbi_yl_sat_score
        BEFORE INSERT ON yl_sat_score
        FOR EACH ROW
    DECLARE
        v_score_ID   yl_sat_score.score_id%TYPE;
    BEGIN
        IF :new.score_id IS NULL THEN
            SELECT
                seq_score.NEXTVAL
            INTO v_score_ID
            FROM
                dual;
    
            :new.score_id := v_score_ID;
        END IF;
    END;
    
    --3)main
    create sequence seq_main
    minvalue 1
    start with 1
    increment by 1;
    
   --drop sequence seq_main
    
    CREATE or replace TRIGGER tbi_yl_sat_main
        BEFORE INSERT ON yl_sat_main
        FOR EACH ROW
    DECLARE
        v_main_ID   yl_sat_main.main_id%TYPE;
    BEGIN
        IF :new.main_id IS NULL THEN
            SELECT
                seq_main.NEXTVAL
            INTO v_main_ID
            FROM
                dual;
    
            :new.main_id := v_main_ID;
        END IF;
    END;
    
--add column in stage---

alter table yl_sat_stage
ADD score_id number;

alter table yl_sat_stage
ADD school_id number;

    
-------------------------------------------------PACKAGE------------------------------------    
    
    
 create or replace package PKG_YL_SAT is   
 
 --Funcation

 --Procedure
 
procedure  p_load_school;
procedure  p_load_score;
procedure  p_load_Data ;
procedure  p_run;

 end;
 
 
 create or replace package body PKG_YL_SAT is
 
 --Fuction

 --Procedure
--load school

     PROCEDURE p_load_school IS
 --creat varchar table
        TYPE varchar_tt IS
            TABLE OF VARCHAR2(255) INDEX BY PLS_INTEGER;
        school_list   varchar_tt;
    BEGIN
 --select all schools that does not exists in DB
        SELECT
            school_name
        BULK COLLECT
        INTO school_list
        FROM
            (
                SELECT DISTINCT
                    school_name
                FROM
                    yl_sat_stage
                MINUS  
                SELECT
                    school_name
                FROM
                    yl_sat_school
            );

 --INSERT Tthe Products
        FORALL indx IN 1..school_list.count
            INSERT INTO yl_sat_school ( school_name ) VALUES ( school_list(indx) );


--Update School_it in stage
  update yl_sat_stage
            set school_id = (select school_id from yl_sat_school where yl_sat_stage.school_name = yl_sat_school.school_name);




    END;

--load score
    PROCEDURE p_load_score IS

        TYPE score_rec IS RECORD ( cr_avg  number,
        math_avg   NUMBER,
        writing_avg   NUMBER
                                );
        TYPE number_tt IS
            TABLE OF score_rec INDEX BY PLS_INTEGER;
        score_list       number_tt;
    BEGIN
        SELECT
            cr_avg,
            math_avg,
            writing_avg
            
        BULK COLLECT
        INTO score_list
        FROM
            (
                SELECT DISTINCT
                    cr_avg,
                    math_avg,
                    writing_avg
                FROM
                    yl_sat_stage
            );
     
    
 
--insert--

        FORALL indx IN 1..score_list.count
            INSERT INTO yl_sat_score (
                cr_avg,
                math_avg,
                writing_avg
            ) VALUES (
                score_list(indx).cr_avg,
                score_list(indx).math_avg,
                score_list(indx).writing_avg
            );


--update

        update yl_sat_stage
            set score_id = (select score_id 
                            from yl_sat_score 
                            where yl_sat_stage.cr_avg = yl_sat_score.cr_avg and
                                  yl_sat_stage.math_avg = yl_sat_score.math_avg and
                                  yl_sat_stage.writing_avg = yl_sat_score.writing_avg);

    END;
 
 

--load data into normalized database
     PROCEDURE p_load_data IS

    
    BEGIN
   
    -- insert data
    
        insert into yl_sat_main(school_id,score_id,num_takers)
        select school_id,score_id,num_takers
        from yl_sat_stage;
        
    END;
 
 -----run---
    PROCEDURE p_run IS
    BEGIN
    
--1) load school
        p_load_school;

--2) load score
        p_load_score;
        
--3) load data
        p_load_data ;
    END;    
END;