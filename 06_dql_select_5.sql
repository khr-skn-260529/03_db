-- SET OPERATORS (집합 연산 --
# : 두 개 이상의 SELECT 결과(ResultSet)를 결합

-- UNION : 합집합 --
SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    category_code = 10      # 2,3,4,11,12,17
UNION
SELECT                      # 1,2,3,4,10,12,13,17,21
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    menu_price < 9000;
# 실행결과 : 1,2,3,4,10,12,13,17,21




-- INTERSECT : 교집합 --
SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    category_code = 10      # 2,3,4,11,12,17
INTERSECT
SELECT                      # 1,2,3,4,10,12,13,17,21
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    menu_price < 9000;
# 실행결과 : 2,3,4,12,17




-- UNION ALL : 중복 허용 합집합 --
SELECT
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    category_code = 10      # 2,3,4,11,12,17
UNION ALL
SELECT                      # 1,2,3,4,10,12,13,17,21
    menu_code,
    menu_name,
    menu_price,
    category_code,
    orderable_status
FROM
    tbl_menu
WHERE
    menu_price < 9000
ORDER BY
    menu_code;
# 실행결과 : 1,2,2,3,3,4,4,10,11,12,12,13,17,17,21



-- MINUS : 차집합 --
# - MySQL에서 MINUS를 제공하지 않음
# - LEFT JOIN을 활용해 구현 가능
SELECT
    a.menu_code,
    a.menu_name,
    a.menu_price,
    a.category_code,
    a.orderable_status
FROM
    tbl_menu a
LEFT JOIN (SELECT
		menu_code,
		menu_name,
		menu_price,
		category_code,
		orderable_status
	FROM
		tbl_menu
	WHERE
		menu_price < 9000) b
    # 서브쿼리 결과 : 1,2,3,4,10,12,13,17,21
ON (a.menu_code = b.menu_code)
WHERE
    a.category_code = 10 AND
    b.menu_code IS NULL;
# 실행결과 : 11
# => tbl_menu LEFT JOIN [서브쿼리] = tbl_menu - [서브쿼리]



-- ===================================
-- SUBQUERY
-- ===================================
-- 하나의 SQL문(main-query) 안에 포함되어 있는 또 다른 SQL문(sub-query)
-- 존재하지 않는 조건에 근거한 값들을 검색하고자 할때 사용.
-- 메인 쿼리가 서브 쿼리를 포함하는 종속적인 관계이다.
-- 메인 쿼리 실행중에 서브 쿼리를 실행해서 그 결과값을 다시 메인쿼리에 전달하는 방식이다.

# 서브쿼리(SUBQUERY) 유형
-- 1. 일반 서브쿼리
-- 2. 상관 서브쿼리
-- 3. 인라인뷰(파생테이블)

# 규칙
-- 서브쿼리는 반드시 소괄호로 묶어야 함 - (SELECT ... ) 형태
-- 서브쿼리는 연산자의 오른쪽에 위치 해야 함
-- 서브쿼리 내에서 order by 문법은 지원 안됨


# 1. 메뉴 테이블에서 '민크미역숫'의 카테고리 코드 조회
SELECT category_code
FROM tbl_menu
WHERE menu_name='민트미역국';
# 실행결과 -> category_code: 4

# 2. 메뉴 테이블에서 카테고리 코드가 4인 메뉴 조회
SELECT *
FROM tbl_menu
WHERE category_code=4;

# 3. 메뉴 테이블에서 '민트미역국'과 같은 카테고리의 메뉴 조회
SELECT *                    #메인쿼리
FROM tbl_menu
WHERE category_code=(
    SELECT category_code    #서브쿼리
    FROM tbl_menu
    WHERE menu_name='민트미역국'
    );



# 메뉴 테이블에서 '민트미역국'보다 비싼 메뉴를
# 가격 내림차순으로 조회
SELECT *
FROM tbl_menu
WHERE menu_price > (
    SELECT menu_price
    FROM tbl_menu
    WHERE menu_name='민트미역국'
    )
ORDER BY menu_price DESC;



-- 다중행 단일열 서브쿼리 --
# -> 서브쿼리가 여러개의 값을 반환

# 카테고리 테이블에서
# ref_category_code 값이 1인 카테고리 코드를 찾아
# 메뉴 테이블에서 같은 카테고리의 메뉴를 모두 조회
SELECT *
FROM tbl_menu
WHERE category_code IN (
    SELECT  category_code
    FROM tbl_category
    WHERE ref_category_code=1
    );


-- ==================== --
-- 상관 서브쿼리 (상호연관) --
-- ==================== --

-- 메인쿼리가 서브쿼리의 결과에 영향을 주는 경우
-- 메인쿼리의 1행을 가장 먼저 실행

-- 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음
-- 그 결과를 다시 메인쿼리로 반환하는 방식으로 수행되는 서브쿼리

-- 서브쿼리의 WHERE 절 수행을 위해서는 메인쿼리가 먼저 수행되는 구조
-- 메인쿼리 테이블의 레코드(행)에 따라 서브쿼리의 결과값도 바뀜
-- 메인 쿼리에서 처리되는 각 행의 컬럼값에 따라 응답이 달라져야 하는 경우에 유용

# 구분
-- 메인쿼리에 있는 것을 서브쿼리에서 가져다 쓰면 상관 서브쿼리 (블럭 잡아 단독으로 실행할수 없다.)
-- 그렇지 않고 서브쿼리가 독단적으로 사용이 되면 일반 서브쿼리

## 카테고리별 가장 비싼 메뉴 조회
# 1. 4번 카테고리 메뉴 중 가장 비싼 메뉴 가격 조회
SELECT MAX(menu_price)
FROM tbl_menu
WHERE category_code=4;

# 2. 4번 카테고리의 메뉴 중 가장 비싼 가격의 메뉴 조회
SELECT *
FROM tbl_menu
WHERE menu_price = 20000;

# 3. 카테고리별 가장 비싼 메뉴 조회
SELECT *
FROM tbl_menu main
WHERE menu_price = (
    SELECT MAX(menu_price)
    FROM tbl_menu sub
    WHERE sub.category_code=main.category_code
    );


## 카테고리 별 평균 금액보다 비싼 메뉴만 조회
SELECT *
FROM tbl_menu main
WHERE menu_price>(
    SELECT AVG(menu_price)
    FROM tbl_menu sub
    WHERE main.category_code=sub.category_code
    );




-- 스칼라 서브쿼리 --
# SELECT 절에서 사용하는 결과값이 1개인 서브쿼리

# 메뉴명, 카테고리 코드(메뉴 테이블)
# + 카테고리 코드에 대응되는 카테고리명(카테고리 테이블) 출력
SELECT
    menu_name,
    category_code,
    (SELECT category_name
     FROM tbl_category sub
     WHERE sub.category_code=main.category_code) AS category_name
FROM tbl_menu main ;
# JOIN 대신 활용 가능!!!



-- 인라인 뷰(INLINED VIEW) --
# FROM 절에 작성괸 서브쿼리
# 서브쿼리의 ResultSet을 테이블 처럼 사용

SELECT *
FROM (
    SELECT m.menu_code, m.menu_name, c.category_name
    FROM tbl_menu m
    JOIN tbl_category c
    ON m.category_code = c.category_code
    ) AS menu_view
WHERE category_name = '한식';


# 인라인뷰를 이용해 기존 테이블의 컬럼명을 변경 가능
# = 원본 테이블의 컬럼명 은닉
# 기존 컬럼명이 너무 길때 활용 가능!!
SELECT *
FROM (
    SELECT
        m.menu_code AS 메뉴코드,
        m.menu_name AS 메뉴명,
        c.category_name AS 카테고리명
    FROM tbl_menu m
    JOIN tbl_category c
    ON m.category_code = c.category_code
    ) AS menu_view
WHERE 카테고리명 = '한식';


-- CTE(Common Table Expression) --
# - 인라인뷰로 사용할 서브쿼리를 별도의 테이블 변수에 저장, 사용할 수 있게하는 문법
/*
 <<작성법>>
 WITH [변수명] AS [서브쿼리]
 SELECT ...
 FROM 변수명
 */
WITH menu_view AS (
    SELECT
        m.menu_code AS 메뉴코드,
        m.menu_name AS 메뉴명,
        c.category_name AS 카테고리명
    FROM tbl_menu m
    JOIN tbl_category c
    ON m.category_code = c.category_code
)
SELECT *
FROM menu_view
WHERE 카테고리명 = '한식';
# CTE 구문을 이용해 인라인뷰를 먼저 선언해두는 것이 처리속도가 미세하게 더 빠름