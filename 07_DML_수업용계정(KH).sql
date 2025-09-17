/*
    09장 DML
    
    1. SELECT ~ FROM ~ WHERE ~ GROUP BY ~ HAVING ~ ORDER BY ~ DESC/ASC
    
    2. INSERT INTO 테이블명(컬럼명,~) VALUES(컬럼개수에 맞게 입력)
       INSERT INTO 테이블명(컬럼명,~) VALUES(모두 컬럼개수 값을 입력)
       
    3. UPDATE 테이블명 SET(SETTER 와 동일) 컬럼명 = 값, 컬럼명 = 값 WHERE ~;
    
    4. DELETE FROM 테이블명 WHERE ~;
*/

-- INSERY UPDATE
DESC EMPLOYEE;
SELECT * FROM EMPLOYEE;
INSERT INTO EMPLOYEE 
VALUES(1, '홍길동' ,'820114-1010101', 'hong_kd@kh.or.kr', '01099998888', 'D5', 'J2',
 3800000, NULL, '200', SYSDATE,  NULL, DEFAULT);
 
SELECT * FROM EMPLOYEE WHERE EMP_ID = 1;

-- UPDATE EMP_NAME = '홍길동'의 EMP_ID 290
UPDATE EMPLOYEE
SET EMP_ID = 290 WHERE EMP_NAME = '홍길동';
SELECT * FROM EMPLOYEE WHERE EMP_ID = 290;

-- DELETE EMP_ID 290 
DELETE FROM EMPLOYEE WHERE EMP_ID = 290;
 
SELECT * FROM USER_CONS_COLUMNS WHERE TABLER_NAME = 'EMPLOYEE'; -- ??

--=====================================================================================
-- 2 INSERT ALL
-- 서브쿼리가 사용하는 테이블이 같고, 조건절이 같은 경우 두개 이상의 테이블에 한번에 삽입 가능
DROP TABLE EMP_DEPT_D1;

CREATE TABLE EMP_DEPT_D1
AS
SELECT * FROM EMPLOYEE; -- WHERE 1 = 0;
-- 데이터 전체 복사
-- WHERE 1=0(NOT 부정값) 대입시 데이터 는 복사하지 않고 구조만 복사
SELECT * FROM EMP_DEPT_D1;
































