/*
    트리거(TRIGGER)
     : 테이블이나 뷰가 INSERT, UPDATE, DELETE 등의 DML 문에 의해 데이터값이 변경될경우
       자동으로 실행될 내용을 정의하여 저장하는 객체
       
    - 변경시점 : BEFORE, AFTER
    - BEFORE TRIGGER : 지정한 테이블에서 이벤트가 발생하기전 트리거 실행(UPDATE, DELETE)
    - AFTER TRIGGER : 지정한 테이블에서 이벤트가 발생된 후 트리거 실행(UPDATE, INSERT)
    - 관점 : BEFORE || AFTER 정하는 기준 (데이터 변경 : 추가, 삭제, 수정)
    
    *예) 
        - DELETE : 회원 탈퇴후 고객테이블에서 회원정보가 삭제가 진행이된다(고객정보 데이터가 사라진다)
                => 다른 테이블에 삭제된 고객의 정보를 INSERT 저장한다.
        - 회원인데 입력하는데 문제점(특정값을 넘었을때)을 가져오는 회원이 있으면, 
          일정한 횟수를 정해놓고 그 횟수가 넘으면 블랙리스트로 처리
        - 입고, 출고 : 상품이 입고되었을때 상품 재고량의 입고 내용을 추가하고,
          상품이 출고 되었다면, 상품 재고량의 출고내용을 빼줘야한다.
          
    - 이벤트가 발생이 되었을때 각 행의 영향을 받는지, 한번만 영향을 받는지 생각한다.
     1) 문장 트리거 : 이벤트가 발생한 SQL 문에 대해 딱 한번만 트리거 실행
     2) 행 트리거 : 이벤트가 발생한 SQL문에 SQL문이 실행 될때마다 매번 트리거실행.
                                                     => (FOR EACH ROW 옵션 설정이 필요함)
    
    - AFTER, BEFORE 발생할때 트리거안에서 사용해야할 명령어
     1) OLD (BEFORE) : BEFORE UPDATE(수정하기전에 자료), BEFORE DELETE(삭제하기 전 자료)
     2) NEW (AFTER) : AFTER UPDATE(수정후 자료), AFTER INSERT(데이터 삽입 후 자료)
     
    [구조]
     CREATE [OR REPLACE] TRIGGER 트리거명
     BEFROE | AFTER INSERT | DELETE | UPDATE ON 테이블명
     [FOR EACH ROW]
     [DECLARE]
     BEGIN
     [EXCEPTION]
     END;
     /
     
*/
-- AFTER TRIGGER(INSERT)
-- 트리거 발생 : 데이터가 입력될때마다 로그정보를 출력하는 트리거 생성하기
-- INSERT, AFTER(:NEW), EMPLOYEE, FOR EACH ROW
CREATE OR REPLACE TRIGGER TRG_INSERT_EMPLOYEE
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
   DBMS_OUTPUT.PUT_LINE(:NEW.EMP_NAME||'신입사원이 입사 했습니다.');
END;
/

SELECT * FROM EMPLOYEE;
 INSERT INTO EMPLOYEE VALUES (905, '길성춘', '690512-1151432', 'gil_sj@kh.or.kr', 
        '01035464455', 'D5', 'J3', 30000000, 0.1, 200, SYSDATE, NULL, DEFAULT);

ROLLBACK;
--===================================================================================
/*
    1) 재고 테이블과 제약조건과 시퀀스 기능 부여
    2) (입고,출고)테이블에 제약조건과 시퀀스 기능 부여
    3) 재고 테이블에 데이터를 입력한다.
    4) (입고,출고)테이블에 갤럭시 노트 8 5개를 입고 진행
        => 재고테이블 1. '갤럭시 노트8'에 재고량이 15로 수정이 되어야한다(TRIGGER 사용하기)
*/

-- 재고 테이블
DROP TABLE PRODUCT;
CREATE TABLE PRODUCT(
    PCODE NUMBER, -- PK(PRIMARY KEY)
    PNAME VARCHAR2(30) NOT NULL,
    BRAND VARCHAR2(30) NOT NULL,
    PRICE NUMBER DEFAULT 0,
    STOCK NUMBER DEFAULT 0,
    CONSTRAINT PK_PRODUCT_PCODE PRIMARY KEY(PCODE)
);
-- 시퀀스 생성 SEQ_PCODE, 초기값:1,증가치:1,NOCACHE
DROP SEQUENCE SEQ_PCODE;
CREATE SEQUENCE SEQ_PCODE
START WITH 1
INCREMENT BY 1
NOCACHE;

SELECT * FROM PRODUCT;
SELECT * FROM USER_SEQUENCES;

-- 재고 테이블에 데이터 입력
INSERT INTO PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '갤러시노트8', '삼성', 900000,10);
INSERT INTO PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '아이폰17PRO_MAX', '애플', 2000000,10);
INSERT INTO PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '샤오미2', '샤오미', 100000,10);
COMMIT;

-- 입고, 출고 테이블
DROP TABLE PRO_DETAIL;
CREATE TABLE PRO_DETAIL(
    PCODE NUMBER,
    DCODE NUMBER,
    PDATE DATE DEFAULT SYSDATE,
    AMOUNT NUMBER DEFAULT 0,
    STATUS VARCHAR2(10) CHECK (STATUS IN('입고','출고')),
    CONSTRAINT PK_PRO_DETAIL_DCODE PRIMARY KEY(DCODE),
    CONSTRAINT FK_PRO_DETAIL_PCODE FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE)
);
-- 시퀀스 생성 SEQ_DCODE, 초기값:1,증가치:1,NOCACHE
DROP SEQUENCE SEQ_DCODE;
CREATE SEQUENCE SEQ_DCODE
START WITH 1
INCREMENT BY 1
NOCACHE;

SELECT * FROM PRO_DETAIL;
SELECT * FROM USER_SEQUENCES;

-- 갤럭시 노트 8 5개 입고하기
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1,SYSDATE, 5, '입고');
UPDATE PRODUCT SET STOCK = STOCK + 5 WHERE PCODE = 1; 
-- (단일 방법)

--입고, 출고 테이블에 입고 되거나, 출고 진행이 되면, 재고테이블에 재고량에 수량이 더하거나, 빼거나 진행이
-- 자동으로 되어야한다.
-- PRO_DETAIL 테이블에서 입고,출고(INSERT) 수량 입력, 시점(AFTER:NEW), FOR EACH ROW
-- 처리할 내용 1 : 수량이 입고가 되면 (PRODUCT)재고랑 테이블에 재고량에서 수량 더해주기
-- 처리할 내용 2 : 수량이 출고가 되면 (PRODUCT)재고랑 테이블에 재고량에서 수량 더해주기

DROP TRIGGER TRG_DETAIL_PRODUCT_INSERT;
CREATE OR REPLACE TRIGGER TRG_DETAIL_PRODUCT_INSERT
AFTER INSERT ON PRO_DETAIL
FOR EACH ROW
BEGIN
    IF :NEW.STATUS = '입고' THEN
        UPDATE PRODUCT SET STOCK = STOCK + :NEW.AMOUNT WHERE PCODE = :NEW.PCODE; 
    END IF;
    
    IF :NEW.STATUS = '출고' THEN
        UPDATE PRODUCT SET STOCK = STOCK - :NEW.AMOUNT WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

-- 입고,출고 해보기
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 5, '입고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 3, '출고');

INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 5, '입고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 2, SYSDATE, 3, '출고');

INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 5, '입고');
INSERT INTO PRO_DETAIL VALUES(SEQ_DCODE.NEXTVAL, 3, SYSDATE, 3, '출고');

COMMIT;
SELECT * FROM PRO_DETAIL;
SELECT * FROM PRODUCT;
ROLLBACK;

SELECT MAX(DCODE) AS MAX_DC FROM PRO_DETAIL;
SELECT SEQ_DCODE.CURRVAL FROM DUAL;  -- 세션에서 NEXTVAL 이 한 번이라도 호출되었어야 CURRVAL 가능
SELECT SEQ_DCODE.NEXTVAL FROM DUAL;
DESCRIBE PRO_DETAIL;

/*
    [과제 1]
    
    - 회원테이블(번호, 이름, 전화번호, 이메일, 혈액형) 설계
        (NEW_MEMBER), 시퀀스 설정(초기값100, 증가치5, 캐쉬2)
    
    - 데이터 5명입력
    
    - 트리거 발생(TRG_MEMBER)DELETE) 회원이 탈퇴하면 회원정보를(BACK_MEMBER)테이블에 저장기능 설계
    
    - BACK_MEMBER 테이블에 시퀀스 등록할수 있도록 설계
        => 삭제한 회원의 날짜도 BACK_MEMBER에 기록되어야 한다.
*/


CREATE TABLE PRODUCT(
    PCODE NUMBER, -- PK
    PNAME VARCHAR2(30) NOT NULL,
    BRAND VARCHAR2(30) NOT NULL,
    PRICE NUMBER DEFAULT 0,
    STOCK NUMBER DEFAULT 0,
    CONSTRAINT PK_PRODUCT_PCODE PRIMARY KEY(PCODE)
);

CREATE SEQUENCE SEQ_PCODE
  START WITH 1
  INCREMENT BY 1
  NOCACHE;

INSERT INTO PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '갤러시노트8', '삼성', 900000, 10);
INSERT INTO PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '아이폰17PRO_MAX', '애플', 2000000, 10);
INSERT INTO PRODUCT VALUES (SEQ_PCODE.NEXTVAL, '샤오미2', '샤오미', 100000, 10);

-- PRO_DETAIL 테이블 및 시퀀스

CREATE TABLE PRO_DETAIL(
    PCODE NUMBER,
    DCODE NUMBER,
    PDATE DATE DEFAULT SYSDATE,
    AMOUNT NUMBER DEFAULT 0,
    STATUS VARCHAR2(10) CHECK (STATUS IN ('입고','출고')),
    CONSTRAINT PK_PRO_DETAIL_DCODE PRIMARY KEY(DCODE),
    CONSTRAINT FK_PRO_DETAIL_PCODE FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE)
);

CREATE SEQUENCE SEQ_DCODE
  START WITH 1
  INCREMENT BY 1
  NOCACHE;

-- 트리거 (공백 제거 등 문법 정리)

CREATE OR REPLACE TRIGGER TRG_DETAIL_PRODUCT_INSERT
AFTER INSERT ON PRO_DETAIL
FOR EACH ROW
BEGIN
    IF :NEW.STATUS = '입고' THEN
        UPDATE PRODUCT
          SET STOCK = STOCK + :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    ELSIF :NEW.STATUS = '출고' THEN
        UPDATE PRODUCT
          SET STOCK = STOCK - :NEW.AMOUNT
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;


INSERT INTO PRO_DETAIL (DCODE, PCODE, PDATE, AMOUNT, STATUS)
VALUES (SEQ_DCODE.NEXTVAL, 1, SYSDATE, 5, '입고');

-- 출고 예시
INSERT INTO PRO_DETAIL (DCODE, PCODE, PDATE, AMOUNT, STATUS)
VALUES (SEQ_DCODE.NEXTVAL, 1, SYSDATE, 3, '출고');


















