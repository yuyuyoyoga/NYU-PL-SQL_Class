-- Generated by Oracle SQL Developer Data Modeler 18.2.0.179.0756
--   at:        2018-10-11 21:04:55 EDT
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



CREATE TABLE w5_date (
    date_id   INTEGER NOT NULL,
    year      NUMBER,
    quarter   NUMBER
);

ALTER TABLE w5_date ADD CONSTRAINT w5_date_pk PRIMARY KEY ( date_id );

CREATE TABLE w5_drug (
    drug_id         INTEGER NOT NULL,
    utlization_id   INTEGER,
    state_id        INTEGER,
    date_id         INTEGER,
    ndc_id          INTEGER,
    prescriptions   NUMBER,
    total_number    NUMBER,
    units           NUMBER
);

ALTER TABLE w5_drug ADD CONSTRAINT w5_drug_pk PRIMARY KEY ( drug_id );

CREATE TABLE w5_ndc (
    ndc_id         INTEGER NOT NULL,
    ndc            VARCHAR2(11),
    product_code   NUMBER,
    labeler_code   NUMBER,
    package_size   NUMBER,
    product_id     INTEGER
);

ALTER TABLE w5_ndc ADD CONSTRAINT w5_ndc_pk PRIMARY KEY ( ndc_id );

CREATE TABLE w5_product (
    product_id     INTEGER NOT NULL,
    product_name   VARCHAR2(255)
);

ALTER TABLE w5_product ADD CONSTRAINT w5_product_pk PRIMARY KEY ( product_id );

CREATE TABLE w5_state (
    state_id     INTEGER NOT NULL,
    state_name   VARCHAR2(255)
);

ALTER TABLE w5_state ADD CONSTRAINT w5_state_pk PRIMARY KEY ( state_id );

CREATE TABLE w5_utlization (
    utlization_id     INTEGER NOT NULL,
    utlization_type   VARCHAR2(255)
);

ALTER TABLE w5_utlization ADD CONSTRAINT w5_utlization_pk PRIMARY KEY ( utlization_id );

ALTER TABLE w5_drug
    ADD CONSTRAINT w5_drug_w5_date_fk FOREIGN KEY ( date_id )
        REFERENCES w5_date ( date_id );

ALTER TABLE w5_drug
    ADD CONSTRAINT w5_drug_w5_ndc_fk FOREIGN KEY ( ndc_id )
        REFERENCES w5_ndc ( ndc_id );

ALTER TABLE w5_drug
    ADD CONSTRAINT w5_drug_w5_product_fkv1 FOREIGN KEY ( state_id )
        REFERENCES w5_state ( state_id );

ALTER TABLE w5_drug
    ADD CONSTRAINT w5_drug_w5_utlization_fk FOREIGN KEY ( utlization_id )
        REFERENCES w5_utlization ( utlization_id );

ALTER TABLE w5_ndc
    ADD CONSTRAINT w5_ndc_w5_product_fk FOREIGN KEY ( product_id )
        REFERENCES w5_product ( product_id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             0
-- ALTER TABLE                             11
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
