CREATE FUNCTION dbo.funcion1
(
    @employee_id INT  
)
RETURNS DECIMAL(10, 2)  
AS
BEGIN
    DECLARE @hire_date DATE;
    DECLARE @base_salary DECIMAL(10, 2);
    DECLARE @years_worked INT;
    DECLARE @salary_increase DECIMAL(10, 2);

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
        SET @salary_increase = @base_salary * 0.10;  
    END
    ELSE IF @years_worked BETWEEN 20 AND 29
    BEGIN
        SET @salary_increase = @base_salary * 0.20;  
    END
    ELSE IF @years_worked BETWEEN 30 AND 39
    BEGIN
        SET @salary_increase = @base_salary * 0.30;  
    END
    ELSE IF @years_worked >= 40
    BEGIN
        SET @salary_increase = @base_salary * 0.40;  
    END
    ELSE
    BEGIN
        SET @salary_increase = 0.00;  
    END

    RETURN @salary_increase;
END;
GO


CREATE FUNCTION dbo.funcion2
(
    @employee_id INT  
)
RETURNS DECIMAL(10, 2)  
AS
BEGIN
    DECLARE @base_salary DECIMAL(10, 2);
    DECLARE @region_name VARCHAR(50);
    DECLARE @region_increase DECIMAL(5, 2);

    SELECT 
        @base_salary = e.salary,
        @region_name = r.region_name
    FROM 
        employees e
    INNER JOIN 
        departments d ON e.department_id = d.department_id
    INNER JOIN 
        locations l ON d.location_id = l.location_id
    INNER JOIN 
        countries c ON l.country_id = c.country_id
    INNER JOIN 
        regions r ON c.region_id = r.region_id
    WHERE 
        e.employee_id = @employee_id;

    IF @base_salary IS NULL OR @region_name IS NULL
    BEGIN
        RETURN NULL;
    END

    IF @region_name = 'Europe'
    BEGIN
        SET @region_increase = 0.03;  
    END
    ELSE IF @region_name = 'Americas'
    BEGIN
        SET @region_increase = 0.05;  
    END
    ELSE IF @region_name = 'Asia'
    BEGIN
        SET @region_increase = 0.04;  
    END
    ELSE IF @region_name = 'Middle East and Africa'
    BEGIN
        SET @region_increase = 0.06;  
    END
    ELSE
    BEGIN
        SET @region_increase = 0.00;  
    END

    RETURN @base_salary * @region_increase;
END;
GO


CREATE FUNCTION dbo.funcionfinal
(
    @employee_id INT  
)
RETURNS VARCHAR(MAX)  
AS
BEGIN
    DECLARE @first_name VARCHAR(50);
    DECLARE @last_name VARCHAR(50);
    DECLARE @base_salary DECIMAL(10, 2);
    DECLARE @salary_increase DECIMAL(10, 2);
    DECLARE @region_increase DECIMAL(10, 2);
    DECLARE @final_salary DECIMAL(10, 2);
    DECLARE @result VARCHAR(MAX);

    SELECT 
        @first_name = first_name,
        @last_name = last_name,
        @base_salary = salary
    FROM 
        employees
    WHERE 
        employee_id = @employee_id;

    IF @first_name IS NULL OR @last_name IS NULL OR @base_salary IS NULL
    BEGIN
        RETURN 'El empleado especificado no existe.';
    END

    SET @salary_increase = dbo.funcion1(@employee_id);

    SET @region_increase = dbo.funcion2(@employee_id);

    SET @final_salary = @base_salary + ISNULL(@salary_increase, 0) + ISNULL(@region_increase, 0);

    SET @result = 'Empleado: ' + @first_name + ' ' + @last_name + CHAR(13) +
                  'Aumento por antigüedad: $' + FORMAT(ISNULL(@salary_increase, 0), 'N2') + CHAR(13) +
                  'Aumento por región: $' + FORMAT(ISNULL(@region_increase, 0), 'N2') + CHAR(13) +
                  'Salario Base: $' + FORMAT(@base_salary, 'N2') + CHAR(13) +
                  'Salario final: $' + FORMAT(@final_salary, 'N2');

    RETURN @result;
END



SELECT dbo.funcionfinal(105) AS final_salary_details;