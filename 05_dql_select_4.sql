-- 내장 함수 --
# - MySQL, DBMS에 이미 구현된 함수
# - 문자형, 숫자형, 날짜형별 함수가 따로 제공
# -  반드시 반환 값을 갖는다

-- ============= --
-- 문자열 관련 함수 --
-- ============= --

# - ASCII: 문자 -> 아스키 코드 값 추출
# - CHAR: 아스키 코드 -> 문자 추출
SELECT ASCII('A'), CHAR(65);

# - BIT_LENGTH: 할당된 비트 크기 반환
# - CHAR_LENGTH: 문자열의 길이 반환
# - LENGTH: 할당된 BYTE 크기 반환
SELECT BIT_LENGTH('pie'),   # 비트 크기
       CHAR_LENGTH('pie'),  # 문자열 길이
       LENGTH('pie');       # 바이트 크기

SELECT menu_name,
       BIT_LENGTH(menu_name),
       CHAR_LENGTH(menu_name),
       LENGTH(menu_name)
FROM tbl_menu;
# 문자 인코딩 : 컴퓨터에서 문자를 표시하는 방법
# UTF-8 : 아스키코드 문자는 1byte, 나머지는 3byte로 표시(MySQL은 UTF-8 차용)
# UTF-16 : 모든 문자를 2byte(16bit)로 표시

# - CONCAT: 문자열을 이어붙임
# - CONCAT_WS: 구분자와 함께 문자열을 이어붙임
SELECT CONCAT('호랑이', '기린', '토끼');
SELECT CONCAT_WS(',', '호랑이', '기린', '토끼');
SELECT CONCAT_WS('-', '2023', '05', '31');

# - INSTR(기준문자열, 부분(검색)문자열) :
#   기준 문자열에서 부분 문자열의 시작 위치 반환
SELECT INSTR('사과딸기바나나','딸기');   # 3
SELECT INSTR('사과딸기바나나','포도');   # 0(없음)

# 메뉴 테이블에서 메뉴명에 '마늘'이 포함된 메뉴만 조회
SELECT *
FROM tbl_menu
WHERE
#    menu_name LIKE '%마늘%';
    INSTR(menu_name,'마늘') > 0;

# - LPAD: 문자열을 길이만큼 왼쪽으로 늘린 후에 빈 곳을 문자열로 채운다.
# - RPAD: 문자열을 길이만큼 오른쪽으로 늘린 후에 빈 곳을 문자열로 채운다.
SELECT LPAD('왼쪽', 6, '@'),
       RPAD('오른쪽', 6 ,'@');

# - SUBSTRING: 시작 위치부터 길이만큼의 문자를 반환
#              (길이를 생략하면 시작 위치부터 끝까지 반환)
SELECT SUBSTRING('안녕하세요 반갑습니다.', 7, 2),
       SUBSTRING('안녕하세요 반갑습니다.', 7),
       SUBSTRING('안녕하세요 반갑습니다.',
                 INSTR('안녕하세요 반갑습니다','반갑')
       );



-- =========== --
-- 수학 관련 함수 --
-- =========== --

# - CEILING: 올림한 정수값 반환
# - FLOOR: 내림한 정수값 반환
# - ROUND: 반올림한 정수값 반환
# - TRUNCATE: 지정된 소수점 아래로 버림
SELECT CEILING(1234.56),
       FLOOR(1234.56),
       ROUND(1234.56),
       TRUNCATE(1234.56,0);

SELECT CEILING(-1.5),        #-1
       FLOOR(-1.5),          #-2
       ROUND(-1.5),          #-2
       TRUNCATE(-1.5,0);     #-1

SELECT TRUNCATE(1234.56,1);  #1234.5
SELECT TRUNCATE(1234.56,0);  #1234
SELECT TRUNCATE(1234.56,-1); #1230
SELECT TRUNCATE(1234.56,-2); #1200

# RAND : 0이상 1 미만의 난수(실수) 반환
SELECT RAND(), RAND(), RAND();
# 1~45 사이 난수 1개 조회
# 0.0 <= RAND() < 1.0
# 0.0 * 45 <= RAND() * 45 < 1.0 * 45
# -> 0.0 <= RAND() * 45 < 45
# 0.0 + 1 <= RAND() * 45 + 1 < 45 +1
# -> 1 <= RAND() * 45 + 1 <= 46
# 1 <= FLOOR(RAND() * 45 + 1) <= 46
# => 1~45 사이의 정수 난수
SELECT FLOOR(RAND() * 45 + 1);


-- ============ --
-- 날짜 관련 함수 --
-- ============ --

# - NOW() : 현재시간
# - ADDADTE(date, 일수) : 날짜를 기준으로 차이를 더함
# - SUBDATE(date, 일수): 날짜를 기준으로 날짜를 뺌
SELECT
    NOW(),
    ADDDATE(NOW(), 1),
    SUBDATE(NOW(), 1),
    ADDDATE(NOW(), INTERVAL 1 MONTH ),
    SUBDATE(NOW(), INTERVAL 1 MONTH);

# - DATEDIFF : 날짜1 - 날짜2의 일수를 반환
# - TIMEDIFF : 시간1 - 시간2
SELECT
    DATEDIFF('2026-11-20', NOW()),
    TIMEDIFF('17:07:11','13:06:10');

# EXTRACT(단위 from date)
# - date에서 해당하는 단위 추출 -> bigint(숫자) 형태
# - 단위: year, quarter, month,
#    week, day, hour, minute, second, microsecond
SELECT
    NOW(),
    EXTRACT(YEAR FROM NOW()),
    EXTRACT(MONTH FROM NOW()),
    EXTRACT(DAY FROM NOW());

# DATE_FORMAT(datetime, 형식문자열) -> 문자열
SELECT
    DATE_FORMAT(NOW(), '%y/%m/%d'),
    DATE_FORMAT(NOW(), '%Y/%m/%d'),
    DATE_FORMAT(NOW(), '%h:%i');

# STR_TO_DATE(문자열, 형식문자열) -> datetime
SELECT
    STR_TO_DATE('25/04/21', '%y/%m/%d'),
    STR_TO_DATE('2025/04/21', '%Y/%m/%d'),
    CAST('2025/04/21' AS DATE); -- 날짜시간형식 유추가 가능한 경우
    # CAST([ ] AS [type]) : 타입 변환 함수


-- ======= --
-- 기타 함수 --
-- ======= --

# null처리 함수 - IFNULL(값, null일때 값)
SELECT
    IFNULL(ref_category_code, '미지정') category_code
FROM
    tbl_category;

# 삼항연산처리 - IF(조건식, 참일때 값, 거짓일때 값)
SELECT
    ISNULL(category_code),
    IF(ISNULL(category_code), '미지정', category_code) category_code
FROM
    tbl_menu;

SELECT
    menu_name,
    menu_price,
    IF(menu_price < 10000, '싼', '비싼') price_clf
FROM
    tbl_menu;