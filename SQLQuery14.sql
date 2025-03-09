CREATE FUNCTION dbo.RegionSalaryIncrease(
@employee_id INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @first_name VARCHAR(50);
    DECLARE @last_name VARCHAR(50);
    DECLARE @base_salary DECIMAL(10, 2);
    DECLARE @region_name VARCHAR(50);
    DECLARE @region_increase DECIMAL(5, 2);
    DECLARE @region_based_increase DECIMAL(10, 2);
    DECLARE @result VARCHAR(MAX);

 SELECT 
        @first_name = e.first_name,
        @last_name = e.last_name,
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

IF @first_name IS NULL OR @last_name IS NULL OR @base_salary IS NULL OR @region_name IS NULL
    BEGIN
        RETURN 'El empleado especificado no existe o no tiene una región asignada.';
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

SET @region_based_increase = @base_salary * @region_increase;

SET @result = 'Nombre: ' + @first_name + ' ' + @last_name + ',' + CHAR(13) +
              'Salario base: $' + FORMAT(@base_salary, 'N2') + CHAR(13) +
              'Región: ' + @region_name + ' (incremento del ' + CAST(@region_increase * 100 AS VARCHAR) + '%)' + CHAR(13) +
              'Aumento: $' + FORMAT(@base_salary, 'N2') + ' x ' + CAST(@region_increase AS VARCHAR) + ' = $' + FORMAT(@region_based_increase, 'N2');

	RETURN @result;
	END