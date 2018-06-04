--查询工资最低的员工
select * from employees where salary = (select min(salary) from employees)
--和149号员工在同一个部门工作的其他员工

select *
  from employees
 where department_id =
       (select department_id from employees where employee_id = 149)
--子查询多层嵌套
--查比202号员工的部门经理的工资还要高的员工
select department_id from employees where employee_id =202

select manager_id from employees where department_id 
=(select department_id from employees where employee_id =202)

select salary from employees where employee_id = (select manager_id from employees where department_id 
=(select department_id from employees where employee_id =202))

select *
  from employees
 where salary > (select salary
                   from employees
                  where employee_id =
                        (select manager_id
                           from departments --*
                          where department_id =
                                (select department_id
                                   from employees
                                  where employee_id = 202)))
--使用子查询，只能是单行单列
--查询员工编号，姓名，工资，工资总和
select employee_id, last_name, salary, sum(salary) from employees --
select employee_id, last_name, salary, (select sum(salary)  from employees) as sum from employees --单独成列
--查询工资最高的前5名员工的信息
select rownum, e.* from employees e where rownum <= 5
order by salary desc

select * from employees order by salary desc
select * from (select * from employees order by salary desc) where rownum <=5
--查询员工表中第6条到12条数据
--效率低
select rownum r, e.* from employees e
select * from (select rownum r, e.* from employees e) where r between 6 and 12
--效率高
select * from(select rownum r, e.* from employees e where rownum <12) --子查询作为数据源，也就是表名
where r >=6
--查询员工表中工资最高的第6条到12条数据
select * from employees order by salary desc

select * from(select rownum r, e.* from (select * from employees order by salary desc) e)
where rownum<=12

select * from(select rownum r, e.* from (select * from employees order by salary desc) e
where rownum<=12）
where r >=6
--多行查询
--查询所有是部门经理的员工
select * from employees where employee_id in (select manager_id from departments )
select * from employees e where e.employee_id = e.manager_id --
--查询所有不是部门经理的员工
select employee_id from departments where  manager_id is not null
select * from employees where employee_id not in (select employee_id from departments where  manager_id is not null) --
--查询大于60号部门任何一个员工工资的员工
--Any逻辑或比较 >any(50,60,90)
select salary from employees where department_id = 60
select * from employees where salary >any(select salary from employees where department_id = 60)
--all逻辑或比较 >all(50,60,90)
select * from employees where salary >all(select salary from employees where department_id = 60)
select * from employees where salary <all(select salary from employees where department_id = 60)
--比刘晨年龄都小的学生信息
select * from student where sage<all(select sage from student where sname='刘晨')
--查询所有员工人数不少于3人的部门信息
select department_id, count(*) from  employees  group by department_id having count(*)>=3

select * from departments where department_id 
in( select department_id from  employees  group by department_id having count(*)>=3)
--内外交互相关子查询
--查询员工编号，姓名，部门编号，工资，本部门的工资总和
select employee_id, last_name, department_id, salary, (select sum(salary) from employees where department_id= e.department_id) as sum_sal 
from employees e

--查询所有工资超过本部门平均工资的员工
select * from employees e where salary > (select avg(salary) from employees where department_id= e.department_id)
--查询是本部门入职最早的但不是部门经理的员工
select min(hire_date) from employees 
select * from employees e where hire_date = (select min(hire_date) from employees where department_id = e.department_id)
and employee_id not in (select manager_id from employees where manager_id is not null)
--exists查询 用来代替in效率比in高
--查询所有是部门经理的员工 
--in
select * from employees where employee_id in (select manager_id from employees where manager_id is not null)
select * from employees where employee_id = manager_id --可能有空的
--exitst
select * 
from employees e
where exists(select 'x' from departments d where e.employee_id = d.manager_id) --x 是引用？
--查询所有是部门经理的员工 
select * 
from employees e
where not exists(select 'x' from departments d where e.employee_id = d.manager_id) --*
--换过职务的员工
select e.last_name
from employees e
where exists(select 'x' from job_history j where e.employee_id = j.employee_id) --存在这样的x
select 'x' from job_history j, employees e where e.employee_id = j.employee_id
--查询所有有成绩的学生姓名
--查询比CS系年龄都小的学生的信息
--选修 叶平 老师代的课的学生中，成绩最高的学生姓名及其成绩
