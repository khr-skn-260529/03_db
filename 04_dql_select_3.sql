# 그룹 함수
# - 그룹의 통계를 반환하는 함수
# - SUM(), AVG(), MAX(), MIN(), COUNT()

-- SUM(칼럼명) --
# - null(빈칸 상태)이 아닌 칼럼의 합
SELECT SUM(menu_price)
FROM tbl_menu;

-- AVG(칼럼명) --
# - null(빈칸 상태)이 아닌 칼럼의 평균값
SELECT AVG(menu_price)
FROM tbl_menu;

# 카테고리 코드가 10인 메뉴의 평균 가격
SELECT AVG(menu_price)
FROM tbl_menu
WHERE category_code = 10;

-- MAX(칼럼명) --
# - null(빈칸 상태)이 아닌 칼럼의 합
SELECT SUM(menu_price)
FROM tbl_menu;

-- MIN,MAX --
SELECT MAX(menu_price) AS 최대값,
       MIN(menu_price) AS 최소값
FROM tbl_menu;

# null과 연산을 수행하면 모든 결과가 null
SELECT 1+null;

# 합계, 평균 -> 숫자 데이터 칼럼에만 적용 가능
# 최대, 최소 -> 숫자, 문자, 날짜 모두 사용 가능
SELECT MAX(menu_name), MIN(menu_name)
FROM tbl_menu;

-- COUNT() --
# - COUNT(*|칼럼명) : 행의 개수를 조회
# - COUNT(*) : 모든 행(null 포함)의 개수
# - COUNT(칼럼명) : 지정된 칼럼 값 중 null인 행을 제외한 행의 개수
SELECT
    COUNT(*),                   #전체 행의 개수
    COUNT(ref_category_code)    #null 제외 카운트
FROM tbl_category;


# ============= #
-- GROUP BY 절 --
# ============= #
# 지정된 칼럼 값이 일치하는 행을 그룹화(grouping) 시키는 구문
SELECT category_code,
       COUNT(*),        #각 그룹의 모든 행의 개수
       SUM(menu_price), #각 그룹의 메뉴 가격 합계
       AVG(menu_price), #각 그룹의 평균 메뉴 가격
       MAX(menu_price), #각 그룹 메뉴 가격의 최대값
       MIN(menu_price)  #각 그룹 메뉴 가격의 최소값
FROM tbl_menu
GROUP BY category_code; #category_code의 값이 같은 행을 그룹화

## GROUP BY 사용 시 주의사항
# 1. null도 별도 그룹으로 묶임
# 2. 그룹화에 사용된 칼럼이 아닌 다른 칼럼은 SELECT 절에 사용할 수 없다
SELECT
    ref_category_code
    #, category_name    #그룹화되지 않은 칼럼으로 인해 오류
FROM tbl_category
GROUP BY ref_category_code;

# 그룹 내 하위 그룹 구성 가능
# -> category_code로 1차 그룹화 후
#    각 그룹에서 orderable_status가 같은 행끼리 2차 그룹화
SELECT category_code,
       orderable_status,
       COUNT(*)             #하위 그룹(orderable_status)에 대한 count
FROM tbl_menu
GROUP BY category_code,
         orderable_status   #하위 그룹
ORDER BY category_code;


# ===================== #
-- WHERE + GROUP BY 절 --
# ===================== #
# - WHERE : 지정된 테이블에서 행을 필터링
# - GROUP BY : 칼럼 값이 같은 행을 그룹화
# - WHERE+GROUP BY : 필터링 된 행 중 칼럼값이 같은 행을 그룹화

# 메뉴 테이블에서 카테고리별 개수,합계 구하기
# 단, 메뉴 가격이 10000원 이상인 메뉴만
SELECT
    category_code,
    COUNT(*),
    SUM(menu_price)
FROM tbl_menu
WHERE menu_price >= 10000
GROUP BY category_code;

# 메뉴 테이블에서 주문이 가능한 메뉴 중
# 카테고리 코드가 4,10인 메뉴의
# 카테고리 별 개수
SELECT category_code,
       COUNT(*)
FROM tbl_menu
WHERE orderable_status = 'Y' AND
      category_code IN (4,10)
GROUP BY category_code;

# 메뉴 테이블에서 주문이 가능한 메뉴 중
# 카테고리 코드가 4,10인 메뉴의
# 카테고리 별 개수
SELECT c.category_name,
       COUNT(*)
FROM tbl_menu m JOIN tbl_category c
    ON m.category_code
           = c.category_code
WHERE m.orderable_status = 'Y' AND
      m.category_code IN (4,10)
GROUP BY c.category_name;




# ============= #
-- HAVING 절 --
# ============= #
# - GROUP BY를 통해 만들어진 그룹에 대한 조건을 작성하는 구문
# - HAVING 절 작성 시 항상 GROUP BY절이 포함됨

# 메뉴 테이블에서
# 카테고리 별 메뉴 개수가 2개 이상인 카테고리의
# 카테고리 번호, 개수 출력
SELECT category_code,
       COUNT(*)
FROM tbl_menu
GROUP BY category_code
HAVING COUNT(*) >= 2;

# 카테고리 테이블에서
# ref_category_code 별로 개수가 3개 이상인
# ref_category_code 번호, 개수 조회
# ref_category_code 오름차순 조회
SELECT ref_category_code,
       COUNT(*)
FROM tbl_category
GROUP BY ref_category_code
HAVING COUNT(*) >= 3
ORDER BY ref_category_code;

# 위 쿼리 결과에서 null 제외
SELECT ref_category_code,
       COUNT(*)
FROM tbl_category
WHERE ref_category_code IS NOT NULL
GROUP BY ref_category_code
HAVING COUNT(*) >= 3
ORDER BY ref_category_code;
## 또는
# SELECT ref_category_code,
#        COUNT(*)
# FROM tbl_category
# GROUP BY ref_category_code
# HAVING COUNT(*) >= 3 AND
#        ref_category_code IS NOT NULL
# ORDER BY ref_category_code;
## WHERE 절 사용 권장

# ORDER BY 기준 : COUNT(*)
# LIMIT 1 = count가 가장 적은 행
SELECT ref_category_code,
       COUNT(*)
FROM tbl_category
WHERE ref_category_code IS NOT NULL
GROUP BY ref_category_code
HAVING COUNT(*) >= 3
ORDER BY COUNT(*)
LIMIT 1;