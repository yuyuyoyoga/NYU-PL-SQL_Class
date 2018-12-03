--view--
create view stage_view as 
select u.utlization_type,s.state_name,n.labeler_code,n.product_code,n.package_size,n.ndc,dt.year_number,dt.quarter,p.product_name,d.prescriptions,d.total_number,d.units
from w5_drug d
inner join w5_utlization u
on d.utlization_id = u.utlization_id
inner join w5_state s
on d.state_id = s.state_id
inner join w5_date dt
on d.date_id = dt.date_id
inner join w5_ndc n
on d.ndc_id = n.ndc_id
inner join w5_product p
on n.product_id = p.product_id;

select count(*) from stage_view;

