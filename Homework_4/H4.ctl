load data 
infile 'H4.csv' "str '\r\n'"
append
into table W5_STAGE
fields terminated by X'09'
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( UTLIZATION_TYPE CHAR(255),
             STATE_NAME CHAR(255),
             LABELER_CODE,
             PRODUCT_CODE,
             PACKAGE_SIZE,
             YEAR_NUMBER,
             QUARTER,
             NDC CHAR(255),
             PRODUCT_NAME CHAR(255),
             PRESCRIPTIONS "TO_NUMBER(:prescriptions,'999,999,999.999')",
             TOTAL_NUMBER "TO_NUMBER(:total_number,'999,999,999.999')",
             UNITS "TO_NUMBER(:units,'999,999,999.999')"
           )
