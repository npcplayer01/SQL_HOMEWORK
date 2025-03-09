CREATE FUNCTION GenerateEmailAddress(
@employee_id INT)

RETURNS VARCHAR(100) AS
BEGIN
    DECLARE @email VARCHAR(100);
    DECLARE @first_name VARCHAR(50);
    DECLARE @last_name VARCHAR(50);
    DECLARE @hire_date DATE;

SELECT 
	@first_name = first_name,
	@last_name = last_name,
	@hire_date = hire_date

	FROM employees
	WHERE employee_id = @employee_id;

IF @first_name IS NULL OR @last_name IS NULL OR @hire_date IS NULL
BEGIN
	RETURN NULL;
	END

SET @first_name = LOWER(LEFT(@first_name, 3));
SET @last_name = LOWER(LEFT(@last_name, 3));

DECLARE @year INT;
SET @year = YEAR(@hire_date);

SET @email = @first_name + '_' + @last_name + '_' + CAST(@year AS VARCHAR) + '@ugb.edu.sv';

 RETURN @email;
END;