--求出所有部门里面工资在平均工资之上的员工
select ename, sal from emp where sal > (select avg(sal) from emp)]
--查询按部门分组后工资最高的人的姓名和工资
select ename, sal from emp where sal = (select max(sal) from emp) group by emp.deptno
select max(sal) max_sal, deptno from emp group by deptno
select ename, sal from emp join (select max(sal) max_sal, deptno from emp t group by deptno) t --*
on (emp.deptno = t.deptno and emp.sal = t.max_sal )--查询的结果是一张表，可以被join，子查询作为表
--查选修了两门课以上的学生姓名 having必须跟group by 配对，针对的是组操作
select sname from student join sc on student.sno = sc.sno group by sc.sno having (count(sc.sno)>=2) --
select sno from sc group by sno having(count(sno)) >=2
select sname from student where sno in (select sno from sc group by sno having count(sno) >=2)
--统计每年入职的人数，年份，人数（仅返回入职不少于2人的年份信息）
--group by:过滤分组之前的数据 having：过滤分组之后的数据
select 年份, 人数 from employees --
select to_char(hire_date, 'yyyy') 年份, count(*) 人数 from employees group by to_char(hire_date, 'yyyy') 
having count(*) >=2
order by 1 --按第一列排
--查每个部门的ID，及员工工资总额大于3万的
select count(*), department_id, sum(salary) sal_sum 
from employees
where department_id is not null
group by department_id
having sum(salary) >=30000
order by department_id
--分析函数 over
select employee_id, salary, department_id, salary,
sum(salary) over(order by employee_id) over1, --连续求和
sum(salary) over() over2
from employees

--连续求和 ，
select employee_id, salary, department_id, salary,
sum(salary) over(partition by employee_id) over1, 
sum(salary) over(order by department_id) over2,
sum(salary) over((partition by employee_id order by department_id) over3
from employees
--子查询：
