----Listing 7-1. Declaring and Using Variables
USE AdventureWorks2014;
GO
--1
DECLARE @myNumber INT = 10;
PRINT 'The value of @myNumber';
PRINT @myNumber;
SET @myNumber = 20;
PRINT 'The value of @myNumber';
PRINT @myNumber;
GO
--2
DECLARE @myString VARCHAR(100), @myBit BIT;
SELECT @myString = 'Hello, World', @myBit = 1;
PRINT 'The value of @myString';
PRINT @myString;
PRINT 'The value of @myBit';
PRINT @myBit;
GO
--3
DECLARE @myUnicodeString NVARCHAR(100);
SET @myUnicodeString = N'This is a Unicode String';
PRINT 'The value of @myUnicodeString';
PRINT @myUnicodeString;
GO
--4
DECLARE @FirstName NVARCHAR(50), @LastName NVARCHAR(50);
SELECT @FirstName = FirstName, @LastName = LastName
FROM Person.Person
WHERE BusinessEntityID = 1;
PRINT 'The value of @FirstName';
PRINT @FirstName;
PRINT 'The value of @LastName';
PRINT @LastName;
GO
--5
PRINT 'The value of @myString';
PRINT @myString;


--Listing 7-2. Using Expressions and Functions to Assign Variable Values
USE AdventureWorks2014;
GO
--1
DECLARE @myINT1 INT = 10, @myINT2 INT = 20, @myINT3 INT;
SET @myINT3 = @myINT1 * @myINT2;
PRINT 'Value of @myINT3: ' + CONVERT(VARCHAR,@myINT3);
GO
--2
DECLARE @myString VARCHAR(100);
SET @myString = 'Hello, ';
SET @myString += 'World';
PRINT 'Value of @myString: ' + @myString;
GO
--3
DECLARE @CustomerCount INT;
SELECT @CustomerCount = COUNT(*)
FROM Sales.Customer;
PRINT 'Customer Count: ' + CAST(@CustomerCount AS VARCHAR);
--4
DECLARE @FullName NVARCHAR(152);
SELECT @FullName = FirstName + ISNULL(' ' + MiddleName,'') + ' ' + LastName
FROM Person.Person
WHERE BusinessEntityID = 1;
PRINT 'FullName: ' + @FullName;


--Listing 7-3. Using a Variable in a WHERE or HAVING Clause Predicate
USE AdventureWorks2014;
GO
--1
DECLARE @ID INT;
SET @ID = 1;
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
WHERE BusinessEntityID = @ID;
GO
--2
DECLARE @FirstName NVARCHAR(50);
SET @FirstName = N'Ke%';
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
WHERE FirstName LIKE @FirstName
ORDER BY BusinessEntityID;
GO
--3
DECLARE @ID INT = 1;
--3.1
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
WHERE @ID = CASE @ID WHEN 0 THEN 0 ELSE BusinessEntityID END;
SET @ID = 0;
--3.2
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
WHERE @ID = CASE @ID WHEN 0 THEN 0 ELSE BusinessEntityID END;
GO
--4
DECLARE @Amount INT = 10000;
SELECT SUM(TotalDue) AS TotalSales, CustomerID
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > @Amount;


--Listing 7-4. Using IF to Control Code Execution
USE AdventureWorks2014;
GO
--1
DECLARE @Count INT;
SELECT @Count = COUNT(*)
FROM Sales.Customer;
IF @Count > 500 BEGIN
PRINT 'The customer count is over 500.';
END;
GO
--2
DECLARE @Name VARCHAR(50);
SELECT @Name = FirstName + ' ' + LastName
FROM Person.Person
WHERE BusinessEntityID = 1;
--2.1
IF CHARINDEX('Ken',@Name) > 0 BEGIN
PRINT 'The name for BusinessEntityID = 1 contains "Ken"';
END;
--2.2
IF CHARINDEX('Kathi',@Name) > 0 BEGIN
PRINT 'The name for BusinessEntityID = 1 contains "Kathi"';
END;


--Listing 7-5. Using ELSE
USE AdventureWorks2014;
GO
--1
DECLARE @Count INT;
SELECT @Count = COUNT(*)
FROM Sales.Customer;
IF @Count < 500 PRINT 'The customer count is less than 500.';
ELSE PRINT 'The customer count is 500 or more.';
GO
--2
DECLARE @Name NVARCHAR(101);
SELECT @Name = FirstName + ' ' + LastName
FROM Person.Person
WHERE BusinessEntityID = 1;
--2.1
IF CHARINDEX('Ken', @Name) > 0 BEGIN
PRINT 'The name for BusinessEntityID = 1 contains "Ken"';
END;
ELSE BEGIN
PRINT 'The name for BusinessEntityID = 1 does not contain "Ken"';
PRINT 'The name is ' + @Name;
END;
--2.2
IF CHARINDEX('Kathi', @Name) > 0 BEGIN
PRINT 'The name for BusinessEntityID = 1 contains "Kathi"';
END;
ELSE BEGIN
PRINT 'The name for BusinessEntityID = 1 does not contain "Kathi"';
PRINT 'The name is ' + @Name;
END;


--Listing 7-6. Using Multiple Conditions with IF and ELSE
USE AdventureWorks2014;
GO
--1
DECLARE @Count INT;
SELECT @Count = COUNT(*)
FROM Sales.Customer;
IF @Count > 500 AND DATEPART(dw,getdate()) = 2 BEGIN
PRINT 'The count is over 500.';
PRINT 'Today is Monday.';
END
ELSE BEGIN
PRINT 'Either the count is too low or today is not Monday.';
END;
--2
IF @Count > 500 AND (DATEPART(dw,getdate()) = 2 OR DATEPART(m,getdate())= 5) BEGIN
PRINT 'The count is over 500.'
PRINT 'It is either Monday or the month is May.'
END


--Listing 7-7. Using a Nested IF Block
USE AdventureWorks2014;
GO
DECLARE @Count INT;
SELECT @Count = COUNT(*)
FROM Sales.Customer;
IF @Count > 500 BEGIN
PRINT 'The count is over 500.';
IF DATEPART(dw,getdate())= 2 BEGIN
PRINT 'Today is Monday.';
END;
ELSE BEGIN
PRINT 'Today is not Monday.';
END;
END;


--Listing 7-8. Using IF EXISTS
USE AdventureWorks2014;
GO
--1
IF EXISTS(SELECT * FROM Person.Person WHERE BusinessEntityID = 1) BEGIN
PRINT 'There is a row with BusinessEntityID = 1';
END
ELSE BEGIN
PRINT 'There is not a row with BusEntityID = 1';
END;
--2
IF NOT EXISTS(SELECT * FROM Person.Person WHERE FirstName = 'Kathi') BEGIN
PRINT 'There is not a person with the first name "Kathi".';
END;


--Listing 7-10. Using SET ROW COUNT to Limit the Number of Rows Affected
USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'dbo.demoSalesOrderDetail')
AND type in (N'U'))
DROP TABLE dbo.demoSalesOrderDetail;
GO
CREATE TABLE dbo.demoSalesOrderDetail(SalesOrderID INT NOT NULL,
SalesOrderDetailID INT NOT NULL, Processed BIT NOT NULL);
GO
SET ROWCOUNT 0;
INSERT INTO dbo.demoSalesOrderDetail(SalesOrderID,SalesOrderDetailID,Processed)
SELECT SalesOrderID, SalesOrderDetailID, 0
FROM Sales.SalesOrderDetail;
PRINT 'Populated work table';
SET ROWCOUNT 50000;
WHILE EXISTS(SELECT * From dbo.demoSalesOrderDetail WHERE Processed = 0) BEGIN
UPDATE dbo.demoSalesOrderDetail SET Processed = 1
WHERE Processed = 0;
PRINT 'Updated 50,000 rows';
END;
PRINT 'Done!';


--Listing 7-11. Using a Nested WHILE Loop
DECLARE @OuterCount INT = 1;
DECLARE @InnerCount INT;
WHILE @OuterCount < 10 BEGIN
PRINT 'Outer Loop';
SET @InnerCount = 1;
WHILE @InnerCount < 5 BEGIN
PRINT ' Inner Loop';
SET @InnerCount += 1;
END;
SET @OuterCount += 1;
END;


--Listing 7-12. Using BREAK
DECLARE @Count INT = 1;
WHILE @Count < 50 BEGIN
PRINT @Count;
IF @Count = 10 BEGIN
PRINT 'Exiting the WHILE loop';
BREAK;
END;
SET @Count += 1;
END;


--Listing 7-13. Using CONTINUE in a WHILE Loop
DECLARE @Count INT = 1;
WHILE @Count < 10 BEGIN
PRINT @Count;
SET @Count += 1;
IF @Count = 3 BEGIN
PRINT 'CONTINUE';
CONTINUE;
END;
PRINT 'Bottom of loop';
END;


--Listing 7-14. Using @@ERROR to Handle Errors
USE AdventureWorks2014;
GO
--1
DECLARE @errorNo INT;
PRINT 1/0;
SET @errorNo = @@ERROR;
IF @errorNo > 0 BEGIN
PRINT 'An error has occurred.'
PRINT @errorNo;
PRINT @@ERROR;
END;
GO
--2
DECLARE @errorNo INT;
DROP TABLE testTable;
SET @errorNo = @@ERROR;
IF @errorNo > 0 BEGIN
PRINT 'An error has occurred.'
PRINT @errorNo;
PRINT @@ERROR;
END;
GO
--3
DECLARE @errorNo INT;
SET IDENTITY_INSERT Person.ContactType ON;
INSERT INTO Person.ContactType(ContactTypeID,Name,ModifiedDate)
VALUES (1,'Accounting Manager',GETDATE());
SET @errorNo = @@ERROR;
IF @errorNo > 0 BEGIN
PRINT 'An error has occurred.';
PRINT @errorNo;
END;


--Listing 7-15. Using GOTO
DECLARE @errorNo INT;
PRINT 'Beginning of code.'
PRINT 1/0;
SET @errorNo = @@ERROR;
IF @errorNo > 0 GOTO ERR_LABEL;
PRINT 'No error';
ERR_LABEL:
PRINT 'At ERR_LABEL';


--Listing 7-16. Using TRY…CATCH
USE AdventureWorks2014;
GO
--1
BEGIN TRY
PRINT 1/0;
END TRY
BEGIN CATCH
PRINT 'Inside the Catch block';
PRINT ERROR_NUMBER();
PRINT ERROR_MESSAGE();
PRINT ERROR_NUMBER();
END CATCH
PRINT 'Outside the catch block';
PRINT ERROR_NUMBER()
GO
--2
BEGIN TRY
DROP TABLE testTable;
END TRY
BEGIN CATCH
PRINT 'An error has occurred.'
PRINT ERROR_NUMBER();
PRINT ERROR_MESSAGE();
END CATCH;


--Listing 7-17. Untrappable Errors
USE AdventureWorks2014;
GO
--1
PRINT 'Syntax error.';
GO
BEGIN TRY
SELECT FROM Sales.SalesOrderDetail;
END TRY
BEGIN CATCH
PRINT ERROR_NUMBER();
END CATCH;
GO
--2
PRINT 'Invalid column.';
GO
BEGIN TRY
SELECT ABC FROM Sales.SalesOrderDetail;
END TRY
BEGIN CATCH
PRINT ERROR_NUMBER();
END CATCH;


--Listing 7-18. Using RAISERROR
USE master;
GO
--1 This code section creates a custom error message
IF EXISTS(SELECT * FROM sys.messages where message_id = 50002) BEGIN
EXEC sp_dropmessage 50002;
END
GO
PRINT 'Creating a custom error message.'
EXEC sp_addmessage 50002, 16,
N'Customer missing.';
GO
USE AdventureWorks2014;
GO
--2
IF NOT EXISTS(SELECT * FROM Sales.Customer
WHERE CustomerID = -1) BEGIN
RAISERROR(50002,16,1);
END
GO
--3
BEGIN TRY
PRINT 1/0;
END TRY
BEGIN CATCH
IF ERROR_NUMBER() = 8134 BEGIN
RAISERROR('A bad math error!',16,1);
END;
END CATCH;


--Listing 7-19. Using TRY…CATCH with a Transaction
--1
CREATE TABLE #Test (ID INT NOT NULL PRIMARY KEY);
GO
--2
BEGIN TRY
--2.1
BEGIN TRAN
--2.1.1
INSERT INTO #Test (ID)
VALUES (1),(2),(3);
--2.1.2
UPDATE #Test SET ID = 2 WHERE ID = 1;
--2.2
COMMIT
END TRY
--3
BEGIN CATCH
--3.1
PRINT ERROR_MESSAGE();
--3.2
PRINT 'Rolling back transaction';
ROLLBACK;
END CATCH;


--Listing 7-20. Simple THROW statement
THROW 999999, 'This is a test error.', 1


--Listing 7-21. Using THROW in a transaction
BEGIN TRY
INSERT INTO Person.PersonPhone (BusinessEntityID, PhoneNumber, PhoneNumberTypeID)
VALUES (1, '697-555-0142', 1);
END TRY
BEGIN CATCH
THROW 999999, 'I will not allow you to insert a duplicate value.', 1;
END CATCH


--Listing 7-22. Creating and Populating Local Temp Table
USE AdventureWorks2014;
GO
CREATE TABLE #myCustomers(CustomerID INT, FirstName VARCHAR(25),
LastName VARCHAR(25));
GO
INSERT INTO #myCustomers(CustomerID,FirstName,LastName)
SELECT C.CustomerID, FirstName, LastName
FROM Person.Person AS P INNER JOIN Sales.Customer AS C
ON P.BusinessEntityID = C.PersonID;
SELECT CustomerID, FirstName, LastName
FROM #myCustomers;
DROP TABLE #myCustomers;


--Listing 7-23. Creating and Populating a Global Temp Table
USE AdventureWorks2014;
GO
CREATE TABLE ##myCustomers(CustomerID INT, FirstName VARCHAR(25),
LastName VARCHAR(25));
GO
INSERT INTO ##myCustomers(CustomerID,FirstName,LastName)
SELECT C.CustomerID, FirstName,LastName
FROM Person.Person AS P INNER JOIN Sales.Customer AS C
ON P.BusinessEntityID = C.PersonID;
SELECT CustomerID, FirstName, LastName
FROM ##myCustomers;
--Run the drop statement when you are done
--DROP TABLE ##myCustomers;


--Listing 7-24. Creating and Populating Table Variable
USE AdventureWorks2014;
DECLARE @myCustomers TABLE (CustomerID INT, FirstName VARCHAR(25),
LastName VARCHAR(25))
INSERT INTO @myCustomers(CustomerID,FirstName,LastName)
SELECT C.CustomerID, FirstName,LastName
FROM Person.Person AS P INNER JOIN Sales.Customer AS C
ON P.BusinessEntityID = C.PersonID;
SELECT CustomerID, FirstName, LastName
FROM @myCustomers;


--Listing 7-25. Using a Temp Table to Solve a Query Problem
USE AdventureWorks2014;
GO
--1
DECLARE @IDTable TABLE (ID INT);
DECLARE @IDList VARCHAR(2000);
DECLARE @ID INT;
DECLARE @Loc INT;
--2
SET @IDList = '16496,12506,11390,10798,2191,11235,10879,15040,3086';
--3
SET @Loc = CHARINDEX(',',@IDList);
--4
WHILE @Loc > 0 BEGIN
--4.1
SET @ID = LEFT(@IDList,@Loc-1);
--4.2
SET @IDList = SUBSTRING(@IDList,@Loc +1,2000);
--4.3
INSERT INTO @IDTable(ID)
VALUES (@ID);
--4.4
SET @Loc = CHARINDEX(',',@IDList);
END;
--5
IF LEN(@IDList) > 0 BEGIN
SET @ID = @IDList;
INSERT INTO @IDTable(ID)
VALUES (@ID);
END;
--6
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person AS p
INNER JOIN @IDTable ON p.BusinessEntityID = ID;


--Listing 7-26. Using an “Array”
--1
SET NOCOUNT ON;
GO
--2
DECLARE @IDTable TABLE(ArrayIndex INT NOT NULL IDENTITY,
ID INT);
DECLARE @RowCount INT;
DECLARE @ID INT;
DECLARE @Count INT = 1;
--3
INSERT INTO @IDTable(ID)
VALUES(500),(333),(200),(999);
--4
SELECT @RowCount = COUNT(*)
FROM @IDTable;
--5
WHILE @Count <= @RowCount BEGIN
--5.1
SELECT @ID = ID
FROM @IDTable
WHERE ArrayIndex = @Count;
--5.2
PRINT CAST(@COUNT AS VARCHAR) + ': ' + CAST(@ID AS VARCHAR);
--5.3
SET @Count += 1;
END;


--Listing 7-27. Using a Cursor
USE AdventureWorks2014;
GO
--1
DECLARE @ProductID INT;
DECLARE @Name NVARCHAR(25);
--2
DECLARE products CURSOR FAST_FORWARD FOR
SELECT ProductID, Name
FROM Production.Product;
--3
OPEN products;
--4
FETCH NEXT FROM products INTO @ProductID, @Name;
--5
WHILE @@FETCH_STATUS = 0 BEGIN
--5.1
PRINT @ProductID;
PRINT @Name;
--5.2
FETCH NEXT FROM products INTO @ProductID, @Name;
END
--6
CLOSE products;
DEALLOCATE products;


--Listing 7-28. Using a Cursor to Populate a Report
USE AdventureWorks2014;
GO
DECLARE @Year INT;
DECLARE @Month INT;
DECLARE @TerritoryID INT;
DECLARE @Total MONEY;
DECLARE @PreviousTotal MONEY;
DECLARE @FirstYear INT;
DECLARE @LastYear INT;
DECLARE @BeginDate DATETIME;
DECLARE @EndDate DATETIME;
CREATE TABLE #Totals(OrderYear INT, OrderMonth INT,
TerritoryID INT, TotalSales MONEY,
PreviousSales MONEY);
SELECT @FirstYear = MIN(YEAR(OrderDate)),
@LastYear = MAX(YEAR(OrderDate))
FROM Sales.SalesOrderHeader;
DECLARE Territory CURSOR FAST_FORWARD FOR
SELECT TerritoryID
FROM Sales.SalesTerritory;
OPEN Territory;
FETCH NEXT FROM Territory INTO @TerritoryID;
WHILE @@FETCH_STATUS = 0 BEGIN
SET @Year = @FirstYear;
WHILE @Year <= @LastYear BEGIN
SET @Month = 1;
WHILE @Month <= 12 BEGIN
SET @BeginDate = CAST(@Year AS VARCHAR) + '/' +
CAST(@Month AS VARCHAR) + '/1';
SET @EndDate = DATEADD(M,1,@BeginDate);
SET @Total = 0;
SELECT @Total = SUM(LineTotal)
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE TerritoryID = @TerritoryID
AND OrderDate >= @BeginDate AND OrderDate < @EndDate;
SET @PreviousTotal = 0;
SET @EndDate = @BeginDate;
SET @BeginDate = DATEADD(M,-1,@BeginDate);
SELECT @PreviousTotal = SUM(LineTotal)
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE TerritoryID = @TerritoryID
AND OrderDate >= @BeginDate AND OrderDate < @EndDate;
INSERT INTO #Totals(TerritoryID, OrderYear,
OrderMonth,TotalSales, PreviousSales)
SELECT @TerritoryID, @Year, @Month,
ISNULL(@Total,0), ISNULL(@PreviousTotal,0);
SET @Month +=1;
END; -- Month loop
SET @Year += 1;
END; -- Year Loop
FETCH NEXT FROM Territory INTO @TerritoryID;
END; -- Territory cursor
CLOSE Territory;
DEALLOCATE Territory;
SELECT OrderYear, OrderMonth, TerritoryID,
TotalSales, PreviousSales
FROM #Totals
ORDER BY OrderYear, OrderMonth, TerritoryID;
SELECT OrderYear, OrderMonth, TerritoryID,
TotalSales, PreviousSales
FROM #Totals
WHERE TerritoryID = 1 AND TotalSales <> 0 AND PreviousSales <> 0
ORDER BY OrderYear, OrderMonth;
DROP TABLE #Totals;


--Listing 7-29. Populating a Report with a Set-Based Approach
USE AdventureWorks2014;
GO
--1
CREATE TABLE #Totals(TerritoryID INT, OrderYear INT, OrderMonth INT,
TotalSales MONEY, PreviousSales MONEY
);
--2
CREATE TABLE #SalesMonths(MonthNo INT);
--3
INSERT INTO #SalesMonths(MonthNo)
VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12);
--4
WITH SalesYears AS (
SELECT YEAR(OrderDate) AS OrderYear
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
)
INSERT INTO #Totals(OrderYear, OrderMonth, TerritoryID,
TotalSales, PreviousSales)
SELECT OrderYear, MonthNo,TerritoryID, 0 AS TotalSales,0 AS PreviousSales
FROM SalesYears, Sales.SalesTerritory, #SalesMonths
ORDER BY OrderYear, MonthNo, TerritoryID;
--5
WITH Totals AS (
SELECT SUM(LineTotal) AS TotalSales,
YEAR(OrderDate) AS OrderYear,
MONTH(OrderDate) AS OrderMonth, TerritoryID
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
GROUP BY YEAR(OrderDate), MONTH(OrderDate), TerritoryID
)
UPDATE #Totals SET TotalSales = Totals.TotalSales
FROM #Totals INNER JOIN Totals ON #Totals.OrderYear = Totals.OrderYear
AND #Totals.OrderMonth = Totals.OrderMonth
AND #Totals.TerritoryID = Totals.TerritoryID;
--6
WITH Totals AS (
SELECT SUM(LineTotal) AS TotalSales,
YEAR(DATEADD(M,1,OrderDate)) AS OrderYear,
MONTH(DATEADD(M,1,OrderDate)) AS OrderMonth, TerritoryID
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
GROUP BY YEAR(DATEADD(M,1,OrderDate)),
MONTH(DATEADD(M,1,OrderDate)), TerritoryID
)
UPDATE #Totals SET PreviousSales = Totals.TotalSales
FROM #Totals INNER JOIN Totals ON #Totals.OrderYear = Totals.OrderYear
AND #Totals.OrderMonth = Totals.OrderMonth
AND #Totals.TerritoryID = Totals.TerritoryID;
--7
SELECT OrderYear, OrderMonth, TerritoryID,
TotalSales, PreviousSales
FROM #Totals
ORDER BY OrderYear, OrderMonth, TerritoryID;
--8
SELECT OrderYear, OrderMonth, TerritoryID,
TotalSales, PreviousSales
FROM #Totals
WHERE TerritoryID = 1 AND TotalSales <> 0 AND PreviousSales <> 0
ORDER BY OrderYear, OrderMonth;
DROP TABLE #Totals;
DROP TABLE #SalesMonths;