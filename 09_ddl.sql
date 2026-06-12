-- DDL (Data Definition Language) --
# - 데이터베이스 스키마(객체)를 생성(CREATE), 수정(ALTER: 구조수정), 삭제(DROP)
# - DDL 구물은 실행 시 바로 DB에 반영된다

# <<주의사항>>
# 1. DML 구문 수행 -> 트랜젝션에 담김
# 2. DML 구문 수행 중간에 DDL 구문 수행하면 트랜젝션 내용이 자동 COMMIT
## 절대 DML과 DDL을 혼용해서 작성하지 말 것!!!

-- ----------------------------------------------------------------

## CREATE TABLE (테이블 생성)
/*
<<작성법>>
CREATE TABLE [IF NOT EXISTS] 테이블명(
    컬럼명1 자료형 [제약조건|auto increament] [default] [comment],
    컬럼명2 자료형 [제약조건] [default] [comment],
    컬럼명3 자료형 [제약조건] [default] [comment],
    ...
    );
 */


-- CREATE TABLE --
## 테이블 생성
# auto_increment : 숫자 자동 증가 옵션
# -> 기본적으로 PK에만 사용 가능
# COMMENT : 주석
# NOT NULL : null 값 허용X
# DEFAULT : 기본값 설정(null값 삽입시 자동으로 기본값 삽입)
CREATE TABLE product(
    id int primary key auto_increment COMMENT '상품식별코드',
    name varchar(100) NOT NULL COMMENT '상품명',
    price int NOT NULL DEFAULT 0 COMMENT '상품가격',
    created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT ' 상품등록일시'
) ;

## 생성한 테이블 조회
SELECT * FROM product;

## 생성한 테이블 DDL 구문 확인
SHOW CREATE TABLE product;

## 생성한 테이블 설명 조회
DESC product;

## 테이블의 메타정보를 조회하는 구문
SELECT *
FROM information_schema.tables
WHERE table_schema = 'menudb' AND
      table_name = 'product';

## product 테이블에 데이터 추가(INSERT)
INSERT INTO product(name)
VALUES ('텀블러');
-- > name 칼럼이 아닌 다른 칼럼은 기본값이 설정되어있으므로 name만 삽입해도 무관

INSERT INTO product(name,price)
VALUES ('머그컵',5000);

SELECT * FROM product;

COMMIT ;


# ===============================

-- CONSTRAINT --
## 제약조건
# - 테이블 컬럼에 붙어 INSERT, UPDATE 시
#   각 컬럼에 기록되는 값에 대한 조건을 설정하는 발법
# - 데이터 무결성을 보장하기 위해 사용
# - 종류 : NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK

## 제약조건 확인 방법
DESC product;

SELECT *
FROM information_schema.table_constraints
WHERE table_schema = 'menudb' AND
      table_name = 'tbl_menu';

# - NOT NULL : 지정된 컬럼은 NULL일 수 없다 = 값 필수
# - UNIQUE : 지정된 컬럼에는 중복되는 값을 지정할 수 없다

# 이미 생성된 테이블이 있다면 테이블 삭제
DROP TABLE IF EXISTS user_unique;

CREATE TABLE IF NOT EXISTS user_unique (
    user_no INT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL UNIQUE, #컬럼레벨 제약 조건
    email VARCHAR(255)
    # , UNIQUE (phone)           #테이블 레벨 제약 조건 설정
) ENGINE=INNODB;
# -> 가독성을 위해 칼럼레벨보다는 테이블레벨에서 제약조건 설정하는 것 권장

INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_unique;


## UNIQUE 제약조건 위배한 경우
INSERT INTO user_unique
    (user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES(3,
       'user03',
       'pass03',
       '이순신',
       '남',
       '010-777-7777',
       'lee222@gmail.com'
      );
# Duplicate entry '010-777-7777' for key 'user_unique.phone'


## phone 값 변경 -> UNIQUE 제약조건 위배 해결
# +) NOT NULL 제약조건 위배
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES(3,
       null,
       'pass03',
       '이순신',
       '남',
       '010-888-8888',
       'lee222@gmail.com'
      );
# [23000][1048] Column 'user_id' cannot be null


## NOT NULL 제약조건 해결
INSERT INTO user_unique
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES(3,
       'user03',
       'pass03',
       '이순신',
       '남',
       '010-888-8888',
       'lee222@gmail.com'
      );

## 조회 확인
SELECT * FROM user_unique;

-- PRIMARY KEY --
# - 테이블 내 행을 구별하기 위한 식별자 역할의 컬럼에 추가하는 제약조건
# - NOT NULL + UNIQUE의 특징을 가짐(중복되지 않는 값 필수)
# - PRIMARY KEY는 테이블 내에 1개만 설정 가능
#   단, PK 설정이 적용되는 컬럼은 1개 또는 여러 개 묶음(복합키)

DROP TABLE IF EXISTS user_primarykey;

CREATE TABLE IF NOT EXISTS user_primarykey (
--     user_no INT PRIMARY KEY,     # 컬럼 레벤 제약조건
    user_no INT,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    PRIMARY KEY (user_no)         # 테이블 레벨 제약조건
) ENGINE=INNODB;

INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com'),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com');

SELECT * FROM user_primarykey;

# PK 설정 여부 확인
DESC user_primarykey;

## primary key 제약조건 위반 - NULL
INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(null, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');
# [23000][1048] Column 'user_no' cannot be null
# 1. NOT NULL 제약조건을 따로 설정하지 않았음에도 NOT NULL의 특성을 띰

## primary key 제약조건 위반 - 중복값 삽입
INSERT INTO user_primarykey
(user_no, user_id, user_pwd, user_name, gender, phone, email)
VALUES
(2, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com');
# Duplicate entry '2' for key 'PRIMARY'
# 2. UNIQUE 제약조건을 따로 설정하지 않았음에도 UNIQUE의 특성을 띰


-- PK 복합키 확인 --
DROP TABLE IF EXISTS order_composite_pk;
CREATE TABLE order_composite_pk (
    user_id int,
    prod_id int,
    count int DEFAULT 1,
    ordered_at DATETIME DEFAULT (CURRENT_TIMESTAMP),
    PRIMARY KEY (user_id, prod_id, ordered_at)
);

INSERT INTO order_composite_pk
VALUES (1, 1, 10, now());

INSERT INTO order_composite_pk
VALUES (2, 1, 5, now());

INSERT INTO order_composite_pk
VALUES (3, 100, default, now());
-- > PK = (user_id, prod_id, ordered_at)이기 때문에 prod_id 중복 오류가 뜨지 않음

## PK 컬럼에 중복되는 값 삽입
INSERT INTO order_composite_pk
(SELECT *
 FROM order_composite_pk
 WHERE user_id = 3);
# Duplicate entry '3' for key 'PRIMARY'


#=========================================================================

-- FOREIGN KEY (외래키) --
# 제약조건
# -> 참조된(REFERENCE) 다른 테이블에서 제공하는 값만 사용가능
# 참조 무결성 조건을 위배하지 않기 위해 사용됨
# 참조 무결성 : 데이터의 결점을 제거해 신뢰도를 높임
#   - 중복 제거 / 중복 값 필요시 참조
# 다른 테이블의 PK 또는 UNIQUE가 설정된 컬럼만 참조 가능하다
# FK 제약조건 설정 시 두 테이블 간의 관계(RELATIONSHIP)이 형성된다
#   - 부모 테이블 : 참조 당해서 컬럼 값을 제공하는 테이블
#   - 자식 테이블 : 참조를 통해 다른 테이블의 컬럼 값을 사용하는 테이블
# 제공되는 값 외에 NULL 사용 가능

## user_grade 테이블 생성
DROP TABLE IF EXISTS user_grade;

CREATE TABLE IF NOT EXISTS user_grade (
    grade_code INT NOT NULL UNIQUE,
    grade_name VARCHAR(255) NOT NULL
) ENGINE=INNODB;

INSERT INTO user_grade
VALUES
(10, '일반회원'),
(20, '우수회원'),
(30, '특별회원');

SELECT * FROM user_grade;


## FK를 사용하는 테이블 생성하기
DROP TABLE IF EXISTS user_foreignkey1;

CREATE TABLE IF NOT EXISTS user_foreignkey1 (
    user_no INT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    grade_code INT ,        -- 10,20,30,NULL만 삽입 가능
    FOREIGN KEY (grade_code)
		REFERENCES user_grade (grade_code)
) ENGINE=INNODB;

INSERT INTO user_foreignkey1
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com', 20);

SELECT * FROM user_foreignkey1;


## FK 제약조건 위배 - 부모 테이블에서 제공하지 않는 값 삽입
INSERT INTO user_foreignkey1
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(3, 'user03', 'pass03', '이순신', '남', '010-777-7777', 'lee222@gmail.com', 50);
# [23000][1452] Cannot add or update a child row: a foreign key constraint fails
# (`menudb`.`user_foreignkey1`, CONSTRAINT `user_foreignkey1_ibfk_1` FOREIGN KEY (`grade_code`) REFERENCES `user_grade` (`grade_code`))


## FK 삭제 옵션 설정
# - 기본값 : 부모 컬럼 값을 자식이 참조 중이면 변경, 삭제 불가능

# - UPDATE/DELETE SET NULL:
#   부모 컬럼 값을 자식이 참조 중이면 변경,
#   삭제 시 자식 컬럼 값을 NULL로 변경

# - UPDATE/DELETE CASCADE:
#   부모 컬럼 값을 자식이 참조 중이면 변경,
#   삭제 시 자식 테이블에서 참조값이 포함된 모든 행을 삭제

DROP TABLE IF EXISTS user_foreignkey2;

CREATE TABLE IF NOT EXISTS user_foreignkey2 (
    user_no INT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_pwd VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3),
    phone VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    grade_code INT ,
    FOREIGN KEY (grade_code)
		REFERENCES user_grade (grade_code)
        ON UPDATE SET NULL
        ON DELETE SET NULL
) ENGINE=INNODB;

INSERT INTO user_foreignkey2
(user_no, user_id, user_pwd, user_name, gender, phone, email, grade_code)
VALUES
(1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@gmail.com', 10),
(2, 'user02', 'pass02', '유관순', '여', '010-777-7777', 'yu77@gmail.com', 20);

SELECT * FROM user_foreignkey2;

## 부모 테이블의 grade_code 수정
DROP TABLE IF EXISTS user_foreignkey1;

UPDATE user_grade
SET grade_code = 50
WHERE grade_code = 10;

-- 자식 테이블의 grade_code가 10이 었던 회원의 grade_code값이 NULL이 된 것을 확인
SELECT * FROM user_foreignkey2;




## 부모 테이블의 행 삭제
DELETE FROM user_grade
WHERE grade_code = 20;

-- 자식 테이블의 grade_code가 20이 었던 회원의 grade_code값이 NULL이 된 것을 확인
SELECT * FROM user_foreignkey2;




#=================================

-- CHECK 제약조건 --
# 컬럼에 삽입될 수 있는 값에 대한 조건을 설정
DROP TABLE IF EXISTS user_check;

CREATE TABLE IF NOT EXISTS user_check (
    user_no INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    gender VARCHAR(3) CHECK (gender IN ('남','여')),
    age INT CHECK (age >= 19)
) ENGINE=INNODB;

INSERT INTO user_check
VALUES
    (null, '홍길동', '남', 25),
    (null, '이순신', '남', 33);

SELECT * FROM user_check;


## 제역조건 위배
# gender 컬럼의 CHECK 제약 조건 에러 발생 - 성별이 두 글자
INSERT INTO user_check
VALUES (null, '안중근', '남성', 27);

# age 컬럼의 CHECK 제약 조건 에러 발생 - 나이가 19세 미만
INSERT INTO user_check
VALUES (null, '유관순', '여', 17);



#=================================================================

-- ALTER TABLE --
# ALTER 테이블 수정
-- ALTER TABLE 테이블명 [서브명령어] ....
-- - ADD : 컬럼/제약조건 추가
-- - DROP : 컬럼/제약조건 삭제
-- - MODIFY : 컬럼 자료형/NOT NULL/기본값 변경
-- - CHANGE : 컬럼명 변경
-- - RENAME : 테이블명 변경

SELECT * FROM product;

## 컬럼 추가
ALTER TABLE product
    ADD description VARCHAR(255)
    NOT NULL
    DEFAULT '설명 없음'
    AFTER price;

SELECT * FROM product;

## 컬럼 삭제
ALTER TABLE product
    DROP description;

SELECT * FROM product;

## 제약조건 추가
ALTER TABLE product
    ADD UNIQUE (name);

DESC product;

## 제약조건 삭제
ALTER TABLE product
    DROP constraint name;

DESC product;

## NOT NULL 제약조건 변경(삭제)
-- NOT NULL은 MODIFY만 가능
DESC product;

ALTER TABLE product
MODIFY name VARCHAR(255) NOT NULL;  #name의 자료형까지 작성해줘야힘

## 컬럼명 변경
ALTER TABLE product
CHANGE name prod_name VARCHAR(255) NOT NULL;
# name -> prod_name


#==========================================
-- DROP : 버림 --
DROP TABLE IF EXISTS product;

DESC product;