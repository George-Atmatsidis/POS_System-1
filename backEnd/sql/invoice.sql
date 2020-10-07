
-- create table Items --
CREATE TABLE Items (
   itemID INT PRIMARY KEY,
   price REAL,
   description VARCHAR(200),
   name VARCHAR(20),
   size VARCHAR(20)
  );
-- create table Inventory --
CREATE TABLE Inventory (
   itemID INT PRIMARY KEY,
   quantity INT,
   location VARCHAR(20)
  );
-- create table Orders --
CREATE TABLE Orders (
   orderID INT PRIMARY KEY,
   customerID INT,
   itemID INT,
   quantity INT,
   date VARCHAR(20)
  );
-- create table Customers --
CREATE TABLE Customers (
   customerID INT PRIMARY KEY,
   customerName VARCHAR(20),
   gender VARCHAR(20),
   email VARCHAR(100),
   address VARCHAR(200),
   phone VARCHAR(10)
  );
-- create table Employees --
CREATE TABLE Employees (
   employeeID INT PRIMARY KEY,
   name VARCHAR(20)
  );
-- create table Invoices --
CREATE TABLE Invoices (
   invoiceID INT PRIMARY KEY,
   customerID INT,
   totalPrice REAL,
   orderID INT,
   employeeID INT,
   date VARCHAR(20),
   shippingDate VARCHAR(20)
  );