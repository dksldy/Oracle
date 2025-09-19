/*
    ** 시퀀스(SEQUECE)
     - 자동으로 번호를 발생시켜주는 객체
     - 정수값을 순차적으로 일정한 값을 시켜서 생성
     
    [표현법]
    CREATE SEQUENCE 시퀀스명
    [START WITH 숫자]             -> 처음 발생시킬 시작 값, 기본값 1
    [INCREMENT BY 숫자]           -> 다음 값에 대한 증가치, 기본값 1
    [MAXVALUE 숫자 | NOMAXVALUE]  -> 발생시킬 최대값, 10의 27승-1 까지 가능
    [MINVALUE 숫자 | NOMINVALUE]  -> 발생시킬 최소값, -10의 26승
    [CYCLE | NOCTCLE]            -> 시퀀스가 최대값까지 증가 완료시
                                    CYCLE은 START WITH 설정값으로 돌아감
                                    NOCYCLE은 에러발생
    [CACHE | NOCACHE]            -> CACHE는 메모리 상에서 시퀀스 값 관리 기본값 20   
    
    일반적인 개념 캐쉬 : 자주사용되는(메모리:RAN) 데이터관련된 자료는
    CPU메모리가 가면 속도가 맞지 않기 때문에 속도가 맞은 캐쉬메모리에서 데이터를
    저장하면 빠르게 데이터를 가져올수 있다.
*/
-- SEQUENCE(SEQ_EMPNO) 생성 (시작값 : 300, 증가치 : 5, 최대값 : 310, NOCYCLE, NOCACHE)
DROP SEQUENCE SEQ_EMPNO;
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

-- SEQUENCE 활용해서 사용해보기
-- SEQ_EMPNO.NEXTVAL : 값을 생성시킴(SEQUENCE 값에 일정 값을 증가시켜 발생한 결과값)
-- SEQ_EMPNO.CURRVAL : 값을 보여줌 (현재 SEQUENCE 값)

-- 위 두가지를 이용하여 SEQUENCE 발생시키고 보여주기
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300값 발생
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 현재 값이 300이므로 300을 보여준다.

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305값 발생
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 현재값 305

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310값 발생
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 현재값 310

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
-- => ORA-08004: 시퀀스 SEQ_EMPNO.NEXTVAL exceeds MAXVALUE은 사례로 될 수 없습니다
-- 최대값(MAXVALUE) 310 이기때문에 오류 발생
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 현재값 310

-- SEQUENCE 정보 확인
SELECT * FROM USER_SEQUENCES;

-- SEQUENCE 객체 삭제
DROP SEQUENCE SEQ_EMPNO;

/*
    NEXTVAL / CURRVAL 사용 가능 여부
    사용가능부분
     - 서브쿼리가 아닌 SELECT문
     - INSERT문의 SELECT절
     - INSERT문의 VALUES절
     - UPDATE문의 SET절
*/
-- SEQUENCE(EMP_SEQ) 생성 -> 시작값 : 1, 증가치 : 1
DROP SEQUENCE EMP_SEQ;
CREATE SEQUENCE EMP_SEQ
START WITH 1
INCREMENT BY 1;

SELECT * FROM USER_SEQUENCES;

-- 1 서브쿼리가 아닌 SELECT문
SELECT EMP_SEQ.NEXTVAL FROM DUAL;
SELECT EMP_SEQ.CURRVAL FROM DUAL;

--2 INSERT문의 SELECT절 사용
-- 2-1 테이블(EMP_TARGET)생성 EMP_NO, EMP_NAME, SALARY 제약조건 EMP_1D(PK)
DROP TABLE EMP_TARGET;
CREATE TABLE EMP_TARGET(
    EMP_NO NUMBER PRIMARY KEY,
    NAME VARCHAR2(20),
    SALARY NUMBER(9)
);
SELECT * FROM EMP_TARGET;

-- 2-2 INSERT문(EMP_TARGET) 의 SELECT절 (EMPLOYEE 사용) 적용
INSERT INTO EMP_TARGET(EMP_NO, NAME, SALARY)
SELECT EMP_SEQ.NEXTVAL, EMP_NAME, SALARY FROM EMPLOYEE;
-- => EMP_NO 값에 EMP_SEQ.NEXTVAL 값이 입력되어 1부터 1씩 증가됨

--3 INSERT문의 VALUE절 사용된다
-- 3-1 EMP_TARGET 테이블에 시퀀스값을 사용해서 한개의 레코드를 입력

SELECT EMP_SEQ.CURRVAL FROM DUAL;
INSERT INTO EMP_TARGET VALUES(EMP_SEQ.NEXTVAL, '구길동', 4000000);

SELECT * FROM EMP_TARGET;

-- 4 UPDATE 문의 SET절 사용
-- EMP_TARGET 테이블에 EMP_NO = 24번 레코드를 EMP_NO 에 새로 시퀀스 값을 적용
UPDATE EMP_TARGET SET EMP_NO = EMP_SEQ.NEXTVAL WHERE EMP_NO = '24';
--===============================================================================
/*
    SEQUENCE 객체 변경하기
    [구조]
    ALTER SEQUENCE 시퀀스명
    [START WITH] -> 주의 : 변경할수 없다. 수정하면 안된다.
    [INCREMENT BY 숫자]
    [MAXVLAUE 숫자 | NOMAXVALUE]
    [MINVALUE 숫자 | NOMINVALUE]
    [CYCLE | NOCYCLE]
    [CACHE 숫자 | NOCACHE]
*/

-- 시퀀스값을 생성을 시키고, 사용하다가 최대값이 문제가 발생된것을 알게되어
-- 최대값을 두배로 증가 증가치를 1로 수정, CACHE 2개로 수정
DROP SEQUENCE SEQ_EMPNO;
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310 // 오류발생

-- 최대값을 두배로 증가시키고, 증가치를 1로 수정, CACHE 2개로 수정
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 1
MAXVALUE 600
CACHE 2;

SELECT * FROM USER_SEQUENCES;
SELECT SEQ_EMPNO. NEXTVAL FROM DUAL;

COMMIT;












