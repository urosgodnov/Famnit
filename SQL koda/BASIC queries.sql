--literal values
SELECT 1
SELECT 'ABC'
go
--from caluse
USE AdventureWorks2014;
   GO
   SELECT BusinessEntityID, JobTitle
   FROM HumanResources.Employee;
go
--literal value+columns
USE AdventureWorks2014;
   GO
   SELECT 'A Literal Value' AS "Literal Value",
   BusinessEntityID AS EmployeeID,
   LoginID JobTitle
   FROM HumanResources.Employee;
   Go 
----WHERE CLAUSE
USE AdventureWorks2014;
GO
--1
SELECT CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;
--2
SELECT CustomerID, SalesOrderID
FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43793;
--3
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate = '2005-07-02';
--4
SELECT BusinessEntityID, LoginID, JobTitle
FROM HumanResources.Employee
WHERE JobTitle = 'Chief Executive Officer';

USE AdventureWorks2014;
GO
--Using a DateTime column
--1
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate > '2005-07-05';
--2
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate < '2005-07-05';
--3
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2005-07-05';
--4
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate <> '2005-07-05';
--5
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate != '2005-07-05';
--Using a numeric column
--6
SELECT SalesOrderID, SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE OrderQty > 10;
--7
SELECT SalesOrderID, SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE OrderQty <= 10;
--8
SELECT SalesOrderID, SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE OrderQty <> 10;
--9
SELECT SalesOrderID, SalesOrderDetailID, OrderQty
FROM Sales.SalesOrderDetail
WHERE OrderQty != 10;
--Using a string column
--10
SELECT BusinessEntityID, FirstName
FROM Person.Person
WHERE FirstName <> 'Catherine';
--11
SELECT BusinessEntityID, FirstName
FROM Person.Person
WHERE FirstName != 'Catherine';
--12
SELECT BusinessEntityID, FirstName
FROM Person.Person
WHERE FirstName > 'M';
--13
SELECT BusinessEntityID, FirstName
FROM Person.Person
WHERE FirstName !> 'M';

--WHERE CLAUSE
USE AdventureWorks2014
GO
--1
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2008-07-02' AND '2014-07-05';
--2
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE CustomerID BETWEEN 25000 AND 25005;
--3
SELECT BusinessEntityID, JobTitle
FROM HumanResources.Employee
WHERE JobTitle BETWEEN 'C' and 'E';
--An invalid BETWEEN expression
--4
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE CustomerID BETWEEN 25005 AND 25000;
----NOT BETWEEN
Use AdventureWorks2012
GO
--1
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate NOT BETWEEN '2005-07-02' AND '2005-07-04';
--2
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE CustomerID NOT BETWEEN 25000 AND 25005;
--3
SELECT BusinessEntityID, JobTitle
FROM HumanResources.Employee
WHERE JobTitle NOT BETWEEN 'C' and 'E';
--An invalid BETWEEN expression
--4
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE CustomerID NOT BETWEEN 25005 AND 25000;


---USING LIKE WITH %
USE AdventureWorks2014;
GO
--1
SELECT DISTINCT LastName
FROM Person.Person
WHERE LastName LIKE 'Sand%';
--2
SELECT DISTINCT LastName
FROM Person.Person
WHERE LastName NOT LIKE 'Sand%';
--3
SELECT DISTINCT LastName
FROM Person.Person
WHERE LastName LIKE '%Z%';
--4
SELECT DISTINCT LastName
FROM Person.Person
WHERE LastName LIKE 'Bec_';

---Square brackets
USE AdventureWorks2014;
GO
--1
SELECT DISTINCT LastName
FROM Person.Person
WHERE LastName LIKE 'Cho[i-k]';
--2
SELECT DISTINCT LastName
FROM Person.Person
WHERE LastName LIKE 'Cho[i,j,k]';
--3
SELECT DISTINCT LastName
FROM Person.Person
WHERE LastName LIKE 'Cho[^i]';

----Combining wildcards
USE AdventureWorks2014;
GO
--1
SELECT LastName
FROM Person.Person
WHERE LastName LIKE 'Ber[r,g]%';
--2
SELECT LastName
FROM Person.Person
WHERE LastName LIKE 'Ber[^r]%';
--3
SELECT LastName
FROM Person.Person
WHERE LastName LIKE 'Be%n_';

----Using WHERE Clauses with Three or More Predicates
USE AdventureWorks2014;
GO
--1
SELECT BusinessEntityID,FirstName,MiddleName,LastName
FROM Person.Person
WHERE FirstName = 'Ken' AND LastName = 'Myer'
OR LastName = 'Meyer';
--2
SELECT BusinessEntityID,FirstName,MiddleName,LastName
FROM Person.Person
WHERE LastName = 'Myer' OR LastName = 'Meyer'
AND FirstName = 'Ken';
--3
SELECT BusinessEntityID,FirstName,MiddleName,LastName
FROM Person.Person
WHERE LastName = 'Meyer'
AND FirstName = 'Ken' OR LastName = 'Myer';
--4
SELECT BusinessEntityID,FirstName,MiddleName,LastName
FROM Person.Person
WHERE FirstName = 'Ken' AND (LastName = 'Myer'
OR LastName = 'Meyer');

--Using NOT with Parentheses
USE AdventureWorks2014;
GO
--1
SELECT BusinessEntityID,FirstName,MiddleName,LastName
FROM Person.Person
WHERE FirstName='Ken' AND LastName <> 'Myer'
AND LastName <> 'Meyer';
--2
SELECT BusinessEntityID,FirstName,MiddleName,LastName
FROM Person.Person
WHERE FirstName='Ken'
AND NOT (LastName = 'Myer' OR LastName = 'Meyer');

---IN OPERATOR
USE AdventureWorks2014
GO
--1
SELECT BusinessEntityID,FirstName,MiddleName,LastName
FROM Person.Person
WHERE FirstName = 'Ken' AND
LastName IN ('Myer','Meyer');
--2
SELECT TerritoryID, Name
FROM Sales.SalesTerritory
WHERE TerritoryID IN (2,1,4,5);
--3
SELECT TerritoryID, Name
FROM Sales.SalesTerritory
WHERE TerritoryID NOT IN (2,1,4,5);

---Working with nothing
USE AdventureWorks2014;
GO
--1) Returns 19,972 rows
SELECT MiddleName
FROM Person.Person;
--2) Returns 291 rows
SELECT MiddleName
FROM Person.Person
WHERE MiddleName = 'B';
--3) Returns 11,182 but 19,681 were expected
SELECT MiddleName
FROM Person.Person
WHERE MiddleName != 'B';
--4) Returns 19,681
SELECT MiddleName
FROM Person.Person
WHERE MiddleName IS NULL
OR MiddleName !='B';

---USING CONTAINS
USE AdventureWorks2014;
GO
--1
SELECT FileName
FROM Production.Document
WHERE Contains(Document,'important');
--2
SELECT FileName
FROM Production.Document
WHERE Contains(Document,' "service guidelines " ')
AND DocumentLevel = 2;

---Using Multiple Terms with CONTAINS
USE AdventureWorks2014;
GO
--1
SELECT FileName, DocumentSummary
FROM Production.Document
WHERE Contains(DocumentSummary,'bicycle AND reflectors');
--2
SELECT FileName, DocumentSummary
FROM Production.Document
WHERE CONTAINS(DocumentSummary,'bicycle AND NOT reflectors');
--3
SELECT FileName, DocumentSummary
FROM Production.Document
WHERE CONTAINS(DocumentSummary,'maintain NEAR bicycle AND NOT reflectors');

----FREETEXT
USE AdventureWorks2014
GO
--1
SELECT Title,DocumentSummary  
FROM Production.Document  
WHERE FREETEXT (DocumentSummary, 'vital safety components' );  
GO 

---ORDER BY
USE AdventureWorks2014;
GO
--1
SELECT ProductID, LocationID
FROM Production.ProductInventory
ORDER BY LocationID;
--2
SELECT ProductID, LocationID
FROM Production.ProductInventory
ORDER BY ProductID, LocationID DESC

---OFFSET
SELECT ProductID, LocationID
FROM Production.ProductInventory
ORDER BY ProductID,LocationID DESC
OFFSET 10 ROWS;

---ORDER BY FETCH NEXT…ONLY
SELECT ProductID, LocationID
FROM Production.ProductInventory
ORDER BY ProductID,LocationID DESC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

