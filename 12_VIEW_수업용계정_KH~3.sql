/*
    VIEW
     : SELECT 쿼리의 실행결과를 화면에 저장한 논리적 가상 테이블
        실제 테이블과는 다르게 실질적 데이터를 저장하고 있진 않지만
        사용자는 테이블을 사용하는것과 동일하게 사용가능
        
    ** 원본 테이블 데이터 값이 변할 경우 실시간으로 VIEW테이블값에도 영향을줘 보여줌
    
    [표현법]
    CREATE VIEW 뷰명
    AS
    서브쿼리
*/
-- 사원번호, 사원이름, 부서명, 국적 뷰 생성
DROP VIEW V_EMP01;
CREATE VIEW V_EMP01
AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_NAME
FROM EMPLOYEE
 LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
 LEFT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
 LEFT JOIN NATIONAL USING (NATIONAL_CODE);

SELECT * FROM V_EMP01;
--==============================================================================
-- VIEW 생성 예시 1

-- 뷰 생성하기 (선택절에 함수를 이용해서 데이터 결과값을 변형을 주었을때 반드시 별칭사용)
-- 1) EMPLOYEE 에서 EMP_ID, EMP_NAME, JOB_NAME, EMP_NO(성별), HIRE_DATE(근무년수)
SELECT * FROM EMPLOYEE;
SELECT EMP_ID, EMP_NAME, JOB_NAME, 
DECODE(SUBSTR(EMP_NO,8,1),1, '남', 2, '여') 성별, HIRE_DATE,
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
FROM EMPLOYEE E
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
/*
    SUBSTR함수 : SUBSTR(문자열,시작할위치, 출력하고싶은 개수)
    DECODE함수 : DECODE(조건, 조건) == SWITCH CASE
    EXTRACT(YEAR FROM SYSDATE) => 달력에 추출기능 (YEAR, MONTH, DATE)
*/
-- 조인후 서브퀄리 활용하여 뷰(V_EMP_JOB)을 생성
DROP VIEW V_EMP_JOB;
CREATE VIEW V_EMP_JOB
AS
SELECT EMP_ID, EMP_NAME, JOB_NAME, 
DECODE(SUBSTR(EMP_NO,8,1),1, '남', 2, '여') GENDER, HIRE_DATE,
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) HIRE_YEAR
FROM EMPLOYEE E
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
SELECT * FROM V_EMP_JOB;
--=> 서브쿼리에 DECODE, EXTRACT 같은 함수를 포함하게되면 반드시 별명을 지어줘야한다.
--================================================================================
-- VIEW 생성시 (INSERT, UPDATE, DELETE) 진행하게 되면 실제 테이블에 영향을 주게 되는가?
-- [결과] 적용된다
-- [주의] 뷰는 뷰용으로 사용할것, 원래 기능인 DML 기능을 사용하지 못하도록 설정할것(예외: 수정허용)
--        => GRANT 권한을 VIEW 만 할수있게 하기 
-- 가상VIEW(V_JOB) 생성 (실제테이블 : JOB)
DROP VIEW V_JOB;
CREATE VIEW V_JOB
AS
SELECT *
FROM JOB;

SELECT * FROM JOB;
SELECT * FROM V_JOB;

-- DML(INSERT, UPDATE, DELETE) 테스트해서 뷰와 실제 테이블 적용이 되는지 확인
-- INSERT INTO ('J8', '임시직')
INSERT INTO V_JOB VALUES ('J8','임시직');

-- UPDATE J8 검색해서 임시직 -> 아르바이트 로 변경
UPDATE V_JOB SET JOB_NAME = '아르바이트' WHERE JOB_CODE = 'J8';

-- DELETE J8에 해당되는 레코드 삭제
DELETE FROM V_JOB WHERE JOB_CODE = 'J8';

-- => JOB 원본 테이블과 V_JOB 뷰 테이블 둘다 적용이되어 바뀌었다
--====================================================================================
/*
    VIEW를 통해 DML 명령어 조작 불가능한 경우
     - 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
     - 뷰에 포함되지 않는 컬럼중 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된경우
     - 산술 표현식으로 정의된 경우
     - 그룹함수나 GROUP BY 절을 포함한 경우
     - DISTINCT를 포함한 경우
     - JOIN을 이용해 여러 테이블을 연결한 경우
     
    ** VIEW 는 대부분 조회의 용도로 사용한다(JOIN 으로 테이블 => VIEW)
        되도록이면 DML 사용하지 않는다.
*/
--===================================================================================
-- 1. 뷰 정의에 포함되지 않은 컬럼을 조작
-- 1-1 뷰 정의 V_JOB2(JOB_CODE만 정의)
DROP VIEW V_JOB2;
CREATE VIEW V_JOB2
AS
SELECT JOB_CODE
FROM JOB;

SELECT * FROM V_JOB2;

-- 1-2 생성된 뷰에서 포함되지 않는 컬럼을 조작하려할때(INSERT 이용)
INSERT INTO V_JOB2 VALUES ('J8','임시직');
-- => SQL 오류: ORA-00913: 값의 수가 너무 많습니다
--===================================================================================
-- 2. 뷰에 포함되지 않은 컬럼중 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된 경우
-- 2-1 뷰를 정의한다 V_JOB3(서브쿼리에서 JOB_NAME)
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'JOB';

DROP VIEW V_JOB3;
CREATE VIEW V_JOB3
AS
SELECT JOB_NAME FROM JOB;

-- 2-2 생성된 뷰에서 INSERT 통해 조작('아르바이트')
INSERT INTO V_JOB3 VALUES ('아르바이트');
-- => ORA-01400: NULL을 ("C##KH"."JOB"."JOB_CODE") 안에 삽입할 수 없습니다
--===================================================================================
-- 3. 산술 표현식으로 정의된 경우
-- 3-1 VIEW 정의 EMP_DAL 서브쿼리(EMPLOYEE)에서(SALARY -> 연봉으로 계산하는 산술식 포함)
DROP VIEW EMP_SAL;
CREATE OR REPLACE VIEW EMP_SAL -- => REPLACE : 있으면 갱신 없으면 생성
AS
SELECT EMP_ID, EMP_NAME, SALARY,
(SALARY + (SALARY * NVL(BONUS,0)))*12 연봉
FROM EMPLOYEE;
SELECT * FROM EMP_SAL;
-- NVL(BONUS,0) => BONUS = NULL 이면 0값을 주고, NULL 이 아니면 BONUS 값을 준다
-- 연산식에 NULL이 포함되어 있는지 점검할것.
SELECT (100 + (100*NVL(NULL,0))) FROM DUAL;
SELECT (100 + (100*NULL)) FROM DUAL;
-- 연산식에 NULL 이 포함되면 결과값이 NULL로 나온다.
-- 연산식에 NULL이 적용되지 않도록 NVL(NULL,0)함수 활용하기

-- 3-2 생성된 VIEW 에서 INSERT를 통해 조작해보기 (연봉컬럼)
INSERT INTO EMP_SAL VALUES (400, '아무개', 400000,4564645646);
-- => SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다
--==================================================================================
-- 4. 그룹 함수나 GROUP BY절을 포함한 경우
-- V_GROUPDEPT VIEW 생성하기 (부서코드, 월급 합계, 평균월급)
DROP VIEW V_GROUPDEPT;
CREATE OR REPLACE VIEW V_GROUPDEPT
AS
SELECT DEPT_CODE, SUM(SALARY) 월급합계, ROUND(AVG(SALARY),1) 평균월급
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT * FROM V_GROUPDEPT;

-- 4-1 INSERT 하기 (가상컬럼 합계, 평균)
INSERT INTO V_GROUPDEPT VALUES('D0',1234567,12345);
-- => SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다
DELETE FROM V_GROUPDEPT WHERE DEPT_CODE = 'D1';
-- => SQL 오류: ORA-01732: 뷰에 대한 데이터 조작이 부적합합니다
--=====================================================================================
-- 5. DISTINCT를 포함한 경우 DML 진행하지 않는다
-- 뷰 정의 V_DT_EMP 서브쿼리(EMPLOYEE) 에서 (DISTINT JOB_CODE)
DROP VIEW V_DT_EMP;
CREATE OR REPLACE VIEW V_DT_EMP
AS
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

SELECT * FROM V_DT_EMP;

INSERT INTO V_DT_EMP VALUES ('J9');
-- => SQL 오류: ORA-01732: 뷰에 대한 데이터 조작이 부적합합니다
DELETE FROM V_DT_EMP WHERE JOB_CODE = 'J9';
-- => SQL 오류: ORA-01732: 뷰에 대한 데이터 조작이 부적합합니다
--=================================================================================
-- 6. JOIN을 이용해 여러 테이블을 연결한 경우
-- 뷰 정의 V_JOINEMP 서브쿼리(EMPLOYEE) 에서 (사원코드, 사원명, 부서명)
DROP VIEW V_JOINEMP;
CREATE OR REPLACE VIEW V_JOINEMP
AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM V_JOINEMP;

INSERT INTO V_JOINEMP VALUES(200,'아무개','아르바이트');
-- => SQL 오류: ORA-01776: 조인 뷰에 의하여 하나 이상의 기본 테이블을 수정할 수 없습니다.
DELETE FROM V_JOINEMP WHERE EMP_ID = '200';
-- => DELETE 는 가능하다!
ROLLBACK;
--==================================================================================
/*
    VIEW 구조
    : 뷰 정의시 사용한 쿼리문장이 TEXT컬럼에 저장되어 있으며
        뷰가 실행될때는 TEXT에 기록된 SELECT에 문장이
    VIEW 에 전체적 관리하고 테이블 구조를 확인할수있다.
*/
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_TABLES;
SELECT * FROM USER_CONSTRAINTS;
/*
    VIEW 옵션
    - OR REPLACE 옵션
        : 생성한 뷰가 존재하면 뷰를 갱신
    - FORCE / NOFORCE 옵션
        : FROCE 옵션은 기본 테이블이 존재하지 않더라도 뷰 생성
          NOFORCE 옵션이 기본값으로 지정됨
    - WITH CHECK OPTION 옵션
        : 옵션을 설정한 컬럼의 값을 조건이 맞지 않을시 수정 불가능하게 함(단, 삭제는 가능)
                                            조건이 맞으면 수정이 가능하다.
    - WITH READ ONLY 옵션
        : 뷰에 대해 조회만 가능하고 삽입, 수정, 삭제 등은 불가능하게 함
*/
-- 1 OR REPLACE 옵션 생략
-- 2 FORCE 테스트 한다. NOFORCE 기본옵션
-- 2-1 뷰를 생성한다. 생성할때 없는 테이블(DUMMY) 지정. 옵션을 선택해서 처리
DROP VIEW DUMMY_VIEW;
CREATE FORCE VIEW DUMMY_VIEW
AS
SELECT * FROM NON_EXISTING_TBL;

SELECT * FROM DUMMY_VIEW;
-- => ORA-04063: view "C##KH.DUMMY_VIEW"에 오류가 있습니다
-- 가상뷰는 생성이 되지만, SELECT * FROM 실행시 오류가 발생한다

-- 3 WITH CHECK OPTION 옵션
-- 3-1 가상뷰를 생성 WITH CHECK OPTION EMPLOYEE 테이블에서 SALARY >= 4000000인 직원
DROP VIEW EMP_SALARY1;
CREATE OR REPLACE VIEW EMP_SALARY1
AS
SELECT EMP_ID,EMP_NAME,SALARY
FROM EMPLOYEE 
WHERE SALARY >= 4000000
WITH CHECK OPTION;

SELECT * FROM EMP_SALARY1;

DESC EMP_SALARY1;
INSERT INTO EMP_SALARY1 VALUES('300','아무개', 4100000);
-- ORA-01400: NULL을 ("C##KH"."EMPLOYEE"."EMP_NO") 안에 삽입할 수 없습니다
-- 3-2 가상뷰에 EMP_ID = 900 SALARY = 5300000 수정
UPDATE EMP_SALARY1 SET SALARY = 5300000 WHERE EMP_ID = '200';
ROLLBACK;
-- WITH CHECK OPTION 해당되는 컬럼이 조건이 맞는다면 수정이된다.
-- 3-3 
UPDATE EMP_SALARY1 SET SALARY = 3300000 WHERE EMP_ID = '200';
-- => SQL 오류: ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
-- 조건이 맞지 않은경우 오류발생

-- 4. WITH READ ONLY 옵션 : 가상뷰에서 SELECT 제외한 DML 작업을 금지시킨다
-- 4-1 가상뷰(V_EMP_READONLY)를 만드시오 (EMPLOYEE 대상으로 가상뷰 만들기)
DROP VIEW V_EMP_READONLY;
CREATE OR REPLACE VIEW V_EMP_READONLY
AS
SELECT EMP_ID, EMP_NAME, SALARY 
FROM EMPLOYEE WHERE DEPT_CODE = 'D1' WITH READ ONLY;

SELECT * FROM V_EMP_READONLY;

-- 4-2 WITH READ ONLY 옵션이 적용된 가상뷰에 INSERT 해보기
INSERT INTO V_EMP_READONLY VALUES('300', '아무개', 1234567);
-- => SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
DELETE FROM V_EMP_READONLY WHERE EMP_ID = '214';
-- => SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
UPDATE V_EMP_READONLY SET SALARY = 5000000  WHERE EMP_ID = '214';
-- => SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
-- WITH READ ONLY를 적용하게 되면 DML작업 금지

/*
    인라인 뷰 (INLINE-VIEW)
    : 일반적으로 FROM절에 사용된 서브쿼리의 결과 화면에 별칭을 붙인것
     FROM절에 서브쿼리를 직접 사용하거나 따로 뷰를 생성후 FROM절에 생성한 뷰를 사용해도됨
    
    [표현법]
    SELECT 컬럼 FROM (SELECT ... FROM ... WHERE ... GROUP BY  ...) 별칭
    WHERE 조건;
    
    SELECT 컬럼 FROM (가상뷰) 별칭 WHERE 조건;
*/
-- 인라인 뷰 생성 (서브쿼리 : EMPLOYEE에서 GROUP BY DEPT_CODE 진행해서 부서별 월급의 평균)
-- 서브쿼리 테스트
SELECT DEPT_CODE, ROUND(AVG(NVL(SALARY,0))) 평균월급
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 인라인뷰 적용
SELECT * FROM (SELECT DEPT_CODE, 
                ROUND(AVG(NVL(SALARY,0)))
                FROM EMPLOYEE
                GROUP BY DEPT_CODE) A
WHERE AVG_SAL > 1000000;

/*
    VIEW 테이블의 활용성
    - 원본 데이터 보호
    - 복잡한 쿼리 캡슐화
        => VIEW 테이블에 복잡한 쿼리를 정리해둠으로 필요한 데이터 조회시 간단하게 캡슐화
    - 재사용성
        => 한번 정의된 VIEW 테이블은 여러곳에서 재사용가능.
    - 성능 최적화
    - 보안 및 접근제어
        => 원본 데이터에 민감한 내용은 제외하고 보여주기 가능
    - 데이터 모델링 및 비즈니스 로직 구현 
*/
-- VIEW 할 원본 데이터테이블 생성
DROP TABLE DEPT03;
CREATE TABLE DEPT03
AS 
SELECT * FROM DEPARTMENT;
 
INSERT INTO DEPT03 VALUES('C1','세이브1','C1'); SAVEPOINT C1;
INSERT INTO DEPT03 VALUES('C2','세이브2','C2'); SAVEPOINT C2;
INSERT INTO DEPT03 VALUES('C3','세이브3','C3'); SAVEPOINT C3;
ROLLBACK TO C1;

SELECT * FROM DEPT03;

-- 원본 데이터테이블 VIEW 생성(부서코드, 부서명)
DROP VIEW V_DEPT03;
CREATE VIEW V_DEPT03
AS
SELECT DEPT_ID, DEPT_TITLE
FROM DEPT03;

SELECT * FROM V_DEPT03;

-- VIEW 테이블에 INSERT 사용해보기
INSERT INTO V_DEPT03 VALUES('C1','세이브1'); 
SAVEPOINT C1;
-- VIEW 테이블을 활용하여 JOIN 해보기(사원코드, 사원명, 월급, 부서코드, 부서명)
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE
    JOIN V_DEPT03 ON (DEPT_CODE = DEPT_ID);





















