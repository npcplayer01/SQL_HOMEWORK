CREATE PROCEDURE Insert_Employee

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

IF EXISTS (SELECT 1 FROM employees WHERE email = @email)
	BEGIN
		RAISERROR('El correo ya esta en uso', 16,1);
		RETURN;
		END;

IF @phone_number IS NOT NULL AND EXISTS (SELECT 1 FROM employees WHERE phone_number = @phone_number)
	BEGIN
		RAISERROR ('El numero de telefono ya esta en uso', 16,1);
		RETURN;
		END;

IF @hire_date > GETDATE()
	BEGIN
		RAISERROR ('La fecha no puede ser futura', 16,1);
		RETURN;
		END;

IF NOT EXISTS (SELECT 1 FROM jobs WHERE job_id = job_id) 
	BEGIN
		RAISERROR ('job_id no existe' , 16, 1 ); 
		RETURN;
		END;

IF EXISTS(SELECT 1 FROM jobs WHERE job_id = @job_id AND (@salary < min_salary OR @salary > max_salary))
	BEGIN
		RAISERROR('El Salario no esta dentro del rango permitido', 16, 1);
		RETURN;
		END;

IF @manager_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM employees WHERE employee_id = @manager_id)
	BEGIN
		RAISERROR ('manager_id no existe.', 16, 1);
		RETURN;
		END; 

IF NOT EXISTS (SELECT 1 FROM departments WHERE department_id = @department_id)
	BEGIN
		RAISERROR('departament_id no existe.', 16, 1);
		RETURN;
		END;

INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
VALUES (@first_name, @last_name, @email, @phone_number, @hire_date, @job_id, @salary, @manager_id, @department_id);

	PRINT 'El registro se ha guardado exitosamente';

END;