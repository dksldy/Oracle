/*
1. 사원의 연봉을 구하는 PL/SQL 블럭 작성, 보너스가 있는 사원은 보너스도 포함하여 계산
2. 구구단 짝수단 출력
	2-1) FOR LOOP
	2-2) WHILE LOOP
*/
-- 사원 연봉 구하기(EMP_NAME, SALARY, BONUS)
DECLARE
    CURSOR EMP_CURSOR IS
        SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE;
    V_NAME EMPLOYEE.EMP_NAME%TYPE;
    V_SALARY EMPLOYEE.SALARY%TYPE;
    V_BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    OPEN EMP_CURSOR;
    LOOP
        FETCH EMP_CURSOR INTO V_NAME, V_SALARY, V_BONUS;
        EXIT WHEN EMP_CURSOR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(V_NAME||'님의 연봉은 '||(V_SALARY+V_SALARY*NVL(V_BONUS,0))*12||'입니다.');
    END LOOP;
    CLOSE EMP_CURSOR;
END;
/

-- 구구단 짝수단 FOR문
DECLARE
    dan PLS_INTEGER;
BEGIN
    FOR k IN 1..4 LOOP
    dan := k*2; -- 2,4,6,8
    DBNS_OUTPUT.PUT_LINE('['||dan||'단]');
    FOR i IN 1..9 LOOP
    DBMS_OUTPUT.PUT_LINE(LPAD(dan,2)||' X '||LPAD(i,2)||' = '||LPAD(dan*i,3));
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    END LOOP;    
END;
/

















