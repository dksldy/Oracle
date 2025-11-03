/*
    데이터 조회(추출) : SELCT
    
    SELECT 조회하고자 하는 정보 FROM 테이블명;
    
    SELECT * 또는 컬럼명1, 컬럼명2, ... FROM 테이블명;
*/
-- 모든 직원의 정보를 조회
SELECT * 
FROM EMPLOYEE;

-- 모든 직원의 이름, 주민번호, 연락처를 조회
SELECT EMP_NAME, EMP_NO, PHONE FROM EMPLOYEE;

-- 모든 직급 정보를 조회
SELECT * FROM JOB;

-- 모든 직급의 이름만 조회
SELECT JOB_NAME FROM JOB;

-- 모든 부서 정보를 조회
SELECT * FROM DEPARTMENT;

-- 모든 사원명, 이메일, 연락처, 입사일, 급여정보를 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY FROM EMPLOYEE;

-- =============================================================================

/*
    컬럼 값에 산술 연산하기
    => SELECT절에 컬럼명 작성 부분에 산술연산을 할수 있음.
*/
-- 사원명, 연봉 정보(급여 * 12) 조회
SELECT EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE;

-- 사원명, 급여정보, 보너스, 연봉, 보너스 포함 연봉 조회
-- * 보너스 포함 연봉 : (급여 + (급여 * 보너스))*12
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, (SALARY+(SALARY * BONUS))*12
FROM EMPLOYEE;
-- =============================================================================
/*
    - 현재 날짜 시간 정보 : SYSDATE
    - 임시 테이블(가상) : DUAL
*/
SELECT SYSDATE FROM DUAL;

-- 근무일수 조회(현재날짜 - 입사일 + 1)
-- 사원명, 입사일, 근무일수
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE + 1 FROM EMPLOYEE;
-- => 날짜데이터 - 날짜데이터 => 일수로 표시된다.

-- =============================================================================
/*
    * 컬럼명의 별칭 지정 : 연산식으로 조회했을 때 의미 파악이 어렵다.
                         별칭을 부여해서 명확하고 깔끔하게 조회 가능하다.
    * 방법 [1] 컬럼명 별칭
           [2] 컬럼명 AS 별칭
           [3] 컬럼명 "별칭"
           [4] 컬럼명 AS "별칭"           
*/
-- 사원명, 급여, 연봉 조회
SELECT EMP_NAME 직원이름 , SALARY " 급 여 ", SALARY*12 AS " 연 봉 " FROM EMPLOYEE;

-- 사원명, 급여, 보너스, 연봉, 보너스 포함 연봉 정보를 별칭을 부여하여 조회
SELECT EMP_NAME " 직원이름 ", SALARY " 급 여 ", BONUS " 보너스 ",
       SALARY*12 " 연봉 ", (SALARY + (SALARY*BONUS))*12 " 보너스 포함 연봉 "
FROM EMPLOYEE;

-- =============================================================================
/*
    * 리터럴 : 임의로 지정한 문자열(' ') 또는 숫자. 값 자체.
    => SELECT 절에 사용하는 경우 조회된 결과(Result Set)에 반복적으로 표시됨
*/
-- 사원명, 급여정보, '원' 단위 조회
SELECT EMP_NAME " 직원이름 ", SALARY " 급여 ", '원' " 단위 " FROM EMPLOYEE;

/*
    값 들을 연결하여 조회하고자 할때 => 연결 연산자 ||
*/
SELECT EMP_NAME, SALARY || '원' " 급여 " FROM EMPLOYEE;

-- 사번사원명급여 정보를 한번에 조회
SELECT EMP_ID || EMP_NAME || SALARY FROM EMPLOYEE;

-- "xxx의 급여는 xxxx원 입니다." 형식으로 조회
SELECT EMP_NAME || '의 급여는 ' || SALARY || '원 입니다.' FROM EMPLOYEE;

-- * 사원 테이블에서 직급코드만 조회
SELECT JOB_CODE FROM EMPLOYEE;

/*
    * 중복 제거 : DISTINCT
    => 중복된 결과값이 있을경우 중복을 제거하여 결과를 조회해준다.
*/
SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE FROM EMPLOYEE;
-- DISTINCT 는 한번만 사용가능하다.
SELECT DISTINCT JOB_CODE, DEPT_CODE FROM EMPLOYEE;
-- => (JOB_CODE, DEPT_CODE) 한 쌍으로 해서 중복을 제거해준다.

--==============================================================================

/*
    * WHERE 절 : 조회하고자 하는 데이터를 특정 조건에 따라 추출하여 조회할때 사용
    
    [표현법]
            SELECT 컬럼명, 연산식, ...
            FROM 테이블명
            WHERE 조건;
            
    - 비교연산자
        * 대소 비교 : > < >= <=
        * 동등 비교 
            - 같음 : =
            - 다름 : != <> ^=
*/
-- 사원 중 부서코드가 'D1' 인 사원들의 사원명, 급여, 부서코드를 조회
SELECT EMP_NAME, SALARY, DEPT_CODE FROM EMPLOYEE
-- WHERE SALRY = 200000 // SALRY 는 NUMBER DATA TYPE 이라 숫자만 입력
WHERE DEPT_CODE = 'D1'; -- DEPT_CODE 는 CHAR 문자형 데이터 타입 ' ' 등호 사용

-- 부서코드가 'D9' 인 사원들의 모든 정보를 조회
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- 부서코드가 'D9' 가 아닌 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D9';
-- WHERE DEPT_CODE <> 'D9';
WHERE DEPT_CODE ^= 'D9';

-- 급여가 400만원 이상인 사원의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- 연봉이 3000만원 이상인 사원의 사원명, 부서코드, 급여, 연봉 조회
SELECT EMP_NAME, DEPT_CODE, SALARY, SALARY*12 연봉 FROM EMPLOYEE
WHERE SALARY*12 >= 30000000;
--==============================================================================
--================================= 실습문제 ====================================
-- ** 연봉 계산시 보너스 제외 **
-- ** 별칭 적용 **
-- 1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
SELECT EMP_NAME " 사원명 ", SALARY " 급여 ", HIRE_DATE" 입사일 ",
        SALARY*12 " 연봉 " FROM EMPLOYEE
WHERE SALARY >= 3000000;
-- 2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
SELECT EMP_NAME " 사원명 ", SALARY " 급여 ", SALARY*12 " 연봉 ", 
    DEPT_CODE " 부서코드 " FROM EMPLOYEE
WHERE SALARY*12 >= 50000000;
-- 3. 직급 코드가 'J3' 이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부를 조회
SELECT EMP_ID " 사번 ", EMP_NAME " 사원명 ", JOB_CODE " 직급 코드 ", 
        ENT_YN" 퇴사 여부 " FROM EMPLOYEE
WHERE JOB_CODE != 'J3';
-- 4. 급여가 350만원 이상 600만원 이하인 모든 사원의 사번, 사원명, 급여 조회
--      AND, OR 로 조건을 연결 가능하다 (논리연산자)
SELECT EMP_ID " 사번 ", EMP_NAME " 사원명 ", SALARY " 급여 " FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

--==============================================================================
/*
    * BETWEEN AND : 조건식에서 사용되는 구문
    => ~이상 ~이하 인 범위에 해당하는 조건을 제시할때 사용
    
    [표현법]
            비교대상컬럼 BETWEEN 최소값 AND 최대값
            
            => 비교대상컬럼 >= 최소값 AND 비교대상컬럼 <= 최대값
*/
-- 급여가 350만원 이상이고 600만원 이하인 사원의 정보를 조회 (사번, 사원명, 급여)
SELECT EMP_ID " 사번 ", EMP_NAME " 사원명 ", SALARY " 급여 " FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

/*
    * NOT : 논리 부정 연산자
*/
-- 급여가 350만원 미만 또는 600만원 초과인 사원의 정보를 조회(사번, 사원명, 급여)
-- * NOT을 사용하지 않은 경우
SELECT EMP_ID " 사번 ", EMP_NAME " 사원명 ", SALARY " 급여 " FROM EMPLOYEE
WHERE SALARY < 3500000 OR SALARY > 6000000;

-- * NOT을 사용하는 경우
SELECT EMP_ID " 사번 ", EMP_NAME " 사원명 ", SALARY " 급여 " FROM EMPLOYEE
--WHERE SALARY NOT BETWEEN 3500000 AND 6000000;
WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
-- => NOT은 BETWEEN 앞에 또는 비교대상컬럼 앞에 붙여서 사용 가능하다.

-- 부서코드가 D6 이거나 D8 이거나 D5 인 사원들의 정보를 조회(사원명, 부서코드, 급여)
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D5';

/*
    * IN : 비교대상컬럼 값이 제시한 값들 중에 일치하는 값이 하나라도 있는경우 조회
    
    [표현법]
            비교대상컬럼 IN (값1,값2,값3,...)
*/
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6','D8','D5');

SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D6','D8','D5');

--==============================================================================
/*
    * LIKE : 비교하고자 하는 컬럼의 값이 제시한 특정 패턴에 만족되는 경우 조회
    
    [표현법]
            비교대상컬럼 LIKE '패턴'
            
    => 특정 패턴 : '%', '_' 를 와일드카드로 사용
        * % : 0글자 이상 
    ex) 비교대상컬럼 LIKE '문자%' : 비교대상컬럼의 값이 '문자' 로 "시작" 되는것을 조회
        비교대상컬럼 LIKE '%문자' : 비교대상컬럼의 값이 '문자' 로 "끝" 나는것을 조회
        비교대상컬럼 LIKE '%문자%' : 비교대상컬럼의 값에 문자가 "포함" 되는것을 조회
        
        * _ : 1글자
        ex) 비교대상컬럼 LIKE '_문자' : 비교대상컬럼의 값에서 문자앞에 
                                        무조건 한글자가 있는 경우 조회
            비교대상컬럼 LIKE '__문자' : 비교대상컬럼의 값에서 문자앞에 
                                        무조건 두글자가 있는 경우
            비교대사얼럼 LIKE '_문자_' : 비교대상컬럼의 값에서 문자 앞, 뒤로
                                        무조건 한글자가 있는경우 조회
*/
-- * 사원들 중에서 성이 전 씨인 사원의 사원명, 급여 조회
SELECT EMP_NAME, SALARY FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- * 사원 이름에 '하' 가 포함된 사원의 사원명, 주민번호, 연락처 조회
SELECT EMP_NAME, EMP_NO, PHONE FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

--==============================================================================
-- * 사원들 중 연락처의 3번째자리가 1인 사원의 정보조회(사번, 사원명, 연락처, 이메일)
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- * 사원들 중 이메일에 4번째 자리가 _ 인 사원의 정보조회(사번, 사원명, 이메일)
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE
WHERE EMAIL LIKE '____%';
-- => 원하는 결과가 나오지않음
--      와일드 카드로 사용되는 문자와 컬럼에서 조회하고자 하는 문자가 동일하기 때문임
--      따라서, 구분이 필요

-- * 나만의 와일드카드 사용 ESCAPE 사용
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE
WHERE EMAIL LIKE '___$_%' ESCAPE '$';

-- * 남자사원 검색
SELECT EMP_NAME, EMP_NO, PHONE FROM EMPLOYEE
WHERE EMP_NO LIKE '%-1%';

-- * 여자사원 검색
SELECT EMP_NAME, EMP_NO, PHONE FROM EMPLOYEE
WHERE EMP_NO LIKE '%-2%';

--==============================================================================
/*
    * IS NULL / IS NOT NULL
        : 컬럼값에 NULL이 있을경우 NULL값을 비교할때 사용하는 구문(연산자)
        
    대상컬럼 IS NULL => 해당 컬럼의 값이 NULL인 경우 조회
    대상컬럼 IS NOT NULL => 해당 컬럼의 값이 NULL이 아닌경우만 조회
*/
-- * 보너스를 받지 않는 사원 조회 (사번, 사원명, 급여, 보너스)
SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMPLOYEE
WHERE BONUS IS NULL;

-- * 보너스를 받는 사원 조회(사번, 사원명, 급여, 보너스)
SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMPLOYEE
WHERE BONUS IS NOT NULL;
-- WHERE NOT BONUS IS NULL;

-- * 사수가 없는 사원 조회 (사원명, 사수사번, 부서코드)
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- * 부서배치를 받지 않았지만, 보너스를 받고있는 사원 조회(사원명, 보너스, 부서코드)
SELECT EMP_NAME, BONUS, DEPT_CODE FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;
--==============================================================================
/*
    * 연산자 우선순위
    
        (0)     ()
        (1) 산술연산자 : * / + -
        (2) 연결연산자 : ||
        (3) 비교연산자 : > < >= <= = != ..
        (4) IS NULL / LIKE '패턴' / IN
        (5) BETWEEN AND
        (6) 부정연산자 : NOT
        (7) AND
        (8) OR
*/
-- * 직급코드가 J7 이거나 J2인 사원들 중 급여가 200만원 이상인 사원조회 (모든정보)
SELECT * FROM EMPLOYEE
--WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') AND SALARY >= 2000000;
WHERE JOB_CODE IN ('J7','J2') AND SALARY >= 2000000;
--==============================================================================
/*
    * ORDER BY : SELECT 문의 가장 마지막줄에 작성, 실행순서도 마지막에 실행
    
    [표현법]
            SELECT 조회할컬럼, ...
            FROM 테이블명
            WHERE 조건식
            ORDER BY 정렬 기준이되는컬럼 정렬방식 NULL에대한 옵션
            
            * 정렬기준이되는컬럼 : 컬럼명, 별칭, 컬럼순번(SELECT 절에 나열한 순서 번호)
            * 정렬방식 :
                - ASC : 오름차순 정렬 (기본값)
                - DESC : 내림차순 정렬
            
            * NULL에대한옵션
                - NULLS FIRST : 정렬하고자하는 컬럼의 값이 
                        NULL인 경우 해당 데이터를 맨 앞에 위치 (DESC인 경우 기본값)
                - NULLS LAST : 정렬하고자 하는 컬럼의 값이
                        NULL인 경우 해당 데이터를 맨 뒤에 배치(ASC인 경우 기본값)
                => NULL값을 기본적으로 큰 값으로 분류하여 정렬함
*/
-- * 모든 사원의 사원명, 연봉 조회( 연봉 내림차순 정렬)
SELECT EMP_NAME, SALARY*12 연봉 FROM EMPLOYEE
-- ORDER BY SALARY*12 DESC;  -- 컬럼(연산식)
-- ORDER BY 연봉 DESC;       -- 별칭
ORDER BY 2 DESC;            -- 컬럼순번

-- * 보너스 기준으로 정렬
SELECT * FROM EMPLOYEE
-- ORDER BY BONUS;         -- 정렬기준 : ASC,  NULL에 대한 처리 : NULLS LAST
ORDER BY BONUS ASC NULLS LAST;
-- 보너스가 높은순서로 조회하되, 보너스가 같은경우 급여기준 오름차순정렬
SELECT * FROM EMPLOYEE
ORDER BY BONUS DESC, SALARY ASC;




















