/*
    [테이블 생성과 삭제]
    - 테이블 삭제
    DROP TABLE 테이블명[CASCADE CONSTRAINT]; 
                        => 참조하고 있는 제약 조건까지 같이 삭제
    - 테이블 생성
    CREATE TABLE 테이블(
    컬럼 데이터_타입 [DEFAULT 값] [컬럼레벨 제약조건], ...
    [테이블 레벨 제약 조건], ...
    );
    
    [테이블 생성규칙]
    - 문자로 시작한다
    - 30자 이내로 한다
    - 영문, 숫자, _, $, #, 을 사용한다(한글 사용은 가능하지만 되도록 사용안함)
    - 테이블의 이름은 동일한 유저(스키마) 안에서 유일해야한다
            => MYSQL의 데이터베이스 = ORACLE의 유저(스키마)
    - 예약어 사용불가
    - 대소문자 구별 X (모든 이름은 대문자로 정의)
    
    [데이터 타입]
    - VARCHAR(n) : 가변길이 문자 타입 (1 < n < 4000 byte)
     => CHAR 가 있지만 장점이 없어 VARCHAR2 를 사용한다 
        (CHAR = 고정길이, VARCHAR2 = 가변길이)
     => VARCHAR // VARCHAR2 = 같은 데이터타입, 가변성 차이
     
    - NUMBER(n, p) : 숫자타입, n은 전체 자리수이고, p는 소수점 이하 자리수
     => NULL에 주의한다 (연산결과 오용될 가능성 있음)
     => 전체 자리수를 초과할 경우 입력 거부
     => 소수점 이하 자리수가 초과되면 반올림되어 입력된다
     
    -DATE : 날짜 타입, 출력이나 입력 형식과 무관하게 
            YYYY/MM/DD :HH24:MI:SS 형태로 저장된다.

    [테이블 생성 관련 명령어]
    SELECT * FROM TAB
    SELECT TABLE_NAME FROM USER_TABLEDS;
    - 스키마에 테이블 목록을 검색한다
    - 스키마는 유저와 동일하게 쓰인다
    
    DESC 테이블;
    SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH
    FROM USER_TAB_COLUMNS
    [WHERE TABLE_NAME = '테이블'];
    - 테이블의 컬럼 구성을 확인한다
*/
--========================================================================
/*
    [테이블 생성과 확인]
    - 테이블명 : BOARD(게시판)
    - 구성 컬럼 : NO(게시물번호), NAME(작성자), SUB(제목), 
                 CONTENT(내용), HDATE(입력일시)
*/    
    DROP TABLE BOARD;
    -- 테이블 생성             
    CREATE TABLE BOARD(
    NO NUMBER,
    NAME VARCHAR2(20),
    SUB VARCHAR2(100),
    CONTECNT VARCHAR2(4000),
    HDATE DATE DEFAULT SYSDATE
    );
    
    -- 테이블 확인
    -- 전체 테이블 확인
    SELECT * FROM TAB; 
    
    -- BOARD 테이블 확인
    SELECT TABLE_NAME FROM USER_TABLES
    WHERE TABLE_NAME = 'BOARD';
    
    -- 테이블 내 유형 확인
    DESC BOARD;
    
    -- BOARD 에 대한 테이블명, 컬럼명, 데이터타입, 데이터길이 값 조회
    SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'BOARD';
    
    -- 생성된 테이블에 행을 입력하고 DEFAULT 입력을 확인
    INSERT INTO BOARD(NO) VALUES(1);
    COMMIT; 
    -- => DDL의 경우 커밋이 필요하지 않지만, DML의 경우에는 수동커밋이 필요
    SELECT * FROM BOARD;
    /*
        COMMIT : 트랜잭션 확정 문
         - 변경후 COMMIT; 을 하지 않을경우 다른 사용자에게 보이지 않는다
         - 세션이 종료되면, 변경내용이 사라질수 있다(ROLLBACK)
        
        COMMIT이 필요한 경우
         - DML(INSERT, UPDATE, DELETE, MERGE) 명령은 수동 커밋 필요
          ex) INSER INTO TEST VALUES (1, 'hello');
              UPDATE TEST SET NAME = 'World';
              DELETE FROM TEST WHERE id = 1;
              COMMIT;
    */
--===========================================================================
    -- 날짜 타입 컬럼 검색
    DROP TABLE HD;
    CREATE TABLE HD(
    NO NUMBER,
    HDATE DATE
    );
    
    INSERT INTO HD VALUES(1, SYSDATE);
    SELECT * FROM HD;
    SELECT * FROM HD WHERE HDATE = '2021/10/02';
    SELECT NO, TO_CHAR(HDATE,'YYYY/MM/DD:HH24:MI:SS') FROM HD;
    SELECT * FROM HD WHERE HDATE BETWEEN '2021/10/02' AND
                                        '2021/10/03';
    COMMIT;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
