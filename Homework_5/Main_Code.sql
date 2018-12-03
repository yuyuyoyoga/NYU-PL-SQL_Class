--sequence and trigger--
   --1)utlization 
    create sequence seq_Utlization
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_utlization
    
    CREATE or replace TRIGGER tbi_W5_UTLIZATION
        BEFORE INSERT ON W5_UTLIZATION
        FOR EACH ROW
    DECLARE
        v_UTLIZATION_ID   W5_UTLIZATION.UTLIZATION_ID%TYPE;
    BEGIN
        IF :new.UTLIZATION_ID IS NULL THEN
            SELECT
                seq_Utlization.NEXTVAL
            INTO v_UTLIZATION_ID
            FROM
                dual;
    
            :new.UTLIZATION_ID := v_UTLIZATION_ID;
        END IF;
    END;
    
    --2)State
    create sequence seq_State
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_state
    
    CREATE or replace TRIGGER W5_State
        BEFORE INSERT ON W5_State
        FOR EACH ROW
    DECLARE
        v_State_ID   W5_state.State_ID%TYPE;
    BEGIN
        IF :new.State_ID IS NULL THEN
            SELECT
                seq_State.NEXTVAL
            INTO v_State_ID
            FROM
                dual;
    
            :new.State_ID := v_State_ID;
        END IF;
    END;
    
    --3)Date
    create sequence seq_Date
    minvalue 1
    start with 1
    increment by 1;
    
   --drop sequence seq_date
    
    CREATE or replace TRIGGER tbi_W5_Date
        BEFORE INSERT ON W5_Date
        FOR EACH ROW
    DECLARE
        v_Date_ID   W5_Date.Date_ID%TYPE;
    BEGIN
        IF :new.Date_ID IS NULL THEN
            SELECT
                seq_Date.NEXTVAL
            INTO v_Date_ID
            FROM
                dual;
    
            :new.Date_ID := v_Date_ID;
        END IF;
    END;
    
    
    --5)Product
    create sequence seq_Product
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_product
    
    CREATE or replace TRIGGER tbi_W5_Product
        BEFORE INSERT ON W5_Product
        FOR EACH ROW
    DECLARE
        v_Product_ID   W5_Product.Product_ID%TYPE;
    BEGIN
        IF :new.Product_id IS NULL THEN
            SELECT
                seq_Product.NEXTVAL
            INTO v_Product_ID
            FROM
                dual;
    
            :new.Product_ID := v_Product_ID;
        END IF;
    END;
    
    --6)Prescriptions
    create sequence seq_NDC
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_NDC
    
    CREATE or replace TRIGGER tbi_W5_NDC
        BEFORE INSERT ON W5_NDC
        FOR EACH ROW
    DECLARE
        v_NDC_ID   W5_NDC.NDC_ID%TYPE;
    BEGIN
        IF :new.NDC_ID IS NULL THEN
            SELECT
                seq_NDC.NEXTVAL
            INTO v_NDC_ID
            FROM
                dual;
    
            :new.NDC_ID := v_NDC_ID;
        END IF;
    END;
    
     --7)Drug
    create sequence seq_Drug
    minvalue 1
    start with 1
    increment by 1;
    
--drop sequence seq_drug;
    
    CREATE or replace TRIGGER W5_Drug
        BEFORE INSERT ON W5_Drug
        FOR EACH ROW
    DECLARE
        v_Drug_ID   W5_Drug.Drug_ID%TYPE;
    BEGIN
        IF :new.Drug_ID IS NULL THEN
            SELECT
                seq_Drug.NEXTVAL
            INTO v_Drug_ID
            FROM
                dual;
    
            :new.Drug_ID := v_Drug_ID;
        END IF;
    END;
    
-------------------------------------------------PACKAGE------------------------------------    
    
    
 create or replace package PKG_YULIU_W5 is   
 
 --Funcation

 --Procedure
 
procedure  p_load_prouct;
procedure p_load_ndc;
procedure  p_load_State;
procedure  p_load_Utlization;
procedure  p_load_Date;
procedure  p_load_Data ;
procedure p_run;

 end;
 
 
 create or replace package body PKG_YULIU_W5 is
 
 --Fuction

 --Procedure
--load product

     PROCEDURE p_load_prouct IS
 --creat varchar table
        TYPE varchar_tt IS
            TABLE OF VARCHAR2(255) INDEX BY PLS_INTEGER;
        product_list   varchar_tt;
    BEGIN
 --select all products that does not exists in DB
        SELECT
            product_name
        BULK COLLECT
        INTO product_list
        FROM
            (
                SELECT DISTINCT
                    product_name
                FROM
                    w5_stage
                MINUS  
                SELECT
                    product_name
                FROM
                    w5_product
            );

 --INSERT Tthe Products
        FORALL indx IN 1..product_list.count
            INSERT INTO w5_product ( product_name ) VALUES ( product_list(indx) );
    END;




--load NDC
    PROCEDURE p_load_ndc IS

        TYPE ndc_rec IS RECORD ( ndc            VARCHAR2(11),
        product_code   NUMBER,
        labeler_code   NUMBER,
        package_size   NUMBER,
        product_id     INTEGER );
        TYPE varchar_tt IS
            TABLE OF ndc_rec INDEX BY PLS_INTEGER;
        ndc_list       varchar_tt;
    BEGIN
        SELECT
            ndc,
            product_code,
            labeler_code,
            package_size,
            (
                SELECT
                    product_id
                FROM
                    w5_product
                WHERE
                    w5_product.product_name = a.product_name
            ) product_id ---
        BULK COLLECT
        INTO ndc_list
        FROM
            (
                SELECT DISTINCT
                    product_name,
                    ndc,
                    product_code,
                    labeler_code,
                    package_size
                FROM
                    w5_stage
            ) a;
     
    
 
--insert--

        FORALL indx IN 1..ndc_list.count
            INSERT INTO w5_ndc (
                ndc,
                product_code,
                labeler_code,
                package_size,
                product_id
            ) VALUES (
                ndc_list(indx).ndc,
                ndc_list(indx).product_code,
                ndc_list(indx).labeler_code,
                ndc_list(indx).package_size,
                ndc_list(indx).product_id
            );


--update

        update w5_stage
            set ndc_id = (select ndc_id from w5_ndc where w5_stage.ndc = w5_ndc.ndc);

    END;
 
 
--load State
 
     PROCEDURE p_load_state IS
        TYPE varchar_tt IS
            TABLE OF VARCHAR2(255) INDEX BY PLS_INTEGER;
        state_list   varchar_tt;
    BEGIN
 --select all products that does not exists in DB
        SELECT
            state_name
        BULK COLLECT
        INTO state_list
        FROM
            (
                SELECT DISTINCT
                    state_name
                FROM
                    w5_stage
                MINUS ------ 
                SELECT
                    state_name
                FROM
                    w5_state
            );
 
 
 --INSERT Tthe state

        FORALL indx IN 1..state_list.count
            INSERT INTO w5_state ( state_name ) VALUES ( state_list(indx) );


--update
         
        update w5_stage
            set State_id = (select State_id from w5_State where w5_stage.State_name = w5_state.State_name);



    END;
--load Utlization
     PROCEDURE p_load_utlization IS
        TYPE varchar_tt IS
                TABLE OF VARCHAR2(255) INDEX BY PLS_INTEGER;
        utlization_list   varchar_tt;
    BEGIN
 --select all products that does not exists in DB
        SELECT
            utlization_type
        BULK COLLECT
        INTO utlization_list
        FROM
            (
                SELECT DISTINCT
                    utlization_type
                FROM
                    w5_stage
                MINUS ------ 
                SELECT
                    utlization_type
                FROM
                    w5_utlization
            );
 
 
 --INSERT Tthe Products

        FORALL indx IN 1..utlization_list.count
            INSERT INTO w5_utlization ( utlization_type ) VALUES ( utlization_list(indx) );

--update 
             update w5_stage
            set utlization_id = (select utlization_id from w5_utlization where w5_stage.utlization_type = w5_utlization.utlization_type);
    
        

    END;

--Load Date
     PROCEDURE p_load_date IS

        TYPE date_rec IS RECORD ( year_number   NUMBER,
        quarter       NUMBER );
        TYPE number_tt IS
            TABLE OF date_rec INDEX BY PLS_INTEGER;
        date_list     number_tt;
    BEGIN
 --select all products that does not exists in DB
        SELECT
            year_number,
            quarter
        BULK COLLECT
        INTO date_list
        FROM
            (
                SELECT DISTINCT
                    year_number,
                    quarter
                FROM
                    w5_stage
                MINUS ------ 
                SELECT
                    year_number,
                    quarter
                FROM
                    w5_date
            );
 
 
 --INSERT Tthe Products

        FORALL indx IN 1..date_list.count
            INSERT INTO w5_date ( year_number,quarter ) VALUES (
                date_list(indx).year_number,
                date_list(indx).quarter
            );
--update

        update w5_stage
            set Date_id = (select Date_id from w5_Date where w5_stage.year_number = w5_date.year_number and w5_stage.quarter = w5_date.quarter);

    END;
--load data
     PROCEDURE p_load_data IS

    
    BEGIN
   
    -- insert data
    
        insert into w5_drug(utlization_id,state_id,date_id,ndc_id,prescriptions,total_number,units)
        select utlization_id,state_id,date_id,ndc_id,prescriptions,total_number,units
        from w5_stage;
    END;
 
 -----run---
    PROCEDURE p_run IS
    BEGIN
 ---load product
        p_load_prouct;

--load NDC
        p_load_ndc;
--load state
        p_load_state;
--load Utils
        p_load_utlization;
--Load Date
        p_load_date;
--load data
        p_load_data;
    END;    
END;