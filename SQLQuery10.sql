CREATE FUNCTION GenerateEmail(
@first_name VARCHAR(50),
@last_name VARCHAR(50),
@hire_date DATE)

RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @email VARCHAR(100);
		SET @first_name = LOWER(LEFT(@first_name, 3));
		SET @last_name = LOWER(LEFT(@last_name, 3));

		DECLARE @year INT;
		SET @year = YEAR(@hire_date);

SET @email = @first_name + '_' + @last_name + '_' + CAST(@year AS VARCHAR) + '@ugb.edu.sv';

RETURN @email;
END;