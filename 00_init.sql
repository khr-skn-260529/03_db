# 계정 생성
create user skn_ai@'%' identified by '1234';
# 계정명: skn_ai / 비밀번호: 1234

# MySQL에서는 database와 schema가 같은 의미로 사용
# - database : 데이터 창고
# - schema : 창고 설계도, 구조

# 데이터베이스(데이터 저장 공간) 생성
create database menudb;
# 스키마 생성
create schema employeedb;

show databases;

# 권한 부여
grant all privileges on menudb.* to skn_ai@'%';
grant all privileges on employeedb.* to skn_ai@'%';

show grants for skn_ai@'%';     #skn_ai 계정에 부여된 권한 목록 조회



