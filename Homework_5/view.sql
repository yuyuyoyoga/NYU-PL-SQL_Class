create view Drug_Usage_View
as 
select p.product_name, sum(nvl(d.prescriptions,0)) as "Prescription_Amount"
from w5_drug d
inner join w5_product p
on d.product_id = p.product_id
group by p.product_name
order by "Prescription_Amount" desc;

create view Unit_Reimbursed_View
as 
select p.product_name, max(nvl(d.units,0)) as "Max_Units"
from w5_drug d
inner join w5_product p
on d.product_id = p.product_id
group by p.product_name
order by "Max_Units" desc;

create view Avg_Cost_Reimbursed_View
as
select p.product_name, round(avg(nvl(d.total_number,0)),2) as "Avg_Cost"
from w5_drug d
inner join w5_product p
on d.product_id = p.product_id
group by p.product_name
order by "Avg_Cost" desc;
