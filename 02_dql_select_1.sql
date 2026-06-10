/* SQL(Structured Query Language)
 - 구조화된 질의 언어
 - RDBMS에서 저장된 데이터를 관리, 조작하거나 DB 구조를 제어할 때 사용하는 언어

 ## SQL의 종류
 - DQL(Data Query Language) : 데이터 질의어
   - 테이블의 데이터를 검색/조회
   - SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY,...

 - DML(Data Manipulation Language) : 데이터 조작 언어
   - 테이블에 저장된 값을 삽입, 수정, 삭제
   - INSERT, UPDATE, DELETE, TRUNCATE, ALTER, DROP, ...

 - DDL(Data Definition Language) : 데이터 정의 언어

 - DCL(Data Control Language) : 데이터 제어 언어

 - TCL(Transaction Control Language) : 트랜잭션 제어 언어

 */


# DQL 구조
/*
    select 컬럼명 (5)  -- 필수
    from 테이블 (1)  -- 필수
    where 조건절(필터링) (2)
    group by 그룹핑 (3)
    having 조건절(그룹핑에 대해 필터링) (4)
    order by 정렬기준 (6)
    limit 행수제한 (7)

    1. SELECT : 조회하고자 하는 컬럼명을 기술함. 여러개를 기술하고자 하면 쉼표(,)로 구분하고 모든 컬럼 조회시 '*'을 사용
    2. FROM : 조회 대상 컬럼이 포함된 테이블명을 기술
    3. WHERE :
        행을 선택하는 조건을 기술함.
        여러 개의 제한 조건을 포함할 수 있으며, 각각의 제한 조건은 논리 연산자로 연결함
        제한조건을 만족시키는 행들만 Result Set에 포함됨
    4. ORDER BY : 정렬할 컬럼을 기준으로 오름/내림차순 지정
    5. GROUP BY : 행을 그룹핑함
    6. HAVING : 그룹핑된 행을 선택하는 조건을 기술함
*/

# tbl_menu(메뉴 테이블)의 모든(*) 컬럼 조회
select
    *
from
    tbl_menu;

# 메뉴 테이블에서 메뉴명, 가격 조회
select
    menu_name,menu_price
from
    tbl_menu;

# 조회되는 칼럼에 연산 가능
# 메뉴 테이블에서 메뉴명, 가격, 부가세(10%), 부가세포함가 조회
select
    menu_name,
    menu_price,
    menu_price*0.1,
    menu_price+menu_price*0.1
from
    tbl_menu;

# =================================== #
# ResultSet : SELECT 조회 결과 행의 집합
# ResultSet에 표기되는 컬럼명 별칭(alias) 설정 가능 -> AS
# =================================== #
select
    menu_name as 메뉴명,
    menu_price as "메뉴 가격",  # 쌍따옴표를 이요해 띄어쓰기된 칼럼명 묶기
    menu_price*0.1 부가세,
    menu_price+menu_price*0.1 "부가세 포함 가격"
from
    tbl_menu;

# 신술 연산
select
    10 + 3,
    10 - 3,
    10 * 3,
    10 / 3,
    10 div 3,   # 몫 == python //
    10 % 3,     # 나머지 == mod
    10 mod 3;    # 나머지 == %

# 문자열 연결 처리(이어쓰기)
# CONCAT('abc','def') = 'abcdef'
# 메뉴 테이블에서 메뉴명, 메뉴가격(원)
SELECT
    menu_name as 메뉴명,
    CONCAT('금',menu_price,'원') as "메뉴 가격(원)"    #작은따옴표 : 문자열
    # menu_price||'원' - Oracle 문법
FROM
    tbl_menu;

# DISTINCT : 컬럼값 중복 제거
# - 지정된 컬럼의 값이 중복되는 행을 제거해서 조회
SELECT
    DISTINCT category_code
FROM
    tbl_menu;


# ========================================== #
# ORDER BY 절
# - 조회결과(ResultSet)의 정렬 순서를 지정하는 구문
# - 특정 칼럼을 기준으로 삼아서 오름차순(ASC), 내림차순(DESC) 지정
# - 기준으로 삼은 칼럼이 여러개 존재하면 그룹화된 정렬이 수행된다
# ========================================== #

# 메뉴 테이블을 조회(가격 오름차순)
SELECT menu_name,menu_price
FROM tbl_menu
ORDER BY menu_price;

# 메뉴 테이블을 조회(가격 내림차순)
SELECT menu_name,menu_price
FROM tbl_menu
ORDER BY menu_price DESC;

# 문자열(유니코드 순서), 날짜(과거~>미래)도 정렬 기준이 될 수 있다
# 메뉴명 오름차순
SELECT menu_name
FROM tbl_menu
ORDER BY menu_name;

# SELECT절에 작성되지 않은 칼럼도 정렬 기준이 될 수 있다 -> 캐싱
SELECT menu_name
FROM tbl_menu
ORDER BY menu_price;

# 기준으로 삼은 칼럼이 여러개 -> 그룹화된 정렬
# 메뉴 테이블에서 메뉴명, 카테고리 코드, 가격 조회
# 단, 카테고리 코드 오름차순, 가격 내림차순 조회
# -> 1. 카테고리 코드로 오름차순 정렬 먼저 수행
#    2. 같은 카테고리 코드를 지닌 행들끼리 모여 정렬됨
#    3. 같은 카테고리 코드를 지닌 행 내에서 가격 내림차순 정렬
SELECT menu_name,category_code,menu_price
FROM tbl_menu
ORDER BY category_code ASC,menu_price DESC;



# ================================================================

# WHERE 행 필터링
# - 각행별로 제시한 조건을 검사하고, TRUE인 행만 결과집합에 포함시킨다.

# WHERE 비교 연산자
-- 표현식 사이의 관계를 비교하기 위해 사용하고, 비교 결과는 논리 결과중에 하나 (TRUE/FALSE/NULL)가 됨
-- 단, 비교하는 두 컬럼 값/표현식은 서로 동일한 데이터 타입이어야 함

-- --------------------------------------------------------------------------------
-- 연산자                    설명
-- --------------------------------------------------------------------------------
-- =                        같다
-- >,<                        크다/작다
-- >=,<=                    크거나 같다/작거나 같다
-- <>,!=                    같지 않다 (^= 없음)
-- BETWEEN AND                특정 범위에 포함되는지 비교
-- LIKE / NOT LIKE            문자 패턴 비교
-- IS NULL / IS NOT NULL    NULL 여부 비교
-- IN / NOT IN                비교 값 목록에 포함/미포함 되는지 여부 비교
-- --------------------------------------------------------------------------------


# WHERE 논리 연산자
-- 여러 개의 제한 조건 결과를 하나의 논리결과로 만들어 줌 (&&,|| 사용불가)
-- AND &&    여러 조건이 동시에 TRUE일 경우에만 TRUE 값 반환
-- OR ||    여러 조건들 중에 어느 하나의 조건만 TRUE이면 TRUE값 반환
-- NOT !    조건에 대한 반대값으로 반환(NULL은 예외)
-- XOR        두 값이 같으면 거짓, 두 값이 다르면 참

# 메뉴 테이블에서 가격이 13000원 이상인 메뉴의
# 메뉴코드, 메뉴명, 가격 조회
#가격 내림차순 정렬
SELECT menu_code,menu_name,menu_price
FROM tbl_menu
WHERE menu_price >= 13000
ORDER BY menu_price DESC;

# 메뉴 테이블에서 카테고리 코드가 10인 메뉴만 조회
# 카테고리 코드, 메뉴명, 가격 조회
# 메뉴명 오름차순 정렬
SELECT category_code,menu_name,menu_price
FROM tbl_menu
WHERE category_code = 10
ORDER BY menu_name;

# 메뉴 테이블에서 가격이 10,000원 이상, 20,000 이하인 메뉴의
# 메뉴명, 가격, 카테고리 코드 조회
# 가격 내림차순
SELECT menu_name,menu_price,category_code
FROM tbl_menu
WHERE menu_price BETWEEN 10000 AND 20000
#WHERE menu_price >= 10000 AND menu_price <= 20000
ORDER BY menu_price DESC;

# 반대 경우
# 10,000원 미만, 20,000 초과
SELECT menu_name,menu_price,category_code
FROM tbl_menu
WHERE menu_price NOT BETWEEN 10000 AND 20000
#WHERE menu_price < 10000 AND menu_price > 20000
ORDER BY menu_price DESC;

# 메뉴 테이블에서 카테고리 코드가 4,6,10인 메뉴의
# 메뉴명, 카테고리 코드 조회
# 카테고리 코드 오름차순
SELECT menu_name,category_code
FROM tbl_menu
WHERE category_code IN (4,6,10)
# WHERE
#     category_code = 4
#    OR category_code = 6
#    OR category_code = 10
ORDER BY category_code;

# 반대 경우
# 메뉴 테이블에서 카테고리 코드가 4,6,10아 아닌 메뉴
SELECT menu_name,category_code
FROM tbl_menu
WHERE category_code NOT IN (4,6,10)
# WHERE
#     NOT category_code = 4
#    AND NOT category_code = 6
#    AND NOT category_code = 10
ORDER BY category_code;



# ========================================== #
# LIKE 절
# - 문자열 패턴 검사 연산자
# - 패턴을 나타내는 기로(와일드카드)로 %, _ 를 사용
#   - % : 포함, 0개 이상
#   - _ : 문자 1개(한 칸)
# ========================================== #

SELECT menu_name
FROM tbl_menu
WHERE
    # '아'로 시작하는 메뉴 조회
    # menu_name LIKE '아%';
    #
    # '밥'으로 끝나는 메뉴 조회
    # menu_name LIKE '%밥';
    #
    # '마늘'이 포한된 메뉴 조회
    # menu_name LIKE '%마늘%';
    #
    # 메뉴명이 5글자인 메뉴 조회
    menu_name LIKE '_____';



# ========================================== #
# DB에서 NULL : 저장된 데이터가 없다
# NULL = 컬럼이 비었음을 나타내는 기호

# 비교연산 '=' : 비교하는 두 값(data)이 같으면 True
# null값은 값(data)가 아니므로 '= NULL' : X
# -> IS NULL 또는 IS NOT NULL을 사용해야함

# 카테고리 테이블에서 ref_category가 null인 행 조회
SELECT *
FROM tbl_category
# WHERE ref_category_code = NULL;
# 컬럼 안에 null값이 있으면 TRUE
# = 칼럼 값이 비어있으면 TRUE
WHERE ref_category_code IS NULL;
# 컬럼 안에 값(data)이 있으면 TRUE
# WHERE ref_category_code IS NOT NULL;



# ========================================== #
# LIMIT
# - 조회 결과(ResultSet)에서 지정된 크기만큼의 행만 조회
# LIMIT n : 0번 인덱스(1행)부터 n행 만큼 조회
# LIMIT m, n : m번 인덱스(m+1 행)부터 n행 만큼 조회
        # m : offset - offset 행만큼 건너뛰고, n행 만큼 조회

SELECT * FROM tbl_menu;
SELECT * FROM tbl_menu LIMIT 5;
SELECT * FROM tbl_menu LIMIT 0,5;
SELECT * FROM tbl_menu LIMIT 5,10;
SELECT * FROM tbl_menu LIMIT 20,3;

# 페이징 처리 시 limit 사용

# 메뉴 테이블을 이용해 메뉴판 만들기
# 한 페이지 당 메뉴 4개 씩 조회
# 순서는 메뉴코드 역순
-- 1 페이지 --
SELECT *
FROM tbl_menu
ORDER BY menu_code DESC
LIMIT 0,4;
-- 2 페이지 --
SELECT *
FROM tbl_menu
ORDER BY menu_code DESC
LIMIT 4,4;
-- 3 페이지 --
SELECT *
FROM tbl_menu
ORDER BY menu_code DESC
LIMIT 8,4;
-- 4 페이지 --
SELECT *
FROM tbl_menu
ORDER BY menu_code DESC
LIMIT 12,4;
-- 5 페이지 --
SELECT *
FROM tbl_menu
ORDER BY menu_code DESC
LIMIT 16,4;
-- 6 페이지 --
SELECT *
FROM tbl_menu
ORDER BY menu_code DESC
LIMIT 20,4;














