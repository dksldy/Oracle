-- ** KH_연습문제 **
-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME 사원명, SUBSTR(EMP_NO,1, 2) 생년, 
                        SUBSTR(EMP_NO,3, 2) 생월,
                        SUBSTR(EMP_NO,5, 2) 생일
FROM EMPLOYEE;

-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME 사원명, RPAD(SUBSTR(EMP_NO,1,7),14,'*') "EMP_NO"
FROM EMPLOYEE;

-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--     (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME, FLOOR(ABS(HIRE_DATE - SYSDATE)) "근무일수1", FLOOR(SYSDATE - HIRE_DATE) "근무일수2"
-- SELECT EMP_NAME 사원명, ABS(FLOOR(MONTHS_BETWEEN(HIRE_DATE, SYSDATE))) 근무일수1, 
--                            ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) 근무일수2
FROM EMPLOYEE;

-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(TO_NUMBER(EMP_ID), 2) = 1;
-- WHERE MOD(EMP_ID,2) != 0;
-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE ROUND(CEIL( MONTHS_BETWEEN(SYSDATE, HIRE_DATE))/12) >= 20;
-- WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >= 20;

-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME, TO_CHAR(SALARY,'L9,999,999') "SALARY"
FROM EMPLOYEE;

-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이(만) 조회
--     (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--          나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
-- SELECT EMP_NAME, TO_DATE(SUBSTR(EMP_NO,1,6),'YYMMDD')
SELECT EMP_NAME  직원명, DEPT_CODE 부서코드, SUBSTR(EMP_NO,1,2)||'년'||
                                            SUBSTR(EMP_NO,3,2)||'월'||
                                            SUBSTR(EMP_NO,5,2)||'일' AS "생년월일",
                                            TO_CHAR(SYSDATE,'YYYY') - 
                                            TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'),'YYYY') "나이(만)"
FROM EMPLOYEE;

-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부, D6면 기획부, D9면 영업부로 처리
--    (단, 부서코드 오름차순으로 정렬)
SELECT EMP_ID, EMP_NAME, DEPT_CODE,
                CASE DEPT_CODE
                    WHEN 'D5' THEN '총무부'
                    WHEN 'D6' THEN '기획부'
                    WHEN 'D9' THEN '영업부'
                END "부서명",
        DECODE(DEPT_CODE, 'D5', '총무부', 'D6', '기획부', 'D9', '영업부') "부서명"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY DEPT_CODE;

-- 9. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--     주민번호 앞자리와 뒷자리의 합 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,1,6) "주민번호 앞자리", SUBSTR(EMP_NO,8) "주민번호 뒷자리",
        SUBSTR(EMP_NO,1,6) + SUBSTR(EMP_NO,8) "주민번호 앞,뒤 의 합"
FROM EMPLOYEE
WHERE EMP_ID = '201';

-- 10. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT SUM((SALARY+(SALARY*NVL(BONUS,0)))*12) "D5 부서 연봉합"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 11. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      |  전체 직원 수 | 2001년 | 2002년 | 2003년 | 2004년  |
SELECT COUNT(*) "전체 직원수", 
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),2001, 1)) "2001년 입사인원수",
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),2002, 1)) "2002년 입사인원수",
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),2003, 1)) "2003년 입사인원수",
    COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE),2004, 1)) "2004년 입사인원수"
FROM EMPLOYEE;















