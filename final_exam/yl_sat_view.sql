
--stage_view

--1) crete view
    create view yl_sat_stage_view 
    as
    select sch.school_name,m.num_takers,sc.cr_avg,sc.math_avg,sc.writing_avg
    from yl_sat_main m
    inner join yl_sat_school sch
    on m.school_id = sch.school_id
    inner join yl_sat_score sc
    on m.score_id = sc.score_id;


--2) check view
    select count(*) from yl_sat_stage_view;


--view top 5 best schools

--1)create view with all number added and select top 5 with highest total score

    create view yl_sat_top5_view as
    
    select * from(
    select sch.school_name,(sc.cr_avg + sc.math_avg + sc.writing_avg) as"Total_Score"
    from yl_sat_main m
    inner join yl_sat_school sch
    on m.school_id = sch.school_id
    inner join yl_sat_score sc
    on m.score_id = sc.score_id
    order by "Total_Score" desc)
    where rownum <= 5;
    
--2) check number
    select count(*) from yl_sat_top5_view;
    
--vew top 5 schools with best math score

    create view yl_sat_top5_math_view as
    
    select * from(
    select sch.school_name, max(sc.math_avg) as"Average_Math_Score"
    from yl_sat_main m
    inner join yl_sat_school sch
    on m.school_id = sch.school_id
    inner join yl_sat_score sc
    on m.score_id = sc.score_id
    group by sch.school_name
    order by "Average_Math_Score" desc)
    where rownum <= 5;
    
    
--2) check number
    select count(*) from yl_sat_top5_math_view;    

