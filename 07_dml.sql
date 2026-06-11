-- ===================================
-- DML
-- ===================================

-- DML(Data Manipulation Language)
-- Data를 조작(삽입, 수정, 삭제, 조회)하기 위해 사용하는 언어
-- Data를 이용하려는 사용자와 DB사이의 인터페이스를 직접적으로 제공하는 언어로써 가장 많이 사용됨
-- INSERT, UPDATE, DELETE, SELECT(DQL)

# INSERT
-- 새로운 행을 추가하는 구문이다.
-- 테이블의 행의 수가 증가한다.
-- insert요청시 처리된 행의 수가 반환된다. (PyCharm에서 Service뷰-Output탭에서 확인이 가능)

# 문법
-- 1. INSERT INTO <테이블명>
--    VALUES (입력데이터1, 입력데이터2, ... );
-- > 위치 기반

-- 2. INSERT INTO <테이블명>(컬럼명1,컬럼명2,...)
--    VALUES (입력데이터1, 입력데이터2, ... );`
--      - null을 허용하는 컬럼은 생략가능하다(생략되면 null값이 대입)
--      - not null인 컬럼은 생략할 수 없다.(단, default값이 지정되면 생략가능)
-- > 명칭 기반

-- 3. INSERT INTO <테이블명>(컬럼명1,컬럼명2,...)
--    VALUES (입력데이터1, 입력데이터2, ... ),
--           (입력데이터1, 입력데이터2, ... ), ... ;

# 행(record) 추가
# - 제약조건에 위배되는 컬럼값이 하나라도 있으면 추가할 수 없다.
# - not null컬럼에는 null값이 있을 수 없다.
# - pk, unique컬럼에는 중복값이 들어갈 수 없다.
# - fk컬럼 참조하는 컬럼 이외의 값을 들어갈 수 없다.
# - check컬럼 제시된 도메인외의 값을 들어갈 수 없다.


-- 문법 1. 테이블에 작성된 칼럼 수서대로 모든 값 작성(위치기반 삽입) --
INSERT INTO tbl_menu
VALUES (null,
#        menu_code : auto increment이기 때문에
#                    null값을 삽입하면 자동으로 숫자가 입력됩
        '바나나해장국',
        9500,
        4,
        'Y');

# 행 삽입 확인
SELECT * FROM tbl_menu;

# tbl_menu 테이블 정보 조회
# Null 컬럼 : null 삽입 가능 여부
# -> 모든 컬럼에 null 삼입 불가
DESC tbl_menu;

# INSERT INTO tbl_menu
# VALUES (null,
#         null,
#         9500,
#         4,
#         'Y');
# -> Error



-- 문범 2. 작성한 컬럼 값 제공(명칭 기반) --
# menu_code 제외 -> 자동으로 null -> auto increment 적용되어 숫자 자동 삽입
INSERT INTO
    tbl_menu(
             menu_price,
             orderable_status,
             menu_name,
             category_code)
VALUES (
        6500,
        'Y',
        '카카오 죽',
        '6'
       );

# 행 삽입 확인
SELECT * FROM tbl_menu;



-- 문법3: 대량 데이터 추가 --
INSERT INTO
    tbl_menu
VALUES
    (null, '참치맛 아이스크림', 1700, 12, 'Y'),
    (null, '멸치맛 아이스크림', 1700, 12, 'Y'),
    (null, '소시지맛 커피', 2300, 8, 'Y');

# 칼럼에 다른 타입의 인수를 작성해도 자동 타입 변환이 됨
# int 타입 칼럼에 char 타입 작성 -> int 타입으로 자동 변환
# char 타입 칼럼에 int 타입 작성 -> char 타입으로 자동 변환




# =========================================================

-- UPDATE --
# - 기존 행의 컬럼 값(데이터 값)을 수정하는 구문
# - 바꾸고 싶은 컬럼 값이 존재하는 행을 잘 찾는 것이 중요
/*
<<작성법>>
UPDATE [테이블명]
SET
    [컬럼명1] = [값1],
    [컬럼명2] = [값2],
    ...
WHERE [수정할 행을 선택하는 조건]
*/

## 기존 tbl_menu 테이블의 19번 행의 menu_price 1000원 인상
UPDATE tbl_menu
SET menu_price=menu_price+1000
    # UPDATE 절 안에서만 "="가 대입연산자
WHERE menu_code=19;

# UPDATE 결과 확인
SELECT * FROM tbl_menu;


## '한식'의 가격을 모두 500원 인상
UPDATE tbl_menu
SET menu_price=menu_price+500
WHERE category_code=(
    SELECT category_code
    FROM tbl_category
    WHERE category_name='한식'
    );

# UPDATE 결과 확인
SELECT * FROM tbl_menu;




# =========================================================

-- DELETE --
# - 지정된 행을 삭제
# WHERE 절 이용 -> 조건을 만족시키는 행 삭제
/*
<<작성법>>
DELETE
FROM [테이블명]
WHERE [조건];
*/

# 전체 테이블 조회
SELECT * FROM tbl_menu;

##27번 메뉴 삭제
DELETE
FROM tbl_menu
WHERE menu_code=27;

# 삭제 결과 확인
SELECT * FROM tbl_menu;

## 메뉴 코드가 21 보다 큰 메뉴 모두 삭제
DELETE
FROM tbl_menu
WHERE menu_code>21;

# 삭제 결과 확인
SELECT * FROM tbl_menu;




# =========================================================

-- REPLACE --
-- > INSERT + UPDATE (~~ upsert 구문)
# - 새로운 데이터를 테이블에 삽입할 때
#   pk(식별자/Primary Key) 칼럼 값이 중복 되는 것이 없으면 -> INSERT
#   pk(식별자/Primary Key) 칼럼 값이 중복 되면 -> UPDATE
/*
 <<작성법>>
 REPLACE INTO [테이블명]
 VALUES (입력데이터1, 입력데이터2, ...)
 */

REPLACE INTO tbl_menu
VALUES(100,
       '참기름커피',
       3000,
       8,
       'Y');

# 실행 결과 확인
SELECT * FROM tbl_menu;
-- > INSERT

REPLACE INTO tbl_menu
VALUES(100,
       '소주맛커피',
       5000,
       8,
       'Y')

# 실행 결과 확인
SELECT * FROM tbl_menu;
-- > UPDATE된 모습
# 실제로는 DELETE 루 INSERT 수행된 것