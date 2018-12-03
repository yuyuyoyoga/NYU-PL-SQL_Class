CREATE TABLE yl_sat_main (
    main_id           INTEGER NOT NULL,
    school_id         INTEGER,
    score_id          INTEGER,
    num_takers   NUMBER
);

ALTER TABLE yl_sat_main ADD CONSTRAINT yl_sat_main_pk PRIMARY KEY ( main_id );

CREATE TABLE yl_sat_school (
    school_id     INTEGER NOT NULL,
    school_name   VARCHAR2(255)
);

ALTER TABLE yl_sat_school ADD CONSTRAINT yl_sat_school_pk PRIMARY KEY ( school_id );

CREATE TABLE yl_sat_score (
    score_id       INTEGER NOT NULL,
    cr_avg         NUMBER,
    math_avg       NUMBER,
    writing_avg   NUMBER
);

ALTER TABLE yl_sat_score ADD CONSTRAINT score_pk PRIMARY KEY ( score_id );

ALTER TABLE yl_sat_main
    ADD CONSTRAINT yl_sat_main_yl_sat_school_fk FOREIGN KEY ( school_id )
        REFERENCES yl_sat_school ( school_id );

ALTER TABLE yl_sat_main
    ADD CONSTRAINT yl_sat_main_yl_sat_score_fk FOREIGN KEY ( score_id )
        REFERENCES yl_sat_score ( score_id );
        
        
---        