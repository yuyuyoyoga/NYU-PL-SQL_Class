Create or replace package PKG_YULIU_Loader is

--function--

    function f_check_utlization (i_column_name hw4_stage.utlization_type%type)
    return number;

    function f_check_state (i_column_name hw4_stage.state_name%type)
    return number;

    function f_check_product (i_column_name hw4_stage.product_name%type)
    return number;
    
    function f_check_year (i_column_name hw4_stage.year_number%type)
    return number;   
    
    function f_check_quarter (i_column_name hw4_stage.quarter%type)
    return number ;

--procedure--
PROCEDURE p_utlization (
        i_column_name    hw4_stage.utlization_type%type
    );
 
    PROCEDURE p_state (
        i_column_name    hw4_stage.state_name%type
    ) ;
    
PROCEDURE p_year (
        i_column_name    hw4_stage.year_number%type
    );
    
PROCEDURE p_quarter (
        i_column_name    hw4_stage.quarter%type
    );
    
   PROCEDURE p_product (
        i_column_name    hw4_stage.product_name%type
    );
    
    PROCEDURE p_prescriptions (
        i_column_name    hw4_stage.prescriptions%type
    );
    
    procedure p_labeler_code(i_column_name hw4_stage.labeler_code%type);


    procedure p_package_size(i_column_name hw4_stage.package_size%type); 


    procedure p_NDC(i_column_name hw4_stage.NDC%type); 


procedure p_units(i_column_name hw4_stage.UNITS%type); 

procedure p_total(i_column_name hw4_stage.total%type);

 procedure p_run;
 
end;


create or replace package body PKG_YULIU_Loader is


--function--
--1) check utlization--
     FUNCTION f_check_utlization (
        i_column_name hw4_stage.utlization_type%TYPE
    ) RETURN NUMBER IS
        v_pk   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_pk
        FROM
            hw4_utlization
        WHERE
            utlization_type = i_column_name;

        RETURN v_pk;
    END;

--2)check state--
    FUNCTION f_check_state (
        i_column_name hw4_stage.state_name%TYPE
    ) RETURN NUMBER IS
        v_pk   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_pk
        FROM
            hw4_state
        WHERE
            state_name = i_column_name;

        RETURN v_pk;
    END;
    
    --3) check product--
      FUNCTION f_check_product (
        i_column_name hw4_stage.product_name%TYPE
    ) RETURN NUMBER IS
        v_pk   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_pk
        FROM
            hw4_product
        WHERE
            product_name = i_column_name;

        RETURN v_pk;
    END;

--4) check year--
    FUNCTION f_check_year (
        i_column_name hw4_stage.year_number%TYPE
    ) RETURN NUMBER IS
        v_pk   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_pk
        FROM
            hw4_year
        WHERE
            year_number = i_column_name;

        RETURN v_pk;
    END;
    
--5)check quarter--    
     FUNCTION f_check_quarter (
        i_column_name hw4_stage.quarter%TYPE
    ) RETURN NUMBER IS
        v_pk   NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_pk
        FROM
            hw4_quarter
        WHERE
            quarter = i_column_name;

        RETURN v_pk;
    END;
    
--procedure--

--1) check UTLIZATION --
    PROCEDURE p_utlization (
        i_column_name    hw4_stage.utlization_type%type
    ) IS
        v_table_id   hw4_utlization.utlization_id%type;
    BEGIN
        IF f_check_utlization(i_column_name) = 0 THEN
            INSERT INTO hw4_utlization (utlization_type) VALUES ( i_column_name ) RETURNING utlization_id INTO v_table_id;

            INSERT INTO hw4_drug ( utlization_id ) VALUES ( v_table_id );

        ELSIF f_check_utlization(i_column_name) = 1 THEN
            INSERT INTO hw4_drug ( utlization_id )
                SELECT
                   hw4_utlization.utlization_id
                FROM
                    hw4_utlization
                WHERE
                    hw4_utlization.utlization_type = i_column_name;
            
        END IF;
    END;
--2) state--
    PROCEDURE p_state (
        i_column_name    hw4_stage.state_name%type
    ) IS
        v_table_id   hw4_state.state_id%type;
    BEGIN
        IF f_check_state(i_column_name) = 0 THEN
            INSERT INTO hw4_state (state_name) VALUES (i_column_name) RETURNING state_id INTO v_table_id;

            INSERT INTO hw4_drug ( state_id ) VALUES ( v_table_id );

        ELSIF f_check_state(i_column_name) = 1 THEN
            INSERT INTO hw4_drug (state_id)
                SELECT
                    hw4_state.state_id
                FROM
                    hw4_state
                WHERE
                    hw4_state.state_name = i_column_name;
            

        END IF;
    END;
--3)year--
    PROCEDURE p_year (
        i_column_name    hw4_stage.year_number%type
    ) IS
        v_table_id   hw4_year.year_id%type;
    BEGIN
        IF f_check_year(i_column_name) = 0 THEN
            INSERT INTO hw4_year(year_number) VALUES ( i_column_name ) RETURNING year_id INTO v_table_id;

            INSERT INTO hw4_drug ( year_id ) VALUES ( v_table_id );

        ELSIF f_check_year(i_column_name) = 1 THEN
            INSERT INTO hw4_drug ( year_id )
                SELECT
                    hw4_year.year_id
                FROM
                    hw4_year
                WHERE
                    hw4_year.year_number = i_column_name;
            

        END IF;
    END;
--4)quarter--
    PROCEDURE p_quarter (
        i_column_name    hw4_stage.quarter%type
    ) IS
        v_table_id   INTEGER;
    BEGIN
        IF f_check_quarter(i_column_name) = 0 THEN
            INSERT INTO hw4_quarter ( quarter ) VALUES ( i_column_name ) RETURNING quarter_id INTO v_table_id;

            INSERT INTO hw4_drug ( quarter_id ) VALUES ( v_table_id );

        ELSIF f_check_quarter(i_column_name) = 1 THEN
            INSERT INTO hw4_drug ( quarter_id )
                SELECT
                    quarter_id
                FROM
                    hw4_quarter
                WHERE
                    hw4_quarter.quarter = i_column_name;
            

        END IF;
    END;
--5)product--
   PROCEDURE p_product (
        i_column_name    hw4_stage.product_name%type
    ) IS
        v_table_id   INTEGER;
    BEGIN
        IF f_check_product(i_column_name) = 0 THEN
            INSERT INTO hw4_product ( product_name ) VALUES ( i_column_name ) RETURNING product_id INTO v_table_id;

            INSERT INTO hw4_drug ( product_id ) VALUES ( v_table_id );

        ELSIF f_check_product(i_column_name) = 1 THEN
            INSERT INTO hw4_drug ( product_id ) 
                SELECT
                    product_id
                FROM
                    hw4_product
                WHERE
                    hw4_product.product_name = i_column_name;
            

        END IF;
    END;
--6)prescriptions--
    PROCEDURE p_prescriptions (
        i_column_name    hw4_stage.prescriptions%type
    ) IS
    begin
        insert into hw4_drug(prescriptions)values(i_column_name);
    end;    
       


--insert--
procedure p_labeler_code(i_column_name hw4_stage.labeler_code%type) is
begin
    insert into hw4_drug(labeler_code)values(i_column_name);
end;

procedure p_package_size(i_column_name hw4_stage.package_size%type) is
begin
    insert into hw4_drug(package_size)values(i_column_name);
end;

procedure p_NDC(i_column_name hw4_stage.NDC%type) is
begin
    insert into hw4_drug(NDC)values(i_column_name);
end;

procedure p_units(i_column_name hw4_stage.UNITS%type) is
begin
    insert into hw4_drug(UNITS)values(i_column_name);
end;

procedure p_total(i_column_name hw4_stage.total%type) is
begin
    insert into hw4_drug(total)values(i_column_name);
end;


--2)run--
       
        PROCEDURE p_run 
        IS
        
        CURSOR cur_drug IS SELECT
                               *
                           FROM
                               hw4_stage;

    BEGIN
        FOR drug_rec IN cur_drug LOOP
            p_utlization(drug_rec.utlization_type);
            p_state(drug_rec.state_name);
            p_year(drug_rec.year_number);
            p_quarter(drug_rec.quarter);
            p_product(drug_rec.product_name);
            p_prescriptions(drug_rec.prescriptions);
            p_labeler_code(drug_rec.labeler_code);
            p_package_size(drug_rec.package_size); 
            p_NDC(drug_rec.NDC); 
            p_total(drug_rec.total); 
            p_units(drug_rec.units);
            
        
        
        
        END LOOP;

    end;
END;



--sequence and trigger--
   --1)utlization 
    create sequence seq_Utlization
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_utlization
    
    CREATE or replace TRIGGER tbi_HW4_UTLIZATION
        BEFORE INSERT ON HW4_UTLIZATION
        FOR EACH ROW
    DECLARE
        v_UTLIZATION_ID   HW4_UTLIZATION.UTLIZATION_ID%TYPE;
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
    
    CREATE or replace TRIGGER tbi_HW4_State
        BEFORE INSERT ON HW4_State
        FOR EACH ROW
    DECLARE
        v_State_ID   HW4_state.State_ID%TYPE;
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
    
    --3)Year
    create sequence seq_Year
    minvalue 1
    start with 1
    increment by 1;
    
   --drop sequence seq_year
    
    CREATE or replace TRIGGER tbi_HW4_year
        BEFORE INSERT ON HW4_year
        FOR EACH ROW
    DECLARE
        v_year_ID   HW4_year.year_ID%TYPE;
    BEGIN
        IF :new.year_ID IS NULL THEN
            SELECT
                seq_year.NEXTVAL
            INTO v_year_ID
            FROM
                dual;
    
            :new.year_ID := v_year_ID;
        END IF;
    END;
    
    --4)Quarter
    create sequence seq_Quarter
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_quarter
    
    CREATE or replace TRIGGER tbi_HW4_Quarter
        BEFORE INSERT ON HW4_Quarter
        FOR EACH ROW
    DECLARE
        v_Quarter_ID   HW4_Quarter.Quarter_ID%TYPE;
    BEGIN
        IF :new.Quarter_ID IS NULL THEN
            SELECT
                seq_Quarter.NEXTVAL
            INTO v_Quarter_ID
            FROM
                dual;
    
            :new.Quarter_ID := v_Quarter_ID;
        END IF;
    END;
    
    --5)Product
    create sequence seq_Product
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_product
    
    CREATE or replace TRIGGER tbi_HW4_Product
        BEFORE INSERT ON HW4_Product
        FOR EACH ROW
    DECLARE
        v_Product_ID   HW4_Product.Product_ID%TYPE;
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
    create sequence seq_Prescriptions
    minvalue 1
    start with 1
    increment by 1;
    
    --drop sequence seq_Prescriptions
    
    CREATE or replace TRIGGER tbi_HW4_Prescriptions
        BEFORE INSERT ON HW4_Prescriptions
        FOR EACH ROW
    DECLARE
        v_Prescriptions_ID   HW4_Prescriptions.Prescriptions_ID%TYPE;
    BEGIN
        IF :new.Prescriptions_ID IS NULL THEN
            SELECT
                seq_Prescriptions.NEXTVAL
            INTO v_Prescriptions_ID
            FROM
                dual;
    
            :new.Prescriptions_ID := v_Prescriptions_ID;
        END IF;
    END;
    
     --7)Drug
    create sequence seq_Drug
    minvalue 1
    start with 1
    increment by 1;
    
--drop sequence seq_drug;
    
    CREATE or replace TRIGGER tbi_HW4_Drug
        BEFORE INSERT ON HW4_Drug
        FOR EACH ROW
    DECLARE
        v_Drug_ID   HW4_Drug.Drug_ID%TYPE;
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
    
