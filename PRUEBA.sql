IF OBJECT_ID ('GetEmployeeDepartament') IS NOT NULL
BEGIN;
PRINT 'existe'
END

ELSE
BEGIN
PRINT 'no existe'
END;

SELECT name, type_desc
FROM sys.objects
WHERE type = 'FN' AND name = 'RegionSalaryIncrease';