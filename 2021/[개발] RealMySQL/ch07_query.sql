## SQL 모드
show variables like 'sql_mode';

## 문자열 표시
SELECT * FROM departments WHERE dept_no = 'd001';
SELECT * FROM departments WHERE dept_no = "d001";

SELECT 'd''001', 'd"001', "d'001", "d""001";


## Null 체크
SELECT NULL = NULL;
SELECT CASE WHEN NULL = NULL THEN 1 ELSE 0 END;
SELECT CASE WHEN NULL IS NULL THEN 1 ELSE 0 END;

SELECT  'abc' REGEXP '^[x-z]';
select null is null;

SELECT 'aec' LIKE 'a__';

explain SELECT 1=1, null=null, null=1;
explain SELECT 1<=>1, null<=>null, null<=>1;

select IFNULL(null, 3); ## 3
select IFNULL(0, 3); ## 0
select isnull(3); ## 0
select isnull(3/0); ## 1

select sysdate(), sleep(2), sysdate();
select now(), sleep(2), now();

EXPLAIN SELECT * FROM dept_emp USE INDEX (`PRIMARY`)
WHERE dept_no BETWEEN 'd003' AND 'd005' and emp_no = 10001;

EXPLAIN SELECT * FROM dept_emp USE INDEX (`PRIMARY`)
WHERE dept_no in ('d003','d004','d005') and emp_no = 10001;


## 날짜와 시간의 포멧
select date_format(now(), '%Y-%m-%d %H');
select str_to_date('2021-02-19 15:34:33', '%Y-%m-%d %H:%i:%s');

## 날짜와 시간의 연산
select now(), date_add(now(), interval 1 day);
select now(), date_add(now(), interval -5 minute);

## 타임 스탬프 연산
select unix_timestamp(), unix_timestamp(date_add(now(), interval -1 minute)), from_unixtime(unix_timestamp());

## 문자열 처리
select rpad('rtest', 10, '_'), lpad('ltest', 10, '-');
select replace(ltrim('     hi    '),' ', '_'), replace(rtrim('     hi    '),' ', '_'), replace(trim('     hi    '),' ', '_')

## 문자열 결합
select concat('hi, ', 'my name is', ' youngchul') as name, concat('born ', 1984), concat(cast(38 as char), ' years old')
select concat_ws(',', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

## Group by 문자열 결합
show variables where Variable_name = 'group_concat_max_len';

## 값 비교와 대체
SET @gender = 'M';
select @gender,
       case @gender when 'M' then 'Man'
                    when 'W' then 'Woman'
                    else 'Unknown'
       end as longGender;

select now(),
       case when now() < '2021-01-01 00:00:00' then 'old'
            else 'new'
       end;

## 타입의 전환(CAST, CONVERT)
select cast('1234' as signed integer) as converted_integer, cast('2000-01-01' as date) as converted_date,
       1 - 2, cast(1 - 2 as unsigned );

## 암호화 및 해시 함수(MD5, SHA)
select MD5('abc'), sha('abc'), sha1('abc'), sha2('abc', 224);

## 처리 대기(sleep)
select sleep(10);

## Benchmark
select benchmark(100000, md5('abcdef'));

## IP 주소 변환
create table tab_acesslog(access_dttm datetime, ip_addr integer unsigned);
insert into tab_acesslog values (now(), inet6_aton('127.0.0.130'));

## 암호화
SELECT PASSWORD('mypass');

## 주석
-- 한줄 주석
/*
 여러줄 주석
 주석~~~
 */
# 이것도 한줄 주석

# SELECT
## where 절 인덱스 사용
CREATE TABLE tb_test (age VARCHAR(10), INDEX idx_age(age));
INSERT INTO tb_test VALUES ('1'),('2'),('3'),('4'),('5'),('6'),('7');
explain SELECT * FROM tb_test WHERE age = 2;
explain SELECT * FROM tb_test WHERE age = '2';
DROP TABLE tb_test;

explain SELECT * FROM employees WHERE first_name='Sumant' OR last_name='Staudhammer';

## null 비교
SELECT NULL = NULL,
       CASE WHEN NULL = NULL THEN 1 ELSE 0 END,
       IF(NULL IS NULL, 1, 0);

EXPLAIN SELECT * FROM titles WHERE to_date IS NULL;
EXPLAIN SELECT * FROM titles WHERE ISNULL(to_date);
EXPLAIN SELECT * FROM titles WHERE ISNULL(to_date) = true;

## 문자, 숫자 비교
EXPLAIN SELECT * FROM employees WHERE emp_no = 10001;
EXPLAIN SELECT * FROM employees WHERE first_name = 'Smith';
EXPLAIN SELECT * FROM employees WHERE emp_no = '10001';
EXPLAIN SELECT * FROM employees WHERE first_name = 10001;

## 날짜 비교
SELECT DATE(NOW()), NOW();

EXPLAIN SELECT COUNT(*) FROM employees WHERE hire_date < '2011-07-23 11:10:12';
EXPLAIN SELECT COUNT(*) FROM employees WHERE hire_date < UNIX_TIMESTAMP();
EXPLAIN SELECT COUNT(*) FROM employees WHERE hire_date < FROM_UNIXTIME(UNIX_TIMESTAMP());

## Distinct
### 개별 선택
EXPLAIN SELECT DISTINCT emp_no FROM salaries;
EXPLAIN SELECT emp_no FROM salaries GROUP BY emp_no;

SELECT DISTINCT(first_name), last_name FROM employees;
SELECT DISTINCT first_name, last_name FROM employees;

### 집합 선택
EXPLAIN SELECT COUNT(DISTINCT s.salary) FROM employees e, salaries s WHERE e.emp_no = s.emp_no AND e.emp_no BETWEEN 100001 AND 100100;
SELECT DISTINCT first_name, last_name FROM employees WHERE emp_no BETWEEN 10001 AND 10200;
SELECT COUNT(DISTINCT first_name), COUNT(DISTINCT last_name) FROM employees WHERE emp_no BETWEEN 10001 AND 10200;
SELECT COUNT(DISTINCT first_name, last_name) FROM employees WHERE emp_no BETWEEN 10001 AND 10200;

## LIMIT
EXPLAIN SELECT * FROM employees WHERE emp_no BETWEEN 10001 AND 10010 ORDER BY first_name LIMIT 0, 10;
EXPLAIN SELECT * FROM employees LIMIT 0, 10;
SELECT DISTINCT first_name FROM employees LIMIT 0, 10;
EXPLAIN SELECT first_name FROM employees GROUP BY first_name LIMIT 0, 10;

## JOIN
EXPLAIN SELECT * FROM employees e, dept_emp de WHERE e.emp_no = de.emp_no;

EXPLAIN SELECT * FROM employees e LEFT JOIN dept_manager mgr ON e.emp_no = mgr.emp_no WHERE mgr.dept_no = 'd001';
EXPLAIN SELECT * FROM employees e LEFT JOIN dept_manager mgr ON e.emp_no = mgr.emp_no AND mgr.dept_no = 'd001';


### ANTI JOIN
CREATE TABLE tab_test1(id INT, PRIMARY KEY(id));
CREATE TABLE tab_test2(id INT);
INSERT INTO tab_test1 VALUES (1),(2),(3),(4);
INSERT INTO tab_test2 VALUES (1),(2);

EXPLAIN SELECT t1.id FROM tab_test1 t1 WHERE t1.id NOT IN (SELECT t2.id FROM tab_test2 t2);
EXPLAIN SELECT t1.id FROM tab_test1 t1 LEFT JOIN tab_test2 t2 ON t1.id = t2.id WHERE t2.id IS NULL;

### Inner join, Outer Join
explain select sql_no_cache  straight_join count(*)
from dept_emp de
inner join employees e on de.emp_no = e.emp_no;

explain select sql_no_cache  straight_join count(*)
from dept_emp de
left join employees e on de.emp_no = e.emp_no;

### Delayed Join
explain select * from dept_emp de, employees e where de.dept_no = 'd001' and e.emp_no = de.emp_no limit 10;
explain select * from dept_emp de, employees e where de.dept_no = 'd001' and e.emp_no = de.emp_no limit 100, 10;
explain select * from (select * from dept_emp where dept_no = 'd001' limit 100, 10) de, employees e where e.emp_no = de.emp_no;

## Group by
select first_name, last_name, count(*) from employees group by first_name order by last_name

select  first_name from employees group by gender;
select first_name, last_name, count(*) from employees group by first_name, last_name order by last_name

### Group by Order by null
create index employees_idx_from_date on salaries (from_date);
explain select from_date from salaries group by from_date;
explain select from_date from salaries group by from_date order by null;

### Group by with rollup
select dept_no, count(*) from dept_emp group by dept_no with rollup ;
select first_name, last_name, count(*) from employees group by first_name, last_name with rollup ;

## Order by
select first_name, last_name from employees order by 'ycshin';
explain select first_name, last_name from employees order by rand();

explain SELECT * FROM employees ORDER BY emp_no;
explain SELECT * FROM employees ORDER BY emp_no+10;

## sub query
### 상관 서브쿼리
explain
select *
from employees e
where exists(
    select 1
    from dept_emp de
    where de.emp_no = e.emp_no
      and de.from_date between '2000-01-01' and '2011-12-30');


UPDATE departments
SET dept_name = (SELECT CONCAT(dept_name, '2') FROM departments WHERE dept_no='d009')
WHERE dept_no='d001';

### select sub query
select emp_no, (select dept_name from departments where dept_name = 'Sales1')
from dept_emp
limit 10;

select emp_no, (select dept_name from departments)
from dept_emp
limit 10;

select emp_no, (select dept_no, dept_name from departments where dept_name = 'Sales1')
from dept_emp
limit 10;

explain
select sql_no_cache
    count(concat(e1.first_name, (select e2.first_name from employees e2 where e2.emp_no = e1.emp_no)))
from employees e1;

explain
select sql_no_cache
    count(concat(e1.first_name, e2.first_name))
from employees e1, employees e2
where e1.emp_no = e2.emp_no;

create index employees_idx_first_name on employees (first_name);
explain
select * from dept_emp de
where de.emp_no =
    (select emp_no
     from   employees
     where first_name = 'Georgi'
       and last_name = 'facello' limit 1);

### where in subquery
explain
select * from dept_emp de
where de.dept_no in (
    select dept_no from departments where dept_name = 'Finance');

### from subquery
Created_tmp_disk_tables,0
Created_tmp_files,32
Created_tmp_tables,6

show status like 'Created_tmp%';
explain
select sql_no_cache * from (
  select *
  from (
   select *
   from employees
   where emp_no in (10001, 10002, 10010, 10201)) x
) y;

## Union
explain
selecT sql_no_cache * from employees where emp_no between 10001 and 200000
union distinct
selecT sql_no_cache * from employees where emp_no between 200001 and 500000;

explain
selecT sql_no_cache * from employees where emp_no between 10001 and 200000
union all
selecT sql_no_cache * from employees where emp_no between 200001 and 500000;