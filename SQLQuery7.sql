ALTER PROCEDURE GetEmployeeDetails
@employee_id INT

AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM employees WHERE employee_id = @employee_id)
	BEGIN
		RAISERROR('El empleado no existe.', 16, 1);
		END

SELECT 

e.employee_id,
e.first_name,
e.last_name,
e.email,
e.hire_date,
j.job_title,
e.salary,
m.first_name + ' ' + m.last_name AS manager_name,
d.department_name

FROM 
	employees e
INNER JOIN
	jobs j ON e.job_id = j.job_id
LEFT JOIN
	employees m ON e.manager_id = m.employee_id
INNER JOIN 
	departments d ON e.department_id = d.department_id
WHERE
	e.employee_id = @employee_id;
	END;