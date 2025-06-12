-- Where Clause

select *
from parks_and_recreation.employee_salary
where first_name = 'Leslie';

select *
from parks_and_recreation.employee_salary
where salary > 50000;

select *
from parks_and_recreation.employee_salary
where salary < 50000;

select *
from parks_and_recreation.employee_demographics
where gender = 'Female';

select *
from parks_and_recreation.employee_demographics
where gender != 'Female';

select *
from parks_and_recreation.employee_demographics
where birth_date > 1985-01-01;

-- logical opperatios: AND OR NOT
select *
from parks_and_recreation.employee_demographics
where birth_date > 1985-01-01
and gender = 'male'; # for and operator, both statements must be true.

select *
from parks_and_recreation.employee_demographics
where birth_date > 1985-01-01
or gender = 'male'; # for or operator, either statements must be true.

select *
from parks_and_recreation.employee_demographics
where birth_date > 1985-01-01
or not gender = 'male'; # birthday greater than 1985 or not equal to male

select *
from parks_and_recreation.employee_demographics
where (first_name  = 'Leslie' and age = 44) or age > 55;

-- LIKE statement
select *
from parks_and_recreation.employee_demographics
where first_name = 'Jerry';

select *
from parks_and_recreation.employee_demographics
where first_name like '%er%'; # % means there can be anything after and before 'er'

select *
from parks_and_recreation.employee_demographics
where first_name like 'A%'; # % means there can be anything after 'a'

select *
from parks_and_recreation.employee_demographics
where first_name like 'a__'; # _ means there can be that many numeber of character