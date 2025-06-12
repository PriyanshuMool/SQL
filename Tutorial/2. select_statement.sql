select *
from parks_and_recreation.employee_demographics;


select first_name, last_name, birth_date, age, age + 10, (age + 10) * 10, (age + 10) * 10 + 10
from parks_and_recreation.employee_demographics;
# PEMDAS: Parenthesis, Exponent, Multiplication, Division, Addition, Subtraction: the order in which these calculations are going to run

# DISTINCT
select distinct gender # only two unique values
from parks_and_recreation.employee_demographics;

select distinct first_name, gender
from parks_and_recreation.employee_demographics;