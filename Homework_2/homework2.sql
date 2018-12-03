Declare

--variabe--
i number;
v_balance accounts.balance%type;
new_balance accounts.balance%type;
deposit_balance accounts.balance%type;
pin accounts.pin%type;

--Cursor Scenario--
cursor cur_scenario is
select * 
from scenario;

v_scenario_rec scenario%rowtype;

Begin
--Pull Scenario--
    open cur_scenario;
    loop
     fetch cur_scenario into v_scenario_rec;
     EXIT WHEN cur_scenario%NOTFOUND;
------check account-----------
     select count(*) 
     into i
     from accounts 
     where account_number = v_scenario_rec.account_number;
     

 ----------check pin--------
    if i >= 1 then
        select count(*) 
        into pin
        from accounts
        where pin = v_scenario_rec.pin;

        
        if pin >= 1 then
-------------transaction withdraw---------
            if v_scenario_rec.transaction_id = 1 then
                
                select balance
                into v_balance
                from accounts
                where account_number = v_scenario_rec.account_number;
                
                if v_scenario_rec.amount < v_balance then
                
                 new_balance := v_balance - v_scenario_rec.amount;
                 update accounts
                 set balance = new_balance
                 where account_number = v_scenario_rec.account_number;
                 
                --insert message--
                
                insert into detail (detail_id, transaction_id,transaction_amount, message_id, "Date", account_number)
                values 
                (SEQ_VALUE.nextval, 
                v_scenario_rec.transaction_id, 
                v_scenario_rec.amount,
                1,
                sysdate,
                v_scenario_rec.account_number);
                
                else
                
                insert into detail (detail_id, transaction_id,transaction_amount, message_id, "Date", account_number)
                values 
                (seq_value.nextval, 
                v_scenario_rec.transaction_id, 
                v_scenario_rec.amount,
                3,
                sysdate,
                v_scenario_rec.account_number);
                end if;
              
--------------deposit-------------------
              
            elsif v_scenario_rec.transaction_id = 2 then
                 
                update accounts
                 set balance = v_scenario_rec.amount + balance
                 where account_number = v_scenario_rec.account_number;
                
                insert into detail (detail_id, transaction_id,transaction_amount, message_id, "Date", account_number)
                values 
                (seq_value.nextval, 
                v_scenario_rec.transaction_id, 
                v_scenario_rec.amount,
                1,
                sysdate,
                v_scenario_rec.account_number);
            end if;
---------------- incorect pin -------------- 
            elsif pin = 0 then
            
            insert into detail (detail_id, transaction_id,transaction_amount, message_id, "Date", account_number)
                values 
                (seq_value.nextval, 
                v_scenario_rec.transaction_id, 
                v_scenario_rec.amount,
                2,
                sysdate,
                v_scenario_rec.account_number);
            
             end if;
------------Account not found----------
    elsif i = 0 then
        
        insert into detail (detail_id, transaction_id,transaction_amount, message_id, "Date", account_number)
        values 
        (seq_value.nextval, 
        v_scenario_rec.transaction_id, 
        v_scenario_rec.amount,
        4,
        sysdate,
        v_scenario_rec.account_number);
    
    end if;
  end loop;

    close cur_scenario;
End;
