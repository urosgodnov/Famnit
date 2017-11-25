--- Listing 11-1. A Query with Multiple Queries in a CTE
--1 First, populate the tempdb tables
USE [tempdb];
GO
CREATE TABLE [Employee](
[EmployeeID] [int] NOT NULL,
[ContactID] [int] NOT NULL,
[ManagerID] [int] NULL,
[Title] [nvarchar](50) NOT NULL);
CREATE TABLE [Contact] (
[ContactID] [int] NOT NULL,
[FirstName] [nvarchar](50) NOT NULL,
[MiddleName] [nvarchar](50) NULL,
[LastName] [nvarchar](50) NOT NULL);
INSERT INTO tempdb.dbo.Contact (ContactID, FirstName, MiddleName, LastName) VALUES
(1030,'Kevin','F','Brown'),
(1009,'Thierry','B','DHers'),
(1028,'David','M','Bradley'),
(1070,'JoLynn','M','Dobney'),
(1071,'Ruth','Ann','Ellerbrock'),
(1005,'Gail','A','Erickson'),
(1076,'Barry','K','Johnson'),
(1006,'Jossef','H','Goldberg'),
(1001,'Terri','Lee','Duffy'),
(1072,'Sidney','M','Higa'),
(1067,'Taylor','R','Maxwell'),
(1073,'Jeffrey','L','Ford'),
(1068,'Jo','A','Brown'),
(1074,'Doris','M','Hartwig'),
(1069,'John','T','Campbell'),
(1075,'Diane','R','Glimp'),
(1129,'Steven','T','Selikoff'),
(1231,'Peter','J','Krebs'),
(1172,'Stuart','V','Munson'),
(1173,'Greg','F','Alderson'),
(1113,'David','N','Johnson'),
(1054,'Zheng','W','Mu'),
(1007, 'Ovidiu', 'V', 'Cracium'),
(1052, 'James', 'R', 'Hamilton'),
(1053, 'Andrew', 'R', 'Hill'),
(1056, 'Jack', 'S', 'Richins'),
(1058, 'Michael', 'Sean', 'Ray'),
(1064, 'Lori', 'A', 'Kane'),
(1287, 'Ken', 'J', 'Sanchez');
INSERT INTO tempdb.dbo.Employee (EmployeeID, ContactID, ManagerID, Title) VALUES
(1, 1209, 16,'Production Technician - WC60'),
(2, 1030, 6,'Marketing Assistant'),
(3, 1002, 12,'Engineering Manager'),
(4, 1290, 3,'Senior Tool Designer'),
(5, 1009, 263,'Tool Designer'),
(6, 1028, 109,'Marketing Manager'),
(7, 1070, 21,'Production Supervisor - WC60'),
(8, 1071, 185,'Production Technician - WC10'),
(9, 1005, 3,'Design Engineer'),
(10, 1076, 185,'Production Technician - WC10'),
(11, 1006, 3,'Design Engineer'),
(12, 1001, 109,'Vice President of Engineering'),
(13, 1072, 185,'Production Technician - WC10'),
(14, 1067, 21,'Production Supervisor - WC50'),
(15, 1073, 185,'Production Technician - WC10'),
(16, 1068, 21,'Production Supervisor - WC60'),
(17, 1074, 185,'Production Technician - WC10'),
(18, 1069, 21,'Production Supervisor - WC60'),
(19, 1075, 185,'Production Technician - WC10'),
(20, 1129, 173,'Production Technician - WC30'),
(21, 1231, 148,'Production Control Manager'),
(22, 1172, 197,'Production Technician - WC45'),
(23, 1173, 197,'Production Technician - WC45'),
(24, 1113, 184,'Production Technician - WC30'),
(25, 1054, 21,'Production Supervisor - WC10'),
(109, 1287, NULL, 'Chief Executive Officer'),
(148, 1052, 109, 'Vice President of Production'),
(173, 1058, 21, 'Production Supervisor - WC30'),
(184, 1056, 21, 'Production Supervisor - WC30'),
(185, 1053, 21, 'Production Supervisor - WC10'),
(197, 1064, 21, 'Production Supervisor - WC45'),
(263, 1007, 3, 'Senior Tool Designer');
--2 Now run the CTE query
USE tempdb;
WITH
Emp AS(
SELECT e.EmployeeID, e.ManagerID,e.Title AS EmpTitle,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS EmpName
FROM Employee AS e
INNER JOIN Contact AS c
ON e.ContactID = c.ContactID
),
Mgr AS(
SELECT e.EmployeeID AS ManagerID,e.Title AS MgrTitle,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS MgrName
FROM Employee AS e
INNER JOIN Contact AS c
ON e.ContactID = c.ContactID
)
SELECT EmployeeID, Emp.ManagerID, EmpName, EmpTitle, MgrName, MgrTitle
FROM Emp INNER JOIN Mgr ON Emp.ManagerID = Mgr.ManagerID
ORDER BY EmployeeID;


--- Listing 11-2. Calling a CTE Multiple Times Within a Statement
USE tempdb;
WITH
Employees AS(
SELECT e.EmployeeID, e.ManagerID,e.Title,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS EmpName
FROM Employee AS e
INNER JOIN Contact AS c
ON e.ContactID = c.ContactID
)
SELECT emp.EmployeeID, emp.ManagerID, emp.EmpName, emp.Title AS EmpTitle,
mgr.EmpName as MgrName, mgr.Title as MgrTitle
FROM Employees AS Emp INNER JOIN Employees AS Mgr
ON Emp.ManagerID = Mgr.EmployeeID;
--2
WITH Employees AS (
SELECT e.EmployeeID, e.ManagerID,e.Title,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName AS EmpName
FROM Employee AS e
INNER JOIN Contact AS c
ON e.ContactID = c.ContactID)
SELECT EmployeeID, ManagerID, EmpName, Title
FROM Employees
WHERE EmployeeID IN (SELECT EmployeeID
FROM Employees AS e
INNER JOIN AdventureWorks2014.HumanResources.Employee AS er2 ON e.ManagerID =
er2.BusinessEntityID
WHERE er2.MaritalStatus = 'M');


--- Listing 11-3. Joining a CTE to Another CTE
USE tempdb;
--1
IF OBJECT_ID('dbo.JobHistory') IS NOT NULL BEGIN
DROP TABLE dbo.JobHistory;
END;
--2
CREATE TABLE JobHistory(
EmployeeID INT NOT NULL,
EffDate DATE NOT NULL,
EffSeq INT NOT NULL,
EmploymentStatus CHAR(1) NOT NULL,
JobTitle VARCHAR(50) NOT NULL,
Salary MONEY NOT NULL,
ActionDesc VARCHAR(20)
CONSTRAINT PK_JobHistory PRIMARY KEY CLUSTERED
(
EmployeeID, EffDate, EffSeq
));
GO
--3
INSERT INTO JobHistory(EmployeeID, EffDate, EffSeq, EmploymentStatus,
JobTitle, Salary, ActionDesc)
VALUES
(1000,'07-31-2008',1,'A','Intern',2000,'New Hire'),
(1000,'05-31-2009',1,'A','Production Technician',2000,'Title Change'),
(1000,'05-31-2009',2,'A','Production Technician',2500,'Salary Change'),
(1000,'11-01-2009',1,'A','Production Technician',3000,'Salary Change'),
(1200,'01-10-2009',1,'A','Design Engineer',5000,'New Hire'),
(1200,'05-01-2009',1,'T','Design Engineer',5000,'Termination'),
(1100,'08-01-2008',1,'A','Accounts Payable Specialist I',2500,'New Hire'),
(1100,'05-01-2009',1,'A','Accounts Payable Specialist II',2500,'Title Change'),
(1100,'05-01-2009',2,'A','Accounts Payable Specialist II',3000,'Salary Change');
--4
DECLARE @Date DATE = '05-02-2009';
--5
WITH EffectiveDate AS (
SELECT MAX(EffDate) AS MaxDate, EmployeeID
FROM JobHistory
WHERE EffDate <= @Date
GROUP BY EmployeeID
),
EffectiveSeq AS (
SELECT MAX(EffSeq) AS MaxSeq, j.EmployeeID, MaxDate
FROM JobHistory AS j
INNER JOIN EffectiveDate AS d
ON j.EffDate = d.MaxDate AND j.EmployeeID = d.EmployeeID
GROUP BY j.EmployeeID, MaxDate)
SELECT j.EmployeeID, EmploymentStatus, JobTitle, Salary
FROM JobHistory AS j
INNER JOIN EffectiveSeq AS e ON j.EmployeeID = e.EmployeeID
AND j.EffDate = e.MaxDate AND j.EffSeq = e.MaxSeq;


--- Listing 11-4. Writing a Query with the Alternate CTE Syntax
USE tempdb;
WITH Emp (EmployeeID, ManagerID, JobTitle,EmpName) AS
(SELECT e.EmployeeID, e.ManagerID,e.Title,
c.FirstName + ISNULL(' ' + c.MiddleName,'') + ' ' + c.LastName
FROM Employee AS e
INNER JOIN Contact AS c
ON e.ContactID = c.ContactID)
SELECT Emp.EmployeeID, ManagerID, JobTitle, EmpName
FROM Emp;


--- Listing 11-5. A Recursive CTE
USE tempdb;
WITH OrgChart (EmployeeID, ManagerID, Title, Level,Node)
AS (SELECT EmployeeID, ManagerID, Title, 0,
CONVERT(VARCHAR(30),'/') AS Node
FROM Employee
WHERE ManagerID IS NULL
UNION ALL
SELECT a.EmployeeID, a.ManagerID,a.Title, b.Level + 1,
CONVERT(VARCHAR(30),b.Node +
CONVERT(VARCHAR,a.ManagerID) + '/')
FROM Employee AS a
INNER JOIN OrgChart AS b ON a.ManagerID = b.EmployeeID
)
SELECT EmployeeID, ManagerID, SPACE(Level * 3) + Title AS Title, Level, Node
FROM OrgChart
ORDER BY Node;


--- Listing 11-6. Viewing the Manipulated Data with OUTPUT
USE AdventureWorks2014;
GO
--1
IF OBJECT_ID('dbo.Customers') IS NOT NULL BEGIN
DROP TABLE dbo.Customers;
END;
--2
CREATE TABLE dbo.Customers (CustomerID INT NOT NULL PRIMARY KEY,
Name VARCHAR(150),PersonID INT NOT NULL)
GO
--3
INSERT INTO dbo.Customers(CustomerID,Name,PersonID)
OUTPUT inserted.CustomerID,inserted.Name
SELECT c.CustomerID, p.FirstName + ' ' + p.LastName,PersonID
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID;
--4
UPDATE c SET Name = p.FirstName +
ISNULL(' ' + p.MiddleName,'') + ' ' + p.LastName
OUTPUT deleted.CustomerID,deleted.Name AS OldName, inserted.Name AS NewName
FROM dbo.Customers AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID;
--5
DELETE FROM dbo.Customers
OUTPUT deleted.CustomerID, deleted.Name, deleted.PersonID
WHERE CustomerID = 11000;


--- Listing 11-7. Saving the Results of OUTPUT
USE AdventureWorks2014;
--1
IF OBJECT_ID('dbo.Customers') IS NOT NULL BEGIN
DROP TABLE dbo.Customers;
END;
IF OBJECT_ID('dbo.CustomerHistory') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerHistory;
END;
--2
CREATE TABLE dbo.Customers (CustomerID INT NOT NULL PRIMARY KEY,
Name VARCHAR(150),PersonID INT NOT NULL)
CREATE TABLE dbo.CustomerHistory(CustomerID INT NOT NULL PRIMARY KEY,
OldName VARCHAR(150), NewName VARCHAR(150),
ChangeDate DATETIME);
GO
--3
INSERT INTO dbo.Customers(CustomerID, Name, PersonID)
SELECT c.CustomerID, p.FirstName + ' ' + p.LastName,PersonID
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p
ON c.PersonID = p.BusinessEntityID;
--4
UPDATE c SET Name = p.FirstName +
ISNULL(' ' + p.MiddleName,'') + ' ' + p.LastName
OUTPUT deleted.CustomerID,deleted.Name, inserted.Name, GETDATE()
INTO dbo.CustomerHistory
FROM dbo.Customers AS c
INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID;
--5
SELECT CustomerID, OldName, NewName,ChangeDate
FROM dbo.CustomerHistory;


--- Listing 11-8. Using the MERGE Statement
USE AdventureWorks2014;
--1
IF OBJECT_ID('dbo.CustomerSource') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerSource;
END;
IF OBJECT_ID('dbo.CustomerTarget') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerTarget;
END;
--2
CREATE TABLE dbo.CustomerSource (CustomerID INT NOT NULL PRIMARY KEY,
Name VARCHAR(150), PersonID INT NOT NULL);
CREATE TABLE dbo.CustomerTarget (CustomerID INT NOT NULL PRIMARY KEY,
Name VARCHAR(150), PersonID INT NOT NULL);
--3
INSERT INTO dbo.CustomerSource(CustomerID,Name,PersonID)
SELECT CustomerID,
p.FirstName + ISNULL(' ' + p.MiddleName,'') + ' ' + p.LastName,
PersonID
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
WHERE c.CustomerID IN (29485,29486,29487,10299);
--4
INSERT INTO dbo.CustomerTarget(CustomerID,Name,PersonID)
SELECT CustomerID, p.FirstName + ' ' + p.LastName, PersonID
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID
WHERE c.CustomerID IN (29485,29486,21139);
--5
SELECT CustomerID, Name, PersonID
FROM dbo.CustomerSource
ORDER BY CustomerID;
--6
SELECT CustomerID, Name, PersonID
FROM dbo.CustomerTarget
ORDER BY CustomerID;
--7
MERGE dbo.CustomerTarget AS t
USING dbo.CustomerSource AS s
ON (s.CustomerID = t.CustomerID)
WHEN MATCHED AND s.Name <> t.Name
THEN UPDATE SET Name = s.Name
WHEN NOT MATCHED BY TARGET
THEN INSERT (CustomerID, Name, PersonID) VALUES (CustomerID, Name, PersonID)
WHEN NOT MATCHED BY SOURCE
THEN DELETE
OUTPUT $action, DELETED.*, INSERTED.*;--semi-colon is required
--8
SELECT CustomerID, Name, PersonID
FROM dbo.CustomerTarget
ORDER BY CustomerID;


--- Listing 11-9. Using GROUPING SETS
USE AdventureWorks2014;
--1
SELECT NULL AS SalesOrderID,SUM(UnitPrice)AS SumOfPrice,ProductID
FROM Sales.SalesOrderDetail
WHERE SalesOrderID BETWEEN 44175 AND 44180
GROUP BY ProductID
UNION
SELECT SalesOrderID,SUM(UnitPrice), NULL
FROM Sales.SalesOrderDetail
WHERE SalesOrderID BETWEEN 44175 AND 44180
GROUP BY SalesOrderID;
--2
SELECT SalesOrderID,SUM(UnitPrice) AS SumOfPrice,ProductID
FROM Sales.SalesOrderDetail
WHERE SalesOrderID BETWEEN 44175 AND 44180
GROUP BY GROUPING SETS(SalesOrderID,ProductID);
--- Listing 11-10. Using CASE to Pivot Data
USE AdventureWorks2014;
SELECT YEAR(OrderDate) AS OrderYear,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 1 THEN TotalDue ELSE 0 END),0)
AS Jan,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 2 THEN TotalDue ELSE 0 END),0)
AS Feb,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 3 THEN TotalDue ELSE 0 END),0)
AS Mar,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 4 THEN TotalDue ELSE 0 END),0)
AS Apr,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 5 THEN TotalDue ELSE 0 END),0)
AS May,
ROUND(SUM(CASE MONTH(OrderDate) WHEN 6 THEN TotalDue ELSE 0 END),0)
AS Jun
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

--- Listing 11-11. Pivoting Results with PIVOT
USE AdventureWorks2014;
--1
SELECT OrderYear, [1] AS Jan, [2] AS Feb, [3] AS Mar,
[4] AS Apr, [5] AS May, [6] AS Jun
FROM (SELECT YEAR(OrderDate) AS OrderYear, TotalDue,
MONTH(OrderDate) AS OrderMonth
FROM Sales.SalesOrderHeader) AS MonthData
PIVOT (
SUM(TotalDue)
FOR OrderMonth IN ([1],[2],[3],[4],[5],[6])
) AS PivotData
ORDER BY OrderYear;
--2
SELECT OrderYear, ROUND(ISNULL([1],0),0) AS Jan,
ROUND(ISNULL([2],0),0) AS Feb, ROUND(ISNULL([3],0),0) AS Mar,
ROUND(ISNULL([4],0),0) AS Apr, ROUND(ISNULL([5],0),0) AS May,
ROUND(ISNULL([6],0),0) AS Jun
FROM (SELECT YEAR(OrderDate) AS OrderYear, TotalDue,
MONTH(OrderDate) AS OrderMonth
FROM Sales.SalesOrderHeader) AS MonthData
PIVOT (
SUM(TotalDue)
FOR OrderMonth IN ([1],[2],[3],[4],[5],[6])
) AS PivotData


--- Listing 11-12. Creating a Numbers Table
USE tempdb;
CREATE TABLE tblNumbers
(num INT NOT NULL
,CONSTRAINT pk_tblNumbers PRIMARY KEY CLUSTERED(num) WITH FILLFACTOR = 100
);


--- Listing 11-13. Populating a Numbers Table
WITH cte0 AS (SELECT 1 AS c UNION ALL SELECT 1),
cte1 AS (SELECT 1 AS c FROM cte0 a, cte0 b),
cte2 AS (SELECT 1 AS c FROM cte1 a, cte1 b),
cte3 AS (SELECT 1 AS c FROM cte2 a, cte2 b),
cte4 AS (SELECT 1 AS c FROM cte3 a, cte3 b),
cte5 AS (SELECT 1 AS c FROM cte4 a, cte4 b),
nums AS (SELECT row_number() OVER (ORDER BY c) AS n FROM cte5)
INSERT INTO tblNumbers(num)
SELECT n FROM nums


--- Listing 11-14. Creating a Calendar Table
USE tempdb;
GO
SELECT dt, DATENAME( dw, dt )
FROM ( SELECT DATEADD( d, num - 1, CAST( CAST( YEAR( CURRENT_TIMESTAMP )
* 10000 + 101 AS VARCHAR(8) ) AS DATETIME ) )
FROM tblNumbers ) D ( dt )
WHERE YEAR( dt ) = 2011 ;


--- Listing 11-15. Parsing a Comma-Delimited List
USE tempdb;
GO
DECLARE @p VARCHAR(50)
SET @p = 'ABCDE,FG,HIJ,KLMNO,PQR,STUV,WX,YZ'
SELECT SUBSTRING( ',' + @p + ',', num + 1,
CHARINDEX( ',', ',' + @p + ',', num + 1 ) - num - 1 ) AS "value"
FROM tblNumbers
WHERE SUBSTRING( ',' + @p + ',', num, 1 ) = ','
AND num < LEN( ',' + @p + ',' ) ;


--- Listing 11-16. Demo Table Cleanup
USE AdventureWorks2014;
GO
IF OBJECT_ID('dbo.Customers') IS NOT NULL BEGIN
DROP TABLE dbo.Customers;
END;
IF OBJECT_ID('dbo.CustomerHistory') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerHistory;
END;
IF OBJECT_ID('dbo.CustomerSource') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerSource;
END;
IF OBJECT_ID('dbo.CustomerTarget') IS NOT NULL BEGIN
DROP TABLE dbo.CustomerTarget;
END;
IF OBJECT_ID('dbo.Sales') IS NOT NULL BEGIN
DROP TABLE dbo.Sales;
END;
