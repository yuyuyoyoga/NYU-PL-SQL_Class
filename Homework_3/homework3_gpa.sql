create package PKG_YULIU_GPA is

--function--

--1a) gpa
function f_gpa (i_gpa_point number, i_credit_hour number)
return number;
--2a)gpa point
function f_gpa_point(i_letter_grade varchar2)
return number;
--3a)letter grade
function f_letter_grade(i_numeric_grade hw3_gpa_grade.numeric_grade%type)
return varchar2;

--procedure--
procedure p_gpa;
end;

---------------------------------body----------------------------------
create package body PKG_YULIU_GPA is

--function--
    FUNCTION f_gpa_point (
        i_letter_grade VARCHAR2
    ) RETURN NUMBER IS
        v_gpa_point   NUMBER;
    BEGIN
        v_gpa_point :=
            CASE i_letter_grade
                WHEN 'A' THEN 4
                WHEN 'B' THEN 3
                WHEN 'C' THEN 2
            END;

        RETURN v_gpa_point;
    END;

    FUNCTION f_gpa (
        i_gpa_point NUMBER,
        i_credit_hour NUMBER
    ) RETURN NUMBER IS
        v_gpa   NUMBER;
    BEGIN
        v_gpa := ( i_gpa_point * i_credit_hour ) / i_credit_hour;
        RETURN v_gpa;
    END;


    FUNCTION f_letter_grade (
        i_numeric_grade hw3_gpa_grade.numeric_grade%TYPE
    ) RETURN VARCHAR2 IS
        v_letter_grade   VARCHAR2(255);
    BEGIN
        IF i_numeric_grade >= 90 THEN
            v_letter_grade := 'A';
        ELSIF i_numeric_grade >= 80 THEN
            v_letter_grade := 'B';
        ELSIF i_numeric_grade >= 70 THEN
            v_letter_grade := 'C';
        END IF;

        RETURN v_letter_grade;
    END;

--procedure--

    PROCEDURE p_gpa IS

        CURSOR cur_grade IS SELECT
                               *
                           FROM
                               hw3_gpa_grade;

        v_grade_rec      hw3_gpa_grade%rowtype;
        v_letter_grade   VARCHAR2(255);
        v_gpa            NUMBER;
        v_total_gpa      NUMBER;
        v_n              NUMBER;
        v_accum_gpa      NUMBER;
    BEGIN
        v_total_gpa := 0;
        v_n := 0;
        OPEN cur_grade;
        LOOP
            FETCH cur_grade INTO v_grade_rec;
            EXIT WHEN cur_grade%notfound;
            v_letter_grade := f_letter_grade(v_grade_rec.numeric_grade);
            v_gpa := f_gpa(f_gpa_point(f_letter_grade(v_grade_rec.numeric_grade) ),v_grade_rec.credit_hour);

            v_n := v_n + 1;
            v_total_gpa := v_total_gpa + v_gpa;
            v_accum_gpa := v_total_gpa / v_n;
            dbms_output.put_line(v_grade_rec.student_name);
            dbms_output.put_line(v_grade_rec.course_name
                                   || ' is '
                                   || v_letter_grade);
            dbms_output.put_line('Cumulative GPA is ' || v_accum_gpa);
        END LOOP;

        CLOSE cur_grade;
    END;
    

end;


-----------------------gpa-----------------

BEGIN
    pkg_yuliu_gpa.p_gpa ();
END;

