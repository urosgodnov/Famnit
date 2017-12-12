--Listing 9-10. Creating and Using User-Defined Scalar Functions
USE AdventureWorks2014;
GO
--1
IF OBJECT_ID('dbo.udf_Product') IS NOT NULL BEGIN
DROP FUNCTION dbo.udf_Product;
END;
IF OBJECT_ID('dbo.udf_Delim') IS NOT NULL BEGIN
DROP FUNCTION dbo.udf_Delim;
END;
GO
--2
CREATE FUNCTION dbo.udf_Product(@num1 INT, @num2 INT) RETURNS INT AS
BEGIN
DECLARE @Product INT;
SET @Product = ISNULL(@num1,0) * ISNULL(@num2,0);
RETURN @Product;
END;
GO
--3
CREATE FUNCTION dbo.udf_Delim(@String VARCHAR(100),@Delimiter CHAR(1))
RETURNS VARCHAR(200) AS
BEGIN
DECLARE @NewString VARCHAR(200) = '';
DECLARE @Count INT = 1;
WHILE @Count <= LEN(@String) BEGIN
SET @NewString += SUBSTRING(@String,@Count,1) + @Delimiter;
SET @Count += 1;
END
RETURN @NewString;
END
GO
--3
SELECT StoreID, TerritoryID,
dbo.udf_Product(StoreID, TerritoryID) AS TheProduct,
dbo.udf_Delim(FirstName,',') AS FirstNameWithCommas
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID= p.BusinessEntityID;


--Listing 9-11. Using a Table-Valued UDF
USE AdventureWorks2014;
GO
--1
SELECT PersonID,FirstName,LastName,JobTitle,BusinessEntityType
FROM dbo.ufnGetContactInformation(1);
--2
SELECT PersonID,FirstName,LastName,JobTitle,BusinessEntityType
FROM dbo.ufnGetContactInformation(7822);
--3
SELECT e.BirthDate, e.Gender, c.FirstName,c.LastName,c.JobTitle
FROM HumanResources.Employee as e
CROSS APPLY dbo.ufnGetContactInformation(e.BusinessEntityID ) AS c;
--4
SELECT sc.CustomerID,sc.TerritoryID,c.FirstName,c.LastName
FROM Sales.Customer AS sc
CROSS APPLY dbo.ufnGetContactInformation(sc.PersonID) AS c;


--Listing 9-12. Creating and Using a Stored Procedure
USE AdventureWorks2014;
GO
--1
IF OBJECT_ID('dbo.usp_CustomerName') IS NOT NULL BEGIN
DROP PROC dbo.usp_CustomerName;
END;
GO
--2
CREATE PROC dbo.usp_CustomerName AS
SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID
ORDER BY p.LastName, p.FirstName,p.MiddleName ;
RETURN 0;
GO
--3
EXEC dbo.usp_CustomerName
GO
--4
ALTER PROC dbo.usp_CustomerName @CustomerID INT AS
SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID
WHERE c.CustomerID = @CustomerID;
RETURN 0;
GO
--5
EXEC dbo.usp_CustomerName @CustomerID = 15128;


--Listing 9-13. Using Default Value Parameters
USE AdventureWorks2014;
GO
--1
IF OBJECT_ID('dbo.usp_CustomerName') IS NOT NULL BEGIN
DROP PROC dbo.usp_CustomerName;
END;
GO
--2
CREATE PROC dbo.usp_CustomerName @CustomerID INT = -1 AS
SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID
WHERE @CustomerID = CASE @CustomerID WHEN -1 THEN -1 ELSE c.CustomerID END;
RETURN 0;
GO
--3
EXEC dbo.usp_CustomerName 15128;
--4
EXEC dbo.usp_CustomerName ;


--Listing 9-14. Using an OUTPUT Parameter
USE AdventureWorks2014;
GO
--1
IF OBJECT_ID('dbo.usp_OrderDetailCount') IS NOT NULL BEGIN
DROP PROC dbo.usp_OrderDetailCount;
END;
GO
--2
CREATE PROC dbo.usp_OrderDetailCount @OrderID INT,
@Count INT OUTPUT AS
SELECT @Count = COUNT(*)
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = @OrderID;
RETURN 0;
GO
--3
DECLARE @OrderCount INT;
--4
EXEC usp_OrderDetailCount 71774, @OrderCount OUTPUT;
--5
PRINT @OrderCount;


--Listing 9-15. Inserting the Rows from a Stored Proc into a Table
USE AdventureWorks2014;
GO
--1
IF OBJECT_ID('dbo.tempCustomer') IS NOT NULL BEGIN
DROP TABLE dbo.tempCustomer;
END
IF OBJECT_ID('dbo.usp_CustomerName') IS NOT NULL BEGIN
DROP PROC dbo.usp_CustomerName;
END;
GO
--2
CREATE TABLE dbo.tempCustomer(CustomerID INT, FirstName NVARCHAR(50),
MiddleName NVARCHAR(50), LastName NVARCHAR(50))
GO
--3
CREATE PROC dbo.usp_CustomerName @CustomerID INT = -1 AS
SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID
WHERE @CustomerID = CASE @CustomerID WHEN -1 THEN -1 ELSE c.CustomerID END;
RETURN 0;
GO
--4
INSERT INTO dbo.tempCustomer EXEC dbo.usp_CustomerName;
--5
SELECT CustomerID, FirstName, MiddleName, LastName
FROM dbo.tempCustomer;


--Listing 9-16. Using Logic in a Stored Procedure
USE tempdb;
GO
--1
IF OBJECT_ID('usp_ProgrammingLogic') IS NOT NULL BEGIN
DROP PROC usp_ProgrammingLogic;
END;
GO
--2
CREATE PROC usp_ProgrammingLogic AS
--2.1
CREATE TABLE #Numbers(number INT NOT NULL);
--2.2
DECLARE @count INT;
SET @count = ASCII('!');
--2.3
WHILE @count < 200 BEGIN
INSERT INTO #Numbers(number) VALUES (@count);
SET @count = @count + 1;
END;
--2.4
ALTER TABLE #Numbers ADD symbol NCHAR(1);
--2.5
UPDATE #Numbers SET symbol = CHAR(number);
--2.6
SELECT number, symbol FROM #Numbers
GO
--3
EXEC usp_ProgrammingLogic;