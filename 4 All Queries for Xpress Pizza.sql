
 USE Xpress	  -- Specifies to use Xpress database 
 




--------------------------------------------------------------------------------------------------------------------------------------------




--Query 1 : View the top 3 dishes that were ordered the most in the month of May

USE Xpress														-- Specifies the database to be used

SELECT TOP 3  Dishes.Dish_name,									-- Selects top 3 dishes by name
    SUM(OD.OrderQty) AS Total_Ordered							-- Calculates the total quantity of each dish ordered
FROM OrderDishes AS OD

	JOIN Dishes ON OD.Dish_ID = Dishes.Dish_ID					-- Joins the OrderDishes table with the Dishes table on Dish_ID column
	JOIN Orders ON OD.Order_ID = Orders.Order_ID				-- Joins the OrderDishes table with the Orders table on the Order_ID column		

WHERE MONTH(Orders.Date) = 5									-- Filters the results for orders made in the month of May
GROUP BY Dishes.Dish_name										-- Groups the results by the name of the dish
ORDER BY Total_Ordered DESC;									-- Orders the results by the total quantity ordered in descending order
    


	

--------------------------------------------------------------------------------------------------------------------------------------------


--Query 2 : View the description of each delivery partner, the number of orders made through them,
		   --and the percentage of orders made through them out of the total number of orders.

USE Xpress;													    -- Specifies to use Xpress database 

SELECT D.Description,											-- Selects column description from Delivery Table
	COUNT (D.Delivery_ID) AS OrdersCount,						-- Counts the delivery IDs and view the result as OrdersCount
	ROUND ((CAST(COUNT(D.Delivery_ID) AS FLOAT)/				-- Rounds the percentage value to 2 decimal places
	(SELECT COUNT (Order_ID) FROM Orders)*100),2) AS "Percentage"

--Counts the number of orders made through a specific delivery partner, casts the result to float data type and divide by Total Orders to calculate percentage

FROM Orders AS O												-- Selects data from the Orders table
	JOIN Delivery AS D ON D.Delivery_ID = O.Delivery_ID			-- Joins the Delivery table on the basis of delivery ID to Orders table
	GROUP BY D.Description										-- Groups the result by the delivery description
	ORDER BY OrdersCount DESC;									-- Orders the result in descending order of orders count



	

--------------------------------------------------------------------------------------------------------------------------------------------




--Query 3 : What is the total commission to be paid to the delivery partners in the month of June??

SELECT 
	d.Description,																					-- select delivery partner's name
	CAST(SUM(di.Price * od.OrderQty * (d.Commission / 100)) AS FLOAT) AS 'Commission for the Month'	
	-- Multiplying the price of each dish by the quantity ordered and the commission percentage for each dish, and then summing the results for all dishes in all orders for the given month. 
	-- The result is cast to a floating-point number to display the commission as a decimal value
FROM 
	Dishes di																				-- table for dishes
	INNER JOIN Orderdishes od ON di.Dish_ID = od.Dish_ID									-- join dishes and order dishes tables on dish ID
	INNER JOIN Orders o ON o.Order_ID = od.Order_ID											-- join orders and order dishes tables on order ID
	INNER JOIN Delivery d ON d.Delivery_ID = o.Delivery_ID									-- join delivery and orders tables on delivery ID
WHERE 
	 MONTH(o.Date) = 6																	    -- filter for orders in June
GROUP BY 
	 d.Description																			-- group results by delivery partner's name
ORDER BY 
	'Commission for the Month' DESC;														-- Sorts the results in descending order by commission


	

--------------------------------------------------------------------------------------------------------------------------------------------




--Query 4 : View the Total Revenue and quantities sold for each dish for first six months of year 2022.
USE Xpress
SELECT 
    d.Dish_name,
    SUM(od.OrderQty) AS [Total Quantities Sold],				-- Calculate the total quantity sold for each dish
    SUM(d.Price * od.OrderQty) AS [Revenue]						-- Calculate the total revenue earned for each dish
FROM 
    Orderdishes AS od											-- Select data from the Orderdishes table
    INNER JOIN Dishes AS d ON od.Dish_ID = d.Dish_ID			-- join the Orderdishes table with the Dishes table using the Dish_ID column
    INNER JOIN Orders AS o ON od.Order_ID = o.Order_ID		    -- join the Orderdishes table with the Orders table using the Order_ID column
WHERE 
	o.Date >= '2022-01-01' AND o.Date < '2022-06-30'			-- filter the results to only include data from the first half of the year (January to June)


GROUP BY 
    d.Dish_name	
    -- group the results by dish name, so that we get the total quantities sold and revenue earned for each unique dish name

ORDER BY 
    [Revenue] DESC, [Total Quantities Sold];				    -- sort the results in descending order by total quantity sold and then by revenue

	

--------------------------------------------------------------------------------------------------------------------------------------------



--Query 5 : View the list of top 10 customers with highest total order price in the first quater of 2022

USE Xpress;

SELECT TOP 10												--Selects the Firstname, Lastname, Customer ID from Customer table, City from address table
    C.FirstName,
    C.LastName,
	A.City,
	C.CustID,
    SUM(OD.OrderQty * D.Price) AS TotalOrderPrice			--Multiplies Dish price with order quantity to calculate Total Order value
FROM
    Orders O
    JOIN Customers C ON O.CustID = C.CustID					-- Joins the Orders table with the Customers table on the customer ID
	JOIN Address A ON C.CustID = A.CustID					-- Joins the Customers table with the Address table on the customer ID
    JOIN OrderDishes OD ON O.Order_ID = OD.Order_ID			-- Joins the OrderDishes table with the Orders table on the order ID
    JOIN Dishes D ON OD.Dish_ID = D.Dish_ID					-- Joins the Dishes table with the OrderDishes table on the dish ID
WHERE
    o.Date >= '2022-01-01' AND o.Date <= '2022-03-31'		-- Filters for orders placed between January 1st, 2022 and March 31st, 2022
GROUP BY													-- Groups the results by customer ID, Firstname, Lastname and city.
    C.CustID,
    C.FirstName,
    C.LastName,
	A.City
ORDER BY													-- Sorts the results in descending order of total order price.
    TotalOrderPrice DESC;	
	


--------------------------------------------------------------------------------------------------------------------------------------------



--Query 6 : view the different cities where customers have ordered from and also view the total orders and total amount for each city 

USE Xpress

SELECT 
    a.City,														 -- Select the City column from the Address table
    ROUND(SUM(d.Price * od.OrderQty), 0) AS Total_Order_Amount,  -- Calculate the total order amount by multiplying the price of each dish with the quantity ordered, summing them up, and rounding the result to 0 decimal places
    COUNT(*) AS TotalOrders										 -- Count the total number of orders for each city
FROM 
    [Address] a													 -- Join the Address table
    JOIN Customers c ON a.CustID = c.CustID						 -- Join the Customers table on the basis of the Customer ID
    JOIN Orders o ON c.CustID = o.CustID						 -- Join the Orders table on the basis of the Customer ID
    JOIN OrderDishes od ON o.Order_ID = od.Order_ID				 -- Join the OrderDishes table on the basis of the Order ID
    JOIN Dishes d ON od.Dish_ID = d.Dish_ID						 -- Join the Dishes table on the basis of the Dish ID
GROUP BY 
    a.City														 -- Group the result set by the City column
ORDER BY 
    Total_Order_Amount DESC,									 -- Order the result set by Total_Order_Amount column in descending order
    TotalOrders							
	

--------------------------------------------------------------------------------------------------------------------------------------------



--Query 7 : Calculate the DishMaking_Cost, Delivery_Commission, Total_Cost, Total_Earnings, and Profit made in first Six months

--Total_Cost = DishMaking_Cost + Delivery_Commission
--Profit = Total_Earnings - Total_Cost

USE Xpress
-- Declare variables for the date range  for first six months
DECLARE @StartDate DATETIME = '2022-01-01';
DECLARE @EndDate DATETIME = '2022-06-30';

-- Create variables for DishMaking_Cost, Delivery_Commission, Total_Cost, Total_Earnings, and Profit
DECLARE @DishMaking_Cost FLOAT = 0.0;
DECLARE @Delivery_Commission FLOAT = 0.0;
DECLARE @Total_Cost FLOAT = 0.0;
DECLARE @Total_Earnings FLOAT = 0.0;
DECLARE @Profit FLOAT = 0.0;

-- Calculate DishMaking_Cost
-- Find the cost of one dish using the Ingredients and Recipes tables
WITH CostOfOneDish AS (
SELECT r.Dish_ID, SUM(i.Price_per_kg * r.Quantity_kg) AS Cost
FROM Ingredients i
JOIN Recipes r ON i.Ing_ID = r.Ing_ID
GROUP BY r.Dish_ID
),
-- Find the total dishes sold in the date range using the Orders and OrderDishes tables
DishesSold AS (
SELECT d.Dish_ID, SUM(od.OrderQty) AS QuantitySold
FROM Orders o
JOIN OrderDishes od ON o.Order_ID = od.Order_ID
JOIN Dishes d ON od.Dish_ID = d.Dish_ID
WHERE CONVERT(datetime, o.Date) >= @StartDate AND CONVERT(datetime, o.Date) <= @EndDate
GROUP BY d.Dish_ID
),
-- Calculate the dish-making cost for the date range
DishMaking_Cost AS (
SELECT SUM(c.Cost * ds.QuantitySold) AS Cost
FROM CostOfOneDish c
JOIN DishesSold ds ON c.Dish_ID = ds.Dish_ID
)
SELECT @DishMaking_Cost = DishMaking_Cost.Cost FROM DishMaking_Cost;

-- Calculate Delivery_Commission
SELECT @Delivery_Commission = SUM(Dishes.Price * Orderdishes.OrderQty * Delivery.Commission / 100)
FROM Orderdishes
INNER JOIN Dishes ON Orderdishes.Dish_ID = Dishes.Dish_ID
INNER JOIN Orders ON Orderdishes.Order_ID = Orders.Order_ID
INNER JOIN Delivery ON Orders.Delivery_ID = Delivery.Delivery_ID
WHERE CONVERT(datetime, Orders.Date) >= @StartDate AND CONVERT(datetime, Orders.Date) <= @EndDate;

-- Calculate Total_Cost
SELECT @Total_Cost = @DishMaking_Cost + @Delivery_Commission;

-- Calculate Total_Revenue
SELECT @Total_Earnings = SUM(Dishes.Price * Orderdishes.OrderQty)
FROM Orderdishes
INNER JOIN Dishes ON Orderdishes.Dish_ID = Dishes.Dish_ID
INNER JOIN Orders ON Orderdishes.Order_ID = Orders.Order_ID
WHERE CONVERT(datetime, Orders.Date) >= @StartDate AND CONVERT(datetime, Orders.Date) <= @EndDate;

-- Calculate Profit
SELECT @Profit = @Total_Earnings - @Total_Cost;

-- Display DishMaking_Cost, Staff_salary, Delivery_Commission, Total_Cost, Total_Earnings, and Profit
SELECT @DishMaking_Cost AS DishMaking_Cost, @Delivery_Commission AS Delivery_Commission, @Total_Cost AS Total_Cost, @Total_Earnings AS Total_Earnings, @Profit AS Profit