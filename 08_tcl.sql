-- TCL (Transaction Control Language) --

# - 트랜젝션 제어 언어
# - COMMIT, ROLLBACK, SAVEPOINT, ...

# Transaction이란?
# - 한 번에 수행된 DML 논리적 작업 단위
# - 하나의 트렌젝션을 이용해서 관련 작업을 한 번에 완료
#   또는 취소할 수 있게하기 위해서 사용됨

-- ==========================================
# MySQL은 기본적으로 AutoCommit 활성화 상태

SET autocommit = ON;    # AutoCommit 활성화
SET autocommit = OFF;   # AutoCommit 비활성화

-- COMMIT --
# : DML로 인한 변경 사항(Transaction)을 DB에 반영

-- ROLLBACK --
# : DML 변경 사할 취소(Transaction 내부 내용 폐기)

# Transaction 시작 = 이후 실행되는 DML 구문을 트랜젝션에 저장하겠다
# Transaction 종료 = COMMIT, ROLLBACK
START TRANSACTION;      # autocommit이 활성화 되어도 사용 가능
                        # 안전장치처럼 꼭 쓰는 것을 권장
-- ------------
## 조회
SELECT *
FROM tbl_menu;

## 행 수정 (판매 가능 여부 'Y' -> 'N')
UPDATE tbl_menu
SET
    orderable_status = 'N'
WHERE menu_code=21;

## 행 삭제
DELETE
FROM tbl_menu
WHERE menu_code=20;

## 행삽입
INSERT INTO tbl_menu
VALUES (null,
        'TX테스트',
        3000,
        5,
        'N')

## 변경 반영 여부 확인
SELECT *
FROM tbl_menu;
# 수정 후 COMMIT을 수행하지 않았는데 조회 시 수정 내용이 반영된 것처럼 보이는 이유
# : 실제 DB에 반영은 안됐지만, 조회 시 트랜젝션에 저장된 DML 구문을 반영해서 보여줌

## 변경 사항 폐기
ROLLBACK ;

##조회 확인
SELECT *
FROM tbl_menu;
# 변경사항 폐기된 것을 확인할 수 있음


## menu_code = 100 삭제 후 DB 반영
DELETE
FROM tbl_menu
WHERE menu_code = 100;

COMMIT;
SELECT *
FROM tbl_menu;

# commit된 내용은 rollback될까?
# => No
ROLLBACK;
SELECT *
FROM tbl_menu;

