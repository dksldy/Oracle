/*
    * GROUP BY절
        : 그룹 기준을 제시할수 있는 구문
        : 여러 개의 값들을 하나의 그룹으로 묶어서 조회하기 위한 목적으로 사용
*/
-- * 전체사원의 급여 총합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- * 부서별 급여 총 합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- * 부서별 사원 수 조회
SELECT DEPT_CODE,COUNT(*) "사원수"   -- 3
FROM EMPLOYEE                       -- 1
GROUP BY DEPT_CODE;                 -- 2

-- * 부서코드가 'D6','D9','D1' 인 각 부서별 급여 총합, 사원수 조회
SELECT DEPT_CODE, SUM(SALARY) "급여총합" , COUNT(*) "사원 수"     -- 4
FROM EMPLOYEE                                                   -- 1
WHERE DEPT_CODE  IN ('D6','D9','D1')                            -- 2
GROUP BY DEPT_CODE                                              -- 3
ORDER BY DEPT_CODE;                                             -- 5

-- * 각 직급별 총 사원수, 보너스를 받는 사원수, 급여 총합, 평균급여, 최저급여, 최고급여 조회
-- (직급코드 오름차순 정렬)
SELECT JOB_CODE, COUNT(*) "총사원수", COUNT(BONUS) "보너스를 받는 사원수", 
       SUM(SALARY) "급여총합",
       FLOOR(AVG(SALARY)) "평균급여", MIN(SALARY) "최저급여", MAX(SALARY) "최고급여"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- * 남자 사원수, 여자 사원수 조회
SELECT DECODE(SUBSTR(EMP_NO,8,1), 1, '남', 2, '여') "성별" , COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

-- * 부서 내 직급별로 사원수, 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, COUNT(*) "사원 수", SUM(SALARY) "급여 총합"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

--========================================================================
/*
    * HAVING 절
     : 그룹에 대한 조건을 제시할때 사용하는 구문
      (보통 그룹함수식을 가지고 조건을 작성하게 된다)
*/
-- 각 부서별 평균 급여 조회(반올림 ROUND)
SELECT DEPT_CODE, ROUND(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 평균 급여가 300만원 이상인 부서만 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY)) "평균급여"
FROM EMPLOYEE
WHERE SALARY >= 3000000         -- 사원의 급여가 300만원 이상인 데이터만 조회
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, ROUND(AVG(SALARY)) "평균급여"
FROM EMPLOYEE
-- WHERE SALARY >= 3000000         -- 사원의 급여가 300만원 이상인 데이터만 조회
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

-- * 직급 별 직급코드, 총 급여합 조회(직급별 급여합이 1000만원 이상인 직급만 조회)
SELECT JOB_CODE, SUM(SALARY)"총급여"
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- * 부서 별 보너스를 받는 사원이 없는 부서의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

SELECT BONUS FROM EMPLOYEE WHERE DEPT_CODE = 'D2';
--> 'D2' 부서에 사원들의 BONUS가 NULL 인걸 확인해본 명령문

SELECT DEPT_CODE        -- 4
FROM EMPLOYEE           -- 1
WHERE BONUS IS NULL     -- 2
GROUP BY DEPT_CODE;     -- 3

SELECT BONUS, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE IN ('D9', 'D6');
-- > 잘못됨

--=======================================================================
/*
    * ROLLUP, CUBE : 그룹 별 산출 결과 값의 집계 계산 함수
    
    - ROLLUP : 전달받은 그룹 중 가장 먼저 지정한 그룹 별로 추가적 집계 결과 반환
    - CUBE : 전달받은 그룹들로 가능한 모든 조합 별로 집계 결과 반환
*/
-- * 각 부서 내 직급 별 급여 합, 부서별 급여 합, 전체 직원 급여 총 합 조회
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)"급여 총합"
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- * 부서별 급여합, 직급별 급여 합, 부서내 지급 급여 총합, 전체 직원 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)"급여 총합"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;
--=========================================================================
/*
    * SELECT문 ( -- 실행순서)
    
    SELECT * | 컬럼명 AS "별칭" | 함수식 | 연산식                            -- 5
    FROM 테이블명 | DUAL                                                   -- 1
    WHERE 조건식(연산자들을 활용하여 작성)                                    -- 2
    GROUP BY 그룹화기준이 되는 컬럼 | 함수식                                  -- 3
    HAVING 조건식 (그룹함수를 활용하여 작성)                                  -- 4 
    ORDER BY 컬럼 | 별칭 | 컬럼순번 [ASC | DESC] [NULLS FIRST | NULLS LAST] -- 6

    * 오라클에서는 순서(위치) 1부터 시작!
*/
--==========================================================================
/*
    * 집합연산자 : 여러 개의 쿼리문을 하나의 쿼리문으로 만들어주는 연산자
    
    - UNION : 합집합 (두 쿼리문을 수행한 결과값을 더해줌) -> OR 와 유사
    - INTERSECT : 교집합 (두 쿼리문을 수행한 결과값의 중복되는 부분을 추출해줌) -> AND 와 유사
    - UNION ALL : 합집합 + 교집합 (중복되는 부분이 2번 조회될수 있음)
    - MINUS : 차집합 (선행 결과값에 후행 결과값을 뺀 나머지)
*/
-- ** UNION **
-- 부서코드가 'D5' 인 사원 또는 급여가 300만원 초과인 사원들의 정보를 조회
--           (사번, 사원명, 부서코드, 급여)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

-- * 부서코드가 D5인 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- * 급여가 300만원 초과인 사원 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNION 사용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- ** INTERSECT **
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- ** UNION ALL **
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'  -- 6
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8

-- ** MINUS **
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

/*
    * 집합연산자 사용시 주의사항
    
    1) 쿼리문들의 컬럼개수가 동일해야 함
    2) 컬럼 자리마다 동일한 타입으로 작성해줘야함 (문자,숫자,...)
    3) 정렬하고자 한다면 ORDER BY 절은 마지막에 작성해야함
*/

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
-- ORDER BY EMP_ID; => 오류 발생
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_ID;