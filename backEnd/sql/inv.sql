-- Delete Existing Tables--
DROP TABLE Invoices;
DROP TABLE Inventory;
DROP TABLE invoice_inventory;
DROP TABLE WorkOrders;
DROP TABLE Quotes;
DROP TABLE Employees;
DROP TABLE Customers;
DROP TABLE Addresses;


-- Create Tables -- 
CREATE TABLE Invoices (
	invNo INT PRIMARY KEY, -- invoice ID
	cusNo INT, 
	empNo INT,
    partID VARCHAR(10)
    -- status VARCHAR(100) 
    -- FOREIGN KEY (cusID) references Customers(cusID) --
  );
  
CREATE TABLE Inventory (
	partID VARCHAR(10) PRIMARY KEY,
	name VARCHAR(50),
    description VARCHAR(200),
    quantity INT,
    price REAL,
    -- size VARCHAR(50),
    brand VARCHAR(50),
    classNo INT
  );

CREATE TABLE WorkOrders (
	workNo INT PRIMARY KEY,	-- 00000 means "Over Counter"
	cusNo INT,
	partID VARCHAR(10)
	-- status VARCHAR(200)
  );

CREATE TABLE Quotes (
   quoteNo INT PRIMARY KEY,
   cusNo INT,
   partID VARCHAR(10)
   -- status VARCHAR(200)
  );
  
CREATE TABLE Employees (
	name VARCHAR(20),
	userName VARCHAR(20) UNIQUE,
	password VARCHAR(20),
	empNo INT PRIMARY KEY,
	address VARCHAR(50),
	phone VARCHAR(16),
	role VARCHAR(20)
  );
  
CREATE TABLE Customers (
	cusNo INT PRIMARY KEY,
	name VARCHAR(20),
	phone VARCHAR(16),
	credit bigint(16),
	email VARCHAR(100),
	-- addrID VARCHAR(20)
	address VARCHAR(50)
  );

/*CREATE TABLE Addresses (
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
  );*/
  
-- Insert Test data into table--
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('John Smith', 'john', '1234', 1000, '1000 Johnson, Jonesboro, AR, 72401', '123-456-7890', 'admin');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Cade Powers', 'cade', '1234', 1001, '2134 Red Wold, Jonesboro, AR, 72142', '321-654-0987', 'admin');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Patrick Cade', 'patrick', '1234', 1002, '1234 Qwertrt, Jonesboro, AR, 72401', '456-789-7890', 'admin');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Fady Farag', 'fady', '1234', 1003, '1345 Johnson, Jonesboro, AR, 72401', '759-186-4451', 'admin');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Ryouji Sezai', 'ryouji', '1234', 1004, '2560 E Johnson, Jonesboro, AR, 72401', '758-458-7894', 'admin');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Xxx Xxxx', 'xxxx', '1234', 1005, '1000 Johnson, Jonesboro, AR, 72401', '123-456-7890', 'admin');

INSERT INTO Customers (cusNo, name, phone, credit, email, address) VALUES (40001, 'Redline Trucking', '741-852-9306', 5113888844440000, 'redline@gmail.com', '1234 Elvin Lane, Carbot, AR 72023');
INSERT INTO Customers (cusNo, name, phone, credit, email, address) VALUES (40002, 'Rust Bucket', '789-671-0549', 7415845795687135, 'rust@gmail.com', '7896 Carr, Jonesboro, AR 72467');
INSERT INTO Customers (cusNo, name, phone, credit, email, address) VALUES (40003, 'Full of It trucking', '789-671-0549', 7415845795687135, 'full@gmail.com', '9842 Johnson, Jonesboro, AR 72467');
INSERT INTO Customers (cusNo, name, phone, credit, email, address) VALUES (40004, 'Freightliner of Lonoke', '789-671-0549', 7415845795687135, 'freight@gmail.com', '7896 Johnson, University, AR 72467');
INSERT INTO Customers (cusNo, name, phone, credit, email, address) VALUES (40005, 'Peterbilt', '789-671-0549', 7415845795687135, 'peter@gmail.com', '1294 Johnson, Jonesboro, AR 72467');

INSERT INTO Inventory (partID, name, description, quantity, price, brand, classNo) VALUES ('45125A', 'New Gear', 'Gear', 2, 120.00, 'Alpha', 001);
INSERT INTO Inventory (partID, name, description, quantity, price, brand, classNo) VALUES ('184125A', 'Super Gear', 'Gear', 10, 30.00, 'Bravo', 001);
INSERT INTO Inventory (partID, name, description, quantity, price, brand, classNo) VALUES ('175999B', 'Good oil', 'Oil', 1, 100.00, 'Charlie', 002);
INSERT INTO Inventory (partID, name, description, quantity, price, brand, classNo) VALUES ('789000B', 'Oil-oil', 'Gear', 2, 120.00, 'Delta', 001);
INSERT INTO Inventory (partID, name, description, quantity, price, brand, classNo) VALUES ('123456A', 'Great Gear', 'Gear', 70, 10.00, 'Echo', 001);
INSERT INTO Inventory (partID, name, description, quantity, price, brand, classNo) VALUES ('45125C', 'USeful tool', 'Tool', 1, 400.00, 'Foxtrot', 003);

INSERT INTO Invoices (invNo, cusNo, empNo, partID) VALUES (10001, 40001, 1000, '45125A');
INSERT INTO Invoices (invNo, cusNo, empNo, partID) VALUES (10001, 40001, 1000, '184125A');
INSERT INTO Invoices (invNo, cusNo, empNo, partID) VALUES (10001, 40001, 1000, '175999B');
INSERT INTO Invoices (invNo, cusNo, empNo, partID) VALUES (10002, 40002, 1001, '184125A');
INSERT INTO Invoices (invNo, cusNo, empNo, partID) VALUES (10002, 40002, 1002, '184125A');
INSERT INTO Invoices (invNo, cusNo, empNo, partID) VALUES (10003, 40003, 1003, '45125C');

INSERT INTO WorkOrders (workNo, cusNo, partID) VALUES (20001, 40001, '45125A');
INSERT INTO WorkOrders (workNo, cusNo, partID) VALUES (20002, 40002, '184125A');
INSERT INTO WorkOrders (workNo, cusNo, partID) VALUES (20003, 40003, '175999B');
INSERT INTO WorkOrders (workNo, cusNo, partID) VALUES (20004, 40001, '184125A');
INSERT INTO WorkOrders (workNo, cusNo, partID) VALUES (00000, 40001, '184125A');

INSERT INTO Quotes (quoteNo, cusNo, partID) VALUES (30001, 40001, '45125A');
INSERT INTO Quotes (quoteNo, cusNo, partID) VALUES (30002, 40002, '184125A');
INSERT INTO Quotes (quoteNo, cusNo, partID) VALUES (30003, 40003, '175999B');
INSERT INTO Quotes (quoteNo, cusNo, partID) VALUES (30004, 40004, '184125A');

