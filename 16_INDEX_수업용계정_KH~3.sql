/*
    인덱스(INDEX)
     : SQL명령문(검색: SELECT)의 처리속도를 향상시키기 위해 검색에 자주 사용되는
     해당 컬럼에 대해 생성하는 오라클 객체로 내부 구조는 B*트리 형식으로 구성되어있다.

    - 장점 : (SELECT)검색속도가 빨라지고 시스템에 걸리는 부하를 줄여 시스템 전체 성능 향상
    - 단점 : 인덱스를 위한 추가 저장공간이 필요하고 인덱스를 생성하는데 시간이걸림
            데이터의 변경작업(INSERT, UPDATE, DELETE)이 자주 일어날 경우 오히려 성능저하
    
    [구조]
    CREATE [UNIQUE] INDEX 인덱스 명
    ON 테이블 명 (컬럼명, 컬럼명 | 함수명, 함수계산식);
    
    SELECT * FROM USER_IND_COLUMNS; => 인덱스 컬럼 확인하는 명령문
*/

-- EMP_02 테이블 생성(EMPLOYEE 서브쿼리 생성)
DROP TABLE EMP_02;
CREATE TABLE EMP_02
AS
SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_02;

-- EMP01_INDEX 테이블을 EMPLOYEE 서브쿼리 생성
DROP TABLE EMP01;
CREATE TABLE EMP01
AS
SELECT * FROM EMPLOYEE;

SELECT * FROM EMP01;

DROP TABLE EMP01_INDEX;
CREATE TABLE EMP01_INDEX
AS
SELECT * FROM EMPLOYEE;

SELECT * FROM EMP01_INDEX;

-- EMP01, EMP01_INDEX 테이블에 인덱스 설정된 컬럼이 존재하는지 확인
SELECT TABLE_NAME, INDEX_NAME,COLUMN_NAME 
FROM USER_IND_COLUMNS WHERE TABLE_NAME IN ('EMP01', 'EMP01_INDEX');
-- => 인덱스를 설정하지 않았으므로 해당되는 컬럼이 보이지 않는다.

-- 인덱스 수행계획 : 인덱스가 설정되지 않는 테이블(EMP01) 검색계획을 세우고 성능체크하기
-- EMP_ID = 222번 검색하는데 검색 수행계획(EXPLAIN PLAN FOR) 진행
--  => 수행계획정보가 (DBMS_XPLAN.DISPLAY)
-- 수행계획 조사방법 -> SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
EXPLAIN PLAN FOR 
SELECT * FROM EMP01 WHERE EMP_ID = '222';
-- => 설명되었습니다(DEMS_XPLAN.DISPLAY로 확인가능)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
/*
                    < SELECT 실행계획 구조 내용 >
---------------------------------------------------------------------------
| Id  | Operation         | Name  | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |       |     1 |    81 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP01 |     1 |    81 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------

- SELECT STATEMENT : SELECT 문장에 실행했다.
- TABLE ACCESS FULL : 전체 테이블을 탐색하여 결과를 도출
- Rows : 실행계획에서 ACCESS 된 ROW 수
- BYTES : 실행계획에서 ACCESS 된 BYTE 수
- Cost : CPU 성능(100%)에서 자원을 얼마나 사용했는지 표현(값이 낮을수록 검색비용 적음)
*/

-- EMP01_INDEX(EMP_ID) 테이블에 PK를 설정하여 자동으로 인덱스 기능이 설정되도록 진행
ALTER TABLE EMP01_INDEX
ADD CONSTRAINT PK_EMP01_INDEX_ID PRIMARY KEY(EMP_ID);

-- INDEX 등록되었는지 확인
SELECT TABLE_NAME, INDEX_NAME,COLUMN_NAME 
FROM USER_IND_COLUMNS WHERE TABLE_NAME IN ('EMP01', 'EMP01_INDEX');
-- => 등록 확인 완료

-- 제약조건 걸렸는지 확인
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'EMP01_INDEX';

-- EMP01_INDEX 테이블에는 EMP_ID(PK) 설정 되어 있기때문에 자동으로 INDEX설정되어 버린다.
-- 따라서 인덱스 컬럼을 사용하면서 검색수행계획 세우기 가능해짐

EXPLAIN PLAN FOR 
SELECT * FROM EMP01_INDEX WHERE EMP_ID = '222';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

/*
-------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                   |     1 |    81 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP01_INDEX       |     1 |    81 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP01_INDEX_ID |     1 |       |     0   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------
*/

-- ROWID 확인하기 
SELECT ROWID, EMP_ID, EMP_NAME FROM EMPLOYEE;
--==========================================================================================
/*
    1. 고유 인덱스(UNIQUE INDEX)
        - 중복 값이 포함될 수 없음
        - PRIMARY KEY 제약조건을 생성하면 자동으로 생성됨
    2. 비고유 인덱스(NONUNIQUE INDEX)
        - 빈번하게 사용되는 일반 컬럼을 대상으로 생성
        - 주로 성능 향상을 위한 목적으로 생성
    3. 단일 인덱스(SINGLE INDEX)
        - 한 개의 컬럼으로 구성한 인덱스
    4. 결합 인덱스(COMPOSITE INDEX)
        - 두 개 이상의 컬럼으로 구성한 인덱스
    5. 함수 기반 인덱스(FUNCTION-BASED INDEX)
        - SELECT절이나 WHERE절에 산술 계산식이나 함수식이 사용된 경우
        - 계산식은 인덱스의 적용을 받지 않음

*/
--=======================================================================================
/*
    1. 고유 인덱스(UNIQUE INDEX)
    2. 비고유 인덱스(NONUNIQUE INDEX)
    
    [구조]
    - UNIQUE INDEX
    CREATE UNIQUE INDEX 인덱스명 <= (IX_테이블명_컬럼명)
    ON 테이블명(컬럼명);
    
    - NONUNIQUE INDEX
    CREATE INDEX 인덱스명
    ON 테이블명(컬럼명);
*/

-- 고유 인덱스(UNIQUE INDEX)
-- [오류] EMPLOYEE 테이블에 DEPT_CODE를 UNUQUE INDEX로 만들려했는데 문제 발생
-- [원인] ORA-01452: 중복 키가 있습니다. 유일한 인덱스를 작성할 수 없습니다
-- [조치] 중복된 내용이 있는 컬럼은 NONUNIQUE INDEX 설정(CREATE INDEX 입력)

CREATE UNIQUE INDEX IX_EMPLOYEE_DEPT_CODE
ON EMPLOYEE(DEPT_CODE);
-- => ORA-01452: 중복 키가 있습니다. 유일한 인덱스를 작성할 수 없습니다

-- 에러발생한것 변경 NONUNIQUE INDEX로 변경 => DEFAULT = NONUNIQUE INDEX
DROP INDEX IX_EMPLOYEE_DEPT_CODE;
CREATE INDEX IX_EMPLOYEE_DEPT_CODE
ON EMPLOYEE(DEPT_CODE);

-- (PK를 제외한)중복되지 않는 컬럼으로 UNIQUE INDEX 설정(EMAIL)
DROP INDEX IX_EMPLOYEE_EMAIL;
CREATE UNIQUE INDEX IX_EMPLOYEE_EMAIL
ON EMPLOYEE(EMAIL);

SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'EMPLOYEE'; 

SELECT * FROM EMPLOYEE;
--======================================================================================
-- 4. 결합인덱스(COMPOSITE INDEX) : 두개 이상의 컬럼으로 구성한 인덱스
DROP INDEX IX_DEPARTMENT_TITLE_LOCATION;
CREATE INDEX IX_DEPARTMENT_TITLE_LOCATION
ON DEPARTMENT(DEPT_TITLE, LOCATION_ID);

SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'DEPARTMENT';

-- 결합 인덱스 설정시 검색컬럼 순서에 따라 인덱스 적용이 되고, 안되는 경우가 있다.
SELECT * FROM DEPARTMENT WHERE DEPT_TITLE = '인사관리부'; -- 인덱스 적용됨
SELECT * FROM DEPARTMENT WHERE DEPT_TITLE = '인사관리부' AND LOCATION_ID = 'L1'; -- 인덱스 적용됨
SELECT * FROM DEPARTMENT WHERE LOCATION_ID = 'L1'; -- 인덱스 적용 안됨

-- 5. 함수기반 인덱스(FUNCTION-BASED INDEX)
-- EMP_SALARY 테이블을 서브쿼리(EMPLOYEE)를 이용해서 생성
-- 단, EMP_ID, EMP_NAME, SALARY, BONUS, (SALARY+SALARY*NVL(BONUS,0))*12 연봉
DROP TABLE EMP_SALARY;
CREATE TABLE EMP_SALARY
AS
SELECT EMP_ID, EMP_NAME, SALARY, BONUS, (SALARY * 12 *(1 + NVL(BONUS,0))) 연봉
FROM EMPLOYEE;

SELECT * FROM EMP_SALARY;

DROP INDEX IX_EMP_SALARY;
CREATE INDEX IX_EMP_SALARY
ON EMP_SALARY(SALARY*12*(1+NVL(BONUS,0)));

SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'EMP_SALARY';

/*
    인덱스 재생성
     : DML 작업(DELETE 명령)을 수행한경우, 해당 인덱스 엔트리가 논리적으로만 제거되고,
      실제 엔트리는 그냥 남아있게 되므로 제거된 인덱스가 필요 없는 공간을 차지하고 있지 안도록
      인덱스를 재생성해야 한다.
      
    [구조]
    ALTER INDEX 인덱스명 REBUILD;
*/
ALTER INDEX IX_EMP_SALARY REBUILD;