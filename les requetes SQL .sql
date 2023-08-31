
-- 1
SELECT *  
FROM adventureworks2019.humanresources.employee
ORDER BY jobtitle;
-- 2
SELECT e.*  
FROM AdventureWorks2019.person.person AS e  
ORDER BY LastName;
-- 3
SELECT FirstName, LastName,BusinessEntityID AS 'employee_id'
FROM AdventureWorks2019.Person.Person
ORDER BY LastName ASC;
-- 4
SELECT productid, productnumber, name as producName
FROM AdventureWorks2019.production.product
WHERE sellstartdate IS NOT NULL
AND Adventureworks2019.production.product.productline = 'T'
ORDER BY name;
-- 5
SELECT salesorderid,customerid,orderdate,subtotal,
(taxamt*100)/subtotal AS Tax_percent
FROM AdventureWorks2019.sales.salesorderheader
ORDER BY subtotal desc;
-- 6
SELECT DISTINCT jobtitle
FROM AdventureWorks2019.HumanResources.Employee
ORDER BY JobTitle ASC;
--7
SELECT customerid,sum(freight) as total_freight
FROM AdventureWorks2019.Sales.SalesOrderHeader
group by customerid
ORDER BY customerid ASC;
--8
SELECT customerid,salespersonid,sum(subtotal) as sum_subtotal, avg(subtotal) as avg_subtotal
FROM AdventureWorks2019.Sales.SalesOrderHeader
GROUP BY customerid,salespersonid
ORDER BY customerid DESC;
--9
SELECT productid, sum(quantity) AS total_quantity
FROM AdventureWorks2019.production.productinventory
WHERE shelf IN ('A','C','H')
GROUP BY productid
HAVING SUM(quantity)>500
ORDER BY productid;
--10
SELECT sum(Quantity) AS total_quantity
FROM AdventureWorks2019.Production.ProductInventory
GROUP BY (LocationID*10);
--11
SELECT p.businessentityid,firstname,lastname,phonenumber as Person_Phone
FROM AdventureWorks2019.Person.Person as p
JOIN AdventureWorks2019.Person.PersonPhone as ph
ON p.BusinessEntityID = ph.BusinessEntityID
WHERE lastname LIKE 'L%'
ORDER BY lastname,firstname;
--12
SELECT salespersonid,customerid,sum(subtotal) AS sum_subtotal
FROM AdventureWorks2019.sales.salesorderheader s
GROUP BY ROLLUP (salespersonid,customerid);
--13
SELECT locationid,shelf,sum(quantity) as total_quantity
from AdventureWorks2019.Production.ProductInventory
GROUP BY CUBE (locationid,shelf);
--14
SELECT LocationID,Shelf,sum(Quantity) as total_quantity
FROM AdventureWorks2019.Production.ProductInventory
GROUP BY GROUPING SETS (ROLLUP (LocationID,shelf), CUBE (LocationID,Shelf));
--15
SELECT LocationID,sum(Quantity) as Total_Quantity
FROM AdventureWorks2019.Production.ProductInventory
GROUP BY GROUPING SETS ( locationid, () );
--16
SELECT a.City, COUNT(b.AddressID) as No_Of_Employees
FROM AdventureWorks2019.Person.BusinessEntityAddress as b
	INNER JOIN AdventureWorks2019.Person.Address as a
		ON b.AddressID = a.AddressID 
GROUP BY a.City
ORDER BY a.City;
--17
SELECT DATEPART(year, OrderDate) AS 'Year',
       SUM(TotalDue) AS 'Order Amount'
FROM AdventureWorks2019.Sales.SalesOrderHeader
GROUP BY DATEPART(year, OrderDate)
ORDER BY DATEPART(year,OrderDate);
--18
SELECT DATEPART(year,OrderDate) AS 'Year_of_Order',sum(totaldue) AS total_due_order
FROM AdventureWorks2019.Sales.SalesOrderHeader
WHERE DATEPART(year,OrderDate) <= '2016'
GROUP BY DATEPART(year,OrderDate)
ORDER BY DATEPART(year,OrderDate);
--19
SELECT ContactTypeID,Name
FROM AdventureWorks2019.Person.ContactType
WHERE name LIKE'%Manager%'
ORDER BY name DESC;
--20
SELECT c.BusinessEntityID, LastName,FirstName 
FROM AdventureWorks2019.Person.BusinessEntityContact as a 
	INNER JOIN AdventureWorks2019.Person.ContactType as b
		ON b.ContactTypeID = a.ContactTypeID
	INNER JOIN AdventureWorks2019.Person.Person as c
		ON c.BusinessEntityID = a.PersonID 
WHERE b.name LIKE '%Purchasing Manager%'
ORDER BY c.LastName,c.FirstName;
--21
SELECT ROW_NUMBER() OVER (PARTITION BY c.PostalCode ORDER BY a.SalesYTD DESC) AS "Row Number",
b.LastName ,a.SalesYTD,c.PostalCode
FROM AdventureWorks2019.Sales.SalesPerson as a
	INNER JOIN AdventureWorks2019.Person.Person as b
		ON a.BusinessEntityID  = b.BusinessEntityID 
	INNER JOIN AdventureWorks2019.Person.Address as c
		ON c.AddressID  = a.BusinessEntityID 
WHERE a.SalesYTD <> 0 
	AND TerritoryID IS NOT NULL
ORDER BY c.PostalCode  DESC;
--22
SELECT b.ContactTypeID, b.Name as ContactTypeName, COUNT(*) AS Nbr_Contacts
FROM AdventureWorks2019.Person.BusinessEntityContact a
	INNER JOIN AdventureWorks2019.Person.ContactType b
		ON a.ContactTypeID = b.ContactTypeID
GROUP BY b.ContactTypeID,b.Name
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC;
--23
SELECT CONCAT(b.FirstName,', ',b.MiddleName,' ',b.LastName) as full_name,CAST(a.RateChangeDate as VARCHAR(10)) AS FromDate, 
	(a.Rate * 40) as weekly_salary
FROM AdventureWorks2019.HumanResources.EmployeePayHistory as a
	INNER JOIN AdventureWorks2019.Person.Person as b
		ON a.BusinessEntityID = b.BusinessEntityID
ORDER BY full_name ASC;
--24
SELECT CAST(hur.RateChangeDate as VARCHAR(10) ) AS FromDate
        , CONCAT(LastName, ', ', FirstName, ' ', MiddleName) AS NameInFull
        , (40 * hur.Rate) AS SalaryInAWeek
    FROM AdventureWorks2019.Person.Person AS pp
        INNER JOIN AdventureWorks2019.HumanResources.EmployeePayHistory AS hur
            ON hur.BusinessEntityID = pp.BusinessEntityID
             WHERE hur.RateChangeDate = (SELECT MAX(RateChangeDate)
                                FROM AdventureWorks2019.HumanResources.EmployeePayHistory 
                                WHERE BusinessEntityID = hur.BusinessEntityID)
    ORDER BY NameInFull;
--25
SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Total Quantity"
    ,AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Avg Quantity"
    ,COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS "No of Orders"
    ,MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Min Quantity"
    ,MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Max Quantity"
    FROM AdventureWorks2019.Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664);
--26
SELECT SalesOrderID, ProductID, OrderQty
    ,SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Total Quantity"
    ,AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Avg Quantity"
    ,COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS "No of Orders"
    ,MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Min Quantity"
    ,MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Max Quantity"
    FROM AdventureWorks2019.Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664) AND CAST(ProductID AS VARCHAR(10)) LIKE '71%';
--27
SELECT SalesOrderID, sum(OrderQty*UnitPrice) as order_cost
FROM AdventureWorks2019.Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING sum(OrderQty*UnitPrice) > 100000.00
ORDER BY SalesOrderID;
--28
SELECT ProductID,Name 
FROM AdventureWorks2019.Production.Product
WHERE name LIKE 'Lock Washer%'
ORDER BY ProductID;
--29
SELECT ProductID, Name, Color 
FROM AdventureWorks2019.Production.Product
ORDER BY ListPrice;
--30
SELECT BusinessEntityID,JobTitle,HireDate 
FROM AdventureWorks2019.HumanResources.Employee
ORDER BY HireDate;
--31
SELECT LastName ,FirstName 
FROM AdventureWorks2019.Person.Person
WHERE LastName LIKE 'R%'
ORDER BY FirstName ASC,LastName DESC;
--32
SELECT BusinessEntityID, SalariedFlag
FROM AdventureWorks2019.HumanResources.Employee
ORDER BY CASE SalariedFlag WHEN 'true' THEN BusinessEntityID END DESC,
	CASE WHEN SalariedFlag = 'false' THEN BusinessEntityID END ASC;
--33
SELECT BusinessEntityID,LastName,TerritoryName,CountryRegionName 
FROM AdventureWorks2019.Sales.vSalesPerson
WHERE TerritoryName IS NOT NULL 
ORDER BY CASE CountryRegionName WHEN 'United States' THEN TerritoryName 
		 ELSE CountryRegionName END;
--34
SELECT p.FirstName, p.LastName
	,ROW_NUMBER () OVER (ORDER BY a.PostalCode) AS 'Row Number'
	,RANK () OVER (ORDER BY a.PostalCode) AS 'Rank'
	,DENSE_RANK () OVER(ORDER BY a.PostalCode) AS 'Dense Rank'
	,NTILE(4) OVER (ORDER BY a.PostalCode) AS 'Quartile'
	,s.SalesYTD, a.PostalCode 
FROM AdventureWorks2019.Sales.SalesPerson as s
	INNER JOIN AdventureWorks2019.Person.Person as p
		ON s.BusinessEntityID = p.BusinessEntityID
	INNER JOIN AdventureWorks2019.Person.Address as a
		ON a.AddressID = p.BusinessEntityID 
WHERE TerritoryID  IS NOT NULL AND SalesYTD <> 0;
--35
SELECT *
FROM AdventureWorks2019.HumanResources.Department
ORDER BY DepartmentID OFFSET 10 ROWS ;
--36
SELECT *
FROM AdventureWorks2019.HumanResources.Department
ORDER BY DepartmentID 
	OFFSET 5 ROWS 
	FETCH NEXT 5 ROWS ONLY;
--37
SELECT Name,Color ,ListPrice 
FROM AdventureWorks2019.Production.Product
WHERE Color IN ('Red','Blue')
ORDER BY ListPrice;
--38
SELECT a.Name,b.SalesOrderID 
FROM AdventureWorks2019.Production.Product as a
FULL OUTER JOIN AdventureWorks2019.Sales.SalesOrderDetail as b
ON a.ProductID = b.ProductID
ORDER BY a.Name;
--39
SELECT a.Name, b.SalesOrderID 
FROM AdventureWorks2019.Production.Product as a
LEFT OUTER JOIN AdventureWorks2019.Sales.SalesOrderDetail as b
ON a.ProductID = b.ProductID
ORDER BY a.Name;
--40
SELECT a.Name,b.SalesOrderID 
FROM AdventureWorks2019.Production.Product as a
	FULL JOIN AdventureWorks2019.Sales.SalesOrderDetail as b
	ON a.ProductID = b.ProductID
ORDER BY a.Name ;
--41
SELECT a.Name,b.BusinessEntityID  
FROM AdventureWorks2019.Sales.SalesTerritory as a
	RIGHT OUTER JOIN AdventureWorks2019.Sales.SalesPerson as b
	ON a.TerritoryID = b.TerritoryID ;
--42
SELECT concat(RTRIM(p.FirstName),' ', LTRIM(p.LastName)) AS Name, d.City  
FROM AdventureWorks2019.Person.Person AS p  
INNER JOIN AdventureWorks2019.HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID   
INNER JOIN  
   (SELECT bea.BusinessEntityID, a.City   
    FROM AdventureWorks2019.Person.Address AS a  
    INNER JOIN AdventureWorks2019.Person.BusinessEntityAddress AS bea  
    ON a.AddressID = bea.AddressID) AS d  
ON p.BusinessEntityID = d.BusinessEntityID  
ORDER BY p.LastName, p.FirstName;
--43
SELECT BusinessEntityID,FirstName,LastName
FROM 
	(SELECT * FROM AdventureWorks2019.Person.Person
	WHERE persontype = 'IN') AS personDerivedTable
WHERE lastname = 'Adams'
ORDER BY firstname;
--44
SELECT BusinessEntityID, FirstName, LastName 
FROM AdventureWorks2019.Person.Person
WHERE BusinessEntityID <= 1500 AND LastName  LIKE 'Al%' AND FirstName LIKE '%M%';
--45
SELECT ProductID,a.Name,Color 
FROM AdventureWorks2019.Production.Product as a
INNER JOIN (VALUES('Blade'),('Crown Race'),('AWC Logo Cap')) AS b(Name)
ON a.Name = b.Name;
--46
WITH Sales_CTE (SalesPersonID,SalesOrderID,SalesYear)
AS
(
	SELECT SalesPersonID,SalesOrderID,DATEPART(year,OrderDate) AS SalesYear
	FROM AdventureWorks2019.Sales.SalesOrderHeader
	WHERE SalesOrderID IS NOT NULL 
)
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear
FROM Sales_CTE
GROUP BY SalesYear, SalesPersonID
ORDER BY SalesPersonID,SalesYear;
--47
WITH Sales_CTE(SalesPersonID,NumberOfOrders)
AS
(
	SELECT SalesPersonID,COUNT(*)
	FROM AdventureWorks2019.Sales.SalesOrderHeader
	WHERE SalesPersonID IS NOT NULL
	GROUP BY SalesPersonID 
)
SELECT AVG(NumberOfOrders) AS 'Average Sales Per Person'
FROM Sales_CTE;
--48
SELECT *
FROM AdventureWorks2019.Production.ProductPhoto
WHERE LargePhotoFileName  LIKE '%green_%' ESCAPE 'a';
--49
SELECT AddressLine1,AddressLine2,City,PostalCode,Countryregioncode
FROM AdventureWorks2019.Person.Address as a
	  JOIN AdventureWorks2019.Person.StateProvince as b
		ON a.StateProvinceID = b.StateProvinceID
WHERE countryregioncode <> 'US' AND city LIKE 'Pa%';
--50
SELECT TOP 20 JobTitle ,HireDate 
FROM AdventureWorks2019.HumanResources.Employee
ORDER BY HireDate DESC;
--51
SELECT *
FROM AdventureWorks2019.Sales.SalesOrderHeader as a
	INNER JOIN AdventureWorks2019.Sales.SalesOrderDetail as b
	ON a.SalesOrderID = b.SalesOrderID
WHERE orderqty > 5 AND unitpricediscount < 1000 AND TotalDue > 100;
--52
SELECT Name, Color 
FROM AdventureWorks2019.production.Product
WHERE name LIKE '%red%';
--53
SELECT Name, ListPrice
FROM AdventureWorks2019.Production.Product
WHERE Name LIKE '%Mountain%' AND ListPrice =  80.99;
--54
SELECT Name, Color 
FROM AdventureWorks2019.Production.Product
WHERE Name LIKE '%Mountain%' OR Name LIKE '%Road%';
--55
SELECT Name, Color 
FROM AdventureWorks2019.Production.Product
WHERE Name LIKE '%Mountain%' AND Name LIKE '%Black%';
--56
SELECT Name,Color 
FROM AdventureWorks2019.Production.Product
WHERE name LIKE 'Chain%';
--57
SELECT name,color
FROM AdventureWorks2019.Production.Product
WHERE name Like 'Chain%' OR name LIKE 'Full%'
--58
SELECT  CONCAT(a.FirstName,' | ',b.EmailAddress) 
FROM AdventureWorks2019.Person.Person as a
	JOIN AdventureWorks2019.Person.EmailAddress as b
	ON a.BusinessEntityID = b.BusinessEntityID;
--59
-- BLANC

--60
SELECT CONCAT(Name,' Color:-',Color,'Product Number:',ProductNumber) as 'result'
FROM AdventureWorks2019.Production.Product;
--61
SELECT CONCAT(Name,',',ProductNumber,Color,' |') 
FROM AdventureWorks2019.Production.Product;