1) Use the Medicaid file in resources
2) Create Database objects 
    i.  Create a stage table to store all data from file
         * Need DDL Script in a SQL File
   ii. Create normalized tables to store the data
       * Need DDL Script in a SQL File
  iii. Create a package to move data from Stage to the normalized data. Each procedure must only do ONE thing?
       * MUST use BULK COLLECT to move the data
  iv. Package should have only ONE public procedure to run everything (eg: p_main )
      * Need code in SQL file
3) Create a sh script
   i. That will load the data from file to stage, using sql/loader
   ii. calls the p_main procedure to run the migration from stage to the normalized tables
        * Need control file and SH file
4) Create a view that reads the relational tables and produce the source file  (source file data and your query's data  should be identical
    * Need query and data in Excel
5) Create 3 views that query the normalized tables to show something "valuable" from your data 
     * Need query and data in Excel

Make sure all objects are consistent (eg: prefix all tables, views etc)
