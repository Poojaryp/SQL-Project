-- Creating tables for the Xpress Pizza Database
USE Xpress
;
-- The Following Tables will be created only if the said table is not available
IF OBJECT_ID('Xpress..Customers') IS NOT NULL
	DROP TABLE Xpress..Customers
	CREATE TABLE Xpress..Customers (
    CustID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
	Phone VARCHAR(20)
);

IF OBJECT_ID('Xpress..Address') IS NOT NULL
	DROP TABLE Xpress..[Address]
	CREATE TABLE Xpress..[Address] (
    AddID INT PRIMARY KEY,
    CustID INT,
    StreetAddress VARCHAR(50),
    City VARCHAR(20),
    Postcode VARCHAR(10),
    FOREIGN KEY (CustID) REFERENCES Xpress..Customers(CustID)
);

IF OBJECT_ID('Xpress..Ingredients') IS NOT NULL
	DROP TABLE Xpress..Ingredients
	CREATE TABLE Xpress..Ingredients (
    Ing_ID SMALLINT PRIMARY KEY,
    Ing_Name VARCHAR(50),
    Price_per_kg DECIMAL(10,2),
    StartDate DATE,
    EndDate DATE
);

IF OBJECT_ID('Xpress..Inventory') IS NOT NULL
	DROP TABLE Xpress..Inventory
	CREATE TABLE Xpress..Inventory (
    Inv_ID SMALLINT PRIMARY KEY,
    Ing_ID SMALLINT,
    Quantity_kg DECIMAL(10,2),
    FOREIGN KEY (Ing_ID) REFERENCES Xpress..Ingredients(Ing_ID)
);

IF OBJECT_ID('Xpress..Dishes') IS NOT NULL
	DROP TABLE Xpress..Dishes
	CREATE TABLE Xpress..Dishes (
    Dish_ID SMALLINT PRIMARY KEY,
    Dish_name VARCHAR(50),
    Price DECIMAL(10,2),
    StartDate DATE,
    EndDate DATE
);

IF OBJECT_ID('Xpress..Recipes') IS NOT NULL
	DROP TABLE Xpress..Recipes
	CREATE TABLE Xpress..Recipes (
    Dish_ID SMALLINT,
    Ing_ID SMALLINT,
    Quantity_kg DECIMAL(10,2),
    PRIMARY KEY (Dish_ID, Ing_ID),
    FOREIGN KEY (Dish_ID) REFERENCES Xpress..Dishes(Dish_ID),
    FOREIGN KEY (Ing_ID) REFERENCES Xpress..Ingredients(Ing_ID)
);

IF OBJECT_ID('Xpress..Delivery') IS NOT NULL
	DROP TABLE Xpress..Delivery
	CREATE TABLE Xpress..Delivery (
    Delivery_ID SMALLINT PRIMARY KEY,
    [Description] VARCHAR(20),
    Commission DECIMAL(10,2)
);

IF OBJECT_ID('Xpress..Orders') IS NOT NULL
	DROP TABLE Xpress..Orders
	CREATE TABLE Xpress.dbo.Orders(
	Order_ID    INT  NOT NULL PRIMARY KEY,
	CustID INT  NOT NULL,
	Delivery_ID INT  NOT NULL,
	[Date] DATE  NOT NULL,
	[Time] TIME  NOT NULL,
	FOREIGN KEY (CustID) REFERENCES Xpress..Customers(CustID)
);

IF OBJECT_ID('Xpress..OrderDishes') IS NOT NULL
	DROP TABLE Xpress..OrderDishes
	CREATE TABLE Xpress..OrderDishes (
	Row_ID INT PRIMARY KEY,
    Order_ID INT,
    Dish_ID SMALLINT,
    OrderQty SMALLINT,
    FOREIGN KEY (Order_ID) REFERENCES Xpress..Orders(Order_ID),
    FOREIGN KEY (Dish_ID) REFERENCES Xpress..Dishes(Dish_ID)
);

IF OBJECT_ID('Xpress..Staff') IS NOT NULL
	DROP TABLE Xpress..Staff
	CREATE TABLE Xpress..Staff (
    Staff_ID SMALLINT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    Contact VARCHAR(20),
    Position VARCHAR(20),
    Hourly_Pay DECIMAL(10,2)
);

IF OBJECT_ID('Xpress..[Shift]') IS NOT NULL
	DROP TABLE Xpress..[Shift]
	CREATE TABLE [Shift] (
    Shift_ID SMALLINT PRIMARY KEY,
	[DayOfWeek] VARCHAR(20),
    StartTime TIME,
    EndTime TIME
);

IF OBJECT_ID('Xpress..Rota') IS NOT NULL
	DROP TABLE Xpress..Rota
	CREATE TABLE Xpress..Rota (
    Shift_ID SMALLINT,
    Staff_ID SMALLINT,
	PRIMARY KEY (Shift_ID, Staff_ID),
    FOREIGN KEY (Shift_ID) REFERENCES Xpress..[Shift](Shift_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Xpress..Staff(Staff_ID)
);