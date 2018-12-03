load data 
infile 'sat_scores.csv' "str '\r\n'"
append
into table YL_SAT_STAGE
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( SCHOOL_NAME CHAR(128),
             NUM_TAKERS,
             CR_AVG,
             MATH_AVG,
             WRITING_AVG
           )
