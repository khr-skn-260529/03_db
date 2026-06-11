-- =============================
-- JOIN
-- =============================
-- 두개 이상의 테이블의 레코드(행)를 연결해서 가상테이블(relation) 생성
-- 연관성을 가지고 있는 컬럼을 기준(데이터)으로 조합

# relation을 생성하는 2가지 방법
-- 1. join : 특정컬럼 기준으로 행과 행을 연결한다. (가로)
-- 2. union : 컬럼과 컬럼을 연결한다.(세로)
-- join은 두 테이블의 행사이의 공통된 데이터를 기준으로 **선을 연결해서** 새로운 하나의 행을 만든다.

# JOIN 구분
-- 1. Equi JOIN : 일반적으로 사용하는 Equality Condition(=)에 의한 조인
-- 2. Non-Equi JOIN : 동등조건(=)이 아닌 BETWEEN AND, IS NULL, IS NOT NULL, IN, NOT IN, !=  등으로 사용.

# EQUI JOIN 구분
-- 1. INNER JOIN(내부 조인) : 교집합 (일반적으로 사용하는 JOIN)
-- 2. OUTER JOIN(외부 조인) : 합집합
        -- LEFT (OUTER) JOIN (왼쪽 외부 조인)
        -- RIGHT (OUTER) JOIN (오른쪽 외부 조인)
-- 3. CROSS JOIN
-- 4. SELF JOIN(자가 조인)
-- 5. MULTIPLE JOIN(다중 조인)

## inner join (내부 조인)
# - 두 테이블의 교집합을 반환하는 SQL JOIN
# : 조인에 사용될 두 테이블의 특정 칼럼 값이 같은 행만 JOIN

# tbl_menu, tbl_category 두 테이블을 inner join
# 조인 조건 : category_code 값이 같은 행끼리 join
SELECT *
FROM tbl_menu a             #별칭 a
INNER JOIN tbl_category b   #별칭 b / INNER 생략 가능(기본값이 INNER JOIN)
ON a.category_code = b.category_code;

# 메뉴명, 가격, 카테고리명 가격 내립차순 조회
SELECT b.menu_name, b.menu_price, a.category_name
FROM tbl_category a
JOIN tbl_menu b
ON a.category_code = b.category_code
ORDER BY b.menu_price DESC;


# ==================================
# OUTER JOIN
# - 좌/우측 기준 테이블의 모든 행을 relation에 포함하는 join
# - LEFT [OUTER] JOIN
# - RIGHT [OUTER] JOIN

# employeedb로 변경
# employee 테이블 조회
SELECT EMP_NAME,DEPT_CODE
FROM employee;

# department 테이블 조회
SELECT *
FROM department;

-- INNER JOIN --
# employee 테이블과 department 테이블 inner join
SELECT a.EMP_ID, a.EMP_NAME, a.DEPT_CODE, b.DEPT_ID, b.DEPT_TITLE
FROM employee a
INNER JOIN department b
ON a.DEPT_CODE = b.DEPT_ID
ORDER BY a.EMP_ID;
# employee : 23행, department : 9행
# -> join 결과 : 21행
# -> 원인 : employee.DEPT_CODE가 NULL값인 두 행(하동운, 이오리)이 조인 결과(relation)에 포함되지 않음


-- LEFT OUTER JOIN --
# JOIN 구문 기준 왼쪽에 작성된 테이블의 모든 행이 relation에 포함되게 하기
# INNER JOIN 결과 21행 + employee 테이블의 JOIN 안 된 2행 = 23행
SELECT a.EMP_ID, a.EMP_NAME, a.DEPT_CODE, b.DEPT_ID, b.DEPT_TITLE
FROM employee a
LEFT OUTER JOIN department b
ON a.DEPT_CODE = b.DEPT_ID
ORDER BY a.EMP_ID;


-- RIGHT OUTER JOIN --
# JOIN 구문 기준 오른쪽에 작성된 테이블의 모든 행이 relation에 포함되게 하기
# INNER JOIN 결과 21행 + department 테이블의 JOIN 안 된 2행 = 23행
SELECT a.EMP_ID, a.EMP_NAME, a.DEPT_CODE, b.DEPT_ID, b.DEPT_TITLE
FROM employee a
RIGHT OUTER JOIN department b
ON a.DEPT_CODE = b.DEPT_ID
ORDER BY a.EMP_ID;


# ============ #
## menudb 계정 ##
-- CROSS JOIN --
# 카테시안 곱, 곱 집합
# 조인되는 두 테이블의 모든 경우의 수를 처리한 것
SELECT COUNT(*)     #COUNT(*): 행의 수 count
FROM tbl_menu;      #22행
SELECT COUNT(*)
FROM tbl_category;   #12행

SELECT *
FROM tbl_menu CROSS JOIN tbl_category;
# 22 * 12 = 264행


-- SELF JOIN --
# 하나의 테이블에서 한 행이 다른 행을 참조하는 관계가 있는 경우에
# 같은 테이블끼리 조인하는 것
# [tip] 똑같은 테이블이 2개 있다고 생각하면 쉬움
SELECT * FROM tbl_category;

SELECT child.category_code, child.category_name, parent.category_name as "상위 카테고리"
FROM tbl_category child JOIN tbl_category parent
ON child.ref_category_code = parent.category_code;
# WHERE parent.category_name = '식사';


-- MULTIPLE JOIN (다중 조인) --
# 3개 이상의 테이블을 조인하는 것
# JOIN 순서가 매우 중요함
# ex) a JOIN b JOIN c
# -> (a+b) JOIN c
# -> (a+b+c)
SELECT * FROM tbl_order;
SELECT * FROM tbl_order_menu;
SELECT * FROM tbl_menu;

SELECT *
FROM tbl_order o
JOIN tbl_order_menu om
ON o.order_code = om.order_code # o,om 합쳐진 relation 생성
RIGHT JOIN tbl_menu m
ON m.menu_code = om.menu_code;

# ===============
# employeedb 계정으로 변경
SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM location;

SELECT * FROM employee e
JOIN department d
ON e.DEPT_CODE = d.DEPT_ID
JOIN location l
ON d.LOCATION_ID = l.LOCAL_CODE;
