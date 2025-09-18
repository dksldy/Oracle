-- KH2 계정 생성 비밀번호 BY 1234;
CREATE USER C##KH2 IDENTIFIED BY 1234;

-- GRANT CREATE ... TO ... 권한 부여하기 (접속, 테이블생성, 뷰 생성, 시퀀스 생성)
GRANT CREATE SESSION TO C##KH2;
GRANT CREATE TABLE TO C##KH2;
GRANT CREATE VIEW TO C##KH2;
GRANT CREATE SEQUENCE TO C##KH2;

-- 부여된 권한 조회
SELECT * FROM dba_sys_privs WHERE grantee = 'C##KH2';
--=======================================================================
-- REVOKE REATE ... FROM ... 권한 회수하기
REVOKE CREATE SESSION FROM C##KH2;
REVOKE CREATE TABLE FROM C##KH2;
REVOKE CREATE VIEW FROM C##KH2;
REVOKE CREATE SEQUENCE FROM C##KH2;

-- 회수한 권한 조회
SELECT * FROM dba_sys_privs WHERE grantee = 'C##KH2';
--=======================================================================
-- 생성된 계정 삭제
DROP USER C##KH2;