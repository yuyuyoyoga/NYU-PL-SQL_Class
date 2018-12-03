create package PKG_YULIU_ATM is

---variable---
---function---

--1a) check account function
    FUNCTION f_check_account (
        i_account_number hw2_atm_scenario.account_number%TYPE
    ) RETURN NUMBER;

--2a) check pin function

    FUNCTION f_check_pin (
        i_pin       hw2_atm_scenario.pin%TYPE,
        i_account   hw2_atm_scenario.account_number%TYPE
    ) RETURN NUMBER;

--3a) check acmount function
    FUNCTION f_check_amount (
        i_account   hw2_atm_scenario.account_number%TYPE,
        i_amount    hw2_atm_scenario.amount%TYPE
    ) RETURN NUMBER;

---procedure---

--1b) withdraw

PROCEDURE p_withdraw(p_account hw2_atm_scenario.account_number%type,p_amount hw2_atm_scenario.amount%type);

--2b) deposit

PROCEDURE p_deposit(p_d_account hw2_atm_scenario.account_number%type,p_d_amount hw2_atm_scenario.amount%type);

--3b) insert

PROCEDURE p_insert (
    i_id                   hw2_atm_log.detail_id%TYPE,
    i_transaction_id       hw2_atm_log.transaction_id%TYPE,
    i_transaction_amount   hw2_atm_log.transaction_amount%TYPE,
    i_message_id           hw2_atm_log.message_id%TYPE,
    i_date                 hw2_atm_log."Date"%TYPE,
    i_account_number       hw2_atm_log.account_number%TYPE
);



--4b) runs
PROCEDURE p_run;


end;
----------------------------------------------BODAY-------------------------------------------

create package body PKG_YULIU_ATM is
--1a) check account function
    FUNCTION f_check_account (
        i_account_number hw2_atm_scenario.account_number%TYPE
    ) RETURN NUMBER IS
        v_account   NUMBER;
        BEGIN
            SELECT
                COUNT(*)
            INTO v_account
            FROM
                hw2_atm_accounts
            WHERE
                account_number = i_account_number;
    
            RETURN v_account;
        END;  

--2a) check pin function
        FUNCTION f_check_pin (
        i_pin       hw2_atm_scenario.pin%TYPE,
        i_account   hw2_atm_scenario.account_number%TYPE
    ) RETURN NUMBER IS
        v_pin   NUMBER;
        BEGIN
            SELECT
                COUNT(*)
            INTO v_pin
            FROM
                hw2_atm_accounts
            WHERE
                pin = i_pin
                AND account_number = i_account;
    
            RETURN v_pin;
        END;
        

--3a) check acmount function
        FUNCTION f_check_amount (
            i_account   hw2_atm_scenario.account_number%TYPE,
            i_amount    hw2_atm_scenario.amount%TYPE
        ) RETURN NUMBER IS
            v_amount   NUMBER;
            BEGIN
                SELECT
                    COUNT(*)
                INTO v_amount
                FROM
                    hw2_atm_accounts
                WHERE
                    account_number = i_account
                    AND balance >= i_amount;
        
                RETURN v_amount;
            END;
---procedure---

--1b) withdraw

    PROCEDURE p_withdraw (
        p_account   hw2_atm_scenario.account_number%TYPE,
        p_amount    hw2_atm_scenario.amount%TYPE
    ) IS
        BEGIN
            UPDATE hw2_atm_accounts
            SET
                balance = balance - p_amount
            WHERE
                account_number = p_account;
    
        END;

--2b) deposit

    PROCEDURE p_deposit (
        p_d_account   hw2_atm_scenario.account_number%TYPE,
        p_d_amount    hw2_atm_scenario.amount%TYPE
    ) IS
        BEGIN
            UPDATE hw2_atm_accounts
            SET
                balance = balance + p_d_amount
            WHERE
                account_number = p_d_account;
    
        END;
--3b) insert

    PROCEDURE p_insert (
        i_id                   hw2_atm_log.detail_id%TYPE,
        i_transaction_id       hw2_atm_log.transaction_id%TYPE,
        i_transaction_amount   hw2_atm_log.transaction_amount%TYPE,
        i_message_id           hw2_atm_log.message_id%TYPE,
        i_date                 hw2_atm_log."Date"%TYPE,
        i_account_number       hw2_atm_log.account_number%TYPE
    ) IS
        BEGIN
            INSERT INTO hw2_atm_log (
                detail_id,
                transaction_id,
                transaction_amount,
                message_id,
                "Date",
                account_number
            ) VALUES (
                i_id,
                i_transaction_id,
                i_transaction_amount,
                i_message_id,
                i_date,
                i_account_number
            );
    
        END;

--4b) runs

    procedure p_run
    is
    v_scenario_rec hw2_atm_scenario%rowtype;

--Cursor Scenario--
    CURSOR cur_scenario IS SELECT
                               *
                           FROM
                               hw2_atm_scenario;

        begin
            open cur_scenario; 
                LOOP
                    FETCH cur_scenario INTO v_scenario_rec;
                EXIT WHEN cur_scenario%notfound;
--check customer---        
                    if f_check_account(v_scenario_rec.account_number) = 1 then
            --check pin---      
                        if f_check_pin(v_scenario_rec.pin,v_scenario_rec.account_number) = 1 then
            --check transaction--
                            if v_scenario_rec.transaction_id = 1 then       
            --check amount--
                                if f_check_amount(v_scenario_rec.account_number,v_scenario_rec.amount) = 1 then
            --execute withdraw
                                    p_withdraw(v_scenario_rec.account_number,v_scenario_rec.amount);
            --insert withdraw result                   
                                    p_insert(seq_value.NEXTVAL,v_scenario_rec.transaction_id,v_scenario_rec.amount,1,SYSDATE,v_scenario_rec.account_number);
            
            --amount less than balance  
                                elsif f_check_amount(v_scenario_rec.account_number,v_scenario_rec.amount) = 0 then
                            
                                    p_insert(seq_value.NEXTVAL,v_scenario_rec.transaction_id,v_scenario_rec.amount,3,SYSDATE,v_scenario_rec.account_number);
                                    
                                end if;
                          
            --deposite--
                          
                            elsif v_scenario_rec.transaction_id = 2 then
                             
                                p_deposit(v_scenario_rec.account_number,v_scenario_rec.amount);
                            
                                p_insert(seq_value.NEXTVAL,v_scenario_rec.transaction_id,v_scenario_rec.amount,1,SYSDATE,v_scenario_rec.account_number);
                            end if;
            --incorect pin--
                        elsif f_check_pin(v_scenario_rec.pin,v_scenario_rec.account_number) = 0 then
                        
                            p_insert(seq_value.NEXTVAL,v_scenario_rec.transaction_id,v_scenario_rec.amount,2,SYSDATE,v_scenario_rec.account_number);
                        
                         end if;
            --Account not found--
                elsif f_check_account(v_scenario_rec.account_number) = 0 then
                    
                        p_insert(seq_value.NEXTVAL,v_scenario_rec.transaction_id,v_scenario_rec.amount,4,SYSDATE,v_scenario_rec.account_number);
                
                end if;
              
            end loop;
            
            close cur_scenario;
    end;   



end;

---------------------------------------trigger-------------------------------
create trigger tbi__hw2_atm_log
    before insert on hw2_atm_log
    for each row

declare
    v_detail_id hw2_atm_log.detail_id%type;


begin
    if :new.detail_id is null then
        select
            seq_value.NEXTVAL
        into v_detail_id
        from
            dual;
            
        :new.detail_id := v_detail_id;
    end if;
end;



------------------------------Script--------------------------
begin

    pkg_yuliu_atm.p_run();

end;
