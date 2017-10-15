--Listing 5-1. Using Aggregate Functions
USE AdventureWorks2014;
GO
--1
SELECT COUNT(*) AS CountOfRows,
	MAX(TotalDue) AS MaxTotal,
	MIN(TotalDue) AS MinTotal,
	SUM(TotalDue) AS SumOfTotal,
	AVG(TotalDue) AS AvgTotal
FROM Sales.SalesOrderHeader;
--2
SELECT MIN(Name) AS MinName,
	MAX(Name) AS MaxName,
	MIN(SellStartDate) AS MinSellStartDate
FROM Production.Product;

--Listing 5-2. Using the GROUP BY Clause
USE AdventureWorks2014;
GO
--1
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;
--2
SELECT TerritoryID,AVG(TotalDue) AS AveragePerTerritory
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID;

--Listing 5-3. How to Group on an Expression
Use AdventureWorks2014;
GO
--1
SELECT COUNT(*) AS CountOfOrders, YEAR(OrderDate) AS OrderYear
FROM Sales.SalesOrderHeader
GROUP BY OrderDate;

--2
SELECT COUNT(*) AS CountOfOrders, YEAR(OrderDate) AS OrderYear
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate);


--Listing 5-4. Using ORDER BY
USE AdventureWorks2014;
GO
--1
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY CustomerID;
--2
SELECT TerritoryID,AVG(TotalDue) AS AveragePerTerritory
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
ORDER BY TerritoryID;
--3
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY SUM(TotalDue) DESC;

--Listing 5-5. Using the WHERE Clause
USE AdventureWorks2014;
GO
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer
FROM Sales.SalesOrderHeader
WHERE TerritoryID in (5,6)
GROUP BY CustomerID;

--Listing 5-6. Using the HAVING Clause
USE AdventureWorks2014;
GO
--1
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 5000;
--2
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(*) = 10 AND SUM(TotalDue) > 5000;
--3
SELECT CustomerID,SUM(TotalDue) AS TotalPerCustomer
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING CustomerID > 27858;

--Listing 5-7. Using DISTINCT and GROUP BY
Use AdventureWorks2014;
GO
--1
SELECT DISTINCT SalesOrderID
FROM Sales.SalesOrderDetail;
--2
SELECT SalesOrderID
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

--Listing 5-8. Using DISTINCT in an Aggregate Expression
USE AdventureWorks2014;
GO
--1
SELECT COUNT(*) AS CountOfRows,
	COUNT(SalesPersonID) AS CountOfSalesPeople,
	COUNT(DISTINCT SalesPersonID) AS CountOfUniqueSalesPeople
FROM Sales.SalesOrderHeader;
--2
SELECT SUM(TotalDue) AS TotalOfAllOrders,
SUM(Distinct TotalDue) AS TotalOfDistinctTotalDue
FROM Sales.SalesOrderHeader;

--Listing 5-9. Writing Aggregate Queries with Two Tables
USE AdventureWorks2014;
GO
--1
SELECT c.CustomerID, c.AccountNumber, COUNT(*) AS CountOfOrders,
	SUM(TotalDue) AS SumOfTotalDue
FROM Sales.Customer AS c
INNER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.AccountNumber
ORDER BY c.CustomerID;
--2
SELECT c.CustomerID, c.AccountNumber, COUNT(*) AS CountOfOrders,
	SUM(TotalDue) AS SumOfTotalDue
FROM Sales.Customer AS c
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.AccountNumber
ORDER BY c.CustomerID;
--3
SELECT c.CustomerID, c.AccountNumber,COUNT(s.SalesOrderID) AS CountOfOrders,
	SUM(COALESCE(TotalDue,0)) AS SumOfTotalDue
FROM Sales.Customer AS c
LEFT OUTER JOIN Sales.SalesOrderHeader AS s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.AccountNumber
ORDER BY c.CustomerID;

--Listing 5-10. Using a Correlated Subquery in the WHERE Clause
Use AdventureWorks2014;
GO
--1
SELECT CustomerID, SalesOrderID, TotalDue
FROM Sales.SalesOrderHeader AS soh
WHERE 10 =
	(SELECT COUNT(*)
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID = soh.SalesOrderID);
--2
SELECT CustomerID, SalesOrderID, TotalDue
FROM Sales.SalesOrderHeader AS soh
WHERE 10000 <
	(SELECT SUM(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = soh.CustomerID);
--3
SELECT CustomerID
FROM Sales.Customer AS c
WHERE CustomerID > (
	SELECT SUM(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = c.CustomerID);

--Listing 5-11. Using an Inline Correlated Subquery
USE AdventureWorks2014;
GO
--1
SELECT CustomerID,
	(SELECT COUNT(*)
	FROM Sales.SalesOrderHeader	
	WHERE CustomerID = C.CustomerID) AS CountOfSales
FROM Sales.Customer AS C
ORDER BY CountOfSales DESC;
--2
SELECT CustomerID,
	(SELECT COUNT(*) AS CountOfSales
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = C.CustomerID) AS CountOfSales,
	(SELECT SUM(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = C.CustomerID) AS SumOfTotalDue,
	(SELECT AVG(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = C.CustomerID) AS AvgOfTotalDue
FROM Sales.Customer AS C
ORDER BY CountOfSales DESC;

--Listing 5-12. Using a Derived Table
USE AdventureWorks2014;
GO
SELECT c.CustomerID,CountOfSales,
	SumOfTotalDue, AvgOfTotalDue
FROM Sales.Customer AS c INNER JOIN
	(SELECT CustomerID, COUNT(*) AS CountOfSales,
	SUM(TotalDue) AS SumOfTotalDue,
	AVG(TotalDue) AS AvgOfTotalDue
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID) AS s
ON c.CustomerID = s.CustomerID;

--Listing 5-13. Using a Common Table Expression
USE AdventureWorks2014;
GO
WITH s AS
	(SELECT CustomerID, COUNT(*) AS CountOfSales,
	SUM(TotalDue) AS SumOfTotalDue,
	AVG(TotalDue) AS AvgOfTotalDue
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID)
SELECT c.CustomerID,CountOfSales,
SumOfTotalDue, AvgOfTotalDue
FROM Sales.Customer AS c INNER JOIN s
ON c.CustomerID = s.CustomerID;

--Listing 5-14. Displaying Details
USE AdventureWorks2014;
GO
--1
SELECT c.CustomerID, SalesOrderID, TotalDue, AvgOfTotalDue,
	TotalDue/SumOfTotalDue * 100 AS SalePercent
FROM Sales.SalesOrderHeader AS soh
INNER JOIN
	(SELECT CustomerID, SUM(TotalDue) AS SumOfTotalDue,
	AVG(TotalDue) AS AvgOfTotalDue
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID) AS c ON soh.CustomerID = c.CustomerID
ORDER BY c.CustomerID;
--2
WITH c AS
	(SELECT CustomerID, SUM(TotalDue) AS SumOfTotalDue,
	AVG(TotalDue) AS AvgOfTotalDue
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID)
SELECT c.CustomerID, SalesOrderID, TotalDue,AvgOfTotalDue,
	TotalDue/SumOfTotalDue * 100 AS SalePercent
FROM Sales.SalesOrderHeader AS soh
INNER JOIN c ON soh.CustomerID = c.CustomerID
ORDER BY c.CustomerID;

--Listing 5-15. Using the OVER Clause
USE AdventureWorks2014;
GO
SELECT CustomerID, SalesOrderID, TotalDue,
	AVG(TotalDue) OVER(PARTITION BY CustomerID) AS AvgOfTotalDue,
	SUM(TotalDue) OVER(PARTITION BY CustomerID) AS SumOfTOtalDue,
	TotalDue/(SUM(TotalDue) OVER(PARTITION BY CustomerID)) * 100
	AS SalePercentPerCustomer,
	SUM(TotalDue) OVER() AS SalesOverAll
FROM Sales.SalesOrderHeader
ORDER BY CustomerID;

--Listing 5-16. Using GROUPING SETS
USE AdventureWorks2014;
GO
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

--Listing 5-17. CUBE and ROLLUP
--1
USE AdventureWorks2014
GO
SELECT COUNT(*) AS CountOfRows, Color,
	ISNULL(Size,CASE WHEN GROUPING(Size) = 0 THEN 'UNK' ELSE 'ALL' END) AS Size,
	GROUPING(Size)
FROM Production.Product
GROUP BY CUBE(Color,Size)
ORDER BY Size;
--2
SELECT COUNT(*) AS CountOfRows, Color,
	ISNULL(Size,CASE WHEN GROUPING(Size) = 0 THEN 'UNK' ELSE 'ALL' END) AS Size
FROM Production.Product
GROUP BY ROLLUP(Color,Size)
ORDER BY Size;

