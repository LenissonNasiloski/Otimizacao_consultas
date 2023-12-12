1  Listar os empregados (nomes) que tem salário maior que seu chefe (usar o join)



--  empregado | 
-- -----------+
--  Maria     |
--  Claudia   |
--  Ana       |
--  Luiz      |

select e.nome
from empregados e
inner join empregados chf
on (chf.emp_id = e.supervisor_id)
where e.salario > chf.salario
-- 222 msec
-- 182 msec
-- 165 msec
-- avg 189.66 msec

2 Listar o maior salario de cada departamento (usa o group by )

--  dep_id |  max  
-- --------+-------
--       1 | 10000
--       2 |  8000
--       3 |  6000
--       4 | 12200

select d.dep_id, max(e.salario)
from departamentos d
inner join empregados e
on (d.dep_id = e.dep_id)
group by d.dep_id
-- 162 msec
-- 208 msec
-- 225 msec
-- 274 msec
-- 166 msec
-- avg 207 msec


3 Listar o dep_id, nome e o salario do funcionario com maior salario dentro de cada departamento (usar o with)
--  dep_id |  nome   | salario 
-- --------+---------+---------
--       3 | Joao    |    6000
--       1 | Claudia |   10000
--       4 | Ana     |   12200
--       2 | Luiz    |    8000

select d.dep_id, e.nome, max(e.salario)
from departamentos d
inner join empregados e
on (d.dep_id = e.dep_id)
group by d.dep_id, e.nome
-- 181 msec
-- 162 msec
-- 147 msec
-- avg 163.33 msec

4 Listar os nomes departamentos que tem menos de 3 empregados;

--    nome    
-- -----------
--  Marketing
--  RH
--  Vendas
select d.nome
from departamentos d
inner join empregados e
on (d.dep_id = e.dep_id)
group by d.nome
having count(e.emp_id) < 3
-- 189 msec
-- 175 msec
-- 162 msec
-- avg 175.33 msec

5 Listar os departamentos  com o número de colaboradores

    
--    nome    | count 
-- -----------+-------
--  Marketing |     1
--  RH        |     2
--  TI        |     4
--  Vendas    |     1
select d.nome, count(e.emp_id)
from departamentos d
inner join empregados e
on (d.dep_id = e.dep_id)
group by d.nome
-- 271 msec
-- 174 msec
-- 183 msec
-- avg 302 msec


6 Listar os empregados que não possue o seu  chefe no mesmo departamento/ 

--  nome | dep_id 
-- ------+--------
--  Joao |      3
--  Ana  |      4
select e.nome, e.dep_id
from empregados chf
inner join empregados e
on (e.supervisor_id = chf.emp_id)
where chf.dep_id <> e.dep_id
-- 256 msec
-- 209 msec
-- 199 msec
-- avg 221.33 msec


7 Listar os nomes dos  departamentos com o total de salários pagos (sliding windows function)

--   sum  |   nome    
-- -------+-----------
--   6000 | Vendas
--  12200 | Marketing
--  15500 | RH
--  32500 | TI
select d.nome, sum(e.salario)
from empregados e
inner join departamentos d
on (e.dep_id = d.dep_id)
group by d.nome
-- 166 msec
-- 161 msec
-- 204 msec
-- avg 177 msec


8 Listar os nomes dos colaboradores com salario maior que a média do seu departamento (dica: usar subconsultas);

--   Nome   | Salário 
-- ---------+---------
--  Maria   |    9500
--  Claudia |   10000
--  Luiz    |    8000
select e.nome, e.salario
from empregados e
where e.salario > (select avg(salario) from empregados)
-- 166 msec
-- 164 msec
-- 199 msec
-- avg 176.33 msec

 9  Faça uma consulta capaz de listar os dep_id, nome, salario, e as médias de cada departamento utilizando o windows function;

--  dep_id |   nome    | salario |  avg  
-- --------+-----------+---------+-------
--       1 | Jose      |    8000 |  8125
--       1 | Claudia   |   10000 |  8125
--       1 | Guilherme |    5000 |  8125
--       1 | Maria     |    9500 |  8125
--       2 | Luiz      |    8000 |  7750
--       2 | Pedro     |    7500 |  7750
--       3 | Joao      |    6000 |  6000
--       4 | Ana       |   12200 | 12200
select e.dep_id, e.nome, e.salario, avg(e.salario)
over (partition by e.dep_id)
from empregados e
-- 171 msec
-- 232 msec
-- 298 msec
-- avg 233.66 msec


10 - Encontre os empregados com salario maior ou igual a média do seu departamento. 
Deve ser reportado o salario do empregado e a média do departamento (dica: usar window function com subconsulta)

--   nome   | salario | dep_id |       avg_salary       
-- ---------+---------+--------+------------------------
--  Claudia |   10000 |      1 |  8125.0000000000000000
--  Maria   |    9500 |      1 |  8125.0000000000000000
--  Luiz    |    8000 |      2 |  7750.0000000000000000
--  Joao    |    6000 |      3 |  6000.0000000000000000
--  Ana     |   12200 |      4 | 12200.0000000000000000
select e.dep_id, e.nome, e.salario, avg(e.salario)
over (partition by e.dep_id)
from empregados e
where e.salario >= (select avg(empregados.salario) from empregados)
-- 194 msec
-- 483 msec
-- 177 msec
-- avg 284.66 msec
