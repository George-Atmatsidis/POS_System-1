
-- Create Tables -- 
CREATE TABLE Invoices (
   invNo INT PRIMARY KEY,
   cusID INT,
   empID INT,
   status VARCHAR(100)
   -- FOREIGN KEY (cusID) references Customers(cusID) --
  );
  
CREATE TABLE Inventory (
	partNo INT PRIMARY KEY,
	name VARCHAR(50),
    price REAL,
    descption VARCHAR(200),
    size VARCHAR(50),
    provider VARCHAR(50)
  );

CREATE TABLE WorkOrders (
   wokID INT PRIMARY KEY,
   cusID INT,
   partNo INT,
   status VARCHAR(200)
  );

CREATE TABLE Quotes (
   quoteNo INT PRIMARY KEY,
   cusID INT,
   partID INT,
   status VARCHAR(200)
  );
  
CREATE TABLE Employees (
   empID INT PRIMARY KEY,
   name VARCHAR(20),
   email VARCHAR(50),
   password VARCHAR(20)
  );
  
CREATE TABLE Customers (
   cusID INT PRIMARY KEY,
   name VARCHAR(20),
   phone VARCHAR(15),
   credit bigint(16),
   email VARCHAR(100),
   addrID VARCHAR(20)
  );

CREATE TABLE Addresses (
   addrID INT PRIMARY KEY,
   streat VARCHAR(100),
   city VARCHAR(50),
   state VARCHAR(15),
   zip VARCHAR(10)
  );

CREATE TABLE invoice_inventory (
	invID INT,
    partNo INT,
    quantity INT,
	PRIMARY KEY (invID, partNo)
  );
  