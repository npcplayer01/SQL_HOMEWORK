CREATE PROCEDURE Update_Employee
@employee_id INT,
@first_name VARCHAR (20),
@last_name VARCHAR (25),
@email VARCHAR (100),
@phone_number VARCHAR (20),
@hire_date DATE,
@job_id INT,
@salary DECIMAL (8, 2),
@manager_id INT,
@department_id INT

AS
BEGIN

IF NOT EXISTS (SELECT 1 FROM employees WHERE employee_id = @employee_id)
	BEGIN
		RAISERROR('El empleado no existe.', 16,1);
		RETURN;
		END
		
IF @first_name IS NULL OR LEN(@first_name) < 2 OR LEN(@first_name) > 20
    BEGIN
        RAISERROR('El first_name no puede estar vacío y debe tener entre 2 y 20 caracteres.', 16, 1);
        RETURN;
    END
	
IF @last_name IS NULL OR LEN(@last_name) < 2 OR LEN(@last_name) > 25
    BEGIN
        RAISERROR('El last_name no puede estar vacío y debe tener entre 2 y 25 caracteres.', 16, 1);
        RETURN;
    END
	
IF EXISTS (SELECT 1 FROM employees WHERE email = @email AND employee_id <> @employee_id)
	BEGIN
		RAISERROR('El correo ya existe, employee_id no coincide', 16,1);
		RETURN;
		END
		
IF @phone_number IS NOT NULL AND EXISTS (SELECT 1 FROM employees WHERE phone_number = @phone_number AND employee_id <> @employee_id)
	BEGIN
		RAISERROR ('El numero de telefono ya esta en uso, employee_id no coincide', 16,1);
		RETURN;
		END

IF @hire_date > GETDATE()
	BEGIN
		RAISERROR ('La fecha no puede ser futura', 16,1);
		RETURN;
		END
		
IF NOT EXISTS (SELECT 1 FROM jobs WHERE job_id = job_id) 
	BEGIN
		RAISERROR ('job_id no existe' , 16, 1 ); 
		RETURN;
		END
		
IF EXISTS(SELECT 1 FROM jobs WHERE job_id = @job_id AND (@salary < min_salary OR @salary > max_salary))
	BEGIN
		RAISERROR('El Salario no esta dentro del rango permitido', 16, 1);
		RETURN;
		END
		
IF @manager_id = @employee_id
	BEGIN
		RAISERROR('Un empleado no puede ser su propio manager.', 16, 1);
		RETURN;
		END
		
IF NOT EXISTS (SELECT 1 FROM departments WHERE department_id = @department_id)
	BEGIN
		RAISERROR('departament_id no existe.', 16, 1);
		RETURN;
		END
		
UPDATE employees
SET
		first_name = @first_name,
        last_name = @last_name,
        email = @email,
        phone_number = @phone_number,
        hire_date = @hire_date,
        job_id = @job_id,
        salary = @salary,
        manager_id = @manager_id,
        department_id = @department_id
		WHERE employee_id = @employee_id;
		
	PRINT 'Empleado actualizado correctamente.'
END;