--��ѯ������͵�Ա��
select * from employees where salary = (select min(salary) from employees)
--��149��Ա����ͬһ�����Ź���������Ա��

select *
  from employees
 where department_id =
       (select department_id from employees where employee_id = 149)
--�Ӳ�ѯ���Ƕ��
--���202��Ա���Ĳ��ž���Ĺ��ʻ�Ҫ�ߵ�Ա��
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
--ʹ���Ӳ�ѯ��ֻ���ǵ��е���
--��ѯԱ����ţ����������ʣ������ܺ�
select employee_id, last_name, salary, sum(salary) from employees --
select employee_id, last_name, salary, (select sum(salary)  from employees) as sum from employees --��������
--��ѯ������ߵ�ǰ5��Ա������Ϣ
select rownum, e.* from employees e where rownum <= 5
order by salary desc

select * from employees order by salary desc
select * from (select * from employees order by salary desc) where rownum <=5
--��ѯԱ�����е�6����12������
--Ч�ʵ�
select rownum r, e.* from employees e
select * from (select rownum r, e.* from employees e) where r between 6 and 12
--Ч�ʸ�
select * from(select rownum r, e.* from employees e where rownum <12) --�Ӳ�ѯ��Ϊ����Դ��Ҳ���Ǳ���
where r >=6
--��ѯԱ�����й�����ߵĵ�6����12������
select * from employees order by salary desc

select * from(select rownum r, e.* from (select * from employees order by salary desc) e)
where rownum<=12

select * from(select rownum r, e.* from (select * from employees order by salary desc) e
where rownum<=12��
where r >=6
--���в�ѯ
--��ѯ�����ǲ��ž����Ա��
select * from employees where employee_id in (select manager_id from departments )
select * from employees e where e.employee_id = e.manager_id --
--��ѯ���в��ǲ��ž����Ա��
select employee_id from departments where  manager_id is not null
select * from employees where employee_id not in (select employee_id from departments where  manager_id is not null) --
--��ѯ����60�Ų����κ�һ��Ա�����ʵ�Ա��
--Any�߼���Ƚ� >any(50,60,90)
select salary from employees where department_id = 60
select * from employees where salary >any(select salary from employees where department_id = 60)
--all�߼���Ƚ� >all(50,60,90)
select * from employees where salary >all(select salary from employees where department_id = 60)
select * from employees where salary <all(select salary from employees where department_id = 60)
--���������䶼С��ѧ����Ϣ
select * from student where sage<all(select sage from student where sname='����')
--��ѯ����Ա������������3�˵Ĳ�����Ϣ
select department_id, count(*) from  employees  group by department_id having count(*)>=3

select * from departments where department_id 
in( select department_id from  employees  group by department_id having count(*)>=3)
--���⽻������Ӳ�ѯ
--��ѯԱ����ţ����������ű�ţ����ʣ������ŵĹ����ܺ�
select employee_id, last_name, department_id, salary, (select sum(salary) from employees where department_id= e.department_id) as sum_sal 
from employees e

--��ѯ���й��ʳ���������ƽ�����ʵ�Ա��
select * from employees e where salary > (select avg(salary) from employees where department_id= e.department_id)
--��ѯ�Ǳ�������ְ����ĵ����ǲ��ž����Ա��
select min(hire_date) from employees 
select * from employees e where hire_date = (select min(hire_date) from employees where department_id = e.department_id)
and employee_id not in (select manager_id from employees where manager_id is not null)
--exists��ѯ ��������inЧ�ʱ�in��
--��ѯ�����ǲ��ž����Ա�� 
--in
select * from employees where employee_id in (select manager_id from employees where manager_id is not null)
select * from employees where employee_id = manager_id --�����пյ�
--exitst
select * 
from employees e
where exists(select 'x' from departments d where e.employee_id = d.manager_id) --x �����ã�
--��ѯ�����ǲ��ž����Ա�� 
select * 
from employees e
where not exists(select 'x' from departments d where e.employee_id = d.manager_id) --*
--����ְ���Ա��
select e.last_name
from employees e
where exists(select 'x' from job_history j where e.employee_id = j.employee_id) --����������x
select 'x' from job_history j, employees e where e.employee_id = j.employee_id
--��ѯ�����гɼ���ѧ������
--��ѯ��CSϵ���䶼С��ѧ������Ϣ
--ѡ�� Ҷƽ ��ʦ���Ŀε�ѧ���У��ɼ���ߵ�ѧ����������ɼ�
