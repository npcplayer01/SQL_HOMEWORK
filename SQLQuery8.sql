CREATE FUNCTION dbo.GetEmploymentTime(@employee_id INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @hire_date DATE;
	DECLARE @years_of_work INT;
	DECLARE @months_of_work INT;
	DECLARE @result VARCHAR(50);


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

IF @years_of_work = 0
    BEGIN
        SET @months_of_work = DATEDIFF(MONTH, @hire_date, GETDATE());

IF DATEADD(MONTH, @months_of_work, @hire_date) > GETDATE()
     BEGIN
     SET @months_of_work = @months_of_work - 1;
     END

SET @result = CAST(@months_of_work AS VARCHAR) + ' meses';
END
ELSE
BEGIN

SET @result = CAST(@years_of_work AS VARCHAR)+ ' años';
END

RETURN @result;
END;
