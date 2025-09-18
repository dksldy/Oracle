/*
    USER 생성
    [표현법]
    CREATE C##계정명 IDENTIFIED BY 비밀번호;
    ex) CREATE KH IDENTIFIED BY 1234;
*/
-- * KH2 USER 생성
CREATE USER KH2 IDENTIFIED BY C##KH2;

--===================================================================
/*
    DCL(Data Control Language)
     : 데이터 제어 언어로 계정에 시스템 권한/객체 접근 권한을 
        부여(GRANT)하거나 회수(REVOKE)하는 구문을 말함
*/
--===================================================================
/*        
    GRANT : 사용자 계정에 권한을 부여
    [표현법]
    GRANT 권한 TO 계정명;
    
    * 시스템 권한 종류
     - CREATE SESSION : 접속권한
     - CREATE TABLE : 테이블 생성 권한
     - CREATE VIEW : 뷰 생성 권한
     - CREATE SEQUENCE : 시퀀스 생성권한
     ...
        
    * 객체 접근권한 부여
    [표현법]
    GRANT 권한 ON 특정객체 TO 계정명;
    
    * 객체 접근권한 종류
     - 조회권한(SELECT) : TABLE, VIEW, SEQUENCE
     - 추가권한(INSERT) : TABLE, VIEW
     - 수정권한(UPDATE) : TABLE, VIEW
     - 삭제권한(DELETE) : TABLE, VIEW   
*/
-- 접속권한 
GRANT CREATE SESSION TO KH2;
-- 테이블 생성권한
GRANT CREATE TABLE TO KH2;
-- 뷰 생성 권한
GRANT CREATE VIEW TO KH2;
-- 시퀀스 생성권한
GRANT CREATE SEQUENCE TO KH2;
-- KH2 계정에 KH계정의 EMPLOYEE 테이블에 대한 조회권한 부여 
GRANT SELECT ON KH.EMPLOYEE TO KH2;
--=============================================================================
/*
    REVOKE : 사용자 계정에 권한을 회수
    
    [표현법]
     REVOKE 회수할권한 FROM 계정명;
        
        REVOKE CREATE SESSION FROM 사용자명;
        REVOKE SELECT ON HR.EMPLOYEES FROM 사용자명;
        REVOKE CONNECT FROM 사용자명;
        REVOKE CREATE SESSION, CREATE TABLE, CREATE VIEW FROM 사용자명;
*/
-- KH2 접속 권한 회수
REVOKE CREATE SESSION FROM KH2;

-- KH2 계정에 KH.EMPLOYEE 테이블에 대한 조회권한 회수
REVOKE SELECT ON KH.EMPLOYEE FROM KH2;

-- 1. 시스템 권한 조회
-- SELECT * FROM dba_sys_privs WHERE grantee = '사용자명';
SELECT * FROM dba_sys_privs WHERE grantee = 'KH2';

-- 사용자 속한 롤 권한조회
--SELECT * FROM dba_role_privs WHERE grantee = '사용자명';

-- 사용자에 객체 권한 조회
--SELECT * FROM dba_tab_privs WHERE grantee = '사용자명';