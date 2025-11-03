/*
    -- 데이터 베이스의 정의 --
    - 한조직에 필요한 정보를 여러 응용 시스템에서 공용할 수 있도록 
    - 논리적으로 연관된 데이터를 모으고 중복되는 데이터를 최소화하여 
    - 구조적으로 통합/저장해놓은 것
    - 데이터 베이스 6
    - 정보, 공용, 연관데이터, 중복최소화, 통합, 저장
*/

-- 1. 테이블 만들기(클래스를 설계한다)
-- 자바 9가지 타입(정수4, 실수2, 부울1, 문자1, 문자열, 날짜)
-- 오라클 4가지타입(VARCHAR2(크기), CHAR(크기), NUMBER(길이,[소수점길이]), DATE)
-- NUMBER 사이즈개념, VARCHAR2, CHAR 의 차이점

-- 테이블 삭제
DROP TABLE MEMBER;
-- 테이블 생성
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(10),
    MEMBER_PWD VARCHAR2(10),
    MEMBER_NAME VARCHAR2(10)
);
--======================================================================================
-- 2. KIMCHI -> VARCHAR2(3)
-- 자바 형변환 INT NUM = (INT)34.45;,    INTEGER.PARTHINT("234.45"); 
SELECT CAST('KIMCHI' AS VARCHAR2(3)) FROM DUAL; 

-- TEST_VARCHAR2 테이블 생성
CREATE TABLE TEST_VARCHAR2(
    TEMP_DATA VARCHAR2(10)
);
DROP TABLE TEST_VARCHAR2;

-- INSERT INTO => 만들어진 테이블에 데이터 등록
INSERT INTO TEST_VARCHAR2(TEMP_DATA) VALUES('KIMCHI');


-- 등록된 데이터 조회
SELECT *FROM TEST_VARCHAR2;
--=========================================================================================
-- 3. DATA 날짜 + 숫자 => DATE
SELECT SYSDATE TODAY, SYSDATE + 10 PLUS_10 FROM DUAL;

-- DATA 날짜 - 숫자 => DATE
SELECT SYSDATE TODAY, SYSDATE - 10 MINUS_10 FROM DUAL;

-- DATA 날짜 - 날짜 => NUMBER
SELECT SYSDATE TODAY, SYSDATE - SYDATE DATE FROM DUAL;

-- TODATE : 문자열 -> 날짜
-- 자바 문자열 "a" 'A' // 오라클 문자열 ' ' " "
SELECT TO_DATE('2025-09-15 11:47:40', 'YYYY-MM-DD HH24:MI:SS') - TO_DATE('2025-09-14 11:47:40', 'YYYY-MM-DD HH24:MI:SS') RESULT 
FROM DUAL; 

-- DATA 날짜 - 숫자/24 => DATA
-- TO_CHAR : 날짜 => 문자열
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') TEST, TO_CHAR(SYSDATE + 12/24, 'YYYY-MM-DD HH24:MI:SS') RESULT FROM DUAL;
--=====================================================================================
-- 4 컬럼주석
CREATE TABLE MEMBER2(
    MEMBER_ID VARCHAR2(10),
    MEMBER_PWD VARCHAR2(10),
    MEMBER_NAME VARCHAR2(10)
);

DROP TABLE MEMBER2;

COMMENT ON COLUMN MEMBER2.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER2.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN MEMBER2.MEMBER_NAME IS '회원이름';

-- 유형확인
DESC MEMBER2;
--===============================================================================
/*
     *5 제약조건(NOT NULL, PK, UQ, FK, CHECK)
     자바 : NULL String name = null; // 힙 영역에 있는 객체를 어떤것도 가르키고 있지 않다.
     오라클 : NULL => 값을 넣을수 있는 상태 (넣지 않아도 실행에 문제는 없음), (Defalut)
             NOT NULL => 데이터에 NULL을 허용하지 않음 (값을 무조건 넣어야함)
             UNIQUE => 중복 값 허용 X
             PRIMARY KEY => NULL과 중복 값을 허용하지 않음(컬럼의 고유 식별자로 사용하기 위해)
             FOREIGN KEY => 참조되는 테이블의 컬럼의 값이 존재하면 허용 (두개테이블 : 본국, 외국)
             CHECK => 저장가능한 데이터 값의 범위나 조건을 지정하여 설정한 값만 허용
    
    [구조]
    CONSTRAINT 제약조건별칭 제약조건타입 (컬럼명)
    
*/
-- 테이블 삭제
DROP TABLE MEMBER;
-- 테이블 생성
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(10) NOT NULL,
    MEMBER_PWD VARCHAR2(10),
    MEMBER_NAME VARCHAR2(10)
);

INSERT INTO MEMBER(MEMBER_ID)VALUES('KKK');
SELECT * FROM MEMBER;
INSERT INTO MEMBER(MEMBER_ID, MEMBER_PWD,MEMBER_NAME)VALUES('ID','PWD','NAME');
-- MEMBER_ID 에 NOT NULL 을 지정해서 INSERT 과정에 ID 값을 포함시키지 않으면 NOT NULL 오류가 남
--==============================================================================
-- 6 제약조건테이블 확인
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'MEMBER';
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'MEMBER';
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'USER_UNIQUE';
SELECT * FROM USER_CONS_COLUMNS WHERE TABLE_NAME = 'USER_UNIQUE';
SELECT * FROM USER_TABLES;
SELECT * FROM USER_UNIQUE;
--=======================================================================================
-- * 7 UNIQUE(절대 중복값 허용하지 않음, 단 NULL은 허용) 테이블 레벨방식으로 외울것
DROP TABLE USER_UNIQUE;
 CREATE TABLE USER_UNIQUE(
 USER_NO NUMBER(3),
 USER_ID VARCHAR2(20),
 USER_PWD VARCHAR2(30) NOT NULL,
 USER_NAME VARCHAR2(30),
 GENDER VARCHAR2(10),
 PHONE VARCHAR2(30),
 EMAIL VARCHAR2(50),
 CONSTRAINT UK_USER_ID UNIQUE(USER_ID)
 );
INSERT INTO USER_UNIQUE VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
INSERT INTO USER_UNIQUE VALUES(1, NULL, 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
INSERT INTO USER_UNIQUE VALUES(1, 'user01', 'pass01', NULL, NULL, '010-1234-5678', 'hong123@kh.or.kr');
INSERT INTO USER_UNIQUE VALUES(1, 'user02', 'pass01', NULL, NULL, '010-1234-5678', 'hong123@kh.or.kr');
--========================================================================================
-- 8 CHECK
DROP TABLE USER_CHECK;

 CREATE TABLE USER_CHECK(
 USER_NO NUMBER PRIMARY KEY,
 USER_ID VARCHAR2(20) UNIQUE,
 USER_PWD VARCHAR2(30) NOT NULL,
 USER_NAME VARCHAR2(30),
 GENDER VARCHAR2(10) CHECK (GENDER IN ('남', '여')),
 PHONE VARCHAR2(30),
 EMAIL VARCHAR2(50)
 );
INSERT INTO USER_CHECK VALUES(1, 'user01', 'pass01', '홍길동', '남자', '010-1234-5678', 'hong123@kh.or.kr');
-- ORA-02290: 체크 제약조건(C##KH.SYS_C008339)이 위배되었습니다.
INSERT INTO USER_CHECK VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
INSERT INTO USER_CHECK VALUES(2, 'user02', 'pass02', '홍길동', '여', '010-1234-5678', 'hong123@kh.or.kr');
SELECT * FROM USER_CHECK;
--=======================================================================================
-- 9 PRIMARY KEY
DROP TABLE USER_PRIMARYKEY;

 CREATE TABLE USER_PRIMARYKEY(
 USER_NO NUMBER,
 USER_ID VARCHAR2(20),
 USER_PWD VARCHAR2(30) NOT NULL,
 USER_NAME VARCHAR2(30),
 GENDER VARCHAR2(10)CHECK(GENDER IN('남','여')),
 PHONE VARCHAR2(30),
 EMAIL VARCHAR2(50),
 CONSTRAINT PK_USER_PRIMARYKEY_NO PRIMARY KEY(USER_NO, USER_ID)
-- 두개 컬럼 묶기 => PRIMARY KEY 제약조건 설정
 );

 INSERT INTO USER_PRIMARYKEY VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr');
 INSERT INTO USER_PRIMARYKEY VALUES(1, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr');
 -- ORA-00001: 무결성 제약 조건(C##KH.PK_USER_PRIMARYKEY_NO)에 위배됩니다
 INSERT INTO USER_PRIMARYKEY VALUES(NULL, 'user03', 'pass03', '유관순', '여', '010-3131-3131', 'yoo123@kh.or.kr');
 -- SQL 오류: ORA-01400: NULL을 ("C##KH"."USER_PRIMARYKEY"."USER_NO") 안에 삽입할 수 없습니다

INSERT INTO USER_PRIMARYKEY VALUES(1, 'user02', 'pass02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr');
INSERT INTO USER_PRIMARYKEY VALUES(1, 'user03', 'pass03', '유관순', '여', '010-3131-3131', 'yoo123@kh.or.kr');

SELECT * FROM USER_PRIMARYKEY;
--======================================================================================
-- ** 10 FOREIGN KEY
-- 주 테이블(PK), 서브테이블(FK)

-- * ON DELETE SET NULL
DROP TABLE USER_GRADE;

CREATE TABLE USER_GRADE(
 GRADE_CODE NUMBER,
 GRADE_NAME VARCHAR2(30) NOT NULL,
 CONSTRAINT PK_CODE PRIMARY KEY(GRADE_CODE)
 );
 
 INSERT INTO USER_GRADE VALUES(10, '일반회원');
 INSERT INTO USER_GRADE VALUES(20, '우수회원');
 INSERT INTO USER_GRADE VALUES(30, '특별회원');
 
SELECT * FROM USER_GRADE;
 
DROP TABLE USER_FOREIGNKEY;

 CREATE TABLE USER_FOREIGNKEY(
 USER_NO NUMBER,
 USER_ID VARCHAR2(20),
 USER_PWD VARCHAR2(30) NOT NULL,
 USER_NAME VARCHAR2(30),
 GENDER VARCHAR2(10),
 PHONE VARCHAR2(30),
 EMAIL VARCHAR2(50),
 GRADE_CODE NUMBER,
 CONSTRAINT PK_FOREIGN_NO PRIMARY KEY(USER_NO),
 CONSTRAINT UK_FOREIGN_ID UNIQUE(USER_ID),
 CONSTRAINT FK_FOREIGN_GRADE_GRADE FOREIGN KEY (GRADE_CODE) 
 REFERENCES USER_GRADE (GRADE_CODE) ON DELETE SET NULL
 );
 
 INSERT INTO USER_FOREIGNKEY 
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10); 
INSERT INTO USER_FOREIGNKEY 
VALUES(2, 'user02', 'pass02', '이순신', '남', '010-9012-3456', 'lee123@kh.or.kr', 20);
INSERT INTO USER_FOREIGNKEY 
VALUES(3, 'user03', 'pass03', '유관순', '여', '010-3131-3131', 'yoo123@kh.or.kr', 30);
INSERT INTO USER_FOREIGNKEY
VALUES(4, 'user04', 'pass04', '신사임당', '여', '010-1111-1111', 'shin123@kh.or.kr', NULL);
INSERT INTO USER_FOREIGNKEY 
VALUES(5, 'user05', 'pass05', '안중근', '남', '010-4444-4444', 'ahn123@kh.or.kr', 50);

SELECT * FROM USER_FOREIGNKEY;
-- DELETE 사용 USER_GRADE(부모 테이블)에서 GRADE_CODE 10 데이터 삭제
DELETE FROM USER_GRADE WHERE GRADE_CODE = 10;
-- => USER_GRADE 에 GRADE_CODE 데이터 10이 삭제되어 
--              참조하고있던 USER_FOREIGNKEY에 GRADE_CODE 10 데이터가 null값으로 변함
--=================================================================================
-- *ON DELETE CASCADE
DROP TABLE USER_GRADE;
-- 부모 테이블 생성
CREATE TABLE USER_GRADE(
 GRADE_CODE NUMBER,
 GRADE_NAME VARCHAR2(30) NOT NULL,
 CONSTRAINT PK_CODE PRIMARY KEY(GRADE_CODE)
 );
 
INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

DROP TABLE USER_FOREIGNKEY;

-- USER_GRADE(부모테이블)를 참조하는 테이블 생성
CREATE TABLE USER_FOREIGNKEY(
 USER_NO NUMBER,
 USER_ID VARCHAR2(20),
 USER_PWD VARCHAR2(30) NOT NULL,
 USER_NAME VARCHAR2(30),
 GENDER VARCHAR2(10),
 PHONE VARCHAR2(30),
 EMAIL VARCHAR2(50),
 GRADE_CODE NUMBER,
 CONSTRAINT PK_FOREIGN_NO PRIMARY KEY(USER_NO),
 CONSTRAINT UK_FOREIGN_ID UNIQUE(USER_ID),
 CONSTRAINT FK_FOREIGN_GRADE_GRADE FOREIGN KEY (GRADE_CODE) 
 REFERENCES USER_GRADE (GRADE_CODE) ON DELETE CASCADE
 );

INSERT INTO USER_FOREIGNKEY 
VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10); 
INSERT INTO USER_FOREIGNKEY 
VALUES(2, 'user02', 'pass02', '이순신', '남', '010-9012-3456', 'lee123@kh.or.kr', 20);
INSERT INTO USER_FOREIGNKEY 
VALUES(3, 'user03', 'pass03', '유관순', '여', '010-3131-3131', 'yoo123@kh.or.kr', 30);
INSERT INTO USER_FOREIGNKEY
VALUES(4, 'user04', 'pass04', '신사임당', '여', '010-1111-1111', 'shin123@kh.or.kr', NULL);
INSERT INTO USER_FOREIGNKEY 
VALUES(5, 'user05', 'pass05', '안중근', '남', '010-4444-4444', 'ahn123@kh.or.kr', 50);

SELECT * FROM USER_FOREIGNKEY;
-- DELETE 이용 GRADE_CODE 10 데이터 제거
DELETE FROM USER_GRADE WHERE GRADE_CODE = 10;
-- => 부모테이블의 데이터를 삭제하면 참조하고있는 컬럼값이 존재하던 행 전체 삭제
--=========================================================================================
-- 11 SUBQURY 활용한 TABLE 생성(JOIN)
-- 서브쿼리를 활용하여 새로운 테이블 생성시에는 제약조건 복사가 되지 않는다.(NOT NULL 예외)
DROP TABLE EMPLOYEE_COPY;
CREATE TABLE EMPLOYEE_COPY
    AS SELECT EMP_ID, EMP_NAME, SALARY, DEPT_TITLE, JOB_NAME
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    LEFT JOIN JOB USING(JOB_CODE);

SELECT * FROM EMPLOYEE_COPY;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMPLOYEE_COPY';