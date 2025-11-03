-- 한 줄 주석
/*
    여러 줄 주석
*/

-- 현재 모든 계정 정보를 조회
SELECT * 
FROM DBA_USERS;
-- SELECT * FROM DBA_USERS; 한줄로도 가능

-- * 명령문 실행 : Ctrl + Enter 키보드 입력 또는 재생버튼 클릭

-- 일반 사용자 계정 생성 구문 => 관리자 계정으로만 생성 가능
-- [표현법] CREATE USER 계정명 IDENTIFIED BY 비밀번호;
-- * 12c 버전 이후로는 계정명 앞에 C## 을 붙여줘야함

-- KH / KH 계정생성
CREATE USER C##KH IDENTIFIED BY KH;

-- 생성된 계정에 권한 부여
-- [표현법] GRANT 권한1, 권한2, ... TO 계정명;

-- KH 계정에 최소한의 권한 부여 (접속, 데이터 관리)
GRANT CONNECT, RESOURCE TO C##KH;
-- * CONNECT : 연결권한
-- * RESOURCE : DATABASE 에서 객체(테이블, 시퀀스, 프로시져, ...) 생성권한

-- * 테이블 스페이스 설정
ALTER USER C##KH DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;