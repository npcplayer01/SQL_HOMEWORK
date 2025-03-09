CREATE FUNCTION dbo.GetSalaryIncreaseDetails(
@employee_id INT
)
RETURNS VARCHAR (MAX)
AS
BEGIN
   DECLARE @first_name VARCHAR(50);
    DECLARE @last_name VARCHAR(50);
    DECLARE @hire_date DATE;
    DECLARE @base_salary DECIMAL(10, 2);
    DECLARE @years_worked INT;
    DECLARE @salary_increased DECIMAL(10, 2);
    DECLARE @increase_percentage DECIMAL(5, 2);
    DECLARE @result VARCHAR(MAX);

SELECT 
        @first_name = first_name,
        @last_name = last_name,
        @hire_date = hire_date,
        @base_salary = salary
    FROM 
        employees
    WHERE 
        employee_id = @employee_id;

IF @first_name IS NULL OR @last_name IS NULL OR @hire_date IS NULL OR @base_salary IS NULL
    BEGIN
        RETURN 'El empleado especificado no existe.';
    END

SET @years_worked = DATEDIFF(YEAR, @hire_date, GETDATE());

IF DATEADD(YEAR, @years_worked, @hire_date) > GETDATE()
    BEGIN
        SET @years_worked = @years_worked - 1;
    END

IF @years_worked BETWEEN 10 AND 19
    BEGIN
        SET @increase_percentage = 0.10;  --10%
    END
    ELSE IF @years_worked BETWEEN 20 AND 29
    BEGIN
        SET @increase_percentage = 0.20;  --20%
    END
    ELSE IF @years_worked BETWEEN 30 AND 39
    BEGIN
        SET @increase_percentage = 0.30;      --30%
	END
    ELSE IF @years_worked >= 40
    BEGIN
        SET @increase_percentage = 0.40;  --40%
    END
    ELSE
    BEGIN
        SET @increase_percentage = 0.00; --0%
	END
SET @salary_increased = @base_salary * @increase_percentage;

SET @result = 'Nombre: ' + @first_name + ' ' + @last_name + ',' + CHAR(13) +
              'Salario base: $' + FORMAT(@base_salary, 'N2') + CHAR(13) +
              'Años trabajados: ' + CAST(@years_worked AS VARCHAR) + ' (aumento del ' + CAST(@increase_percentage * 100 AS VARCHAR) + '%)' + CHAR(13) +
              'Aumento: $' + FORMAT(@base_salary, 'N2') + ' x ' + CAST(@increase_percentage AS VARCHAR) + ' = $' + FORMAT(@salary_increased, 'N2');

	RETURN @result;
	END