ALTER FUNCTION CalculateSalary (
@employee_id INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
	DECLARE @hire_date DATE;
	DECLARE @years_worked INT;
	DECLARE @base_salary DECIMAL(10, 2);
	DECLARE @salary_increased DECIMAL (10, 2);

SELECT 
	@hire_date = hire_date, 
	@base_salary = salary

FROM 
	employees 
WHERE 
	employee_id = @employee_id;

IF @hire_date IS NULL OR @base_salary IS NULL
	BEGIN
		RETURN NULL;
		END

SET @years_worked = DATEDIFF(YEAR, @hire_date, GETDATE());

IF DATEADD(YEAR, @years_worked, @hire_date) > GETDATE()
    BEGIN
        SET @years_worked = @years_worked - 1;
    END

IF @years_worked BETWEEN 10 AND 19
    BEGIN
        SET @salary_increased = @base_salary * 0.10;      
END
    ELSE IF @years_worked BETWEEN 20 AND 29
    BEGIN
        SET @salary_increased = @base_salary * 0.20;     
END
    ELSE IF @years_worked BETWEEN 30 AND 39
    BEGIN
        SET @salary_increased = @base_salary * 0.30; 
END
    ELSE IF @years_worked >= 40
    BEGIN
        SET @salary_increased = @base_salary * 0.40;  
END
    ELSE
    BEGIN
        SET @salary_increased = 0.00;
END

RETURN @salary_increased;
END
