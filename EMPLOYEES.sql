use employees;
-- Conteo General: ¿Cuántos empleados hay en total en la base de datos?
select * from employees;
select count(emp_no) as NumeroDeEmpleados from employees;
-- Salarios Extremos: ¿Cuál es el salario más alto y el salario más bajo que se ha pagado en la historia de la empresa?
select max(salary) as SalarioMasAlto,min(salary) as SalarioMasBajo from salaries;
-- Promedio Salarial: ¿Cuál es el salario promedio de todos los empleados?
select round(avg(salary)) as PromedioSalarial from salaries;
-- Agrupación por Género: Genera un reporte que muestre cuántos empleados hay de cada género (M y F).
SELECT gender AS Genero, COUNT(*) AS Empleados FROM employees GROUP BY gender;
-- Conteo de Cargos: ¿Cuántos empleados han ostentado cada cargo (title) a lo largo del tiempo? Ordena los resultados del cargo más común al menos común.
select title as cargos, count(*) as OrdenCargos from titles group by title order by OrdenCargos desc;
-- Filtro de Grupos con HAVING: Muestra los cargos que han sido ocupados por más de 75,000 personas.
select title as cargos, count(*) as OrdenCargos from titles group by title having count(*) > 75000 order by OrdenCargos desc;
-- Agrupación Múltiple: ¿Cuántos empleados masculinos y femeninos hay por cada cargo?
select title as Cargo, gender as Genero, count(*) as TodosLosEmpleados FROM titles JOIN employees ON titles.emp_no = employees.emp_no group by title , gender;
-- Nombres de Departamentos: Muestra una lista de todos los empleados (emp_no,first_name) junto al nombre del departamento en el que trabajan actualmente.
select e.emp_no, e.first_name, de.dept_name from employees e join dept_emp d on e.emp_no = d.emp_no join departments de on d.dept_no = de.dept_no;
-- Empleados de un Departamento Específico: Obtén el nombre y apellido de todos los empleados que trabajan en el departamento de "Marketing".
select e.first_name, e.last_name, dept_name from employees e join dept_emp de on e.emp_no = de.emp_no join departments d on de.dept_no = d.dept_no where d.dept_name = 'Marketing';
-- Gerentes Actuales: Genera una lista de los gerentes de departamento(managers) actuales, mostrando su número de empleado, nombre completo y el nombre del departamento que dirigen.
select e.emp_no, e.first_name , e.last_name, d.dept_name from  employees e join dept_manager dm on e.emp_no = dm.emp_no join departments d on dm.dept_no = d.dept_no;
-- Salario por Departamento: Calcula el salario promedio actual para cada departamento. El reporte debe mostrar el nombre del departamento y su salario promedio.
select avg(salary), d.dept_name from salaries join employees e on salaries.emp_no = e.emp_no join dept_emp de on e.emp_no = de.emp_no join departments d on de.dept_no = d.dept_no group by d.dept_name;
-- Historial de Cargos de un Empleado: Muestra todos los cargos que ha tenido el empleado número 10006, junto con las fechas de inicio y fin de cada cargo.
select title, emp_no, to_date, from_date from titles where emp_no = 10006;
-- Departamentos sin Empleados (LEFT JOIN): ¿Hay algún departamento que no tenga empleados asignados? (Esta consulta teórica te ayudará a entender left JOIN).
select * from departments d LEFT JOIN dept_emp de ON d.dept_no = de.dept_no where de.dept_no is null group by d.dept_name;
-- Salario Actual del Empleado: Obtén el nombre, apellido y el salario actual de todos los empleados.
select s.salary, e.first_name, e.last_name from salaries s join employees e on s.emp_no = e.emp_no where s.to_date = '9999-01-01';
-- Salarios por Encima del Promedio: Encuentra a todos los empleados cuyo salario actual es mayor que el salario promedio de toda la empresa.
SELECT e.first_name, e.last_name, s.salary FROM employees e JOIN salaries s ON e.emp_no = s.emp_no WHERE s.to_date = '9999-01-01' AND s.salary > (select avg(salary) from salaries where to_date = '9999-01-01') order by s.salary desc;
-- Nombres de los Gerentes: Usando una subconsulta con IN, muestra el nombre y apellido de todas las personas que son o han sido gerentes de un departamento.
select e.first_name as Nombre, e.last_name as Apellido from  employees e where emp_no in(select emp_no from dept_manager);
-- Empleados que no son Gerentes: Encuentra a todos los empleados que nunca han sido gerentes de un departamento, usando NOT IN.
select e.first_name as Nombre, e.last_name as Apellido from  employees e where e.emp_no not in(select emp_no from dept_manager);
-- Último Empleado Contratado: ¿Quién es el último empleado que fue contratado? Muestra su nombre completo y fecha de contratación.
select e.first_name as Nombre, e.last_name as Apellido, e.hire_date as ultimoContratado from  employees e order by e.hire_date desc limit 1;
-- Jefes del Departamento de "Development": Obtén los nombres de todos los gerentes que han dirigido el departamento de "Development".
select e.first_name as Nombre, e.last_name as Apellido, d.dept_name as Departamento from  employees e join dept_manager dm on dm.emp_no = e.emp_no join departments d on dm.dept_no = d.dept_no where d.dept_name = 'Development';
-- Empleados con el Salario Máximo: Encuentra al empleado (o empleados) que tiene el salario más alto registrado en la tabla de salarios.
select emp_no as empleados, salary as SalarioMaximo from salaries where salary = (select max(salary) from salaries);
-- Nombres Completos: Muestra una lista de los primeros 100 empleados con su nombre y apellido combinados en una sola columna llamada nombre_completo.
select concat(first_name,' ',last_name) as Nombre_Completo from employees limit 100;
-- Antigüedad del Empleado: Calcula la antigüedad en años de cada empleado (desde hire_date hasta la fecha actual). Muestra el número de empleado y su antigüedad.
select emp_no, timestampdiff (year, hire_date, CURDATE()) as Antiguedad from employees;
-- Categorización de Salarios con CASE: Clasifica los salarios actuales de los empleados en tres categorías:
-- o 'Bajo': si es menor a 50,000.
-- o 'Medio': si está entre 50,000 y 90,000.
-- o 'Alto': si es mayor a 90,000.
select emp_no as NumeroEmpleado, salary as Salario, case when salary < 50000 then 'Bajo' when salary between 50000 and 90000 then 'Medio' when salary > 90000 then 'Alto' else null end as Categoria from salaries;
-- Mes de Contratación: Genera un reporte que cuente cuántos empleados fueron contratados en cada mes del año (independientemente del año).
select month(hire_date) as Mes, count(*) as NumeroDeEmpleados from employees group by month(hire_date) order by Mes;
-- Iniciales de Empleados: Crea una columna que muestre las iniciales de cada empleado (por ejemplo, para 'Georgi Facello' sería 'G.F.').
select emp_no , concat(left(first_name, 1), '.', left(last_name, 1)) as Iniciales from employees;
-- Departamento con el Mejor Salario Promedio: ¿Qué departamento tiene el salario promedio actual más alto?
select d.dept_no, d.dept_name, avg(salary) from salaries s join employees e on s.emp_no = e.emp_no join dept_emp de on e.emp_no = de.emp_no join departments d on de.dept_no = d.dept_no group by d.dept_name order by avg(salary) desc limit 1;
-- Gerente con Más Tiempo en el Cargo: Encuentra al gerente que ha estado en su puesto por más tiempo. Muestra su nombre y el número de días en el cargo.
select e.first_name as Nombre, e.last_name as Apellido, datediff(dm.to_date, dm.from_date) as NumeroDias from dept_manager dm join employees e on dm.emp_no = e.emp_no order by NumeroDias desc limit 1;
-- Incremento Salarial por Empleado: Para el empleado 10001, calcula la diferencia entre su primer salario y su salario actual.
select (select salary from salaries where emp_no = 10001 order by from_date  asc limit 1) as PrimerSalario, (SELECT salary FROM salaries WHERE emp_no = 10001 AND to_date = '9999-01-01') as SalarioActual, ((SELECT salary FROM salaries WHERE emp_no = 10001 AND to_date = '9999-01-01') - (select salary from salaries where emp_no = 10001 order by from_date  asc limit 1)) as Incremento from salaries limit 1;
select employees.emp_no,first_name , case when hire_date = from_date then salary end as primer_salario,max(case when to_date = "9999-01-01" then salary end) -  max(case when hire_date = from_date then salary end) as diferencia, max(case when to_date = "9999-01-01" then salary end) as salario_actual from employees inner join salaries on employees.emp_no = salaries.emp_no where employees.emp_no = 10001;
select s1.salary, s2.salary, (s2.salary - s1.salary) as incremento from employees e join salaries s1 on e.emp_no = s1.emp_no join salaries s2 on e.emp_no = s2.emp_no where e.emp_no = 10001 and s1.from_date = (select min(from_date) from salaries where emp_no = e.emp_no) and s2.to_date = '9999-01-01';
-- Empleados Contratados el Mismo Día: Encuentra todos los pares de empleados que fueron contratados en la misma fecha.
select count(emp_no) as contador, e.hire_date from employees e group by hire_date having count(*) > 1 order by hire_date asc;
-- El Ingeniero Mejor Pagado: ¿Quién es el 'Senior Engineer' con el salario actual más alto en toda la empresa? Muestra su nombre, apellido y salario.
select e.first_name, e.last_name, max(salary), t.title from employees e join salaries s on e.emp_no = s.emp_no join titles t on e.emp_no = t.emp_no where t.title = 'senior engineer';