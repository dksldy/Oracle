/*
    * JOIN
     : 두 개 이상의 테이블을 "연결(결합)"하여 하나의 가상 테이블처럼 조회하는 구문
     
    * 관계형 데이터베이스(RDB)에서는 최소한의 데이터를 각각의 테이블에 저장
        --> 중복 저장을 최소화하기 위해 최대한 쪼개서 관리함
        
    => JOIN은 크게 "오라클 전용 구문" 과 "ANSI 구문" (미국 국제표준협회)
            오라클 전용 구문               |            ANSI 구문
    --------------------------------------------------------------------------
            등가 종인                     |            내부조인
        (EQUAL JOIN)                    |      (INNER JOIN) -> JOIN USING / ON
    --------------------------------------------------------------------------
            포괄 조인                     |        외부 조인
        (OUTER JOIN)                    |          LEFT / RIGHT / FULL OUTER JOIN
    ------------------------------------------------------------------------------
        자체조인(SELF JOTN)              |        동일한 테이블에 JOIN ON 사용
         비등가 조인(NON EQUAL JOIN)      |    JOIN ON + 비교연산자 (BETWEEN, >=, <, ...)
    -------------------------------------------------------------------------------
*/
-- * 전체 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

-- * 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- * 사번, 사원명, 부서명 조회
/*
    * 등가 조인(EQAUL JOIN) / 내부 조인(INNER JOIN)
    => 두 테이블의 연결 컬럼(조인 조건)이 같은 값인 행들만 결과에 포함
        즉, 조건에 일치하지 않는 행은 결과에서 제외됨
*/ 
-- * 오라클 전용 구문
/*
    * FROM 절에 조회하고자 하는 테이블 나열 (, 로 구분)
    *WHERE 절에 매칭시킬 컬럼에 대한 조건을 작성
*/
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
ORDER BY 2;
--> EMPLOYEE 테이블에서 부서코드(DEPT_CODE)가 NULL인 사원은 결과에서 제외됨.
--> DEPARTMENT 테이블에서 D3, D4, D7 부서코드에 해당하는 사원이 EMPLOYEE 테이블에 존재하지 않아 결과에서 제외됨.

-- * 사번, 사원명, 직급명 조회
SELECT JOB_CODE, JOB_NAME FROM JOB;

SELECT EMP_ID, EMP_NAME, JOB_CODE FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
--> 두 테이블의 컬럼명이 동일할 경우, 별칭 또는 테이블명을 명시하여 구분해주어야 한다.

-- * ANSI 구문
/*
    * FROM 절에 기준이 되는 테이블을 하나 작성
    * JOIN 절에 조인하고자 하는 테이블을 작성 + 매칭시키고자 하는 조건 작성
     - JOIN USING   : 컬럼명이 같은 경우
     - JOIN ON      : 컬럼명이 같거나 다른 경우
*/
-- * 사번, 사원명, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- * 사번, 사원명, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E
    JOIN JOB J ON E.JOB_CODE = J.JOB_CODE;
    
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE);

-------------------------------------------

-- * 대리 직급인 사원의 사번, 사원명, 직급명, 급여 조회
-- *오라클 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND
        JOB_NAME = '대리';
        
-- * ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
    JOIN JOB J USING (JOB_CODE)
WHERE JOB_NAME = '대리';
--=========================================================================
--------------------------- QUIZ --------------------------------------
-- [1] 인사관리부 부서의 사원들의 사번, 사원명, 보너스 조회
-- * 오라클 구문 * --
SELECT EMP_ID 사번, EMP_NAME 사원명, BONUS 보너스
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND
    DEPT_TITLE = '인사관리부';
-- * ANSI 구문 * --
SELECT EMP_ID 사번, EMP_NAME 사원명, BONUS 보너스
FROM EMPLOYEE E
    JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

-- [2] 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
-- * 오라클 구문 * --
SELECT DEPT_ID 부서코드, DEPT_TITLE 부서명, LOCAL_CODE 지역코드, LOCAL_NAME 지역명
FROM DEPARTMENT D, LOCATION L
WHERE LOCATION_ID = LOCAL_CODE;
-- * ANSI 구문 * --
SELECT DEPT_ID 부서코드, DEPT_TITLE 부서명, LOCAL_CODE 지역코드, LOCAL_NAME 지역명
FROM DEPARTMENT D
    JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);
    
-- [3] 보너스를 받는 사원의 사번, 사원명, 보너스, 부서명 조회
-- * 오라클 구문 * --
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND
     BONUS IS NOT NULL;
-- * ANSI 구문 * --
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E
    JOIN DEPARTMENT D ON
    (E.DEPT_CODE = D.DEPT_ID)
WHERE BONUS IS NOT NULL;

-- [4] 총무부가 아닌 사원들의 사원명, 급여 조회
-- * 오라클 구문 * --
SELECT EMP_NAME, SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND
    DEPT_TITLE != '총무부';
-- * ANSI 구문 * --
SELECT EMP_NAME, SALARY
FROM EMPLOYEE E
    JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE DEPT_TITLE != '총무부';
--==============================================================================
/*
    * 포괄 조인 / 외부 조인 (OUTER JOIN)
     : 두 테이블을 조인할 때, 조인 조건에 맞지 않는 행도 결과에 포함하는 구문
     
     - LEFT OUTER JOIN : 두 테이블 중 왼쪽에 작성된 테이블을 기준으로 조인
                        (왼쪽 테이블의 모든 행 + 조건에 맞는 오른쪽 테이블 행)
     - RIGHT OUTER JOIN : 두 테이블 중 오른쪽에 작성된 테이블을 기준으로 조인
                        (오른쪽 테이블의 모든행 + 조건에 맞는 왼쪽 테이블 행)
                        
     - FULL OUTER JOIN : 두 테이블이 가진 모든 행을 조회하는 구문 (오라클 전용구문X // ANSI 구문에서만 가능)
*/
-- * 모든 사원의 사원명, 부서명, 급여, 연봉 조회
-- * LEFT JOIN * --

-- ** 오라클 구문 ** --
-- => 기준이 되지 않는 테이블의 컬럼 옆에 (+) 기호를 붙여 표현
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 연봉
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+);

-- ** ANSI 구문 **--
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 연봉
FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID);
    
-- * RIGHT JOIN * --

-- ** 오라클 구문 ** --
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 연봉
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID
ORDER BY EMP_NAME;

-- ** ANSI 구문 **--
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 연봉
FROM EMPLOYEE E
    RIGHT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
ORDER BY EMP_NAME;

-- * FULL JOIN * --
-- ** 오라클 구문 **-- => 없음

-- ** ANSI 구문 ** --
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12 연봉
FROM EMPLOYEE E
    FULL JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
ORDER BY EMP_NAME;
--==========================================================================================
/*
    * 비등가 조인 (NON EQUAL JOIN)
     => 조인 조건에 '=' 대신 >, <, BETWEEN, LIKE 등의 비교 연산자를 사용하여 매칭하는 조인
      (주로, 범위 조건으로 매칭할 때 사용)
      
    * ANSI 구문에서는 USING ON만 사용 가능하다.
*/
-- * 사원에 대한 급여 등급 조회 (사원명, 급여, 급여등급)
-- * 사원(EMPLOYEE), 급여등급 (SAL_GRADE)
-- ** 오라클 구문 ** --
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
WHERE --SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
    SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- ** ANSI 구문 ** --
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE E
    JOIN SAL_GRADE S ON SALARY BETWEEN MIN_SAL AND MAX_SAL;
  --JOIN SAL_GRADE ON (SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
--=============================================================================================
/*
    * 자체조인(SELF JOIN)
     : 하나의 테이블을 마치 서로 다른 테이블처럼 별칭(A,B)을 주어 조인하는 구문
       테이블 내에서 자기 자신과 관계있는 데이터를 조회할때 사용
*/
-- * 전체 사원의 사번, 사원명, 부서코드
--                  사수사번, 사수 사원명, 사수 부서코드 조회

-- * 사원(EMPLOYEE), 사수(EMPLOYEE)
-- ** 오라클 구문 ** --
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- ** ANSI 구문 ** --
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
    JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;
    
-- * 사수가 없는 사원 정보도 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
    LEFT JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;
--=======================================================================
/*
    * 다중 조인 : 2개 이상의 테이블을 조인하는 것
*/
-- * 사번, 사원명, 부서명, 직급명 조회
-- 사원(EMPLOYEE), 부서(DEPARTMENT), 직급(JOB)

-- ** 오라클 구문 ** --
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE DEPT_CODE = DEPT_ID(+)    -- EMPLOYEE 테이블과 DEPARTMENT 테이블 조인 조건
    AND E.JOB_CODE = J.JOB_CODE;
    
-- ** ANSI ** --
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON
    (DEPT_CODE = DEPT_ID)
    JOIN JOB USING (JOB_CODE);

-- * 사번, 사원명, 부서명, 지역명 조회
-- 사원(EMPLOYEE), 부서(DEPARTMENT), 지역(LOCATION)

-- ** 오라클 구문 ** --
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID AND
        D.LOCATION_ID = L.LOCAL_CODE;

-- ** ANSI ** --
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN LOCATION L ON L.LOCAL_CODE = D.LOCATION_ID;
--> ANSI 구문 에서는 JOIN 시 순서에 유의 해야한다.

--=========================================================================
------------------------ QUIZ --------------------------------------
-- [1] 사번, 사원명, 부서명, 지역명, 국가명 조회
-- ** 오라클 **
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID AND               -- E = D JOIN
        D.LOCATION_ID = L.LOCAL_CODE AND
        L.NATIONAL_CODE = N.NATIONAL_CODE;
-- ** ANSI **
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
    JOIN DEPARTMENT  ON DEPT_CODE = DEPT_ID
    JOIN LOCATION  ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE);

-- [2] 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회
-- ** 오라클 **
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, L.LOCAL_NAME, N.NATIONAL_NAME, S.SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID AND
    E.JOB_CODE = J.JOB_CODE AND
    D.LOCATION_ID = L.LOCAL_CODE AND
    L.NATIONAL_CODE = N.NATIONAL_CODE AND
    E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL
ORDER BY E.EMP_ID;

-- ** ANSI **
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, L.LOCAL_NAME, N.NATIONAL_NAME, S.SAL_LEVEL
FROM EMPLOYEE E
    JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    JOIN JOB J USING (JOB_CODE)
    JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
    JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL)
ORDER BY E.EMP_ID;