import psycopg2
import os
import timeit
import csv

path_nssm = 'nssm.exe'
csvfile = open('out.csv', 'w', encoding='UTF-8', newline='')
writer = csv.writer(csvfile)
header = ['idquestao', 'tempo']
writer.writerow(header)
def create_connection():
	# Connect to the PostgreSQL database
	conn = psycopg2.connect(
		host="localhost",
		database="dojo",
		user="postgres",
		password="postgres"
	)
	#conn.set_session(autocommit=False)
	# Create a cursor
	cur = conn.cursor()
	return conn,cur

def execTest(query, tamAmostra, idQuestao):
	i = 0
	while i < tamAmostra:
		try:
			conn, cur = create_connection()
			print(f'execTest {i+1}')
			t = timeit.Timer(lambda: cur.execute(query))
			time = t.timeit(1)
			print(time)
			#reinicia o serviço do postgres
			os.system(f'{path_nssm} restart postgresql-x64-16')
			writer.writerow([idQuestao, time])
			i += 1
		finally:			
			cur.close()
			conn.close()


# execTest(
# 	'''WITH salariomaxdep
#  AS
#   (
# select e.dep_id, max(e.salario) salario
# from empregados e
# group by e.dep_id
#  )
# select e.dep_id, e.nome, sl.salario
# from empregados e
# 	 inner join salariomaxdep sl
# 	 on (sl.dep_id = e.dep_id
# 	 and sl.salario = e.salario)
# ''',
# 	5,
# 	3
# )
execTest(
	'''select e.nome, e.dep_id
	from empregados chf
	inner join empregados e
	on (e.supervisor_id = chf.emp_id)
	where chf.dep_id <> e.dep_id''',
	5,
	6
)
# execTest(
# 	'''WITH salariomedio
# AS
#  (
# SELECT distinct emp.dep_id, avg(emp.salario) as salariom
# FROM empregados emp
# group by emp.dep_id
# )
# select e.dep_id, e.nome, e.salario, sm.salariom
# from empregados e
# 	 inner join salariomedio sm
# 	 on sm.dep_id = e.dep_id''',
# 	5,
# 	9
# )

csvfile.close()