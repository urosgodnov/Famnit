---+ and concat
USE AdventureWorks2014;
GO
--1
SELECT 'ab' + 'c';
--2
SELECT BusinessEntityID, FirstName + ' ' + LastName AS "Full Name"
FROM Person.Person;
--3
SELECT BusinessEntityID, LastName + ', ' + FirstName AS "Full Name"
FROM Person.Person;
--4
SELECT BusinessEntityID, FirstName + ' ' + MiddleName +
' ' + LastName AS "Full Name"
FROM Person.Person;

-- Simple CONCAT statement
SELECT CONCAT ('I ', 'love', ' writing', ' T-SQL') AS RESULT;
go
SELECT BusinessEntityID, CONCAT(FirstName,' ', MiddleName,' ', LastName) AS "Full Name"
FROM Person.Person;
--Using ISNULL and COALESCE
USE AdventureWorks2014;
GO
--1
SELECT BusinessEntityID, FirstName + ' ' + ISNULL(MiddleName,'') +
' ' + LastName AS "Full Name"
FROM Person.Person;
--2
SELECT BusinessEntityID, FirstName + ISNULL(' ' + MiddleName,'') +
' ' + LastName AS "Full Name"
FROM Person.Person;
--3
SELECT BusinessEntityID, FirstName + COALESCE(' ' + MiddleName,'') +
' ' + LastName AS "Full Name"
FROM Person.Person;

---Cast and convert
USE AdventureWorks2014
GO
--1
SELECT CAST(BusinessEntityID AS NVARCHAR) + ': ' + LastName
+ ', ' + FirstName AS ID_Name
FROM Person.Person;
--2
SELECT CONVERT(NVARCHAR(10),BusinessEntityID) + ': ' + LastName
+ ', ' + FirstName AS ID_Name
FROM Person.Person;
--3
SELECT BusinessEntityID, BusinessEntityID + 1 AS "Adds 1",
CAST(BusinessEntityID AS NVARCHAR(10)) + '1'AS "Appends 1"
FROM Person.Person;

--Using Mathematical Operators
USE AdventureWorks2014;
GO
--1
SELECT 1 + 1;
--2
SELECT 10 / 3 AS DIVISION, 10 % 3 AS MODULO;
--3
SELECT OrderQty, OrderQty * 10 AS Times10
FROM Sales.SalesOrderDetail;
--4
SELECT OrderQty * UnitPrice * (1.0 - UnitPriceDiscount)
AS Calculated, LineTotal
FROM Sales.SalesOrderDetail;
--5
SELECT SpecialOfferID,MaxQty,DiscountPct,
DiscountPct * ISNULL(MaxQty,1000) AS MaxDiscount
FROM Sales.SpecialOffer;

--Using RTRIM and LTRIM
--Create the temp table
CREATE TABLE #trimExample (COL1 VARCHAR(10));
GO
--Populate the table
INSERT INTO #trimExample (COL1)
VALUES ('a '),('b '),(' c'),(' d ');
--Select the values using the functions
SELECT COL1, '*' + RTRIM(COL1) + '*' AS "RTRIM",
'*' + LTRIM(COL1) + '*' AS "LTRIM"
FROM #trimExample;
--Clean up
DROP TABLE #trimExample;

--The LEFT and RIGHT Functions
USE AdventureWorks2014;
GO
SELECT LastName,LEFT(LastName,5) AS "LEFT",
RIGHT(LastName,4) AS "RIGHT"
FROM Person.Person
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027);

--Using the LEN and DATALENGTH Functions
USE AdventureWorks2014;
GO
SELECT LastName,LEN(LastName) AS "Length",
DATALENGTH(LastName) AS "Data Length"
FROM Person.Person
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027);

--Using CHARINDEX
USE AdventureWorks2014;
GO
SELECT LastName, CHARINDEX('e',LastName) AS "Find e",
CHARINDEX('e',LastName,4) AS "Skip 4 Characters",
CHARINDEX('be',LastName) AS "Find be",
CHARINDEX('Be',LastName) AS "Find B"
FROM Person.Person
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027);

--Using SUBSTRING
USE AdventureWorks2014;
GO
SELECT LastName, SUBSTRING(LastName,1,4) AS "First 4",
SUBSTRING(LastName,5,50) AS "Characters 5 and later"
FROM Person.Person
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027);

--Using the CHOOSE Function
SELECT CHOOSE (4, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i')
GO
SELECT CHOOSE (CAST(RAND() * 9+1 AS INT), 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i')

--Using UPPER and LOWER
USE AdventureWorks2014;
GO
SELECT LastName, UPPER(LastName) AS "UPPER",
LOWER(LastName) AS "LOWER"
FROM Person.Person
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027);

--Using REPLACE
USE AdventureWorks2014;
GO
--1
SELECT LastName, REPLACE(LastName,'A','Z') AS "Replace A",
REPLACE(LastName,'A','ZZ') AS "Replace with 2 characters",
REPLACE(LastName,'ab','') AS "Remove string"
FROM Person.Person
WHERE BusinessEntityID IN (293,295,211,297,299,3057,15027);

--STRING_SPLIT
--USE tempdb;
GO
SELECT value FROM STRING_SPLIT(N'Rapid Wien,Benfica Lisboa,Seattle Seahawks',',');
GO
--COMPRESS
SELECT
target_name,
DATALENGTH(xet.target_data) AS original_size,
DATALENGTH(COMPRESS(xet.target_data)) AS compressed_size,
CAST((DATALENGTH(xet.target_data) -
DATALENGTH(COMPRESS(xet.target_data)))*100.0/DATALENGTH(xet.target_data) AS
DECIMAL(5,2)) AS compression_rate_in_percent
FROM sys.dm_xe_session_targets xet
INNER JOIN sys.dm_xe_sessions xe ON xe.address = xet.event_session_address
WHERE xe.name = 'system_health';

--DECOMPRESS
DECLARE @input AS NVARCHAR(100) = N'SQL Server 2016 Developer''s Guide';
SELECT DECOMPRESS(COMPRESS(@input));
go
DECLARE @input AS NVARCHAR(100) = N'SQL Server 2016 Developer''s Guide';
SELECT CAST(DECOMPRESS(COMPRESS(@input)) AS NVARCHAR(100)) AS input;

--Nesting Functions
USE AdventureWorks2014;
GO
--1
SELECT EmailAddress,
SUBSTRING(EmailAddress,CHARINDEX('@',EmailAddress) + 1,50) AS DOMAIN
FROM Production.ProductReview;

-----Date functions
--GETDATE
--SYSDATETIME

SELECT GETDATE(), SYSDATETIME();

--Using the DATEADD Function
Use AdventureWorks2014
GO
--1
SELECT OrderDate, DATEADD(year,1,OrderDate) AS OneMoreYear,
DATEADD(month,1,OrderDate) AS OneMoreMonth,
DATEADD(day,-1,OrderDate) AS OneLessDay
FROM Sales.SalesOrderHeader
WHERE SalesOrderID in (43659,43714,60621);
--2
SELECT DATEADD(month,1,'2009-01-29') AS FebDate;

--Using DATEDIFF
Use AdventureWorks2014;
GO
--1
SELECT OrderDate, GETDATE() CurrentDateTime,
DATEDIFF(year,OrderDate,GETDATE()) AS YearDiff,
DATEDIFF(month,OrderDate,GETDATE()) AS MonthDiff,
DATEDIFF(day,OrderDate,GETDATE()) AS DayDiff
FROM Sales.SalesOrderHeader
WHERE SalesOrderID in (43659,43714,60621);

--Using DATENAME and DATEPART
Use AdventureWorks2014
GO
--1
SELECT OrderDate, DATEPART(year,OrderDate) AS OrderYear,
DATEPART(month,OrderDate) AS OrderMonth,
DATEPART(day,OrderDate) AS OrderDay,
DATEPART(weekday,OrderDate) AS OrderWeekDay
FROM Sales.SalesOrderHeader
WHERE SalesOrderID in (43659,43714,60621);
--2
SELECT OrderDate, DATENAME(year,OrderDate) AS OrderYear,
DATENAME(month,OrderDate) AS OrderMonth,
DATENAME(day,OrderDate) AS OrderDay,
DATENAME(weekday,OrderDate) AS OrderWeekDay
FROM Sales.SalesOrderHeader
WHERE SalesOrderID in (43659,43714,60621);

--Using the DAY, MONTH, and YEAR Functions
Use AdventureWorks2014
GO
SELECT OrderDate, YEAR(OrderDate) AS OrderYear,
MONTH(OrderDate) AS OrderMonth,
DAY(OrderDate) AS OrderDay
FROM Sales.SalesOrderHeader
WHERE SalesOrderID in (43659,43714,60621);

--USING CONVERT
SELECT CONVERT(VARCHAR,OrderDate,1) AS "1",
CONVERT(VARCHAR,OrderDate,101) AS "101",
CONVERT(VARCHAR,OrderDate,2) AS "2",
CONVERT(VARCHAR,OrderDate,104) AS "104"
FROM Sales.SalesOrderHeader
WHERE SalesOrderID in (43659,43714,60621);

--FORMAT Function Examples
DECLARE @d DATETIME = GETDATE();
SELECT FORMAT( @d, 'dd', 'en-US' ) AS Result;
SELECT FORMAT( @d, 'd/M/y', 'en-US' ) AS Result;
SELECT FORMAT( @d, 'dd/MM/yyyy', 'en-US' ) AS Result;
SELECT FORMAT( @d, 'dd.MM.yyyy') AS Result;

--DATEFROMPARTS Examples
SELECT DATEFROMPARTS(2012, 3, 10) AS RESULT;
SELECT TIMEFROMPARTS(12, 10, 32, 0, 0) AS RESULT;
SELECT DATETIME2FROMPARTS (2012, 3, 10, 12, 10, 32, 0, 0) AS RESULT;

-----Matchematical functions
SELECT ABS(2) AS "2", ABS(-2) AS "-2"

SELECT POWER(10,1) AS "Ten to the First",
POWER(10,2) AS "Ten to the Second",
POWER(10,3) AS "Ten to the Third";

--Using the SQUARE and SQRT Functions
SELECT SQUARE(10) AS "Square of 10",
SQRT(10) AS "Square Root of 10",
SQRT(SQUARE(10)) AS "The Square Root of the Square of 10";

--Using RAND
SELECT CAST(RAND() * 100 AS INT) + 1 AS "1 to 100",
CAST(RAND()* 1000 AS INT) + 900 AS "900 to 1900",
CAST(RAND() * 5 AS INT)+ 1 AS "1 to 5";

--System functions
--Using Simple CASE
USE AdventureWorks2014;
GO
SELECT Title,
CASE Title
WHEN 'Mr.' THEN 'Male'
WHEN 'Ms.' THEN 'Female'
WHEN 'Mrs.' THEN 'Female'
WHEN 'Miss' THEN 'Female'
ELSE 'Unknown' END AS Gender
FROM Person.Person
WHERE BusinessEntityID IN (1,5,6,357,358,11621,423);

--Using Searched CASE
SELECT Title,
CASE WHEN Title IN ('Ms.','Mrs.','Miss') THEN 'Female'
WHEN Title = 'Mr.' THEN 'Male'
ELSE 'Unknown' END AS Gender
FROM Person.Person
WHERE BusinessEntityID IN (1,5,6,357,358,11621,423);

--Returning a Column Name in CASE
USE AdventureWorks2014;
GO
SELECT VacationHours,SickLeaveHours,
CASE WHEN VacationHours > SickLeaveHours THEN VacationHours
ELSE SickLeaveHours END AS 'More Hours'
FROM HumanResources.Employee;

--IIF Statement
--IIF Statement without variables
SELECT IIF (50 > 20, 'TRUE', 'FALSE') AS RESULT;
--IIF Statement with variables
DECLARE @a INT = 50
DECLARE @b INT = 25
SELECT IIF (@a > @b, 'TRUE', 'FALSE') AS RESULT;
--IIF Statement without variables
SELECT IIF (50 > 20, 'TRUE', 'FALSE') AS RESULT;
--IIF Statement with variables
GO
DECLARE @a INT = 50;
DECLARE @b INT = 25;
SELECT IIF (@a > @b, 'TRUE', 'FALSE') AS RESULT;
GO
--A Few System Functions
SELECT DB_NAME() AS "Database Name",
HOST_NAME() AS "Host Name",
CURRENT_USER AS "Current User",
USER_NAME() AS "User Name",
APP_NAME() AS "App Name";

--@@ROWCOUNT()
USE TSQLV4
GO
DECLARE @empid AS INT = 10;
 SELECT empid, firstname, lastname
FROM HR.Employees
WHERE empid = @empid;
IF @@ROWCOUNT = 0
  PRINT CONCAT('Employee ', CAST(@empid AS VARCHAR(10)), ' was not found.');
GO

--Using Functions in WHERE and ORDER BY
USE AdventureWorks2014;
GO
--1
SELECT FirstName
FROM Person.Person
WHERE CHARINDEX('ke',FirstName) > 0;
--2
SELECT BirthDate
FROM HumanResources.Employee
ORDER BY YEAR(BirthDate);

--Limiting Results with TOP
USE AdventureWorks2014;
GO
--1
IF OBJECT_ID('dbo.Sales') IS NOT NULL BEGIN
DROP TABLE dbo.Sales;
END;
--2
CREATE TABLE dbo.Sales (CustomerID INT, OrderDate DATE,
SalesOrderID INT NOT NULL PRIMARY KEY);
GO
--3
INSERT TOP(5) INTO dbo.Sales(CustomerID,OrderDate,SalesOrderID)
SELECT CustomerID, OrderDate, SalesOrderID
FROM Sales.SalesOrderHeader;
--4
SELECT CustomerID, OrderDate, SalesOrderID
FROM dbo.Sales
ORDER BY SalesOrderID;
--5
DELETE TOP(2) dbo.Sales
--6
UPDATE TOP(2) dbo.Sales SET CustomerID = CustomerID + 10000;
--7
SELECT CustomerID, OrderDate, SalesOrderID
FROM dbo.Sales
ORDER BY SalesOrderID;
--8
DECLARE @Rows INT = 2;
SELECT TOP(@Rows) CustomerID, OrderDate, SalesOrderID
FROM dbo.Sales
ORDER BY SalesOrderID;


SELECT TOP (3) WITH TIES [SalesOrderID], orderdate, [CustomerID]
FROM [Sales].[SalesOrderHeader]
ORDER BY orderdate DESC;

--Using rownumber
USE AdventureWorks2014;
GO
--1
SELECT CustomerID, FirstName + ' ' + LastName AS Name,
ROW_NUMBER() OVER (ORDER BY LastName, FirstName) AS Row
FROM Sales.Customer AS c 
INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID;
--2
WITH customers AS (
SELECT CustomerID, FirstName + ' ' + LastName AS Name,
ROW_NUMBER() OVER (ORDER BY LastName, FirstName) AS Row
FROM Sales.Customer AS c 
INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID
)
SELECT CustomerID, Name, Row
FROM customers
WHERE Row > 50
ORDER BY Row;
--3
SELECT CustomerID, FirstName + ' ' + LastName AS Name, c.TerritoryID,
ROW_NUMBER() OVER (PARTITION BY c.TerritoryID
ORDER BY LastName, FirstName) AS Row
FROM Sales.Customer AS c 
INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID;

--Using RANK and DENSE_RANK
USE AdventureWorks2014;
GO
SELECT CustomerID,COUNT(*) AS CountOfSales,
RANK() OVER(ORDER BY COUNT(*) DESC) AS Ranking,
ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS Row,
DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS DenseRanking
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY COUNT(*) DESC;

--NTILE
USE AdventureWorks2014;
GO
DECLARE @NTILE_Var int = 4;  

SELECT p.FirstName, p.LastName  
    ,NTILE(@NTILE_Var) OVER(PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS Quartile  
    ,CONVERT(nvarchar(20),s.SalesYTD,1) AS SalesYTD  
    ,a.PostalCode  
FROM Sales.SalesPerson AS s   
INNER JOIN Person.Person AS p   
    ON s.BusinessEntityID = p.BusinessEntityID  
INNER JOIN Person.Address AS a   
    ON a.AddressID = p.BusinessEntityID  
WHERE TerritoryID IS NOT NULL   
    AND SalesYTD <> 0;  
GO  

-----SET OPERATORS

-- UNION
CREATE VIEW Lunch 
AS 
  SELECT 'Beer' AS item 
  UNION SELECT 'Olives' 
  UNION SELECT 'Bread' 
  UNION SELECT 'Salami' 
  UNION SELECT 'Calamari' 
  UNION SELECT 'Coffee';
GO
CREATE VIEW Dinner 
AS 
  SELECT 'Wine' AS item 
  UNION SELECT 'Olives' 
  UNION SELECT 'Bread' 
  UNION SELECT 'Steak' 
  UNION SELECT 'Aubergines' 
  UNION SELECT 'Salad' 
  UNION SELECT 'Coffee' 
  UNION SELECT 'Apple';
GO
SELECT item FROM Lunch
UNION 
SELECT item FROM Dinner;
GO
--UNION ALL
SELECT item FROM Lunch
UNION ALL
SELECT item FROM Dinner;
GO
--EXCEPT
SELECT item FROM Dinner
EXCEPT 
SELECT item FROM Lunch;
GO
--INTERSECT 
SELECT item FROM Dinner
INTERSECT 
SELECT item FROM Lunch;
