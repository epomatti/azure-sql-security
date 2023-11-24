DECLARE @SSNPattern [char](11) = '%6818';
DECLARE @MinSalary [money] = $1000;
SELECT * FROM [HR].[Employees]
WHERE SSN LIKE @SSNPattern AND [Salary] >= @MinSalary;