/*
    TCL
    : 트랜잭션을 제어하는 언어로 데이터의 변경사항들을 적용(커밋)하거나 취소(롤백) 하는것
    
    - 트랜잭션은 데이터베이스의 논리적 연산단위로 
            데이터의 변경사항들을 하나의 묶음으로 트랜잭션에 모아서 관리
    - DML문을 수행할때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리하고
        트랜잭션이 존재하지 않으면 트랜잭션을 만들어서 관리함
    
    트랜잭션의 종류
     - COMMIT : 데이터 변경사항들을 실제 데이터베이스에 적용구문
     - ROLLBACK : 데이터 변경사항들을 취소하는 구문 => 이전 COMMIT 시점으로 돌아감
     - SAVEPOINT 포인트명; :
        현재시점에 대하여 임시 저장구문 => ROLLBACK을 사용하여 돌아올수 있음
*/

/*
    COMMIT / ROLLBACK
    
    INSERT 1 -> DELETE 2 -> UPDATE 3 -> DELETE 4 -> INSERT 5
    - DELETE 2 시점 COMMIT / INSERT 5 시점 COMMIT
     => INSERT 5 시점에서 마지막 COMMIT이 나왔기 때문에 실제 데이터베이스에는
        INSERT 5 시점까지 적용되어있음
        
    - DELETE 2 시점 COMMIT / INSERT 5 시점 ROLLBACK
     => INSERT 5 시점에 ROLLBACK 적용하게되면 실제 데이터베이스에는
        DELETE 2 시점까지 적용되어있음
*/
-- 현시점에서 COMMIT진행 (트랜잭션 종료 및 새로운 시작점)
COMMIT;
-- TABLE 생성 서브쿼리 이용
DROP TABLE DEPT02;
CREATE TABLE DEPT02
AS 
SELECT * FROM DEPARTMENT;

-- DEPT02 새로운 데이터 입력
INSERT INTO DEPT02 VALUES('D0','전략기획부', 'L5');

-- DELETE FROM DEPT02 WHERE DEPT_ID = 'D0';
SELECT * FROM DEPT02;
ROLLBACK;

--=========================================================================
-- SAVEPOINT 확인
-- COMMIT과 COMMIT 사이에서 일정단락부분이 완료가 되면 SAVEPOINT C1, 
-- 다음 일정단락부분이 완료가 되면 SAVEPOINT C2 로 정한다.

-- DEPT02테이블에 INSERT 1 후 SAVEPOINT C1 지정 
INSERT INTO DEPT02 VALUES('C1','세이브1','C1');
SAVEPOINT C1;

-- DEPT02 테이블에 INSERT 2 후 SAVEPOINT C2 지정
INSERT INTO DEPT02 VALUES('C2','세이브2','C2');
SAVEPOINT C2;

-- DEPT02 테이블에 INSERT 3 후 SAVEPOINT C3 지정
INSERT INTO DEPT02 VALUES('C3','세이브3','C3');
SAVEPOINT C3;

-- SAVEPOINT C1 으로 ROLLBACK 후 데이터 확인
ROLLBACK TO C1;
SELECT * FROM DEPT02;

-- SAVEPOINT C1 전으로 ROLLBACK
ROLLBACK;

--===============================================================================
-- SAVEPOINT C1, C2 지정 후 COMMIT사용 ROLLBACK C1 이용해보기 

-- 현시점에서 COMMIT진행 (트랜잭션 종료 및 새로운 시작점)
COMMIT;
-- TABLE 생성 서브쿼리 이용
DROP TABLE DEPT03;
CREATE TABLE DEPT03
AS 
SELECT * FROM DEPARTMENT;

-- DEPT03테이블에 INSERT 1 후 SAVEPOINT C1 지정 
INSERT INTO DEPT03 VALUES('C1','세이브1','C1');
SAVEPOINT C1;

-- DEPT03 테이블에 INSERT 2 후 SAVEPOINT C2 지정 후 COMMIT
INSERT INTO DEPT03 VALUES('C2','세이브2','C2');
SAVEPOINT C2;
COMMIT;

-- DEPT03 테이블에 INSERT 3 후 SAVEPOINT C3 지정
INSERT INTO DEPT03 VALUES('C3','세이브3','C3');
SAVEPOINT C3;

-- SAVEPOINT C1 으로 ROLLBACK
ROLLBACK TO C1;
-- ** ORA-01086: 'C1' 저장점이 이 세션에 설정되지 않았거나 부적합합니다.
-- => SAVEPOINT C2 시점에 COMMIT을 사용 C1 으로 ROLLLBACK 불가
SELECT * FROM DEPT03;
-- SAVEPOINT 전으로 ROLLBACK
ROLLBACK;
-- => C2 COMMIT 시점으로 롤백됨