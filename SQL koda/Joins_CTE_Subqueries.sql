USE AdventureWorks2014;
GO
SELECT s.SalesOrderID, s.OrderDate, s.TotalDue, d.SalesOrderDetailID,
d.ProductID, d.OrderQty
FROM Sales.SalesOrderHeader AS s
INNER JOIN Sales.SalesOrderDetail AS d ON s.SalesOrderID = d.SalesOrderID;


--Listing 4-2. Writing an Incorrect Query
USE AdventureWorks2014;
GO
SELECT s.SalesOrderID, OrderDate, TotalDue, SalesOrderDetailID,
d.ProductID, d.OrderQty
FROM Sales.SalesOrderHeader AS s
INNER JOIN Sales.SalesOrderDetail d ON 1 = 1;

--Listing 4-3. Joining Two Tables with Different Column Names
USE AdventureWorks2014;
GO
SELECT c.CustomerID, c.PersonID, p.BusinessEntityID, p.LastName
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID;


--Listing 4-4. Joining on Two Columns
USE AdventureWorks2014;
GO
SELECT sod.SalesOrderID, sod.SalesOrderDetailID,
so.ProductID, so.SpecialOfferID, so.ModifiedDate
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Sales.SpecialOfferProduct AS so
ON so.ProductID = sod.ProductID AND
so.SpecialOfferID = sod.SpecialOfferID
WHERE sod.SalesOrderID IN (51116,51112);


--Listing 4-5. Joining Three Tables
USE AdventureWorks2014;
GO
SELECT soh.SalesOrderID, soh.OrderDate, p.ProductID, p.Name
FROM Sales.SalesOrderHeader as soh
INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS p ON sod.ProductID = p.ProductID
ORDER BY soh.SalesOrderID;


--Listing 4-6. Using LEFT OUTER JOIN
USE AdventureWorks2014;
GO
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate
FROM Sales.Customer AS c
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
WHERE c.CustomerID IN (11028,11029,1,2,3,4);


--Listing 4-7. Using RIGHT OUTER JOIN
USE AdventureWorks2014;
GO
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate
FROM Sales.SalesOrderHeader AS s
RIGHT OUTER JOIN Sales.Customer AS c ON c.CustomerID = s.CustomerID
WHERE c.CustomerID IN (11028,11029,1,2,3,4);


--Listing 4-8. Using LEFT OUTER JOIN to Find the Rows with No Matches
USE AdventureWorks2014;
GO
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate
FROM Sales.Customer AS c
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
WHERE s.SalesOrderID IS NULL;


--Listing 4-9. Joining Three Tables with LEFT JOIN
USE AdventureWorks2014;
GO
SELECT C.CustomerID, SOH.SalesOrderID, SOD.SalesOrderDetailID, SOD.ProductID
FROM Sales.Customer AS C
LEFT OUTER JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
LEFT OUTER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE C.CustomerID IN (11028,11029,1,2,3,4);


--Listing 4-10. Adding Another Table to the Left Side of the Join
USE AdventureWorks2014;
GO
SELECT C.CustomerID, SOH.SalesOrderID, SOD.SalesOrderDetailID,
SOD.ProductID, T.Name
FROM Sales.Customer AS C
LEFT OUTER JOIN Sales.SalesOrderHeader AS SOH ON C.CustomerID = SOH.CustomerID
LEFT OUTER JOIN Sales.SalesOrderDetail AS SOD ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT OUTER JOIN Sales.SalesTerritory AS T ON C.TerritoryID = T.TerritoryID
WHERE C.CustomerID IN (11028,11029,1,2,3,4);


--Listing 4-11. FULL OUTER JOIN Demonstration
USE AdventureWorks2014;
GO
IF OBJECT_ID('Production.ProductColor') IS NOT NULL BEGIN
DROP TABLE Production.ProductColor;
END
CREATE table Production.ProductColor
(Color nvarchar(15) NOT NULL PRIMARY KEY)
GO
--Insert most of the existing colors
INSERT INTO Production.ProductColor
SELECT DISTINCT Color
FROM Production.Product
WHERE Color IS NOT NULL and Color <> 'Silver'
--Insert some additional colors
INSERT INTO Production.ProductColor
VALUES ('Green'),('Orange'),('Purple');
--Here is the query:
SELECT c.Color AS "Color from list", p.Color, p.ProductID
FROM Production.Product AS p
FULL OUTER JOIN Production.ProductColor AS c ON p.Color = c.Color
ORDER BY p.ProductID;


--Listing 4-12. A CROSS JOIN
USE AdventureWorks2014;
GO
--1
SELECT p.ProductID, l.LocationID
FROM Production.Product AS p
CROSS JOIN Production.Location AS l
ORDER BY ProductID;
--2
SELECT p.ProductID, l.LocationID
FROM Production.Product AS p
CROSS JOIN Production.Location AS l
ORDER BY LocationID;


--Listing 4-13. Using Self-Join
USE AdventureWorks2014;
GO
CREATE TABLE #Employee (
EmployeeID int,
ManagerID int,
Title nvarchar(50));
INSERT INTO #Employee
VALUES (1, NULL, 'Chief Executive Officer')
INSERT INTO #Employee
VALUES (2, 1, 'Engineering Manager')
INSERT INTO #Employee
VALUES (3, 2, 'Senior Tool Designer')
INSERT INTO #Employee
VALUES (4, 2, 'Design Engineer')
INSERT INTO #Employee
VALUES (5, 2, 'Research and Development')
INSERT INTO #Employee
VALUES (6, 1, 'Marketing Manager')
INSERT INTO #Employee
VALUES (7, 6, 'Marketing Specialist');
SELECT a.EmployeeID AS Employee,
a.Title AS EmployeeTitle,
b.EmployeeID AS ManagerID,
b.Title AS ManagerTitle
FROM #Employee AS a
LEFT OUTER JOIN #Employee AS b ON a.ManagerID = b.EmployeeID;
DROP TABLE #Employee;

----Important!
USE [TSQLV4]
GO
SELECT
  S.companyname AS supplier, S.country,
  P.productid, P.productname, P.unitprice,
  C.categoryname
FROM Production.Suppliers AS S
  LEFT OUTER JOIN Production.Products AS P
    ON S.supplierid = P.supplierid
  INNER JOIN Production.Categories AS C
    ON C.categoryid = P.categoryid
WHERE S.country = N'Japan';
---Supplier XYZ from Japan was discarded Why?!.
GO
---2 solutions
SELECT
  S.companyname AS supplier, S.country,
  P.productid, P.productname, P.unitprice,
  C.categoryname
FROM Production.Suppliers AS S
  LEFT OUTER JOIN Production.Products AS P
    ON S.supplierid = P.supplierid
  LEFT OUTER JOIN Production.Categories AS C
    ON C.categoryid = P.categoryid
WHERE S.country = N'Japan';
GO
SELECT
  S.companyname AS supplier, S.country,
  P.productid, P.productname, P.unitprice,
  C.categoryname
FROM Production.Suppliers AS S
  LEFT OUTER JOIN 
    (Production.Products AS P
       INNER JOIN Production.Categories AS C
         ON C.categoryid = P.categoryid)
    ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';
GO 









--Listing 4-14. Using a Subquery in the IN List
USE AdventureWorks2014;
GO
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE CustomerID IN (SELECT CustomerID FROM Sales.SalesOrderHeader);


--Listing 4-15. A Subquery with NOT IN
USE AdventureWorks2014;
GO
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE CustomerID NOT IN
(SELECT CustomerID FROM Sales.SalesOrderHeader);


--Listing 4-16. A Subquery with NOT IN
USE AdventureWorks2014;
GO
--1
SELECT CurrencyRateID, FromCurrencyCode, ToCurrencyCode
FROM Sales.CurrencyRate
WHERE CurrencyRateID NOT IN
(SELECT CurrencyRateID
FROM Sales.SalesOrderHeader);
--2
SELECT CurrencyRateID, FromCurrencyCode, ToCurrencyCode
FROM Sales.CurrencyRate
WHERE CurrencyRateID NOT IN
(SELECT CurrencyRateID
FROM Sales.SalesOrderHeader
WHERE CurrencyRateID IS NOT NULL);

--Listing 4-18. Using a Derived Table
USE AdventureWorks2014;
GO
SELECT c.CustomerID, s.SalesOrderID
FROM Sales.Customer AS c
INNER JOIN (SELECT SalesOrderID, CustomerID
FROM Sales.SalesOrderHeader) AS s ON c.CustomerID = s.CustomerID;


--Listing 4-19. Using a Common Table Expression
USE AdventureWorks2014;
GO
WITH orders AS (
SELECT SalesOrderID, CustomerID
FROM Sales.SalesOrderHeader
)
SELECT c.CustomerID, orders.SalesOrderID
FROM Sales.Customer AS c
INNER JOIN orders ON c.CustomerID = orders.CustomerID;


--Listing 4-20. Using a CTE to Solve a Problem
USE AdventureWorks2014;
GO
--1
SELECT c.CustomerID, s.SalesOrderID, s.OrderDate
FROM Sales.Customer AS c
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
WHERE s.OrderDate = '2005/07/01';
--2
WITH orders AS (
SELECT SalesOrderID, CustomerID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate = '2005/07/01'
)
SELECT c.CustomerID, orders.SalesOrderID, orders.OrderDate
FROM Sales.Customer AS c
LEFT OUTER JOIN orders ON c.CustomerID = orders.CustomerID
ORDER BY orders.OrderDate DESC;


