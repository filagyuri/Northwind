Use Northwind_SPP

Go

--Question 1
--Return all the fields from all shippers
Select * from Shippers;

--Question 2
--Return two columns Category Name and Description
Select
	CategoryName,
	Description
from Categories;

--Question 3
--First, Last, HireDate of Sales Representatives
Select
	FirstName,
	LastName,
	HireDate
from Employees
where
	title = 'Sales Representative';

--Question 4
--First, Last, HireDate of U.S Sales Representatives3
Select
	FirstName,
	LastName,
	HireDate
from Employees
where
	title = 'Sales Representative'
	and
	Country = 'USA';

--Question 5
--Orders placed by a specific employee (Steven Buchanan - 5)
Select 
	OrderID,
	OrderDate
from Orders
where EmployeeID = 5;

--Question 6
--Show suppliers whose contact title is NOT Marketing Manager
Select
	SupplierID,
	ContactName,
	ContactTitle
from Suppliers
where ContactTitle != 'Marketing Manager';

--Question 7
--Find product with string "queso"
Select
	ProductID,
	ProductName
from Products
where ProductName like '%queso%';

--Question 8
--Select OrderID, CustomerID, ShipCountry in France/Belgium
Select
	OrderID,
	CustomerID,
	ShipCountry
from Orders
where ShipCountry in ('France','Belgium');

--Question 9
--Select OrderID, CustomerID, ShipCountry in Latin Country
Select
	OrderID,
	CustomerID,
	ShipCountry
from Orders
where 
	ShipCountry in ('Brazil',
					'Mexico',
					'Argentina',
					'Venezuela');

--Question 10
--Employees, in order of age
Select
	FirstName,
	LastName,
	Title,
	BirthDate
from Employees
order by BirthDate asc;

--Question 11
--Employees, in order of age, date portion only
Select
	FirstName,
	LastName,
	Title,
	DateOnlyBirthDate = convert(date,BirthDate)
from Employees
order by BirthDate asc;

--Question 12
--Employee First, Last, and FullName
Select
	FirstName,
	LastName,
	FullName = CONCAT(FirstName,' ',LastName)
from Employees;

--Question 13
--OrderDetails amount per line item
Select
	OrderID,
	ProductID,
	UnitPrice,
	Quantity,
	TotalPrice = UnitPrice * Quantity
from OrderDetails;

--Question 14
--How many Customers
Select
	count(distinct(CustomerID)) TotalCustomers
from Customers;

--Question 15
--First order ever made on Orders Table
Select
	min(OrderDate) FirstOrder
from Orders;

--Question 16
--Show a list of countries where Northwind has customers
Select
	distinct(Country)
from Customers
order by Country asc;

--Question 17
--Show how many contact titles for customers
Select
	ContactTitle,
	count(ContactTitle) TotalContactTitle
from Customers
group by ContactTitle
order by TotalContactTitle desc;

--Question 18
--Products with associated supplier name
Select
	distinct ProductID,
	ProductName,
	CompanyName
from Products p
join Suppliers s
	on p.SupplierID = s.SupplierID;

--Question 19
--OrderID, OrderDate, Shipper for previous orders
Select
	OrderID,
	OrderDate,
	s.CompanyName
from Orders o
join Shippers s
	on o.ShipVia = s.ShipperID
where OrderID < 10270;

--Question 20
--Calculate how many products per Category
Select
	CategoryName,
	count(p.ProductID) TotalProducts
from Categories c
join Products p
	on c.CategoryID = p.CategoryID
group by CategoryName
order by TotalProducts desc;

--Question 21
--Total Customers per country/city
Select
	Country,
	City,
	count(*) TotalCustomers
from Customers
group by
	Country,
	City
order by 
	TotalCustomers desc;

--Question 22
--Products that needs reordering
Select
	ProductID,
	ProductName,
	UnitsInStock,
	ReorderLevel
from Products
where UnitsInStock <= ReorderLevel
order by ProductID asc;

--Question 23
--Products that needs reordering and false discontinued flag
Select
	ProductID,
	ProductName,
	UnitsInStock,
	UnitsOnOrder,
	ReorderLevel
from Products
where 
	UnitsOnOrder + UnitsInStock <= ReorderLevel
	and
	Discontinued = 0
order by ProductID asc;

--Question 24
--Country list by region, null region at the back of the table
Select
	CustomerID,
	CompanyName,
	Region
from Customers
order by
	(case when Region is NULL then 1 else 0 end),
	Region,
	CustomerID;

--Question 25
--Calculate top 3 average freight
Select
	top 3
	ShipCountry,
	avg(Freight) AverageFreight
from Orders
group by ShipCountry
order by AverageFreight desc;

--Question 26 & 27
--High freight charges in 2015
Select
	top 3
	ShipCountry,
	avg(Freight) AverageFreight
from Orders
where year(OrderDate) = 2015
group by ShipCountry
order by AverageFreight desc;

--Question 28
--High freight charges last year
Select
	top 3
	ShipCountry,
	avg(Freight) AverageFreight
from Orders
where 
	OrderDate >= DATEADD(yy,-1,
		(Select max(OrderDate) from Orders))
group by ShipCountry
order by AverageFreight desc;

--Question 29
--Employee/Order Detail report
Select
	o.EmployeeID,
	e.LastName,
	o.OrderID,
	p.ProductName,
	Quantity
from Orders o
join Employees e
	on o.EmployeeID = e.EmployeeID
join OrderDetails od
	on o.OrderID = od.OrderID
join Products p
	on od.ProductID = p.ProductID
order by 
	o.OrderID,
	p.ProductName;

--Question 30
--Customers with no orders
Select
	c.CustomerID [Customers_CustomerID],
	o.CustomerID [Orders_CustomerID]
from Customers c
left join Orders o
	on c.CustomerID = o.CustomerID
where o.CustomerID is NULL;

--Question 31
--Customers with no orders with EmployeeID 4
Select
	c.CustomerID,
	o.CustomerID
from Customers c
left join Orders o
on c.CustomerID = o.CustomerID
	and o.EmployeeID = 4
where o.CustomerID is NULL;

--Question 32
--High value customers
Select
	o.CustomerID,
	CompanyName,
	o.OrderID,
	sum(UnitPrice * Quantity) TotalOrderAmount
from Orders o
join OrderDetails od
	on o.OrderID = od.OrderID
join Customers c
	on o.CustomerID = c.CustomerID
where year(OrderDate) = 2016
group by 
	o.CustomerID,
	CompanyName,
	o.OrderID
having sum(UnitPrice * Quantity) >= 10000
order by TotalOrderAmount desc;

--Question 33
--High value customers with total orders
Select
	o.CustomerID,
	CompanyName,
	sum(UnitPrice * Quantity) TotalOrderAmount
from Orders o
join OrderDetails od
	on o.OrderID = od.OrderID
join Customers c
	on o.CustomerID = c.CustomerID
where year(OrderDate) = 2016
group by 
	o.CustomerID,
	CompanyName
having sum(UnitPrice * Quantity) >= 15000
order by TotalOrderAmount desc;

--Question 34
--High-value customers with discount
Select
	o.CustomerID,
	CompanyName,
	TotalWithoutDiscount = sum(UnitPrice * Quantity),
	TotalWithDiscount = sum(UnitPrice * Quantity *(1-Discount)) 
from Orders o
join OrderDetails od
	on o.OrderID = od.OrderID
join Customers c
	on o.CustomerID = c.CustomerID
where year(OrderDate) = 2016
group by 
	o.CustomerID,
	CompanyName
having sum(UnitPrice * Quantity) >= 15000
order by TotalWithDiscount desc;

--Question 35
--Month-end orders
Select
	EmployeeID,
	OrderID,
	OrderDate
from Orders
where OrderDate = EOMONTH(OrderDate)
order by EmployeeID;

--Question 36
--Orders with many line items
Select
	OrderID,
	TotalOrderDetails = count(ProductID)
from OrderDetails
group by OrderID
order by TotalOrderDetails desc;

--Question 37
--Randomly select 2% OrderIDs
Select
	top 2 percent OrderID
from Orders
order by NewID();

--Question 38 & 39 & 40
--Orders double-entry details (Quantity <60, double-entried ProductIDs)
With potentialdup as
	(Select
		OrderID
	from OrderDetails
	where Quantity >= 60
	group by
		OrderID,
		Quantity
	having count(*) > 1)
Select * from OrderDetails
where OrderID in (Select OrderID from potentialdup)
order by OrderID, Quantity;

--Question 41
--Find late orders
Select
	OrderID,
	OrderDate,
	RequiredDate,
	ShippedDate
from Orders
where ShippedDate >= RequiredDate;

--Question 42
--Find how many late orders for employees
Select
	e.EmployeeID,
	LastName,
	TotalLateOrder = count(o.OrderID)
from Orders o
join Employees e
	on o.EmployeeID = e.EmployeeID
where ShippedDate >= RequiredDate
group by e.EmployeeID, LastName
order by TotalLateOrder desc;

--Question 42-47
--Find how many all and late orders for employees
With 
	totalallorders as 
	(Select EmployeeID, allorders = count(*) 
	from Orders 
	group by EmployeeID),
	totallateorders as
	(Select EmployeeID, lateorders = count(*) 
	from Orders 
	where ShippedDate >= RequiredDate
	group by EmployeeID)
Select 
	a.EmployeeID,
	LastName,
	isnull(lateorders,0) [Total Later Orders],
	allorders [Total Orders],
	[Percent Late Order] = convert(decimal(2,2),(isnull(lateorders,0)*1.00)/allorders)
from totalallorders a
full outer join totallateorders l
	on a.EmployeeID = l.EmployeeID
join Employees e
	on a.EmployeeID = e.EmployeeID
order by a.EmployeeID;

--Question 48 - 49
--Grouping Customers by Total Order Amount
With all2016orders as(
	Select
		o.CustomerID,
		CompanyName,
		TotalOrderAmount = sum(UnitPrice * Quantity)
	from Orders o
	join OrderDetails od
		on o.OrderID = od.OrderID
	join Customers c
		on o.CustomerID = c.CustomerID
	where year(OrderDate) = 2016
	group by 
		o.CustomerID,
		CompanyName)
Select
	CustomerID,
	CompanyName,
	TotalOrderAmount,
	CustomerGroup = case
		when TotalOrderAmount >= 0 and TotalOrderAmount < 1000 then 'Low'
		when TotalOrderAmount >= 1000 and TotalOrderAmount < 5000 then 'Medium'
		when TotalOrderAmount >= 5000 and TotalOrderAmount < 10000 then 'High'
		else 'Very High' end
from all2016orders
order by CustomerID;

--Question 50-51
--Customer grouping with percentage
With 
all2016orders as(
	Select
		o.CustomerID,
		CompanyName,
		TotalOrderAmount = sum(UnitPrice * Quantity)
	from Orders o
	join OrderDetails od
		on o.OrderID = od.OrderID
	join Customers c
		on o.CustomerID = c.CustomerID
	where year(OrderDate) = 2016
	group by 
		o.CustomerID,
		CompanyName),
customergrouping as(
	Select
	CustomerID,
	CompanyName,
	TotalOrderAmount,
	CustomerGroup = case
		when TotalOrderAmount >= 0 and TotalOrderAmount < 1000 then 'Low'
		when TotalOrderAmount >= 1000 and TotalOrderAmount < 5000 then 'Medium'
		when TotalOrderAmount >= 5000 and TotalOrderAmount < 10000 then 'High'
		else 'Very High' end
	from all2016orders)
Select 
	CustomerGroup,
	count(*) TotalInGroup,
	PercentageInGroup = count(*)*1.0/(select count(*) from customergrouping)
from customergrouping
group by CustomerGroup
order by TotalInGroup desc;

--Question 52
--Country with Suppliers or Customers
Select distinct Country from Customers
union
Select distinct Country from Suppliers;

--Question 53
--Country with Suppliers or Customers compare 2 lists
With 
countrycustomer as (Select distinct Country from Customers),
countrysupplier as (Select distinct Country from Suppliers)
Select
	cs.Country SupplierCountry,
	cc.Country CustomerCountry
from countrycustomer cc
full outer join countrysupplier cs
	on cs.Country = cc.Country

--Question 54
--Country with Suppliers or Customers compare number of countries
With 
countrycustomer as (Select Country, Total = count(*) from Customers group by Country),
countrysupplier as (Select Country, Total = count(*) from Suppliers group by Country)
Select
	Country = isnull(cs.Country, cc.Country),
	TotalSuppliers = isnull(cs.Total,0),
	TotalCustomers = isnull(cc.Total,0)
from countrysupplier cs
full outer join countrycustomer cc
	on cs.Country = cc.Country;

--Question 55
--First order in each country
With rankOrders as
	(Select
		ShipCountry,
		CustomerID,
		OrderID,
		OrderDate,
		OrderbyCountry = rank() over (partition by ShipCountry order by OrderDate)
	from Orders)
Select ShipCountry,
		CustomerID,
		OrderID,
		OrderDate 
from rankOrders
where OrderbyCountry = 1;

--Question 56-57
--Customers with multiple orders in 5 day period
With NextOrderDate as
	(Select
		CustomerID,
		OrderDate = convert(date,OrderDate),
		NextOrderDate = convert(date,Lead(OrderDate,1) 
			over (partition by CustomerID order by CustomerID, OrderDate))
	from Orders)
Select
	CustomerID,
	OrderDate,
	NextOrderDate,
	DaysBetweenOrders = Datediff(dd,OrderDate,NextOrderDate)
from NextOrderDate
where Datediff(dd,OrderDate,NextOrderDate) <= 5;

	