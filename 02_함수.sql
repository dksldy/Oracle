/*
    * 함수(FUNCTION)
        : 전달된 컬럼값을 실행한 결과를 반환
        
    - 단일 행 함수 : N개의 값을 읽어서 N개로 결과값을 반환 (행마다 함수의 실행한 결과를 반환)
    - 그룹 함수 : N개의 값을 읽어서 1개 결과값을 반환 (그룹을 지어 그룹별로 함수의 결과를 반환)
    
    => SELECT절에 단일행 함수와 그룹 함수를 함께 사용할수 없음
    
    => 함수식을 사용할수 있는 위치 : SELECT절, WHERE절, ORDER BY절, GROUP BY절, HAVING절
*/
--=========================== 단일행 함수 ========================================
/*
    * 문자타입의 데이터 처리 함수
    => VARCHAR2(n), CHAR(n)
    
    *LENGTH(컬럼명 또는 '문자열') : 문자열의 길이를 반환(글자수)
    *LENGTHB(컬럼명 또는 '문자열') : 문자열의 바이트수를 반환
    
    => 영문자, 숫자, 특수문자 글자당 1byte
        한글은 글자당 3byte
*/
-- '오라클' 단어의 글자수와 바이트수를 확인 -> | 3 | 9 |
SELECT LENGTH('오라클') 글자수, LENGTHB('오라클') 바이트수
FROM DUAL;

--'오라클' 단어의 글자수와 바이트수 확인 -> | 6 | 6 |
SELECT LENGTH('ORACLE') 글자수, LENGTHB('ORACLE') 바이트수
FROM DUAL;


-- 사원 정보 중 사원명, 사원명(글자수), 사원명(바이트수),
--          이메일, 이메일(글자수), 이메일(바이트수) 조회
SELECT EMP_NAME 사원명, LENGTH(EMP_NAME) "사원명(글자수)", 
        LENGTHB(EMP_NAME) "사원명(바이트수)",
        EMAIL 이메일, LENGTH(EMAIL) "이메일(글자수)",
        LENGTHB(EMAIL) "이메일(바이트수)"
FROM EMPLOYEE;
--==============================================================================
/*
    * INSTR : 문자열로부터 특정 문자의 시작위치를 반환
    
    - INSTR(컬럼 또는 '문자열', '찾고자하는 문자', [찾을 위치의 시작값, 순번])
    => 결과는 숫자타입
*/
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 앞쪽에 있는 첫번째 B의 위치 : 3
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL; -- 찾을 위치의 시작값의 기본값 : 1
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL; -- 시작값을 음수로 지정시 뒤에서 부터 찾음
SELECT INSTR('AABAACAABBAA', 'B',1,2) FROM DUAL; -- 앞에서부터 두번째로 찾은 위치 : 9

-- 사원 정보 중 이메일에 _ 의 첫번째 위치, @의 첫번째 위치 조회
SELECT EMAIL, INSTR(EMAIL, '_',1)"_위치", INSTR(EMAIL,'@')"@위치"
FROM EMPLOYEE;
--==============================================================================
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출해서 반환
    
    - SUBSTR('문자열' 또는 컬럼, 시작위치, [길이])
    => 길이를 지정하지 않으면 문자열 끝까지 추출한다.
*/
SELECT SUBSTR('ORACLE SQL DEVELOPER', 10) FROM DUAL;
-- SQL 부분만 추출
SELECT SUBSTR('ORACLE SQL DEVELOPER', 8, 3) FROM DUAL;

SELECT SUBSTR('ORACLE SQL DEVELOPER', -3) FROM DUAL;

-- * 사원들의 이름, 주민번호 조회
SELECT EMP_NAME, EMP_NO FROM EMPLOYEE;

-- 사원들 중 여사원들만 조회
SELECT EMP_NAME, EMP_NO FROM EMPLOYEE
-- WHERE SUBSTR(EMP_NO,8,1) = '2' OR SUBSTR(EMP_NO,8,1) = '4'
WHERE SUBSTR(EMP_NO,8,1) IN ('2','4');

-- 남사원들 조회
SELECT EMP_NAME, EMP_NO FROM EMPLOYEE
-- WHERE SUBSTR(EMP_NO,8,1) = '2' OR SUBSTR(EMP_NO,8,1) = '4'
WHERE SUBSTR(EMP_NO,8,1) IN ('1','3')
ORDER BY EMP_NAME;      -- 가나다 순으로 정렬

-- * 함수는 중첩해서 사용가능
-- 사원 정보 중 사원명, 이메일, 아이디(이메일에서 @ 앞 까지의 값) 조회
-- [1] 이메일 에서 '@'의 위치 찾기 => INSTR함수 사용
-- [2] 이메일 값에서 1번째 위치부터 '@' 위치 전까지 추출 => SUBSTR 함수 사용
SELECT EMP_NAME 사원명, EMAIL 이메일,INSTR(EMAIL,'@') "메일 @위치",
        SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) 아이디
FROM EMPLOYEE;

SELECT EMP_NAME 사원명, SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) 아이디 
FROM EMPLOYEE;

--==============================================================================
/*
    * LPAD / RPAD : 문자열을 조회할때 통일감있게 조회하고자 할때 사용
                    문자열에 덧 붙이하고자 하는 문자를 왼쪽 또는 오른쪽에 붙혀,
                    최종길이만큼 문자열 반환
                    
    - LPAD('문자열' 또는 컬럼, 최종길이,[덧붙힐문자]) -> 왼쪽에 덧붙힐 문자를 채움
    - RPAD('문자열' 또는 컬럼, 최종길이, [덧붙힐문자]) -> 오른쪽에 덧붙힐 문자를 채움
    => 덧붙힐 문자 생략 시 기본값으로 공백으로 채움
*/
-- 사원 정보 중 사원명을 왼쪽에 공백으로 채워서 조회(길이 20)
SELECT EMP_NAME, LPAD(EMP_NAME,20) "이름2"
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMP_NAME,20) "이름2"
FROM EMPLOYEE;

-- 사원명, 이메일 조회(이메일을 오른쪽 정렬 -> 왼쪽에 공백채우기, 길이 20)
SELECT EMP_NAME, LPAD(EMAIL, 20) EMAIL
FROM EMPLOYEE;

-- 이메일 '#' 으로 왼쪽을 채워보기
SELECT EMP_NAME, LPAD(EMAIL, 20, '#') EMAIL
FROM EMPLOYEE;

-- 주민번호 뒷자리 다른값으로 표시
SELECT RPAD('000202-1', 14, '*')FROM DUAL;

-- 사원들의 정보 중 사원명, 주민번호 조회('XXXXXX-X******' 형식)
-- [1] 주민번호에서 8자리 추출
-- [2] 나머지 오른쪽은 '*'로 채우기
-- SELECT EMP_NAME, SUBSTR(EMP_NO,1,8) || '******'
SELECT EMP_NAME 사원명, RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호
FROM EMPLOYEE;
--==============================================================================
/*
    * LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 후 나머지를 반환
    
    - LTRIM('문자열' 또는 컬럼, [제거하고자 하는 문자들]) -> 왼쪽에서 제거
    - RTRIM('문자열' 또는 컬럼, [제거하고자 하는 문자들]) -> 오른쪽에서 제거
    => 제거할 문자들을 생략했을경우 공백을 제거해준다.
*/
SELECT LTRIM('      H I') FROM DUAL; 
--> 왼쪽부터 공백이 아닌 문자가 있는 위치까지 공백 모두 제거

SELECT RTRIM('      H I    ') FROM DUAL; 
--> 오른쪽부터 공백이 아닌 문자가 있는 위치까지 공백모두 제거

SELECT LTRIM('123123H123', '312') FROM DUAL;
--> 제거하고자 하는 "문자들" 이기 때문에 '123' 과 '312' 는 동일

SELECT RTRIM('123123H123', '123') FROM DUAL;

/*
    * TRIM : 문자열 앞/뒤/양쪽에 있는 지정한 문자들을 제거한후 나머지 값을 반환
    
    -TRIM([LEADING 또는 TRAILING 또는 BOTH] [제거할 문자 FROM]'문자열' 또는 컬럼)
    => 제거할 문자 생략 시 공백 제거
    => 위치 옵션 생략 시 양쪽제거
*/

SELECT TRIM('      H I    ') "값" FROM DUAL;
--> 기본값 => 양쪽 공백 제거(BOTH)
SELECT TRIM('L' FROM 'LLLLLLHLLLLL') FROM DUAL;
--> 'LLLHLLL'에 양쪽에서 'L' 제거
SELECT TRIM(LEADING 'L' FROM 'LLLLLLHLLLLL') FROM DUAL;
--> LTRIM과 유사 왼쪽에서부터 'L' 제거
SELECT TRIM(TRAILING 'L' FROM 'LLLLLLHLLLLL') FROM DUAL;
--> RTRIM과 유사 오른쪽에서부터 'L' 제거
SELECT TRIM(BOTH 'L' FROM 'LLLLLLHLLLLL') FROM DUAL;
--> BOTH 양쪽 에서부터 제거
--==============================================================================
/*
    * LOWER / UPPER / INITCAP
    
    - LOWER('문자열' 또는 컬럼) : 알파벳을 모두 소문자로 변환
    - UPPER('문자열' 또는 컬럼) : 알파벳을 모두 대문자로 변환
    - INITCAP('문자열' 또는 컬럼) : 띄어쓰기 기준 첫 글자마다 대문자로 변경하여 반환 
*/
-- No pain NO gain
SELECT LOWER ('No pain NO gain') 소문자 FROM DUAL;
SELECT UPPER ('No pain NO gain') 대문자 FROM DUAL;
SELECT INITCAP ('No pain NO gain') "단어의 첫글자만 대문자" FROM DUAL;
--==============================================================================
/*
    * CONCAT : 문자열 두개를 하나의 문자열로 합쳐서 반환
    
    CONCAT('문자열1', '컬럼')
*/
-- 'KH','D 강의장' 문자 두개를 합쳐서 조회
SELECT 'KH' || ' D 강의장' FROM DUAL;
SELECT CONCAT('KH',' D 강의장') FROM DUAL;

-- 사원 번호와 사원명을 사용하여 조회 (조회형식 : {사원번호}{사원명}님)
SELECT CONCAT(EMP_ID, CONCAT(EMP_NAME, '님')) FROM EMPLOYEE;
--==============================================================================
/*
    * REPLACE : 문자열에서 특정 부분을 다른 부분으로 교체하여 반환
    
    - REPLACE('문자열' 또는 컬럼, 찾을문자열, 변경할문자열)
*/
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') FROM DUAL;

SELECT * FROM EMPLOYEE;

-- 사원 정보중 이메일의 '@kh.or.kr' 부분을 '@gmail.com' 으로 변경하여 조회(이메일, 변경이메일)
SELECT EMAIL 이메일, REPLACE(EMAIL,'@kh.or.kr','@gmail.com') 변경이메일
FROM EMPLOYEE;
--==============================================================================
/*
    [ 숫자 타입의 데이터 처리 함수]
*/
/*
    *ABS : 숫자의 절대값을 구해주는 함수
*/
SELECT ABS(-10) "-10의 절대값" FROM DUAL;

SELECT ABS(-7.7) "-7.7의 절대값" FROM DUAL;
--==============================================================================
/*
    * MOD : 두 수를 나눈 나머지 값을 구해주는 함수
    
    - MOD(숫자1, 숫자2) --> 숫자1 % 숫자2
*/
SELECT MOD(10,3) FROM DUAL;

SELECT MOD(10.9,3) FROM DUAL;
--==============================================================================
/*
    * ROUND : 반올림한 결과를 구해주는 함수
    
    ROUND(숫자, [위치])     위치 : 소수점 N번째 자리
    => 반올림 위치 생략시 첫째자리에서 반올림
*/
SELECT ROUND(123.456) FROM DUAL; -- 결과 123
SELECT ROUND (123.456,1) FROM DUAL; -- 123.5
SELECT ROUND (123.456,2) FROM DUAL; -- 123.46

SELECT ROUND(123.456,-1) FROM DUAL; -- 120 1의 자리에서 반올림
SELECT ROUND(123.456,-2) FROM DUAL; -- 100
--==============================================================================
/*
    * CEIL : 올림처리 한 결과를 구해주는 함수
    
    - CEIL(숫자)
*/
SELECT CEIL(123.456) FROM DUAL;

/*
    * FLOOR : 버림처리 한 결과를 구해주는 함수
    
    - FLOOR(숫자)
*/
SELECT FLOOR(123.456) FROM DUAL;
/*
    * TRUNC : 버림처리 한 결과를 구해주는 함수 (위치지정기능)
    
    - TRUNC(숫자,[위치])
*/
SELECT TRUNC(123.456) FROM DUAL;    -- 123
SELECT TRUNC(123.456,1) FROM DUAL;  -- 123.4
SELECT TRUNC(123.456,-1) FROM DUAL; -- 120
--==============================================================================
/*
    [날짜 타입의 데이터 처리 함수]
*/
-- SYSDATE : 현재 날짜 및 시간 (시스템기준)
SELECT SYSDATE FROM DUAL;

/*
    * MONTHS_BETWEEN : 두 날짜의 개월수를 반환
    
    - MONTHS_BETWEEN(날짜1, 날짜2)
     : 날짜1 - 날짜2 => 개월수 반환
*/
-- *사원의 근속 개월수 조회(사원명, 입사일, 근속개월수)
SELECT EMP_NAME 사원명, HIRE_DATE 입사일, 
        CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)),'개월차') 근속개월수
FROM EMPLOYEE;

-- *공부 시작한지 몇개월차?
SELECT CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE,'25/08/19')),'개월차') 공부
FROM DUAL;

-- * 수료까지 몇개월 남았는지
SELECT CONCAT(FLOOR(MONTHS_BETWEEN('26/02/17', SYSDATE)),'개월') 남음
FROM DUAL;
--==============================================================================
/*
    * ADD_MONTHS : 특정 날짜에 N개월 수를 더해서 반환
    
    - ADD_MONTHS(날짜, 더할 개월수)
*/
-- * 현재날짜 기준 3개월 후 조회
SELECT ADD_MONTHS(SYSDATE,3) FROM DUAL;

-- * 사원정보 입사일, 입사일 + 3개월"수습종료일"
SELECT EMP_NAME 사원명, HIRE_DATE 입사일, ADD_MONTHS(HIRE_DATE,3) "수습 종료일"
FROM EMPLOYEE;
--==============================================================================
/*
    * NEXT_DAY : 특정 날짜 이후로 지정한 요일의 가장 가까운 날짜 반환
    
    NEXT_DAY(날짜, 요일)
    => 요일의 경우 문자 또는 숫자
      1: 일, 2: 월, ..., 7: 토
*/
-- 현재 날짜 기준 가장 가까운 금요일의 날짜 조회
SELECT SYSDATE 오늘날짜, NEXT_DAY(SYSDATE, 6) 금요일 FROM DUAL;
-- 숫자는 언어 설정 상관없이 동작됨
SELECT SYSDATE 오늘날짜, NEXT_DAY(SYSDATE, '금요일') 금요일 FROM DUAL;
SELECT SYSDATE 오늘날짜, NEXT_DAY(SYSDATE, '금') 금요일 FROM DUAL;

-- 언어 설정 변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;  -- 미국어변경
ALTER SESSION SET NLS_LANGUAGE = KOREAN;    -- 한국어 변경

SELECT SYSDATE, NEXT_DAY(SYSDATE,'FRIDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,'FRI') FROM DUAL;
--==============================================================================
/*
    * LAST_DAY : 해당 월의 마지막 날짜를 구해주는 함수
    
    - LAST_DAY(날짜)
*/
-- 이번달의 마지막 날짜 조회
SELECT LAST_DAY(SYSDATE) "해당 월의 마지막날짜" FROM DUAL;

-- 사원명, 입사일, 입사한 달의 마지막 날짜, 입사한달의 근무일수 조회
SELECT EMP_NAME 사원명, HIRE_DATE 입사일, LAST_DAY(HIRE_DATE) "입사한달의 마지막날짜",
        LAST_DAY(HIRE_DATE) - HIRE_DATE + 1 "입사한달의 근무일수 조회"
FROM EMPLOYEE;
--==============================================================================
/*
    * EXTRACT : 특정 날짜로부터 년도/월/일 값을 추출해서 반환해주는 함수
    
    - EXTRACT(YEAR FROM 날짜)     : 년도 추출
    - EXTRACT(MONTH FROM 날짜)    : 월 추출
    - EXTRACT(DAY FROM 날짜)      : 일 추출
*/
-- * 현재 날짜 기준 년도, 월, 일 각각 추출
SELECT EXTRACT(YEAR FROM SYSDATE) 년도,
        EXTRACT(MONTH FROM SYSDATE) 월,
        EXTRACT(DAY FROM SYSDATE) 일
FROM DUAL;

-- 사원명, 입사년도, 입사월, 입사일 조회(입사년도>입사월>입사일 순으로 오름차순 정렬)
SELECT EMP_NAME 사원명,
        EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
        EXTRACT(MONTH FROM HIRE_DATE) 입사월,
        EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
-- ORDER BY EXTRACT(YEAR FROM HIRE_DATE),
--          EXTRACT(MONTH FROM HIRE_DATE),
--          EXTRACT(DAY FROM HIRE_DATE);
-- ORDER BY 입사년도, 입사월, 입사일;
ORDER BY 2, 3, 4;
--==============================================================================
/*
    * 형변환 함수 : 데이터 타입을 변환해주는 함수
                    - 문자 / 숫자 / 날짜
*/
/*
    * TO_CHAR : 숫자 또는 날짜 타입의 값을 문자 타입으로 변환해주는 함수
    
    - TO_CHAR(숫자 또는 날짜,[포맷])
*/
-- * 숫자 타입 -> 문자타입
SELECT 1234 "숫자타입의 데이터", TO_CHAR(1234) "문자로 변환한 데이터" FROM DUAL;

SELECT TO_CHAR(1234)"변환만 한 데이터", TO_CHAR(1234,'999999') FROM DUAL;
--> '9' : 개수만큼 자릿수를 확보
-- => 오른쪽 정렬, 빈칸은 공백으로 채움

SELECT TO_CHAR(1234)"변환만 한 데이터", TO_CHAR(1234,'000000') FROM DUAL;
--> '0' : 개수만큼 자리수를 확보. 빈칸은 0으로 채움.

SELECT TO_CHAR(1234,'L999999') FROM DUAL;
--> 'L' : 화폐 단위를 표시, 시스템에 설정된 언어(나라)에 따라 다르게 표시된다.

SELECT TO_CHAR(1234, '$999999') FROM DUAL;

SELECT TO_CHAR(10000000,'L9,999,999,999') FROM DUAL;

-- * 사원정보 중 사원명, 월급, 연봉을 조회(화폐단위 표시, 3자리씩 구분하여 표시)
SELECT EMP_NAME 사원명, LTRIM(CONCAT(TO_CHAR(SALARY,'L9,999,999,999'),'원')) 월급, 
        LTRIM(CONCAT(TO_CHAR(SALARY*12, 'L9,999,999,999'),'원')) 연봉
FROM EMPLOYEE;
--=======================================================================
-- 날짜 타입 -> 문자 타입
SELECT SYSDATE, TO_CHAR(SYSDATE) "날짜타입을 문자타입으로" FROM DUAL;

/*
    * HH : 시 정보 (HOUR) -> 12시간제
            => HH24 : 24시간제
            
    * MI : 분 정보 (MINUTE)
    * SS : 초 정보 (SECOND)
*/
SELECT TO_CHAR(SYSDATE,'HH:MI:SS') "시:분:초" FROM DUAL;
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') "시:분:초" FROM DUAL;

/*
    * YYYY : 년도 4글자로 표현
        YY : 년도 2글자로 표현
        
    * MM   : 월
    * DD   : 일
*/
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') "년-월-일 시:분:초" FROM DUAL;

/*
    * DAY : 요일정보 (X요일)
    * DY  : 요일정보 (X) -> '월', '화',...
*/
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS DAY DY') "년-월-일 시:분:초 요일" FROM DUAL;

/*
    * MONTH, MON : 월 정보(X월)
*/
SELECT TO_CHAR(SYSDATE,'MONTH MON') "월정보" FROM DUAL;

-- * 사원 정보 중 사원명, 입사날짜 조회(입사날짜"XXXX년 XX월 XX일" 형식으로 조회)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE,'YYYY"년" MM"월" DD"일"') "입사날짜"
FROM EMPLOYEE;
-- => 표시할 문자(글자)는 큰 따옴표("")로 묶어서 형식을 지정해야한다
--===================================================================================
/*
    * TO_DATE : 숫자 타입 또는 문자 타입을 날짜 타입으로 변환해주는 함수
    
    - TO_DATE(숫자 또는 문자,[포맷])
*/
SELECT TO_DATE(20250911) FROM DUAL;

SELECT TO_DATE(250911) FROM DUAL;   
--> 현재 50년 미만인 경우, 자동으로 50년 미만 데이터는 20XX로 변환
SELECT TO_DATE(950911) FROM DUAL;
--> 자동으로 50년 이상 데이터는 19XX로 변환

SELECT TO_DATE(020911) FROM DUAL;   
--> 숫자는 0부터 시작하면 안됨
SELECT TO_DATE('020911') FROM DUAL; 
--> 0부터 시작하는 경우 문자타입으로 제시

SELECT TO_DATE('250911 142700','YYMMDD HH24MISS') FROM DUAL;
--> 시간 정보가 포함된 데이터의 경우 형식을 지정해야함
--=========================================================================
/*
    * TO_NUMBER : 문자타입의 데이터를 숫자 타입으로 변환해주는 함수
    
    - TO_NUMBER(문자, [포맷])
        : 포맷 지정하는 경우는 ... 기호가 포함되거나 화폐단위가 포함된 경우...
*/
SELECT TO_NUMBER('0123456789') FROM DUAL;

SELECT '10000' + '500' FROM DUAL;
SELECT '10,000' + '500' FROM DUAL;  --> 수치 부적합

SELECT TO_NUMBER('10,000','99,999')+TO_NUMBER('500','999') FROM DUAL;
--=========================================================================
/*
    NULL 처리 함수
*/
/*
    * NVL : 해당 컬럼의 값이 NULL인 경우 다른 값으로 대체해주는 함수
    
    - NVL(컬럼, 해당 값이 NULL인 경우 사용할 값)
*/
-- * 사원 정보 중 사원명, 보너스 정보를 조회(보너스 값이 NULL 인 경우 0으로 조회)
SELECT EMP_NAME EMPNAME, NVL(BONUS,0) BONUS FROM EMPLOYEE;

-- * 사원명, 보너스 포함 연봉(SALARY +(SALARY*BONUS))*12 조회
-- SELECT EMP_NAME EMPNAME, NVL((SALARY +(SALARY*BONUS))*12, SALARY*12) 보너스포함연봉
SELECT EMP_NAME, (SALARY + (SALARY*NVL(BONUS,0)))*12 보너스포함연봉
FROM EMPLOYEE;

/*
    * NVL2 : 해당 컬럼이 NULL일 경우 표시할 값을 지정하고,
            NULL이 아닐 경우 표시할 값 지정할수 있는 함수
            
    - NVL2(컬럼, NULL이 아닐경우 표시할값, NULL일 경우 표시할 값)
*/
-- * 사원명, 보너스 유무(O/X) 조회
SELECT EMP_NAME, BONUS, NVL2(BONUS,'O','X') "보너스 유무"
FROM EMPLOYEE;

-- * 사원명, 부서코드, 부서배치여부('배정완료'/'미배정') 조회
SELECT EMP_NAME, DEPT_CODE, NVL2(DEPT_CODE,'배정완료','미배정')
FROM EMPLOYEE;

/*
    * NULLIF : 두 값이 일치하면 NULL, 일치하지 않으면 비교대상1 값을 반환
    
    - NULLIF(비교대상1, 비교대상2)
*/
SELECT NULLIF('999','999') FROM DUAL;   --- NULL
SELECT NULLIF('999','777') FROM DUAL;   --- 999
--============================================================================
/*
    * 선택함수 
    
    - DECODE(비교대상, 비교값1, 결과값1, 비교값2, 결과값2,...)
     + 비교대상 : 컬럼, 연산식, 함수식, ...
     
     - 자바에서 switch 와 유사하다
     switch(비교대상){
     case 비교값1:
            결과값1
     case 비교값2:
            결과값2
     break;
*/
-- * 사번, 사원명, 주민번호, 성별 조회
-- => 1:'남', 2:'여', 3:'남', 4:'여'
SELECT EMP_ID, EMP_NAME, EMP_NO,
        DECODE(SUBSTR(EMP_NO,8,1), 1, '남', 2, '여', 3, '남', 4, '여', '알수없음') 성별
FROM EMPLOYEE;

-- * 사원명, 기존급여, 인상될 급여 조회
/*
    직급이 J7인 사원은 10% 인상
    직급이 J6인 사원은 15% 인상
    직급이 J4인 사원은 20% 인상
    그 외에는 5%인상
*/
SELECT EMP_NAME, JOB_CODE, SALARY, 
    DECODE(DEPT_CODE, 'J7', SALARY*1.1, 
                      'J6', SALARY*1.15, 
                      'J5', SALARY*1.2, SALARY*1.05) "인상될 급여"
FROM EMPLOYEE
ORDER BY JOB_CODE;

/*
    * CASE WHEN THEN : 조건식에 따라 결과값을 반환해주는 함수
    
    [표현법]
            CASE 
                WHEN 조건식1 THEN 결과값1
                WHEN 조건식2 THEN 결과값2
                ...
                ELSE 결과값
            END
*/
-- * 사원명, 급여, 급여에 따른 등급 조회
/*
    급여가 500만원 이상 '고급'
          350만원 이상 '중급'
          그 외 '초급'
*/
SELECT EMP_NAME, SALARY,
        CASE
            WHEN SALARY >= 5000000 THEN '고급'
            WHEN SALARY >= 3500000 THEN '중급'
            ELSE '초급' 
        END "급여 등급"
FROM EMPLOYEE;
--=================================================================
------------------------ 그룹 함수 ---------------------------------
/*
    * SUM : 해당 컬럼 값들의 총 합을 구해주는 함수
    
    - SUM(숫자타입컬럼)
*/
-- * 전체 사원들의 총 급여를 조회
SELECT SUM(SALARY) "총 급여"
FROM EMPLOYEE;

-- * XXX,XXX,XXX 표시
SELECT TO_CHAR(SUM(SALARY),'L999,999,999') "총 급여"
FROM EMPLOYEE;

-- * 남자 사원들의 총 급여 조회
SELECT TO_CHAR(SUM(SALARY),'L999,999,999') "남자 사원들의총 급여"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN (1,3);

-- * 여자 사원들의 총 급여 조회
SELECT TO_CHAR(SUM(SALARY),'L999,999,999') "여자 사원들의총 급여"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN (2,4);

-- * 부서코드가 'D5'인 사원들의 총 연봉 조회
SELECT TO_CHAR(SUM(SALARY*12),'L999,999,999') "D5부서 총 연봉"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

/*
    * AVG : 해당 컬럼의 값들의 평균을 구해주는 함수
    
    - AVG(숫자타입컬럼)
*/
-- * 전체 사원들의 평균 급여 조회(반올림)
SELECT ROUND(AVG(SALARY))"평균급여"
FROM EMPLOYEE;

/*
    * MIN : 해당 컬럼의 값들 중 가장 작은 값 반환해주는 함수
    
    - MIN(모든타입컬럼)
*/
SELECT MIN(EMP_NAME) "문자타입 최소값", MIN(SALARY) "숫자타입 최소값",
        MIN(HIRE_DATE) "날짜타입 최소값"
FROM EMPLOYEE;

/*
    * MAX : 해당 컬럼의 값들 중 가장 큰 값 반환해주는 함수
    
    - MAX(모든타입컬럼)
*/
SELECT MAX(EMP_NAME) "문자타입 최대값", MAX(SALARY) "숫자타입 최대값",
        MAX(HIRE_DATE) "날짜타입 최대값"
FROM EMPLOYEE;

/*
    * COUNT : 행의 개수를 반환해주는 함수
            (단, 조건이 있을경우 해당 조건에 맞는 행의 개수를 반환)
            
    - COUNT(*) : 조회된 결과에 모든 행의 개수를 반환
    - COUNT(컬럼) : 해당 컬럼값이 NULL이 아닌 것만 세어 개수를 반환
    - COUNT(DISTINCT 컬럼) : 해당 컬럼값의 중복을 제거한 후 개수를 반환
                            => 중복 제거시 NULL은 포함하지않고 세어짐
*/
-- * 전체 사원수 조회
SELECT COUNT(*) "전체사원수"
FROM EMPLOYEE;

-- * 남자 사원 수
SELECT COUNT(*) "남자 사원수"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN (1,3);

-- * 보너스를 받는 사원수
SELECT COUNT(*) "보너스를 받는 사원수"
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

SELECT COUNT(BONUS) "보너스를 받는 사원수"
FROM EMPLOYEE;




















