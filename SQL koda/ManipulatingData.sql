USE AdventureWorks2014;
GO
IF OBJECT_ID('demoCustomer') IS NOT NULL BEGIN
DROP TABLE demoCustomer;
END;
CREATE TABLE demoCustomer(CustomerID INT NOT NULL PRIMARY KEY,
FirstName NVARCHAR(50) NOT NULL, MiddleName NVARCHAR(50) NULL,
LastName NVARCHAR(100))
go;

--- Listing 6-1. Adding One Row at a Time with Literal Values
USE AdventureWorks2014;
GO
--1
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
VALUES (1,'Orlando','N.','Gee');
--2
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT 3, 'Donna','F.','Cameras';
--3
INSERT INTO dbo.demoCustomer
VALUES (4,'Janet','M.','Gates');
--4
INSERT INTO dbo.demoCustomer
SELECT 6,'Rosmarie','J.','Carroll';
--5
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
VALUES (2,'Keith',NULL,'Harris');
--6
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, LastName)
VALUES (5,'Lucy','Harrington');
--7
SELECT CustomerID, FirstName, MiddleName, LastName
FROM dbo.demoCustomer;


--- Listing 6-2. Attempting to Insert Rows with Invalid INSERT Statements
USE AdventureWorks2014;
GO
PRINT '1';
--1
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
VALUES (1, 'Dominic','P.','Gash');
PRINT '2';
--2
INSERT INTO dbo.demoCustomer (CustomerID, MiddleName, LastName)
VALUES (10,'M.','Garza');
GO
PRINT '3';
GO
--3
INSERT INTO dbo.demoCustomer
VALUES (11,'Katherine','Harding');
GO
PRINT '4';
GO
--4
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, LastName)
VALUES (11, 'Katherine', NULL,'Harding');
GO
PRINT '5';
GO
--5
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, LastName)
VALUES ('A','Katherine','Harding');


--- Listing 6-3. Inserting Multiple Rows with One INSERT
USE AdventureWorks2014;
GO
--1
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT 7,'Dominic','P.','Gash'
UNION
SELECT 10,'Kathleen','M.','Garza'
UNION
SELECT 11, 'Katherine', NULL,' Harding';
--2
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
VALUES (12,'Johnny','A.','Capino'),
(16,'Christopher','R.','Beck'),
(18,'David','J.','Liu');
--3
SELECT CustomerID, FirstName, MiddleName, LastName
FROM dbo.demoCustomer
WHERE CustomerID >= 7;


--- Listing 6-4. Inserting Rows from Another Table
USE AdventureWorks2014;
GO
--1
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT BusinessEntityID, FirstName, MiddleName, LastName
FROM Person.Person
WHERE BusinessEntityID BETWEEN 19 AND 35;
--2
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT DISTINCT c.BusinessEntityID, c.FirstName, c.MiddleName, c.LastName
FROM Person.Person AS c
INNER JOIN Sales.SalesOrderHeader AS s ON c.BusinessEntityID = s.SalesPersonID
--3
SELECT CustomerID, FirstName, MiddleName, LastName
FROM dbo.demoCustomer
WHERE CustomerID > 18;


--- Listing 6-5. Inserting Missing Rows
USE AdventureWorks2014;
GO
--1
INSERT INTO dbo.demoCustomer (CustomerID, FirstName, MiddleName, LastName)
SELECT c.BusinessEntityID, c.FirstName, c.MiddleName, c.LastName
FROM Person.Person AS c
LEFT OUTER JOIN dbo.demoCustomer AS d ON c.BusinessEntityID = d.CustomerID
WHERE d.CustomerID IS NULL;
--2
SELECT COUNT(CustomerID) AS CustomerCount
FROM dbo.demoCustomer;


--- Listing 6-6. Using SELECT INTO to Create and Populate a Table
USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoCustomer]')
AND type in (N'U'))
DROP TABLE dbo.demoCustomer;
GO
--1
SELECT BusinessEntityID, FirstName, MiddleName, LastName,
FirstName + ISNULL(' ' + MiddleName,'') + ' ' + LastName AS FullName
INTO dbo.demoCustomer
FROM Person.Person;
--2
SELECT BusinessEntityID, FirstName, MiddleName, LastName, FullName
FROM dbo.demoCustomer;


--- Listing 6-7. Inserting Data with a Column Default Constraint
USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoDefault]')
AND type in (N'U'))
DROP TABLE [dbo].[demoDefault]
GO
CREATE TABLE [dbo].[demoDefault](
[KeyColumn] [int] NOT NULL PRIMARY KEY,
[HasADefault1] [DATETIME2](1) NOT NULL,
[HasADefault2] [NVARCHAR](50) NULL,
)
GO
ALTER TABLE [dbo].[demoDefault] ADD CONSTRAINT [DF_demoDefault_HasADefault]
DEFAULT (GETDATE()) FOR [HasADefault1]
GO
ALTER TABLE [dbo].[demoDefault] ADD CONSTRAINT [DF_demoDefault_HasADefault2]
DEFAULT ('the default') FOR [HasADefault2]
GO
--1
INSERT INTO dbo.demoDefault(HasADefault1,HasADefault2,KeyColumn)
VALUES ('2009-04-24','Test 1',1),('2009-10-1',NULL,2);
--2
INSERT INTO dbo.demoDefault (HasADefault1,HasADefault2,KeyColumn)
VALUES (DEFAULT,DEFAULT,3),(DEFAULT,DEFAULT,4);
--3
INSERT INTO dbo.demoDefault (KeyColumn)
VALUES (5),(6);
--4
SELECT HasADefault1,HasADefault2,KeyColumn
FROM dbo.demoDefault;


--- Listing 6-8. Inserting Rows into Tables with Autopopulated Columns
USE [AdventureWorks2014]
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoAutoPopulate]')
AND type in (N'U'))
DROP TABLE [dbo].[demoAutoPopulate];
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSequence]'))
DROP SEQUENCE [dbo].[demoSequence];
CREATE SEQUENCE dbo.demoSequence
AS INT
START WITH 1
INCREMENT BY 1;
CREATE TABLE [dbo].[demoAutoPopulate](
[RegularColumn] [NVARCHAR](50) NOT NULL PRIMARY KEY,
[IdentityColumn] [INT] IDENTITY(1,1) NOT NULL,
[RowversionColumn] [ROWVERSION] NOT NULL,
[SequenceColumn] [INT] NOT NULL,
[ComputedColumn] AS ([RegularColumn]+CONVERT([NVARCHAR],
[IdentityColumn],(0))) PERSISTED)
GO
--1
INSERT INTO dbo.demoAutoPopulate (RegularColumn, SequenceColumn)
VALUES ('a', NEXT VALUE FOR dbo.demoSequence),
('b', NEXT VALUE FOR dbo.demoSequence),
('c', NEXT VALUE FOR dbo.demoSequence);
--2
SELECT RegularColumn, IdentityColumn, RowversionColumn, SequenceColumn, ComputedColumn
FROM demoAutoPopulate;


USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoProduct]')
AND type in (N'U'))
DROP TABLE [dbo].[demoProduct]
GO
CREATE TABLE [dbo].[demoProduct](
[ProductID] [INT] NOT NULL PRIMARY KEY,
[Name] [dbo].[Name] NOT NULL,
[Color] [NVARCHAR](15) NULL,
[StandardCost] [MONEY] NOT NULL,
[ListPrice] [MONEY] NOT NULL,
[Size] [NVARCHAR](5) NULL,
[Weight] [DECIMAL](8, 2) NULL,
);
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesOrderHeader]')
AND type in (N'U'))
DROP TABLE [dbo].[demoSalesOrderHeader]
GO
CREATE TABLE [dbo].[demoSalesOrderHeader](
[SalesOrderID] [INT] NOT NULL PRIMARY KEY,
[SalesID] [INT] NOT NULL IDENTITY,
[OrderDate] [DATETIME] NOT NULL,
[CustomerID] [INT] NOT NULL,
[SubTotal] [MONEY] NOT NULL,
[TaxAmt] [MONEY] NOT NULL,
[Freight] [MONEY] NOT NULL,
[DateEntered] [DATETIME],
[SalesNumber] [INT] NOT NULL,
[TotalDue] AS (ISNULL(([SubTotal]+[TaxAmt])+[Freight],(0))),
[RV] ROWVERSION NOT NULL);
GO
ALTER TABLE [dbo].[demoSalesOrderHeader] ADD CONSTRAINT
[DF_demoSalesOrderHeader_DateEntered]
DEFAULT (getdate()) FOR [DateEntered];
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesSequence]'))
DROP SEQUENCE [dbo].[demoSalesSequence]
GO
CREATE SEQUENCE demoSalesSequence
AS INT
START WITH 1
INCREMENT BY 1;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoAddress]')
AND type in (N'U'))
DROP TABLE [dbo].[demoAddress]
GO
CREATE TABLE [dbo].[demoAddress](
[AddressID] [INT] NOT NULL IDENTITY PRIMARY KEY,
[AddressLine1] [NVARCHAR](60) NOT NULL,
[AddressLine2] [NVARCHAR](60) NULL,
[City] [NVARCHAR](30) NOT NULL,
[PostalCode] [NVARCHAR](15) NOT NULL
);
--CHAPTER 6 ? MANIPULATING DATA218


--- Listing 6-9. Creating Demo Tables - deleting
USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoProduct]')
AND type in (N'U'))
DROP TABLE [dbo].[demoProduct];
GO
SELECT * INTO dbo.demoProduct FROM Production.Product;
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoCustomer]')
AND type in (N'U'))
DROP TABLE [dbo].[demoCustomer];
GO
SELECT * INTO dbo.demoCustomer FROM Sales.Customer;
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoAddress]')
AND type in (N'U'))
DROP TABLE [dbo].[demoAddress];
GO
SELECT * INTO dbo.demoAddress FROM Person.Address;
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesOrderHeader]')
AND type in (N'U'))
DROP TABLE [dbo].[demoSalesOrderHeader];
GO
SELECT * INTO dbo.demoSalesOrderHeader FROM Sales.SalesOrderHeader;
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesOrderDetail]')
AND type in (N'U'))
DROP TABLE [dbo].[demoSalesOrderDetail];
GO
SELECT * INTO dbo.demoSalesOrderDetail FROM Sales.SalesOrderDetail;


--- Listing 6-10. Deleting Rows from Tables
USE AdventureWorks2014;
GO
--1
SELECT CustomerID
FROM dbo.demoCustomer;
--2
DELETE dbo.demoCustomer;
--3
SELECT CustomerID
FROM dbo.demoCustomer;
--4
SELECT ProductID
FROM dbo.demoProduct
WHERE ProductID > 900;
--5
DELETE dbo.demoProduct
WHERE ProductID > 900;
--6
SELECT ProductID
FROM dbo.demoProduct
WHERE ProductID > 900;


--- Listing 6-11. Deleting When Joining or Using a Subquery
USE AdventureWorks2014;
GO
--1
SELECT d.SalesOrderID, SalesOrderNumber
FROM dbo.demoSalesOrderDetail AS d
INNER JOIN dbo.demoSalesOrderHeader AS h ON d.SalesOrderID = h.SalesOrderID
WHERE h.SalesOrderNumber = 'SO71797'
--2
DELETE d
FROM dbo.demoSalesOrderDetail AS d
INNER JOIN dbo.demoSalesOrderHeader AS h ON d.SalesOrderID = h.SalesOrderID
WHERE h.SalesOrderNumber = 'SO71797'
--3
SELECT d.SalesOrderID, SalesOrderNumber
FROM dbo.demoSalesOrderDetail AS d
INNER JOIN dbo.demoSalesOrderHeader AS h ON d.SalesOrderID = h.SalesOrderID
WHERE h.SalesOrderNumber = 'SO71797'
--4
SELECT SalesOrderID, ProductID
FROM dbo.demoSalesOrderDetail
WHERE ProductID NOT IN
(SELECT ProductID FROM dbo.demoProduct WHERE ProductID IS NOT NULL);
--5
DELETE FROM dbo.demoSalesOrderDetail
WHERE ProductID NOT IN
(SELECT ProductID FROM dbo.demoProduct WHERE ProductID IS NOT NULL);
--6
SELECT SalesOrderID, ProductID
FROM dbo.demoSalesOrderDetail
WHERE ProductID NOT IN
(SELECT ProductID FROM dbo.demoProduct WHERE ProductID IS NOT NULL);


--- Listing 6-12. Truncating Tables
USE AdventureWorks2014;
GO
--1
SELECT SalesOrderID, OrderDate
FROM dbo.demoSalesOrderHeader;
--2
TRUNCATE TABLE dbo.demoSalesOrderHeader;
--3
SELECT SalesOrderID, OrderDate
FROM dbo.demoSalesOrderHeader;


--- Listing 6-13. Updating Data in a Table
USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoPerson]')
AND type in (N'U'))
DROP TABLE [dbo].[demoPerson]
GO
SELECT * INTO dbo.demoPerson
FROM Person.Person
WHERE Title in ('Mr.', 'Mrs.', 'Ms.')
--1
SELECT BusinessEntityID, NameStyle, Title
FROM dbo.demoPerson
ORDER BY BusinessEntityID;
--2
UPDATE dbo.demoPerson
SET NameStyle = 1;
--3
SELECT BusinessEntityID, NameStyle, Title
FROM dbo.demoPerson
ORDER BY BusinessEntityID;
--4
UPDATE dbo.demoPerson
SET NameStyle = 0
WHERE Title = 'Ms.';
--5
SELECT BusinessEntityID, NameStyle, Title
FROM dbo.demoPerson
ORDER BY BusinessEntityID;


--- Listing 6-14. Update with Expressions, Columns, or Data from Another Table
USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoPersonStore]')
AND type in (N'U'))
DROP TABLE [dbo].[demoPersonStore]
GO
CREATE TABLE [dbo].[demoPersonStore] (
[FirstName] [NVARCHAR] (60),
[LastName] [NVARCHAR] (60),
[CompanyName] [NVARCHAR] (60)
);
INSERT INTO dbo.demoPersonStore (FirstName, LastName, CompanyName)
SELECT a.FirstName, a.LastName, c.Name
FROM Person.Person a
JOIN Sales.SalesPerson b
ON a.BusinessEntityID = b.BusinessEntityID
JOIN Sales.Store c
ON b.BusinessEntityID = c.SalesPersonID
--1
SELECT FirstName,LastName, CompanyName,
LEFT(FirstName,3) + '.' + LEFT(LastName,3) AS NewCompany
FROM dbo.demoPersonStore;
--2
UPDATE dbo.demoPersonStore
SET CompanyName = LEFT(FirstName,3) + '.' + LEFT(LastName,3);
--3
SELECT FirstName,LastName, CompanyName,
LEFT(FirstName,3) + '.' + LEFT(LastName,3) AS NewCompany
FROM dbo.demoPersonStore;


--- Listing 6-15. Updating with a Join
USE AdventureWorks2014;
GO
--1
SELECT AddressLine1, AddressLine2
FROM dbo.demoAddress;
--2
UPDATE a
SET AddressLine1 = FirstName + ' ' + LastName,
AddressLine2 = AddressLine1 + ISNULL(' ' + AddressLine2,'')
FROM dbo.demoAddress AS a
INNER JOIN Person.BusinessEntityAddress c ON a.AddressID = c.AddressID
INNER JOIN Person.Person b ON b.BusinessEntityID = c.BusinessEntityID
--3
SELECT AddressLine1, AddressLine2
FROM dbo.demoAddress;


--- Listing 6-16. Updates with Aggregate Expressions
USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoCustomerSummary]')
AND type in (N'U'))
DROP TABLE [dbo].[demoCustomerSummary];
GO
CREATE TABLE dbo.demoCustomerSummary (CustomerID INT NOT NULL PRIMARY KEY,
SaleCount INTEGER NULL,
TotalAmount MONEY NULL);
GO
INSERT INTO dbo.demoCustomerSummary (CustomerID, SaleCount,TotalAmount)
SELECT BusinessEntityID, 0, 0
FROM dbo.demoPerson;
GO
--1
SELECT CustomerID, SaleCount, TotalAmount
FROM dbo.demoCustomerSummary
WHERE CustomerID in (11621,12798,13589,14465,18623);
--2
WITH Totals AS (
SELECT COUNT(*) AS SaleCount,SUM(TotalDue) AS TotalAmount,
CustomerID
FROM dbo.demoSalesOrderHeader
GROUP BY CustomerID)
UPDATE c SET TotalAmount = Totals.TotalAmount,
SaleCount = Totals.SaleCount
FROM dbo.demoCustomerSummary AS c
INNER JOIN Totals ON c.CustomerID = Totals.CustomerID;
--3
SELECT CustomerID, SaleCount, TotalAmount
FROM dbo.demoCustomerSummary
WHERE CustomerID in (11621,12798,13589,14465,18623);


--- Listing 6-17. Explicit Transactions
USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoTransaction]')
AND type in (N'U'))
DROP TABLE [dbo].[demoTransaction];
GO
CREATE TABLE dbo.demoTransaction (col1 INT NOT NULL);
GO
--1
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (1);
INSERT INTO dbo.demoTransaction (col1) VALUES (2);
COMMIT TRAN
--2
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (3);
INSERT INTO dbo.demoTransaction (col1) VALUES ('a');
COMMIT TRAN
GO
--3
SELECT col1
FROM dbo.demoTransaction;


USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoTransaction]')
AND type in (N'U'))
DROP TABLE [dbo].[demoTransaction];
GO
CREATE TABLE dbo.demoTransaction (col1 INT NOT NULL);
GO
--1
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (1);
INSERT INTO dbo.demoTransaction (col1) VALUES (2);
COMMIT TRAN
--2
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (3);
INSERT INTO dbo.demoTransaction (col1) VALUES (4);
ROLLBACK TRAN
GO
--3
SELECT col1
FROM dbo.demoTransaction;


--- Listing 6-19. The Difference Between the Set-Based and Iterative Approaches
USE AdventureWorks2014;
GO
--Create a work table
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoPerformance]')
AND type in (N'U'))
DROP TABLE [dbo].[demoPerformance];
GO
CREATE TABLE [dbo].[demoPerformance](
[SalesOrderID] [int] NOT NULL,
[SalesOrderDetailID] [int] NOT NULL,
CONSTRAINT [PK_demoPerformance] PRIMARY KEY CLUSTERED
(
[SalesOrderID] ASC,
[SalesOrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
PRINT 'Insert all rows start';
PRINT getdate();
--Insert all rows from the Sales.SalesOrderDetail table at once
INSERT INTO dbo.demoPerformance(SalesOrderID, SalesOrderDetailID)
SELECT SalesOrderID, SalesOrderDetailID
FROM Sales.SalesOrderDetail;
PRINT 'Insert all rows end';
PRINT getdate();
--Remove all rows from the first insert
TRUNCATE TABLE [dbo].[demoPerformance];
PRINT 'Insert rows one at a time begin';
PRINT getdate();
--Set up a loop to insert one row at a time
WHILE EXISTS(
SELECT *
FROM Sales.SalesOrderDetail AS d LEFT JOIN dbo.demoPerformance AS p
ON d.SalesOrderID = p.SalesOrderID
AND d.SalesOrderDetailID = p.SalesOrderDetailID
WHERE p.SalesOrderID IS NULL) BEGIN
INSERT INTO dbo.demoPerformance (SalesOrderID,SalesOrderDetailID)
SELECT TOP 1 d.SalesOrderID, d.SalesOrderDetailID
FROM Sales.SalesOrderDetail AS d LEFT JOIN dbo.demoPerformance AS p
ON d.SalesOrderID = p.SalesOrderID
AND d.SalesOrderDetailID = p.SalesOrderDetailID
WHERE p.SalesOrderID IS NULL;
END
PRINT 'Insert rows one at a time end';
PRINT getdate();


--- Listing 6-20. Deleting Demo Tables
USE [AdventureWorks2014];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoProduct]')
AND type in (N'U'))
DROP TABLE [dbo].[demoProduct];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoCustomer]')
AND type in (N'U'))
DROP TABLE [dbo].[demoCustomer];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoAddress]')
AND type in (N'U'))
DROP TABLE [dbo].[demoAddress];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesOrderHeader]')
AND type in (N'U'))
DROP TABLE [dbo].[demoSalesOrderHeader];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoSalesOrderDetail]')
AND type in (N'U'))
DROP TABLE [dbo].[demoSalesOrderDetail];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoTransaction]')
AND type in (N'U'))
DROP TABLE [dbo].[demoTransaction];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoCustomerSummary]')
AND type in (N'U'))
DROP TABLE [dbo].[demoCustomerSummary];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoDefault]')
AND type in (N'U'))
DROP TABLE [dbo].[demoDefault];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoAutoPopulate]')
AND type in (N'U'))
DROP TABLE [dbo].[demoAutoPopulate];
USE [AdventureWorks2014];
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoPerformance]')
AND type in (N'U'))
DROP TABLE [dbo].[demoPerformance];

------Transactions
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoTransaction]')
AND type in (N'U'))
DROP TABLE [dbo].[demoTransaction];
GO
CREATE TABLE dbo.demoTransaction (col1 INT NOT NULL);
GO
--1
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (1);
INSERT INTO dbo.demoTransaction (col1) VALUES (2);
COMMIT TRAN
--2
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (3);
INSERT INTO dbo.demoTransaction (col1) VALUES ('a');
COMMIT TRAN
GO
--3
SELECT col1
FROM dbo.demoTransaction;

IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoTransaction]')
AND type in (N'U'))
DROP TABLE [dbo].[demoTransaction];
GO
CREATE TABLE dbo.demoTransaction (col1 INT NOT NULL);
GO
--1
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (1);
INSERT INTO dbo.demoTransaction (col1) VALUES (2);
COMMIT TRAN
--2
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (3);
INSERT INTO dbo.demoTransaction (col1) VALUES (4);
ROLLBACK TRAN
GO
--3
SELECT col1
FROM dbo.demoTransaction;


USE AdventureWorks2014;
GO
IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[demoTransaction]')
AND type in (N'U'))
DROP TABLE [dbo].[demoTransaction];
GO
CREATE TABLE dbo.demoTransaction (col1 INT NOT NULL);
GO
BEGIN TRAN
INSERT INTO dbo.demoTransaction (col1) VALUES (1);
INSERT INTO dbo.demoTransaction (col1) VALUES (2);
--2. Switch to window 2, and run this code:
USE AdventureWorks2014;
GO
SELECT col1 FROM dbo.demoTransaction;
--3. At this point, you will see nothing returned from the code from step 2 as it
--continues to execute. Switch to window 1, and run this code:
COMMIT TRAN