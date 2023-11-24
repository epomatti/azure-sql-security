CREATE SCHEMA [HR];
GO

CREATE TABLE [HR].[Employees]
(
    [EmployeeID] [int] IDENTITY(1,1) NOT NULL,
    [SSN] [char](11) NOT NULL,
    [FirstName] [nvarchar](50) NOT NULL,
    [LastName] [nvarchar](50) NOT NULL,
    [Salary] [money] NOT NULL
) ON [PRIMARY];
GO