---- LAG
USE AdventureWorks2014;  
GO  
SELECT BusinessEntityID, YEAR(QuotaDate) AS SalesYear, SalesQuota AS CurrentQuota,   
       LAG(SalesQuota, 1,0) OVER (ORDER BY YEAR(QuotaDate)) AS PreviousQuota  
FROM Sales.SalesPersonQuotaHistory  
WHERE BusinessEntityID = 275 and YEAR(QuotaDate) IN ('2010','2011');
GO
USE AdventureWorks2014;  
GO  
SELECT TerritoryName, BusinessEntityID, SalesYTD,   
       LAG (SalesYTD, 1, 0) OVER (PARTITION BY TerritoryName ORDER BY SalesYTD DESC) AS PrevRepSales  
FROM Sales.vSalesPerson  
WHERE TerritoryName IN (N'Northwest', N'Canada')   
ORDER BY TerritoryName; 

----LEAD
USE AdventureWorks2014;  
GO  
SELECT BusinessEntityID, YEAR(QuotaDate) AS SalesYear, SalesQuota AS CurrentQuota,   
    LEAD(SalesQuota, 1,0) OVER (ORDER BY YEAR(QuotaDate)) AS NextQuota  
FROM Sales.SalesPersonQuotaHistory  
WHERE BusinessEntityID = 275 and YEAR(QuotaDate) IN ('2010','2011'); 
GO
USE AdventureWorks2014;  
GO  
SELECT TerritoryName, BusinessEntityID, SalesYTD,   
       LEAD (SalesYTD, 1, 0) OVER (PARTITION BY TerritoryName ORDER BY SalesYTD DESC) AS NextRepSales  
FROM Sales.vSalesPerson  
WHERE TerritoryName IN (N'Northwest', N'Canada')   
ORDER BY TerritoryName; 
GO
---FIRST VALUE
USE AdventureWorks2014;  
GO  
SELECT Name, ListPrice,   
       FIRST_VALUE(Name) OVER (ORDER BY ListPrice ASC) AS LeastExpensive   
FROM Production.Product  
WHERE ProductSubcategoryID = 37;
GO
USE AdventureWorks2014;   
GO  
SELECT JobTitle, LastName, VacationHours,   
       FIRST_VALUE(LastName) OVER (PARTITION BY JobTitle   
                                   ORDER BY VacationHours ASC  
                                   ROWS UNBOUNDED PRECEDING  
                                  ) AS FewestVacationHours  
FROM HumanResources.Employee AS e  
INNER JOIN Person.Person AS p   
    ON e.BusinessEntityID = p.BusinessEntityID  
ORDER BY JobTitle;   
---LAST VALUE
GO
USE AdventureWorks2014;  
GO  
SELECT Department, LastName, Rate, HireDate,   
    LAST_VALUE(HireDate) OVER (PARTITION BY Department ORDER BY Rate) AS LastValue  
FROM HumanResources.vEmployeeDepartmentHistory AS edh  
INNER JOIN HumanResources.EmployeePayHistory AS eph    
    ON eph.BusinessEntityID = edh.BusinessEntityID  
INNER JOIN HumanResources.Employee AS e  
    ON e.BusinessEntityID = edh.BusinessEntityID  
WHERE Department IN (N'Information Services',N'Document Control');  
GO
SELECT BusinessEntityID, DATEPART(QUARTER,QuotaDate)AS Quarter, YEAR(QuotaDate) AS SalesYear,   
    SalesQuota AS QuotaThisQuarter,   
    SalesQuota - FIRST_VALUE(SalesQuota)   
        OVER (PARTITION BY BusinessEntityID, YEAR(QuotaDate)   
              ORDER BY DATEPART(QUARTER,QuotaDate) ) AS DifferenceFromFirstQuarter,   
    SalesQuota - LAST_VALUE(SalesQuota)   
        OVER (PARTITION BY BusinessEntityID, YEAR(QuotaDate)   
              ORDER BY DATEPART(QUARTER,QuotaDate)   
              RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS DifferenceFromLastQuarter   
FROM Sales.SalesPersonQuotaHistory   
WHERE YEAR(QuotaDate) > 2005   
AND BusinessEntityID BETWEEN 274 AND 275   
ORDER BY BusinessEntityID, SalesYear, Quarter;
GO

---Listing 8-6. Generating XML Using the FOR XML RAW Command
USE AdventureWorks2014;
GO
SELECT TOP 5 FirstName
FROM Person.Person
FOR XML RAW;


---Listing 8-7. XML Output Using the FOR XML RAW Command
<row FirstName="Syed" />
<row FirstName="Catherine" />
<row FirstName="Kim" />
<row FirstName="Kim" />
<row FirstName="Kim" />


---Listing 8-8. Creating Element-Centric XML Using XML RAW
--Run this query
USE AdventureWorks2014;
GO
SELECT TOP 5 FirstName, LastName
FROM Person.Person
FOR XML RAW ('NAME'), ELEMENTS


---Listing 8-10. Using AUTO Mode with ELEMENTS Option
--Run the query
USE AdventureWorks2014;
GO
SELECT CustomerID, LastName, FirstName, MiddleName
FROM Person.Person AS Person
INNER JOIN Sales.Customer AS Customer ON Person.BusinessEntityID = Customer.PersonID
FOR XML AUTO, ;

---Listing 8-11. Using XML FOR EXPLICIT
--Run the query
USE AdventureWorks2014;
GO
SELECT 1 AS Tag,
NULL AS Parent,
CustomerID AS [Customer!1!CustomerID],
NULL AS [Name!2!FName],
NULL AS [Name!2!LName]
FROM Sales.Customer AS C
INNER JOIN Person.Person AS P
ON P.BusinessEntityID = C.PersonID
UNION
SELECT 2 AS Tag,
1 AS Parent,
CustomerID,
FirstName,
LastName
FROM Person.Person P
INNER JOIN Sales.Customer AS C
ON P.BusinessEntityID = C.PersonID
ORDER BY [Customer!1!CustomerID], [Name!2!FName]
FOR XML EXPLICIT;


---Listing 8-12. Simple FOR XML PATH Query
--Run the query
USE AdventureWorks2014;
GO
SELECT p.FirstName,
p.LastName,
s.Bonus,
s.SalesYTD
FROM Person.Person p
JOIN Sales.SalesPerson s
ON p.BusinessEntityID = s.BusinessEntityID
FOR XML PATH

---Listing 8-13. Defining XML Hierarchy Using PATH Mode
--Run the query
USE AdventureWorks2014;
GO
SELECT p.FirstName "@FirstName",
p.LastName "@LastName",
s.Bonus "Sales/Bonus",
s.SalesYTD "Sales/YTD"
FROM Person.Person p
JOIN Sales.SalesPerson s
ON p.BusinessEntityID = s.BusinessEntityID
FOR XML PATH


-----Listing 8-14. Simple FOR XML PATH Query with NAME Option
--Run the query
USE AdventureWorks2014;
GO
SELECT ProductID "@ProductID",
Name "Product/ProductName",
Color "Product/Color"
FROM Production.Product
FOR XML PATH ('Product')