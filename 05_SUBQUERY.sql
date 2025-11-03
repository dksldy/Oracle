/*
    * 서브쿼리(SUBQUERY)
     : 하나의 쿼리문 내에서 괄호()로 감싸져 사용되는 또 다른 쿼리문
       메인 쿼리문의 조건이나 결과를 위해 먼저 실행되어 값을 제공(보조 역할)
*/
-- * "노옹철" 사원과 같은 부서에 속한 사원 정보를 조회

-- [1] "노옹철" 사원의 부서코드를 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- [2] 부서코드가 D9인 사원들의 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- * [1],[2] 쿼리문을 하나로 합쳐보자
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철'
                    );

--==================================================

-- * 전체 사원의 평균급여보다 더 많은 급여를 받는 사원의 정보를 조회
-- [1] 전체 사원의 평균 굽여 조회
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

-- [2] 평균 급여보다 많이 받는 사원의 정보 조회
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3047663;

-- > [1],[2] 합체
SELECT *
FROM EMPLOYEE
WHERE SALARY >= (
                SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEE
                );
--=========================================================================
/*
    * 서브쿼리의 종류 *
     : 서브쿼리를 수행한 결과의 행과 열 수에 따라 분류
     
    - 단일행 서브쿼리 : 서브쿼리의 수행 결과가 오로지 1개일 때 (1행 1열)
    - 다중행 서브쿼리 : 서브쿼리의 수행 결과가 여러 행 일때 (N행 1열)
    - 다중열 서브쿼리 : 서브쿼리의 수행 결과가 한 행이고, 여러개의 컬럼일때 (1행 N열)
    - 다중행 다중열 서브쿼리 : 서브쿼리의 수행 결과가 여러 행이고, 여러 칼럼 일때 (N행 N열)
    
    >> 종류에 따라 서브쿼리 앞에 사용되는 연산자가 달라질수 있다.
*/
-- 단일행 서브쿼리 : 서브쿼리 결과가 오로지 1개
/*
    비교연산자 사용 : = != > < >= <= ..
*/
-- * 전 직원의 평균 급여보다 더 적게(미만) 급여를 받는 사원의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (
                SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEE
                );

-- * 최저 급여를 받는 사원의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (
                SELECT MIN(SALARY)
                FROM EMPLOYEE
                );

-- * 노옹철 사원의 급여보다 많이 받는 사원의 사원명, 부서코드, 급여 정보 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (
                SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철'
                );

-- * 부서코드를 부서명으로 조회                
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND
    SALARY > (
                SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철'
                );

-- ** ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY > (
                SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철'
                );

-- * 부서별 급여 합이 가장 큰 부서의 부서코드, 급여합 을 조회
-- [1] 부서별 급여합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- [2] 부서별 급여 합 중 가장 큰 값(급여합)
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- [3] 부서별 급여 합이 가장 큰 부서의 부서코드, 급여 합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
                        SELECT MAX(SUM(SALARY))
                        FROM EMPLOYEE
                        GROUP BY DEPT_CODE
                        );

-- * 전지연 사원과 같은 부서의 사원들의 사번, 사원명, 연락처, 입사일, 부서명 조회
-- 단, 조회결과에서 전지연 사원의 정보는 제외
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

-- * 부서코드가 'D1' 이고 사원명은 '전지연' 이 아닌 사원들의 정보 조회
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND
        DEPT_CODE = 'D1' AND
        EMP_NAME != '전지연';
        
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND
        DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '전지연') 
        AND EMP_NAME != '전지연';

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '전지연')
    AND EMP_NAME != '전지연';
--===================================================================================
/*
    * 다중행 서브쿼리 : 서브쿼리의 결과가 여러 행인 경우 (N행 1열)
    
    IN(서브쿼리)    : 여러개의 결과값 중에서 하나라도 일치하는 값이 있다면 결과로 표시
      * 비교대상 = 결과값1 OR 비교대상2 = 결과값2 OR ...
    
    > ANY(서브쿼리) : 여러개의 결과값 중에서 하나라도 크면 결과로 표시
    < ANY(서브쿼리) : 여러개의 결과값 중에서 하나라도 작으면 결과로 표시
      * 비교대상 > 결과값1 OR 비교대상 > 결과값2 OR ...
                <                   <
    
    > ALL(서브쿼리) : 모든 결과값 보다 크면 결과로 표시
    < ALL(서브쿼리) : 모든 결과값 보다 작으면 결과로 표시
        * 비교대상 > 결과값1 AND 비교대상 > 결과값2 AND ...
                  <                    <
*/
-- * 유재식 사원 또는 윤은해 사원과 같은 직급인 사원들의 정보 조회(사번, 사원명, 직급코드, 급여)
-- [1] 유재식 사원 또는 윤은해 사원의 직급코드 조회
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('유재식','윤은해');

-- [2] 직급 코드가 'J3' OR 'J7' 인 사원들의 정보 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN('J3','J7');

-- * 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ( SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN ('유재식','윤은해'));

-- 대리 직급인 사원들 중 과장 직급인 사원의 최소 급여보다 많이 받는 사원의 정보 조회 (사번, 이름, 직급명, 급여)
-- [1] 과장 직급인 사원들의 급여 조회
SELECT SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';
/*
3760000
2200000
2500000
*/
-- [2] ANY 연산자를 사용하여 비교
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY(3760000, 2200000, 25000000);
    
-- * 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY(SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');

--=========================================================================
/*
    * 다중열 서브쿼리 : 서브쿼리의 수행 결과가 한 행이고, 여러 개의 컬럼(열)인 경우
    
    (컬럼1, 컬럼2,...) = (서브쿼리)
*/
-- * 하이유 사원과 같은 부서, 같은 직급에 해당하는 사원 정보 조회

-- [1] 하이유 사원의 부서코드, 직급코드 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';

SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '하이유';

SELECT JOB_CODE FROM EMPLOYEE WHERE EMP_NAME = '하이유';

-- * 단일행 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '하이유')
        AND JOB_CODE =(SELECT JOB_CODE FROM EMPLOYEE WHERE EMP_NAME = '하이유');

-- * 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE EMP_NAME = '하이유')
        AND EMP_NAME != '하이유';

-- * 박나라 사원과 같은 직급이고, 같은 사수를 가지고 있는 사원의 정보를 조회(사원명, 직급코드, 사수번호)
-- [1] 박나라 사원의 직급코드, 사수번호 조회
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라';

-- [2] 해당 직급코드, 사수번호인 사원들의 정보 조회
SELECT EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE,MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID 
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '박나라')
    AND EMP_NAME != '박나라';

--===========================================================================
/*
    * 다중행 다중열 서브쿼리 : 서브쿼리의 결과가 여러행, 여러 열 인경우
*/
-- * 각 직급별 최소 급여를 받는 사원 정보를 조회

-- [1] 각 직급별 최소 급여
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;
/*
J1	8000000
J2	3700000
J4	1550000
J3	3400000
J7	1380000
J5	2200000
J6	2000000
*/
-- [2] 각 직급별 최소 급여를 받는 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J1' AND SALARY = 8000000
    OR JOB_CODE = 'J2' AND SALARY = 3700000;
    --OR ...
    
-- * 서브쿼리 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE);

-- * 직급별 최고 급여를 받는 사원 정보 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE);

--================================================================================
/*
    * 인라인 뷰 : 서브쿼리를 FROM절에 작성하여 마치 테이블처럼 사용
                (서브쿼리의 결과를 임시 테이블처럼 활용)
*/
-- * 사원들의 사번, 이름, 보너스 포함 연봉, 부서코드 를 조회
-- => 보너스 포함 연봉이 3000만원 이상인 사원들만 조회
-- => 보너스 포함 연봉 내림차순 정렬
SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 "보너스 포함 연봉", DEPT_CODE
FROM EMPLOYEE
WHERE (SALARY + SALARY*NVL(BONUS,0))*12 >= 30000000
ORDER BY 3 DESC;

-- => TOP-N분석 : 상위 N개를 조회
-- * ROWNUM : 조회된 행에 대하여 순서대로 1부터 순번을 부여해주는 가상 컬럼
SELECT ROWNUM, EMP_ID, EMP_NAME, "보너스 포함 연봉", "부서코드"
FROM (SELECT EMP_ID, EMP_NAME, (SALARY+SALARY*NVL(BONUS,0))*12 "보너스 포함 연봉", DEPT_CODE "부서코드"
    FROM EMPLOYEE
    WHERE (SALARY + SALARY*NVL(BONUS,0))*12 >= 30000000
    ORDER BY 3 DESC)
WHERE ROWNUM <= 5;

-- * 가장 최근에 입사한 사원 5명을 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;

SELECT ROWNUM, EMP_ID, EMP_NAME, HIRE_DATE
FROM(SELECT EMP_ID, EMP_NAME, HIRE_DATE
     FROM EMPLOYEE
     ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;
--=============================================================================
/*
  * 순서를 매기는 함수 (WINDOW FUNCTION)
  
  - RANK()OVER(정렬기준)        : 동일한 순위 이후의 등수를 동일한 순위의 개수만큼 건너뛰고 순위를 계산
  - DENSE_RANK()OVER(정렬기준)  : 동일한 순위가 있더라도 그 다음 등수는 +1 해서 순위 계산
  
  => SELECT 절에서만 사용 가능
*/
-- * 급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY,
        RANK()OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY,
        DENSE_RANK()OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;

--> 5위 까지만 조회(상위 5명)
SELECT EMP_NAME, SALARY,
        RANK()OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;
-- WHERE 순위 <= 5; -> WHERE절에서는 별칭 사용불가.

SELECT *
FROM (SELECT EMP_NAME, SALARY,
        RANK()OVER(ORDER BY SALARY DESC) "순위"
        FROM EMPLOYEE)
WHERE 순위 <= 5;

-- 3위 ~ 5위 조회
SELECT *
FROM (SELECT EMP_NAME, SALARY,
        RANK()OVER(ORDER BY SALARY DESC) "순위"
        FROM EMPLOYEE)
WHERE 순위 BETWEEN 3 AND 5;
--=======================================================================
-- [1] ROWNUM 을 활용하여 급여가 가장 높은 5명을 조회하려고 했으나, 제대로 조회가되지 않았다.
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

-- 문제점 : 정렬이 되기 전에 5명이 추려짐
--         WHERE 절에 ROWNUM <= 5 가 먼저 실행되고, ORDER BY 내림차순 을 실행하여
--         내림차순 전 급여 조회 결과에 ROWNUM이 새겨져 있는 상태로 내림차순되어 결과값이 이상해짐
-- 해결   : 
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT ROWNUM, EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

-- [2] 부서별 평균 급여가 270만원을 초과하는 부서에 해당하는 부서코드, 
--              부서별 총 급여합, 부서별 평균급여, 부서별 사원수를 조회
-- 제대로 조회되지 않았다.
SELECT DEPT_CODE, SUM(SALARY) "총합", FLOOR(AVG(SALARY)) "평균급여", COUNT(*) "사원수"
FROM EMPLOYEE
WHERE SALARY > 2700000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;

-- 문제점 : 
-- 해결   : 
SELECT DEPT_CODE, SUM(SALARY) "총합" , 
        FLOOR(AVG(SALARY)) "평균급여", 
        COUNT(*) "사원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) > 2700000
ORDER BY DEPT_CODE ASC;



SELECT DEPT_CODE, SUM(salary) "총합",
        FLOOR(AVG(salary)) "평균급여",
                    COUNT(*) "사원수"
FROM EMPLOYEE
WHERE DEPT_CODE 
IN (
SELECT DEPT_CODE 
FROM (
SELECT DEPT_CODE, FLOOR(AVG(salary)) AS "AVG_SAL"
FROM EMPLOYEE 
GROUP BY DEPT_CODE ) A
WHERE AVG_SAL >=2700000 )
GROUP BY DEPT_CODE;




