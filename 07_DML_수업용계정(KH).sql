/*
    09장 DML
    
    1. SELECT ~ FROM ~ WHERE ~ GROUP BY ~ HAVING ~ ORDER BY ~ DESC/ASC
    
    2. INSERT INTO 테이블명(컬럼명,~) VALUES(컬럼개수에 맞게 입력)
       INSERT INTO 테이블명(컬럼명,~) VALUES(모두 컬럼개수 값을 입력)
       
    3. UPDATE 테이블명 SET(SETTER 와 동일) 컬럼명 = 값, 컬럼명 = 값 WHERE ~;
    
    4. DELETE FROM 테이블명 WHERE ~;
*/
/*
    D : DATA, L : LANGUAGE
    DML(MANIPULATION, 데이터 조작) : INSERT(추가/삽입), UPDATE(수정), DELETE(삭제)
    DDL(DEFINION, 데이터 정의): CREATE(생성) : 클래스설계(접근제어자, 타입, 변수 위치), 
                            제약조건 5가지, ALTER(변경), DROP(삭제)
    DCL(CONTROL, 데이터 제어) : GRANT, REVOKE
    TCL(TRANSACTION CONTROL, 트랜잭션 제어) : COMMIT, ROLLBACK, SAVEPOINT
*/

/*
    DML (데이터 조작 언어)
     : 테이블에 데이터(값)를 추가하거나 (INSERT : 제약조건 주의바람),
                수정하거나(UPDATE : 주의 WHERE 사용하지 않으면 전체 업데이트가 발생함),
                    삭제하기 위해 (DELETE)사용하는 언어
*/

/*
    INSERT => 테이블에 새로운 행을 추가하는 구문
    
    [표현법]
    1) INSERT INTO 테이블명 VALUES(값,값,값,...)
*/

/*
    DML (데이터 조작 언어)
    : 테이블에 데이터(값)를 추가하거나 (INSERT),
                            수정하거나 (UPDATE),
                                삭제하기 위해 (DELETE) 사용하는 언어
*/

/*
    [기본 상식]
    1. long a = 10L; 변수타입 상수 정해져있다.
    2. 변수 = 상수 => 일치해야한다
    3. 형변환(자동형변환, 강제형변환)
    
    INSERT=> 테이블에 새로운 행을 추가하는 구문
    [표현법]
    1) INSERT INTO 테이블명(컬럼, ...) VALUES (값, 값, 값, ...)
    -> 테이블의 모든 컬럼에 대한 값을 직접 제시하여 한 행을 추가하고자 할 때 사용
       컬럼 순서에 맞게 VALUES에 값을 나열해야 함 (* 해당 컬럼의 데이터 타입에 맞게!)
                                                (제약조건에 맞게 입력요청)
    값을 부족하게 제시했을 경우 => not enough value 오류발생!
    값을 더 많이 제시했을 경우 => too many values 오류발생!
*/

-- INSERT
-- 주의 : 타입에 맞게 (NUMBER = 숫자, VARCHAR2 = '문자열', DATE = '날짜,시간')
-- 주의 : 길이 조심 (VARCHAR2(5) : 5byte = '123456' => 오류남)
--        NUMBER(5) = 123456; =>  error
DESC EMPLOYEE;
SELECT * FROM EMPLOYEE;
INSERT INTO EMPLOYEE
VALUES(1, '홍길동','820114-1010101', 'hong_kd@kh.or.kr', '01099998888', 'D5', 'J2',
 3800000, NULL, '200', SYSDATE,  NULL, DEFAULT);
 
SELECT * FROM EMPLOYEE WHERE EMP_ID = 1;

-- UPDATE EMP_NAME = '홍길동'의 EMP_ID 290
UPDATE EMPLOYEE
SET EMP_ID = 290 WHERE EMP_NAME = '홍길동';
SELECT * FROM EMPLOYEE WHERE EMP_ID = 290;

-- DELETE EMP_ID 290 
DELETE FROM EMPLOYEE WHERE EMP_ID = 290;
 
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'EMPLOYEE';
--====================================================================

CREATE TABLE EMP_01(
 EMP_ID NUMBER,
 EMP_NAME VARCHAR2(30),
 DEPT_TITLE VARCHAR2(20)
 );
 
 SELECT * FROM USER_TABLES WHERE TABLE_NAME = 'EMP_01';
 
 INSERT INTO EMP_01(
 SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE
 FROM EMPLOYEE E
 LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
 );
 SELECT * FROM EMP_01;
 
 INSERT INTO EMP_01(
 SELECT EMP_ID,
 EMP_NAME,
 DEPT_TITLE
 FROM EMPLOYEE
 LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
 );
--========================================================================
/*
    
*/
--========================================================================
-- INSERT ALL
-- 서브쿼리가 사용하는 테이블이 같고, 조건절이 같은 경우 두개 이상의 테이블에 한번에 대입 가능
DROP TABLE EMP_DEPT_D1;

CREATE TABLE EMP_DEPT_D1
AS
SELECT * FROM EMPLOYEE; -- WHERE 1 = 0;
-- 데이터 전체 복사
-- WHERE 1=0(NOT 부정값) 대입시 데이터 는 복사하지 않고 구조만 복사
SELECT * FROM EMP_DEPT_D1;
--========================================================================
 
 -- 구조복사
 DROP TABLE EMP_DEPT_D1;
 CREATE TABLE EMP_DEPT_D1
 AS 
 SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
 FROM EMPLOYEE
 WHERE 1 = 0;

 DROP TABLE EMP_MANAGER;
 CREATE TABLE EMP_MANAGER
 AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
 FROM EMPLOYEE
 WHERE 1 = 0;

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

-- DEPT_CODE = 'D1' 의 값을 가진 데이터 INSERT ALL 
INSERT ALL
 INTO EMP_DEPT_D1 VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
 INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
 SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
 FROM EMPLOYEE
 WHERE DEPT_CODE = 'D1';

DESC EMP_DEPT_D1;


/*
    [INSERT]
     : 테이블에 새로운 행을 추가하여 테이블의 행 개수를 증가시키는 구문
     INSERT INTO 테이블명 (컬럼명, 컬럼명, ...)
     VALUES (컬럼에 대입할 값, 대입할값, ...);
*/
-- 

/*
    -- INSERT ALL 한번의 서브쿼리 동시에 2개이상에 테이블에 입력이 가능한 구조
    [표현법]
    INSERT ALL
        INTO 테이블명 VALUES (컬럼명, 컬럼명, 컬럼명, ...)
        INTO 테이블명 VALUES (컬럼명, 컬럼명, ...)
        서브쿼리;
*/
/*
    WHERE 1 = 0; 데이터를 전달하기보다는 참, 거짓 조건으로 구조만 복사하는것
*/

-- INSERT ALL 
-- EMPLOYEE테이블의 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의 사번, 이름,
-- 입사일, 급여를 조회해서 EMP_OLD테이블에 삽입하고 그 후에 입사한 사원의 정보는 
-- EMP_NEW테이블에 삽입

-- EMP_OLD 테이블 생성
DROP TABLE EMP_OLD;
CREATE TABLE EMP_OLD
 AS SELECT  EMP_ID, 
            EMP_NAME,
            HIRE_DATE,
            SALARY
 FROM EMPLOYEE
 WHERE 1 = 0;
 DESC EMP_OLD;

-- EMP_NEW 테이블 생성
DROP TABLE EMP_NEW;
CREATE TABLE EMP_NEW
 AS SELECT  EMP_ID, 
            EMP_NAME,
            HIRE_DATE,
            SALARY
 FROM EMPLOYEE
 WHERE 1 = 0;
DESC EMP_NEW;
/*
    조건에 따라 INSERT ALL 하기
    EMPLOYEE테이블의 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의 사번, 이름,
    입사일, 급여를 조회해서 EMP_OLD 테이블에 삽입하고 그 후에 입사한 사원의 정보는 
    EMP_NEW 테이블에 삽입
    
    [표현법]
    INSERT ALL
    WHEN 컬럼명 조건 THEN
    INTO 테이블명 VALUES (INSERT할 컬럼명 값)
    WHEN ... THEN ...
    IMTO ... VALUES ...
    SELECT INSERT 할 컬럼명 값
    FROM 참조할 테이블명;
    => 조건은 생략가능 단, 생략시 모든 내용이 INSERT됨
*/
INSERT ALL
 WHEN HIRE_DATE < '2000/01/01' THEN
 INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
 WHEN HIRE_DATE >= '2000/01/01' THEN
 INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
 SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
 FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

--==============================================================================
/*
    [UPDATE]
     : 테이블에 기록된 컬럼의 값을 수정하는 구문
       테이블의 전체 행 개수에는 변화가 없음
       
       [표현법]
       UPDATE 테이블명
       SET 컬럼명 = 변경할 내용 => 여러개의 컬럼 값을 동시에 변경가능 , 로 나열
       [WHERE 조건]; => WHERE절을 생략할경우 테이블의 모든 행의 데이터가 변경됨 주의
    
    * 업데이트시 제약 조건을 잘 확인해야함
        (PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK)
        (PK, FK, UK, NOT NULL, CHECK)
        주어진 길이의 초과값을 넣으면 안된다.
*/
    -- DEPT_COPY 테이블 생성 (DEPARTMENT 카피)
    DROP TABLE DEPT_COPY;
    CREATE TABLE DEPT_COPY
    AS SELECT * FROM DEPARTMENT;
    -- UPDATE 전 데이터 조회
    SELECT * FROM DEPT_COPY;
    
    -- DEPT_COPY 테이블에 DEPT_ID 'D9'를 이용하여
    --              DEPT_TITLE 을 '전략기획팀'으로 변경
    UPDATE DEPT_COPY
    SET DEPT_TITLE = '전략기획팀'
    WHERE DEPT_ID = 'D9';
    -- UPDATE 후 데이터 조회
    SELECT * FROM DEPT_COPY;
    
    ROLLBACK;
--=================================================================================
-- 방명수 사원의 급여와 보너스율을 유재식 사원과 동일하게 변경
-- 테이블 생성
DROP TABLE EMP_SALARY;
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID,
        EMP_NAME,
        DEPT_CODE,
        SALARY,
        BONUS
FROM EMPLOYEE;

SELECT *
FROM EMP_SALARY
WHERE EMP_NAME IN ('방명수','유재식');

-- 업데이트 할 내용 작성
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY FROM EMP_SALARY WHERE EMP_NAME = '유재식'),
    BONUS = (SELECT BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT *
FROM EMP_SALARY 
WHERE EMP_NAME IN ('방명수', '유재식');
ROLLBACK;

--=======================================================================
/*
    [다중열 컬럼방식]
    UPDATE 테이블명
    SET (변경할 컬럼명, ...) = (SELECT 컬럼명 FROM 테이블명 WHERE 조건)
                                => 참조할 내용
    WHERE 조건
            => UPDATE 할 컬럼 데이터
*/
SELECT * FROM EMP_SALARY
WHERE (SALARY, BONUS) = 
(SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식');

-- 각각 쿼리문 작성한 것을 다중행 다중 열 서브쿼리로 변경
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                        FROM EMP_SALARY
                        WHERE EMP_NAME = '유재식')
WHERE EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('유재식','노옹철', '전형돈', '정중하', '하동운');

--===========================================================================
-- EMP_SALARY 테이블에서 아시아 지역에 근무하는 직원의 보너스 포인트를 0.3으로 변경
/*
-- 이부분을 실습하기 위해서는 뒤에서부터 조인을 풀어서 작업
-- 풀어서 작업을 했는데 합칠때는?
- A JOIN B     B JOIN C     C JOIN D
- A JOIN B ON(PK = FK) WHERE
- B JOIN C ON(PK = FK) WHERE
- C JOIN D ON(PK = FK) WHERE
- A -> B -> C -> D
- 구현할때는 앞에서
- A JOIN B ON(PK = FK) JOIN C ON (PK = FK) WHERE
- A JOIN B ON(PK = FK) JOIN C ON (PK = FK) JOIN D ON (PK = FK) WHERE
*/

SELECT * FROM EMP_SALARY;
DROP TABLE EMP_SALARY;

UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN(SELECT EMP_ID
                FROM EMPLOYEE
                JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
                JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                WHERE LOCAL_NAME LIKE 'ASIA%');
                
-- LOCATION 테이블 구조
DESC LOCATION; 
-- => LOCAL_CODE CHAR(2), NATIONAL_CODE CHAR(2), LOCAL_NAME VARCHER(40)
SELECT * FROM LOCATION;

-- WHERE 필터링기능이다 (레코드단위로 필터링 조건에 맞는 내용을 가져온다)
-- LOCAL_NAME 컬럼에서 첫글자부터 ASIA로 되어 있는것을 찾기(검색기능)
SELECT * FROM LOCATION WHERE LOCAL_NAME LIKE ('%ASIA%');

-- LOCATION 테이블에 INSERT 이용하여 L4, KO2, TASIA4 대입하기
INSERT INTO LOCATION VALUES('L6','KR','TASIA4');

-- JOIN 두개이상 테이블을 한개의 테이블로 보이게 하는 기능(PK, FK)
SELECT * FROM DEPARTMENT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- JOIN 두개 이상 테이블을 한개의 테이블로 보이게하는 기능(PK=EK)
-- 한개테이블이 만들어졌으면 조건을 걸어서 필터링해보시오
SELECT * FROM DEPARTMENT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE ('%ASIA%');

-- EMPLOYEE 와 DEPARTMENT 새로운 테이블 VRABLE
SELECT EMP_ID, DEPT_CODE, DEPT_ID, DEPT_TITLE, LOCAL_CODE, NATIONAL_CODE, LOCAL_NAME
FROM EMPLOYEE 
    JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE '%ASIA%';

SELECT EMP_ID
FROM EMPLOYEE 
    JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE '%ASIA%';

-- DEPARTMENT 와 LOCATION 조인부분 => (새로운 테이블 VRABLE)
SELECT * FROM DEPARTMENT 
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE) 
WHERE LOCAL_NAME LIKE '%ASIA%';

SELECT * FROM EMP_SALARY;
SELECT * FROM EMPLOYEE;
ROLLBACK;
-- ==========================================================================
/*
    MERGE
    : 구조가 같은 두 개의 테이블을 하나의 테이블로 합치는 기능 제공
    두 테이블에서 지정하는 조건의 값이 존재하면 UPDATE되고 조건의 값이 없으면 INSERT 함
    
    - 기본조건 : 두개의 컬럼수와 타입이 일치해야 한다.
    
    [표현법]
    MERGE INTO 테이블명1 USING 테이블명2 ON(PK = FK)
    WHEN MATCHED THEN
    UPDATE SET
        1.컬럼 = 2.컬럼
        1.컬럼 = 2.컬럼
        ...
    WHEN NOT MATCHED THEN
    INSERT VALUES(2.컬럼, ...);
*/
-- 주 테이블 생성 (서브쿼리)
DROP TABLE EMP_M01;
CREATE TABLE EMP_M01
AS
SELECT * FROM EMPLOYEE;
SELECT * FROM EMP_M01;

-- 서브 테이블 생성 (서브쿼리)
DROP TABLE EMP_M02;
CREATE TABLE EMP_M02
AS
SELECT * FROM EMPLOYEE
WHERE JOB_CODE = 'J4';
SELECT * FROM EMP_M02;

-- 서브테이블의 새로운 회원 입력
INSERT INTO EMP_M02
VALUES(999,'곽두원', '561016-1234567', 'kwack_dw@kh.co.kr', '01011112222',
            'D9', 'J1', 9000000, 0.5, NULL, SYSDATE, DEFAULT, DEFAULT);

-- 서브테이블에 전체 SALARY = 0; 초기화
UPDATE EMP_M02 SET SALARY = 0;

-- 
MERGE INTO EMP_M01 USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID)
 WHEN MATCHED THEN
 UPDATE SET
 EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
 EMP_M01.EMP_NO = EMP_M02.EMP_NO,
 EMP_M01.EMAIL = EMP_M02.EMAIL,
 EMP_M01.PHONE = EMP_M02.PHONE,
 EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
 EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
 EMP_M01.SALARY = EMP_M02.SALARY,
 EMP_M01.BONUS = EMP_M02.BONUS,
 EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
 EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
 EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
 EMP_M01.ENT_YN = EMP_M02.ENT_YN
 WHEN NOT MATCHED THEN
 INSERT VALUES(EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL, 
            EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, 
            EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE, 
            EMP_M02.ENT_DATE, EMP_M02.ENT_YN);

SELECT * FROM EMP_M01 WHERE EMP_ID = 999;
SELECT * FROM EMP_M01 WHERE JOB_CODE = 'J4';
SELECT * FROM EMP_M02;
ROLLBACK;
--=================================================================================
/*
    DELETE
    : 테이블의 행을 삭제하는 구문으로 테이블의 행 개수가 줄어듦
    
    [표현법]
    DELETE FROM 테이블명
    [WHERE 조건] => WHERE 조건 을 설정하지 않으면 모든행 삭제
*/
-- DELETE FROM 사용시 FK(FOREIGN KEY) 제약조건은 컬럼삭제가 불가능 
-- 제약조건 비활성화 후 삭제 가능

-- LOC 테이블 생성
DROP TABLE LOC;
CREATE TABLE LOC
AS 
SELECT LOCAL_CODE, 
        NATIONAL_CODE,
        LOCAL_NAME
FROM LOCATION;


-- DELETE 를 이용해 LOCAL_CODE 'L1' 삭제하기
DELETE FROM LOC WHERE LOCAL_CODE = 'L1';
-- => LOCAL_CODE 'L1'을 가지고 있는 행 전체 삭제됨
SELECT * FROM LOC;
-- FK(FOREIGN KEY)제약조건으로 컬럼삭제가 불가능한경우
DROP TABLE LOC;
CREATE TABLE LOC(
        LOCAL_CODE1 VARCHAR2 (10), 
        NATIONAL_CODE1 VARCHAR2 (10),
        LOCAL_NAME1 VARCHAR2 (10),
        CONSTRAINT PK_FOREIGN_LC PRIMARY KEY(NAIONAL_CODE),
        CONSTRAINT FK_FOREIGN_LN FOREIGN KEY(LOCAL_NAME)
);
DESC LOC;


























