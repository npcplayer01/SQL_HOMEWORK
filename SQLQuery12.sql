ALTER PROCEDURE GetEmployeeDepartament
	@department_id INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM departments WHERE department_id = @department_id)
	BEGIN
		RAISERROR('El departamento ingresado no existe', 16, 1);
		END

	SELECT 
		e.employee_id,
		e.first_name,
		e.last_name,
		e.email,
		e.hire_date,
		j.job_title,
		e.salary,
		
	ISNULL(m.first_name + ' ' + m.last_name, 'No tiene manager') AS manager_name, d.department_name
	FROM
		employees e
	INNER JOIN 
	jobs j ON e.job_id = j.job_id
	LEFT JOIN
	employees m ON e.manager_id = m.employee_id
	INNER JOIN
		departments d ON e.department_id = d.department_id
		WHERE
		e.department_id = @department_id;
		END