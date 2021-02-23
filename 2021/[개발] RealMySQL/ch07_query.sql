create table tb_boolean(bool_value boolean);

select *
from tb_boolean
where bool_value = FALSE

insert into tb_boolean value (44);
insert into tb_boolean value (FALSE);

select null is null
explain select 1=1, null<=>null, null<=>1;

select IFNULL(null, 3);
select isnull(3);

select now(), sleep(2), sysdate();

select now();


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


