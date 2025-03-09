EXEC Insert_Employee
	'Carlos',
	'Ruiz',
	'cerc@gmail.com',
	'22222222',
	'2025-02-25',
	3,
	5000.00,
	108,
	2;

	EXEC Update_Employee
	209,
	'Denis',
	'Flores',
	'denis@gmail.com',
	'33333833',
	'2025-02-20',
	3,
	5500.00,
	108,
	2;

	EXEC Update_Employee
	208,
	'Oscar',
	'Alvarenga',
	'oscar8@gmail.com',
	'842125522',
	'2025-02-02',
	3,
	5900.00,
	108,
	2;


	EXEC GetEmployeeDetails 208;


	SELECT dbo.GetEmploymentTime(208) AS employment_time;

	SELECT dbo.GetYears(195) AS years_worked;

	SELECT dbo.GenerateEmailAddress(101) AS generated_email;


	EXEC GetEmployeeDepartament @department_id = 6;

	SELECT dbo.GetSalaryIncreaseDetails(105) AS salary_increased_details;

	SELECT dbo.RegionSalaryIncrease(105) AS region_based_increase;