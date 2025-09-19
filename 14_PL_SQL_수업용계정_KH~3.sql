/*
    PL/SQL : Procedural Language extension to SQL
     - 오라클 자체에 내장되어(JDK,JRE = PL/SQL) 있는 절차적 언어
    - DDL, DML, DCL, DQL, TCL 단행실행방법에 나타난 
        SQL의 단점을 보완하여 SQL문장(사용자가 정의한 함수 :MAIN) 
            내에서 변수의 정의, 조건처리, 반복처리 등을 진행하여 단행으로 처리했던 
                SQL문 으로 모아서(로직을통해서) 한번에 실행
                
    [구조]
    DECLARE
        변수명 데이터타입 [:= 초기값];  -- 선언부(선택)
    BEGIN
        실행 명령어;      -- 실행부(필수)
    EXCEPTION
        예외를 처리하는부분; -- 예외처리부(선택)
    END;
    
    [선언부] : DECLARE 로 시작한다.(변수, 상수를 선언하고 초기화) 
                자바내 메인에서 지역변수(9가지 타입)
    실행부   : BEGIN으로 시작한다(SQL문, 제어문 : 조건문, 반복문) 
                로직을 구현할수있다 : 메인함수 하고싶은것 생각대로 진행하듯이 한다
    [예외처리부] : EXCEPTION 시작 예외가 발생하면 해결하면된다.(자바 예외처리와 같다)
*/
-- PL/SQL 실행하면 그 결과값을 볼수있는 화면설정
SET SERVEROUTPUT ON;

-- PL/SQL 문을 작성하자 => 화면에 HELLO WORLD 출력
-- System.out.println("Hello World");
BEGIN DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/
-- PUT_LINE이라는 프로시저를 이용하여 출력(DBMS_OUTPUT 패키지에 속해있음)


/*
    2단계 선언부(DECLARE)
     - 변수 또는 상수를 선언하는 부분
     - 초기값도 설정할수 있다
    
    1. 데이터타입
     - 일반타입 (CHAR, VARCHAR2, NUMBER, ...)
     - 레퍼런스 타입(다른 테이블의 컬럼을 참조 EMPLOYEE.EMP_ID)
     - ROW 타입(객체타입) 
     
    2. 선언방식
     변수명[CONSTANT] 자료형[:=];
     [주의] 
        - 상수선언을 할때는 CONSTANT를 넣어야한다.
        - 변수의 초기값을 설정할때는 := 해야한다.    
*/
-- ID와 NAME 선언, 각 변수에 상수값을 주고 출력.
DECLARE
    EMP_ID NUMBER(5);
    EMP_NAME VARCHAR2(30);
BEGIN
    EMP_ID := 100;
    EMP_NAME := '홍길동';
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '|| EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : '|| EMP_NAME);
END;
/

-- 레퍼런스 타입과, 직접 상수값을 입력하지 않고 SELECT 문을 이용하여 변수값 저장
-- ID와 NAME 선언, 각 변수에 SELECT 문을 통해서 주고 출력.
-- EMPLOYEE 테이블에 SELECT 문을 진행할때 사용자에게 찾고자하는 
--              EMP_ID 입력받기 (SCANNER = '&사용자 정의 변수')
-- [구조] SELECT ... INTO ...(선언된변수) FROM A JOIN B ON (A.a=B.b) WHERE ...;
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME INTO EMP_ID, EMP_NAME
    FROM EMPLOYEE 
    WHERE EMP_ID = '&USERID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '|| EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : '|| EMP_NAME);
END;
/

/*
    - ROWTYPE (테이블명%ROWTYPE)과, 직접상수값을 입력하지 않고 SELECT 문을 이용해서 
        한 레코드 타입값을 ROWTYPE 변수에 값을 저장한다.
    - ROWTYPE 선언(EMPLOYEE)하고, 각 변수에 SLEECT문을 통해서 받고, 출력
    - EMPLOYEE 테이블에서 SELECT 문을 진행할때 사용자에게 찾고자하는 EMP_ID 입력 받기
    [구조] SELECT ... INTO ...(선언된ROWTYPE변수) FROM A JOIN B ON (A.a=B.b) WHERE ...;
*/
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * INTO E
    FROM EMPLOYEE 
    WHERE EMP_ID = '&USER_ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '|| E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : '|| E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : '|| E.SALARY);
END;
/

/*
    [표현법]
    IF (조건)
    THEN
        DBMS_OUTPUT.PUT_LINE('출력할내용')
    END IF;
*/
-- TYPE(테이블명.컬럼명%TYPE)과, 직접상수값을 입력하지 않고 
-- SELECT문을이용 레코드값을 레퍼런스 TYPE 변수에 값저장 
-- 레퍼런스 TYPE 선언(EMPLOYEE)하고, 각 변수에 SELECT문을 통해 받고, 출력
-- '&사용자 정의 변수' 사용하기
-- 만약 BONUS가 없으면 '보너스를지급받지않는 사원입니다.' 출력하기
-- 만약 BONUS가 있으면 보너스율 로 출력해준다.
-- BONUS NULL 이면 0값주기(NVL)

-- ID,NAME,SALARY,BONUS
DECLARE
    EMP_ID      EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME    EMPLOYEE.EMP_NAME%TYPE;
    SALARY      EMPLOYEE.SALARY%TYPE;
    BONUS       EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE 
    WHERE EMP_ID = '&USER_ID';
    
    DBMS_OUTPUT.PUT_LINE('ID '|| EMP_ID);
    DBMS_OUTPUT.PUT_LINE('NAME '|| EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('SALARY '|| SALARY);
    DBMS_OUTPUT.PUT_LINE('BONUS '|| BONUS);
    
    IF (BONUS = 0)
    THEN
        DBMS_OUTPUT.PUT_LINE('보너스를 받지않는 사원입니다.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(EMP_NAME ||'보너스율은 '||BONUS * 100||'% 입니다.');
END;
/

/*
    [구조]
     SELECT ...
     INTO ...(선언된 ROWTYPE 변수)
     FROM  A JOIN B JOIN ON (A.a = B.b) 
     WHERE
- TYPE(테이블명.컬럼명%TYPE)과 
     SELECT문을이용 레코드값을 레퍼런스 TYPE 변수에 값저장 
- 레퍼런스 TYPE 선언(EMPLOYEE)하고, 각 변수에 SELECT문을 통해 받고, 출력
- '&사용자 정의 변수' 사용하기
- 만약 NATIONAL_CODE = 'KO' '국내팀' 저장, 그렇지 않으면 '해외팀'
- EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE, 해외팀 까지 출력
    
*/

DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NATIONAL_CODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20);
BEGIN
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.NATIONAL_CODE
    INTO EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    FROM EMPLOYEE E
        JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
        JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    WHERE E.EMP_ID = '&USER_ID';
    
    IF (NATIONAL_CODE = 'KO')
    THEN
        TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;
        
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '||EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : '||EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE : '||DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('NATIONAL_CODE : '||NATIONAL_CODE);
    DBMS_OUTPUT.PUT_LINE('TEAM : '||TEAM);
END;
/

/*
    JOIN 팁
     - 내가 찾고자 하는 컬럼값을 가지고 있는 테이블을 찾는다 (모델링보고 작업하면 개꿀)
     - 두 테이블간에 JOIN연결 : PK, FK 컬럼명 찾기 (DESC 테이블명; = 연관찾기)     
       ex) JOIN TEST (EMPLOYEE(DEPT_CODE FK), DEPARTMENT(DEPT_ID PK))
                   (DEPATMENT (LOCATION_ID FK)LOCATION(LOCAL_CODE PK))
     - 참조 순서를 FK -> PK, FK -> PK, FK ... -> PK
     - JOIN ON () || JOIN USING ()
     - EMPLOYEE E JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
       JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
*/

-- 학생성적점수 입력받기 성적 점수를 기준으로 등급 계산
-- 90이상 A, 80이상 B, 70이상 C, 60이상 D, 그 이하 F
DECLARE
    STUDENT VARCHAR2(10);
    SCORE NUMBER(5);
    GRADE CHAR(1);
BEGIN
    STUDENT := '&STU_NAME';
    SCORE := '&USER_SCORE';
    IF(SCORE >= 90) THEN
        GRADE := 'A';
    ELSIF(SCORE >= 80) THEN
        GRADE := 'B';
    ELSIF(SCORE >= 70) THEN
        GRADE := 'C';
    ELSIF(SCORE >= 60) THEN
        GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
        DBMS_OUTPUT.PUT_LINE(STUDENT||'님의 성적은 '||SCORE||', 등급은'|| GRADE ||' 입니다.');
END;
/
--============================================================================
/*
    반복문 : BASIC LOOP
    
    [구조]
    DECLARE
        
    BEGIN
        LOOP
            명령어...;
            IF(조건) THEN
                ... EXIT;
            END IF;
        END LOOP;
    END;
    /
*/
-- 무한루프를 이용해 1부터 5까지 출력하는 프로그램 만들기
DECLARE 
    NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('NUM = '||NUM);
        NUM := NUM + 1;
        IF(NUM > 5)THEN
            EXIT;
        END IF;
    END LOOP;
END;
/
--=====================================================================
/*
    WHILE LOOP 방식
    
    [구조]
    WHILE(결정값) LOOP;
        명령어...
    END LOOP;
*/
-- WHILE LOOP 문을 사용하여 1부터 5까지 출력
DECLARE
    NUM NUMBER(2) := 1;
BEGIN
    WHILE(NUM <= 5)LOOP
        DBMS_OUTPUT.PUT_LINE('NUM : '||NUM);
        NUM := NUM + 1;
    END LOOP;
END;
/
--==================================================================
/*
    FOR LOOP 반복문
    
    [구조]
    DECLARE
        ...
    BEGIN
        FOR ... IN 배열구조 형식 LOOP
            명령어...;
        END LOOP;
    END;
    /
    
    - FOR ... IN REVERSE N1 .. N2 LOOP 를 사용해 거꾸로 사용도 가능 
*/
-- FOR LOOP 문을 활용하여 1부터 5까지 출력
DECLARE
    NUM NUMBER(2);
BEGIN
    FOR NUM IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('NUM : '||NUM);
    END LOOP;
END;
/

-- 반대로 5 에서 1 까지 출력하기 (REVERSE)
DECLARE
    NUM NUMBER(2);
BEGIN
    FOR NUM IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('NUM : '||NUM);
    END LOOP;
END;
/
--===================================================================
/*
    타입변수 선언
     : 테이블 타입의 변수 선언과 초기화, 변수 값 출력

    재정의 타입 변수선언
     : 복잡한구조(배열구조) 타입선언을 재정의 한다.
     [구조]
     TYPE 재정의 타입명 IS TABLE OF 테이블.컬럼%TYPE INDEX BY BINARY_INTEGER;
*/ 
-- ** 1 타입을 재정의하시오. 
-- 레퍼런스타입[] => 테이블.컬럼%TYPE[] => 테이블.컬럼%TYPE INDEX BY BINARY_INTEGER;
-- 1-1 EMPLOYEE.EMP_ID%TYPE[] 재정의 (EMP_ID_TABLE_TYPE)
-- 1-2 EMPLOYEE.EMP_NAME%TYPE[] 재정의 (EMP_NAME_TABLE_TYPE)
-- 2 재정의 타입으로 변수를 선언하다
-- 3 FOR LOOP를 통해서 EMPLOYEE 에 SELECT를 이용해 ROWTYPE 데이터를 받는다
-- 3-1 FOR LOOP 안에서 ROWTYPE에 각각 컬럼값을 TABLE 선언된 변수에 입력
-- 4 테이블 타입에 선언된 배열값을 출력한다.(FOR LOOP)
DECLARE
    TYPE EMP_ID_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_ID%TYPE INDEX BY BINARY_INTEGER;
    TYPE EMP_NAME_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_NAME%TYPE INDEX BY BINARY_INTEGER;
    EMP_ID_TABLE EMP_ID_TABLE_TYPE;
    EMP_NAME_TABLE EMP_NAME_TABLE_TYPE;
    I BINARY_INTEGER := 0;
BEGIN
    FOR ROW_DATA IN (SELECT EMP_ID, EMP_NAME FROM EMPLOYEE) LOOP
        I := I + 1;
        EMP_ID_TABLE(I) := ROW_DATA.EMP_ID;
        EMP_NAME_TABLE(I) := ROW_DATA.EMP_NAME;
    END LOOP;
    
    FOR K IN 1..I LOOP
         DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID_TABLE(K) || ', EMP_NAME : ' || 
            EMP_NAME_TABLE(K));
    END LOOP;
END;
/
--=================================================================================
/*
    재정의 타입 레코드, 변수선언
     : 복잡한구조(레코드구조) 타입선언을 재정의 한다.
     [구조]
     TYPE 재정의 타입명 IS RECORD OF (
     변수명 테이블.컬럼%TYPE,
     변수명 테이블.컬럼%TYPE,
     ...
     /
*/

/*
DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_TITLE DEPRATMENT.DEPT_TITLE%TYPE;
    NATIONAL_CODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20);
BEGIN
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.NATIONAL_CODE
    INTO EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    FROM EMPLOYEE E
        JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
        JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    WHERE E.EMP_ID = '&USER_ID';
    
    IF (NATIONAL_CODE = 'KO')
    THEN
        TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;
        
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '||EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : '||EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE : '||DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('NATIONAL_CODE : '||NATIONAL_CODE);
    DBMS_OUTPUT.PUT_LINE('TEAM : '||TEAM);
END;
/
*/
-- 위에있는 프로그램을 레코드 타입으로 재정의 하고 리빌딩하기
DECLARE
    TYPE EMP_RECORD_TYPE IS RECORD(
        EMP_ID EMPLOYEE.EMP_ID%TYPE,
        EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
        DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
        NATIONAL_CODE LOCATION.NATIONAL_CODE%TYPE
    );
    EMP_RECORD EMP_RECORD_TYPE;
    TEAM VARCHAR2(20);
BEGIN
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.NATIONAL_CODE
    INTO EMP_RECORD
    FROM EMPLOYEE E
        JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
        JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    WHERE E.EMP_ID = '&USER_ID';
    
    IF (EMP_RECORD.NATIONAL_CODE = 'KO')
    THEN
        TEAM := '국내팀';
    ELSE
        TEAM := '해외팀';
    END IF;
        
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '||EMP_RECORD.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : '||EMP_RECORD.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_TITLE : '||EMP_RECORD.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('NATIONAL_CODE : '||EMP_RECORD.NATIONAL_CODE);
    DBMS_OUTPUT.PUT_LINE('TEAM : '||TEAM);
END;
/
--=========================================================================
/*
    CASE 선택문
    
    [구조]
    CASE 변수
    WHEN 값 THEN 내용
    WHEN 값 THEN 내용
    ...
    ELSE 내용
    END;
*/
-- EMPLOYEE 에서 사원번호를 입력해서 SELECT 를 통해 ROW 타입으로 저장한 다음
-- DEPT_CODE(부서코드)에 따라 다음과 같이 CASE문 작성
-- 'D1' -> '개발부1', 'D2' -> '개발부2', .. 'D9' -> '개발부9' 출력
DECLARE
    EMP_ROW EMPLOYEE%ROWTYPE;
    DEPART_NAME VARCHAR2(50);
BEGIN
    SELECT * INTO EMP_ROW 
    FROM EMPLOYEE 
    WHERE EMP_ID = '&USER_EMP';
    
    DEPART_NAME := CASE EMP_ROW.DEPT_CODE
    WHEN 'D1' THEN '개발부1'
    WHEN 'D2' THEN '개발부2'
    WHEN 'D3' THEN '개발부3'
    WHEN 'D4' THEN '개발부4'
    WHEN 'D5' THEN '개발부5'
    WHEN 'D6' THEN '개발부6'
    WHEN 'D7' THEN '개발부7'
    WHEN 'D8' THEN '개발부8'
    WHEN 'D9' THEN '개발부9'
    ELSE '부서없음'
    END;
    
    DBMS_OUTPUT.PUT_LINE('EMP_ROW.EMP_ID : '||EMP_ROW.EMP_ID||
    ' EMP_ROW.DEPT_CODE : '|| EMP_ROW.DEPT_CODE||' 부서명 : '||DEPART_NAME);
END;
/
--=================================================================================
/*
    예외처리부
     : 예외(EXCEPTION) 실행중에 발생하는 오류 예외이다
     
    [구조]
    EXCEPTION
        WHEN 예외명 THEN 예외처리문;
        WHEN 예외명 THEN 예외처리문;
        ...
        WHEN OTHERS THEN 예외처리문;
    
    [참고]
    OTHERS : 어떤 예외든 발생한것을 모두 받는다.(맨아래 위치)
    
    ORACLE 에서 미리 정의한 EXCEPTION(예외) => 시스템 예외
*/
-- 사용자에게서 값을 입력을 받아 100을 나눈 결과값을 출력하시오
-- 사용자가 0을 입력하면 오류가 발생하므로 예외처리 진행
DECLARE
    NUM NUMBER;
    DATA_VALUE NUMBER;
    CONST_DATA CONSTANT NUMBER := 100;
BEGIN
    NUM := '&NUM';
    DATA_VALUE := CONST_DATA / NUM;
    DBMS_OUTPUT.PUT_LINE(CONST_DATA ||' / '|| NUM || ' = '|| DATA_VALUE);
    
EXCEPTION
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌수없습니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('OTHER 0 으로 나눌수 없습니다.');
    
END;
/

-- 유일키를 위배하는 예외처리를 진행한다
-- EMPLOYEE 에서 EMP_ID에 중복(201) 하도록 사용자에게 입력받아서 UPDATE 처리

DECLARE
    NUM NUMBER;
BEGIN
    UPDATE EMPLOYEE SET EMP_ID = '&USER_iD' WHERE EMP_NAME = '선동일';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('중복된 사본입니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('OTHERS 중복된 사본입니다.');
END;
/
--=========================================================================
/*
    - 미리 정의되지 않는 예외처리값을 확인하기
    - ORA-00001: 무결성 제약 조건(C##KH.EMPLOYEE_PK)에 위배됩니다
    - -00001 사용자가 정의해서 예외처리 진행
 
    [구조]
    사용자정의 예외명 EXCEPTION;
    PRAGMA EXCEPTION_INIT(사용자 정의 예외명, 에러 코드번호)
    ex) PRAGMA EXCEPTION_INIT -00001 ORA-00001;
*/
DECLARE
    NUM NUMBER;
    DUP_EMP_NO EXCEPTION;
    PRAGMA EXCEPTION_INIT (DUP_EMP_NO, -00001);
BEGIN
    UPDATE EMPLOYEE SET EMP_ID = '&USER_ID' WHERE EMP_NAME = '선동일';
EXCEPTION
    WHEN DUP_EMP_NO THEN DBMS_OUTPUT.PUT_LINE('중복된 사본입니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('OTHERS 중복된 사본입니다.');
END;
/


/*
    [수업내용 정리]
    
    1.
    PL/SQL
     : SQL의 단점을 보완하여 SQL문장 내에서 변수의 정의, 조건처리, 반복처리 등 지원
     
    [구조]
    DECLARE -> 선언
        변수, 상수 선언
    BEGIN   -> 실행
        제어문, 반복문, 함수 정의 등 로직 기술
    EXCEPTION -> 예외처리부
        예외사항 발생시 해결하기 위한 문장 기술
    
    [EX]    
    SET SERVEROUTPUT ON;
     => 프로시저를 사용하여 출력하는 내용을 화면에 보여주도록 설정.
    BEGIN
        DBMS_OUTPUT.PUT_LINE('문자열'||컬럼명);
     => JAVA 에서 System.out.println("문자열",변수명); 과 같음
    EDN;
    /
    
    2.
    타입 변수 선언
    
    
    
*/

















