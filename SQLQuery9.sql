CREATE FUNCTION dbo.GetYears(@employee_id INT)
RETURNS INT
AS
BEGIN
	DECLARE @hire_date DATE;
	DECLARE @years_of_work INT;

SELECT @hire_date = hire_date
FROM employees
WHERE employee_id = @employee_id;

IF @hire_date IS NULL
BEGIN
	RETURN NULL;
	END

SET @years_of_work = DATEDIFF(YEAR, @hire_date, GETDATE());

IF DATEADD(YEAR, @years_of_work, @hire_date) > GETDATE()
BEGIN
	SET @years_of_work = @years_of_work - 1;
	END

	RETURN @years_of_work;
END