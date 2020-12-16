-- Delete Existing Tables --
	DROP TABLE IF EXISTS parts;
    DROP TABLE IF EXISTS Inventory;
	DROP TABLE IF EXISTS WorkOrders;
	DROP TABLE IF EXISTS Quotes;
    DROP TABLE IF EXISTS class;
	DROP TABLE IF EXISTS invoices;
    DROP TABLE IF EXISTS Employees;
	DROP TABLE IF EXISTS Customers;
    DROP TABLE IF EXISTS Bills;
    DROP TABLE IF EXISTS accountReceivable;

-- Create Tables --  
CREATE TABLE Employees (
	name VARCHAR(20),
	userName VARCHAR(20) UNIQUE,
	password VARCHAR(20) NOT NULL,
	empNo INT PRIMARY KEY,
	address VARCHAR(50),
	phone VARCHAR(16),
	role VARCHAR(20) default '' -- Default data is blank
  );
  
CREATE TABLE Customers (
	cusNo INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	phone VARCHAR(16),
	credit bigint CHECK(credit >= 0),
	email VARCHAR(100),
	address VARCHAR(50),
    billing VARCHAR(50),
    shipping VARCHAR(50),
    cityTax REAL default 0.05 CHECK(cityTax >= 0),
    stateTax REAL default 0.1 CHECK(stateTax >= 0),
    federalTax REAL default 0.025 CHECK(federalTax >= 0),
    chargeMax float,
    currentCharge float
);
 
 CREATE TABLE Class (
	classNo INT PRIMARY KEY,
    descr VARCHAR(100),
    margin1 REAL,
    margin2 REAL,
    margin3 REAL
);
 
CREATE TABLE Inventory (
	partID VARCHAR(20) PRIMARY KEY,
	description VARCHAR(100) default 'No description',
	quantity INT,
    QuantityOO INT default 1,  -- How much is default value??
	price REAL CHECK(price >= 0),
    brand VARCHAR(50) default 'No brand',
    cost REAL CHECK(cost >= 0),
    source VARCHAR(50) default 'Unknown source',
	classNo INT,
	FOREIGN KEY(classNo) REFERENCES Class(classNo) ON UPDATE CASCADE ON DELETE RESTRICT
  );

CREATE TABLE parts(
	ID INT, -- invoice No/ WorkOrder No/ Quote No
	partID VARCHAR(20), -- Inventory ID
    quantity INT,
    price REAL CHECK(price >= 0),
    FOREIGN KEY(partID) REFERENCES Inventory(partID) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Invoices (
	invNo INT PRIMARY KEY CHECK (invNo >= 3000 AND invNo < 4000), -- RANGE: 3000~3999 
	cusNo INT, 
	empNo INT,
    subTotal REAL CHECK (subTotal >= 0),
	taxTotal REAL CHECK (taxTotal >= 0),
    total REAL CHECK (total >= 0),
    invDate DATETIME DEFAULT NOW(),
    FOREIGN KEY(cusNo) REFERENCES Customers(cusNo) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(empNo) REFERENCES Employees(empNo) ON UPDATE CASCADE ON DELETE RESTRICT
  );

CREATE TABLE WorkOrders (
	workNo INT PRIMARY KEY CHECK (workNo >= 2000 AND workNo < 3000), -- RANGE: 2000~2999 
	cusNo INT, 
	empNo INT,
    subTotal REAL CHECK (subTotal >= 0),
	taxTotal REAL CHECK (taxTotal >= 0),
    total REAL CHECK (total >= 0),
    date DATETIME DEFAULT NOW(),
    FOREIGN KEY(cusNo) REFERENCES Customers(cusNo) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(empNo) REFERENCES Employees(empNo) ON UPDATE CASCADE ON DELETE RESTRICT
  );

CREATE TABLE Quotes (
	quoteNo INT PRIMARY KEY CHECK (quoteNo >= 1000 AND quoteNo < 2000), -- RANGE: 1000~1999 
	cusNo INT, 
	empNo INT,
    subTotal REAL CHECK (subTotal >= 0),
	taxTotal REAL CHECK (taxTotal >= 0),
    total REAL CHECK (total >= 0),
    date DATETIME DEFAULT NOW(),
    FOREIGN KEY(cusNo) REFERENCES Customers(cusNo) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(empNo) REFERENCES Employees(empNo) ON UPDATE CASCADE ON DELETE RESTRICT
  );

CREATE TABLE AccountReceivable(
	accountNo INT,
    -- companyName VARCHAR(50),
    amount float,
    dateDue DATETIME DEFAULT NOW()
);

CREATE TABLE Bills(
	accountNo INT,
    -- companyName VARCHAR(50),
    amount float,
    payDate DATETIME DEFAULT NOW()
);


-- Create TRIGGERS --
DROP FUNCTION IF EXISTS proc_add_to_work();
DROP FUNCTION IF EXISTS proc_add_to_inv();

CREATE FUNCTION proc_add_to_work() RETURNS trigger AS $proc_add_to_work$
BEGIN
INSERT INTO Parts (SELECT ID+1000, partID, quantity, cost FROM Parts WHERE ID = NEW.workNo - 1000);
RETURN NEW;
END;
$proc_add_to_work$
LANGUAGE plpgsql;

CREATE TRIGGER trg_add_parts_to_work -- when adding new work orders, add parts data from quotes
AFTER INSERT ON workorders
FOR EACH ROW
EXECUTE FUNCTION proc_add_to_work();


CREATE FUNCTION proc_add_to_inv() RETURNS trigger AS $proc_add_to_inv$
BEGIN
INSERT INTO Parts (SELECT ID+1000, partID, quantity, cost FROM Parts WHERE ID = NEW.invNo - 1000);
RETURN NEW;
END;
$proc_add_to_inv$
LANGUAGE plpgsql;

CREATE TRIGGER trg_add_parts_to_inv -- when adding new work orders, add parts data from quotes
AFTER INSERT ON Invoices
FOR EACH ROW
EXECUTE FUNCTION proc_add_to_inv();


-- Insert Test data into table --
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('John Smith', 'john', '1234', 1000, '1000 Johnson, Jonesboro, AR, 72401', '123-456-7890', '');
-- INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Cade Powers', 'cade', '1234', 1001, '2134 Red Wold, Jonesboro, AR, 72142', '321-654-0987', 'admin');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Patrick Cade', 'patrick', '1234', 1002, '1234 Qwertrt, Jonesboro, AR, 72401', '456-789-7890', '');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Fady Farag', 'fady', '1234', 1003, '1345 Johnson, Jonesboro, AR, 72401', '759-186-4451', '');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Ryouji Sezai', 'ryouji', '1234', 1004, '2560 E Johnson, Jonesboro, AR, 72401', '758-458-7894', '');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Xxx Xxxx', 'xxxx', '1234', 1005, '1000 Johnson, Jonesboro, AR, 72401', '123-456-7890', '');

INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (001, 'Redstone', '741-852-9306', 5113888844440000, 'redline@gmail.com', '1234 Elvin Lane, Carbot, AR 72023', 'POBox 203 Ruelle, AR, 72451', 'ATTN: Robby 1234 Redstone St. Ruelle, AR, 72451', 2000.00, 1000.00);
INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (002, 'Rust Bucket', '789-671-0549', 7415845795687135, 'rust@gmail.com', '7896 Carr, Jonesboro, AR 72467', 'POBox 310 Jonesboro, AR, 72451', '7896 Carr, Jonesboro, AR 72467', 3000.00, 500.24);
INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (003, 'Full of It trucking', '789-671-0549', 7415845795687135, 'full@gmail.com', '9842 Johnson, Jonesboro, AR 72467', 'POBox 203 Little Rock, AR, 72451', '9842 Johnson, Jonesboro, AR 72467', 3000.00, 500.24);
INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (004, 'Freightliner', '789-671-0549', 7415845795687135, 'freight@gmail.com', '7896 Johnson, University, AR 72467', 'POBox 456 University, AR 72467', '7896 Johnson, University, AR 72467', 3000.00, 500.24);
INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (005, 'Peterbilt', '789-671-0549', 7415845795687135, 'peter@gmail.com', '1294 Johnson, Jonesboro, AR 72467', 'POBox 278 Jonesboro, AR 72467', '1294 Johnson, Jonesboro, AR 72467', 3000.00, 500.24);

INSERT INTO Class (classNo, descr, margin1, margin2, margin3) VALUES (001, 'Flywheel', 1.2, 1.6, 2.0);
INSERT INTO Class (classNo, descr, margin1, margin2, margin3) VALUES (002, 'Gears', 1.4, 1.8, 2.2);
INSERT INTO Class (classNo, descr, margin1, margin2, margin3) VALUES (003, 'Tire', 1.1, 1.2, 1.5);
INSERT INTO Class (classNo, descr, margin1, margin2, margin3) VALUES (005, 'Engine Mount', 1.1, 1.2, 1.5);

INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('45125A', 2, 320.00, 'Alpha', 80, 001);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('184125A', 10, 800.00, 'Bravo', 80.00, 001);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('175999B', 2, 80.00, 'Charlie', 40.00, 002);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('789000B', 28, 126, 'Delta', 4.50, 001);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('123456A', 70, 700, 'Echo', 100.00, 001);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('45125C', 5, 2000.00, 'Foxtrot', 400.00, 003);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('1245AV', 2, 100, 'G', 50.00, 002);

INSERT INTO Invoices (invNo, cusNo, empNo, subTotal, taxTotal, total, invDate) VALUES (3001, 001, 1000, 480.00, 84.00, 564.00, '2020-10-01');
INSERT INTO Invoices (invNo, cusNo, empNo, subTotal, taxTotal, total, invDate) VALUES (3002, 002, 1002, 245, 42.88, 287.88, '2020-10-05');
INSERT INTO Invoices (invNo, cusNo, empNo, subTotal, taxTotal, total, invDate) VALUES (3003, 001, 1003, 400, 70, 470, '2020-10-10');
INSERT INTO Invoices (invNo, cusNo, empNo, subTotal, taxTotal, total) VALUES (3004, 005, 1003, 0, 0, 0);

INSERT INTO Parts (ID, partID, quantity, price) VALUES (3001, '45125A', 2, 80);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (3001, '184125A', 3, 80.00);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (3001, '175999B', 1, 80.00);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (3002, '789000B', 10, 4.5);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (3002, '123456A', 2, 100);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (3003, '45125C', 1, 400);

INSERT INTO WorkOrders (workNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (2001, 001, 1000, 160.00, 28.00, 188.00, '2020-10-01');
INSERT INTO WorkOrders (workNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (2002, 002, 1002, 245, 42.88, 287.88, '2020-10-05');
INSERT INTO WorkOrders (workNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (2003, 003, 1003, 400, 70, 470, '2020-10-10');

INSERT INTO Parts (ID, partID, quantity, price) VALUES (2001, '45125A', 2, 80);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (2001, '184125A', 3, 80.00);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (2001, '175999B', 1, 80.00);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (2002, '789000B', 10, 4.5);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (2002, '123456A', 2, 100);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (2003, '45125C', 1, 400);

INSERT INTO Quotes (quoteNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (1001, 001, 1000, 160.00, 28.00, 188.00, '2020-10-01');
INSERT INTO Quotes (quoteNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (1002, 002, 1002, 245, 42.88, 287.88, '2020-10-05');
INSERT INTO Quotes (quoteNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (1003, 003, 1003, 400, 70, 470, '2020-10-10');

INSERT INTO Parts (ID, partID, quantity, price) VALUES (1001, '45125A', 2, 80);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (1001, '184125A', 3, 80.00);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (1001, '175999B', 1, 80.00);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (1002, '789000B', 10, 4.5);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (1002, '123456A', 2, 100);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (1003, '45125C', 1, 400);

INSERT INTO AccountReceivable (accountNo, amount, dateDue) VALUES (001, 12000.23, '2020-10-05');
INSERT INTO AccountReceivable (accountNo, amount, dateDue) VALUES (002, 10000.00, '2020-10-05');
INSERT INTO AccountReceivable (accountNo, amount, dateDue) VALUES (003, 5000.00, '2020-10-05');

INSERT INTO Bills (accountNo, amount, payDate) VALUES (001, 1200.23, '2020-10-05'); 
INSERT INTO Bills (accountNo, amount, payDate) VALUES (002, 120.56, '2020-10-10'); 

/*-- Test for TRIGGER 
INSERT INTO Quotes (quoteNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (1999, 003, 1003, 400, 70, 470, '2020-10-10'); 
INSERT INTO Parts (ID, partID, quantity, price) VALUES (1999, '45125A', 2, 80);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (1999, '184125A', 3, 80.00);
INSERT INTO Parts (ID, partID, quantity, price) VALUES (1999, '175999B', 1, 80.00);

INSERT INTO WorkOrders (SELECT quoteNo+1000, cusNo, empNo, subTotal, taxTotal, total, date FROM Quotes WHERE quoteNo = 1999); -- Convert Quote to WorkOrder
INSERT INTO Invoices (SELECT workNo+1000, cusNo, empNo, subTotal, taxTotal, total, date FROM WorkOrders WHERE workNo = 2999);

-- Update data
UPDATE Employees SET role = 'admin' WHERE empNo = 1005; -- Change Role
UPDATE Customers SET cusNo = 006 WHERE cusNo = 005; -- Test for foreign key: change cusNo in customers, then cusNos in invoice, workorder, and quote are changed
UPDATE Employees SET empNo = 1006 WHERE empNo = 1005; -- Test for foreign key: change empNo in employees, then empNos in other tables are changed
UPDATE Class SET classNo = 004 WHERE classNo = 003; -- Test for foreign key*/




-- ======================================== Queries for each route =======================================================
-- Login
-- Get Request For Login: {	Username: “Cade”, Password: “1234”}
SELECT username, role FROM Employees WHERE username = 'Cade' AND password = '1234';

-- register
-- Post Request For register: {Name: “Cade Powers”, Username: “Cade”, Password: “1234”, EmployeeId: 2345, 
-- 								Address: “2134 Red Wolf Jonesboro, AR, 72142”, PhoneNumber: “501-515-4086”}
INSERT INTO Employees(name, userName, password, empNo, address, phone) 
	VALUES ('Cade Powers', 'Cade', '1234', 2345, '2134 Red Wolf Jonesboro, AR, 72142', '501-515-4086');


-- ==================  Accounts Recievable =====================
-- accountsRecievable
-- Request Get request
SELECT accountNo, name, amount, datedue FROM AccountReceivable, customers WHERE accountNo = cusNo;

-- accountsRecievable/paid
-- Post Request: {AccountNumber: 001, AmountPaid: 1000.00,}
INSERT INTO Bills (accountNo, amount) VALUES(001, 1000.00);


-- ==================  inventory Management ============================
-- inventoryManagement/partsManagement
-- Get Request: {PartNumberPattern: “*125A”}
SELECT partID, description, quantity, price FROM Inventory WHERE partID like '%125A';

-- im/pm/detailed
-- Get Request: {PartNumber: “45125A”}
SELECT QuantityOO, cost, brand, source, classNo FROM Inventory WHERE partID = '45125A';
-- Post Request: {PartNumber: “45125A”, Quantity: 4, QuantityOO: -2}
UPDATE Inventory SET quantity = 4, QuantityOO = QuantityOO - 2 WHERE partID = '45125A';

-- im/pm/add
-- Put Request: {PartNumber: “101-45214-000”, *Description: “Freightliner engine mount”, Quantity: 8, *QuantityOO: 2, Price: 50.00,
-- 				 *Brand: “Freightliner”, Cost: 25.00, *Source: “Freightliner”, ClassID: 005}
INSERT INTO Inventory (partID, description, quantity, QuantityOO, price, brand, cost, source, classNo) 
	VALUES ('101-45214-000', 'Freightliner engine mount', 8, 2, 50.00, 'Freightliner', 25.00, 'Freightliner', 005);


-- im/classManagement
-- Get Request
SELECT * FROM class;

-- im/classManagement/update
-- Post Request: {ClassID: 001, ClassDescr: “Flywheels”, Margin1: 1.4}
UPDATE class SET descr = 'Flywheels', margin1 = 1.4 WHERE classNo = 001;



-- ========================= Customer Management ==================================
-- customerManagement
-- Get Request: {Name: “Red*”}
SELECT cusNo, name, address, phone FROM customers WHERE name like 'Red%';

-- customerManagement/detailed
-- Get Request: {ID: 001}
SELECT Billing, shipping, cityTax, stateTax, federalTax, chargeMax, currentCharge FROM customers WHERE cusNo = 001;
-- Post Request: {ID: 001, CityTax, 0.06}
UPDATE Customers SET cityTax = 0.06 WHERE cusNo = 001;

-- customerManagement/add
-- Put Request: { Name: “Cade Powers”, Addr: “245 Redwolf Blvd. Jonesboro, AR, 72154”, Phone: “501-515-4088”, BillingAddr: “POBox 203 Ruelle, AR, 72451”,
-- 			ShippingAddr: “ATTN: Robby 1234 Redstone St. Ruelle, AR, 72451”, CityTax: 0.05,	StateTax: 0.1, FederalTax: 0.025, ChargeMax: 20000.00, CurrentCharge: 10000.00}
INSERT INTO Customers (name, address, phone, billing, shipping, cityTax, stateTax, federalTax, chargeMax, currentCharge) VALUES ('Cade Powers', '245 Redwolf Blvd. Jonesboro, AR, 72154', '501-515-4088', 'POBox 203 Ruelle, AR, 72451', 'ATTN: Robby 1234 Redstone St. Ruelle, AR, 72451', 0.05, 0.1, 0.025, 20000.00, 10000.00);


-- ================================= Employee Management ==============================================
-- employeeManagement
-- Get Request: {Name: “John*”}
SELECT empNo, name, address, phone FROM employees WHERE name like 'John';

-- employeManagement/detailed
-- Get Request: {ID: 002}
SELECT * FROM employees WHERE empNo = 002;
-- Post Request: {ID: 002, password: 1111}
UPDATE Employees SET password = 1111 WHERE empNo = 002;
-- customerManagement/add
-- Same as Login query


-- ==================================== Parts Counter =============================================
-- partsCounter/invoice
-- Get Request { CustomerName: “Red*”}
SELECT invNo, name, invDate, partID, total FROM Invoices, Parts, Customers 
	WHERE parts.ID = invNo AND invoices.cusNo = customers.cusNo AND name like 'Red%' 
    GROUP BY invoices.invNo ORDER BY invDate ASC;

-- Get Request {ID: 30001 }
-- invoice info
SELECT invoices.* FROM invoices WHERE invNo = '3001';
-- items contained in invoice 3001
SELECT * FROM parts, inventory WHERE ID = '3001' and inventory.partID = parts.partID;


-- partsCounter/invoice/add
-- get request {customerID: 001}
SELECT name, billing, shipping, phone, email FROM Customers WHERE cusNo = 001;
-- get request {partNumber: 1245AV}
SELECT descr, (price * margin1) AS priceM1, (price * margin2) AS priceM2, (price * margin3) AS priceM3, cost, quantity
	FROM Inventory, class WHERE Inventory.classNo = class.classNo AND partID = '1245AV';
-- Get Request: {CustomerID: “001”,	Parts: “{1245AV, 2,160.00},{101-45214-000,4,80.00},…”}
INSERT INTO Invoices(invNo, cusNo) VALUES(3005, 1);			-- provisional invoice
INSERT INTO parts(ID, partID, quantity, price) VALUES(3005, '1245AV', 2, 160.00);
INSERT INTO parts(ID, partID, quantity, price) VALUES(3005, '101-45214-000', 4, 80.00);
SELECT SUM(price) AS subtotal,
	   SUM(price) * (SELECT cityTax+stateTax+federalTax FROM Customers WHERE cusNo = 1) AS taxTotal,
       SUM(price) * (SELECT cityTax+stateTax+federalTax+1 FROM Customers WHERE cusNo = 1) AS total
FROM parts WHERE ID = 3005;
-- After all parts are added, decide the subtotal, taxtotal, total
UPDATE Invoices 
SET empNo = 1004,
	subTotal = (SELECT SUM(price) FROM parts WHERE ID = 3005), 
	taxTotal = subTotal * (SELECT cityTax+stateTax+federalTax FROM Customers WHERE cusNo = 1), 
	total = subTotal + taxTotal 
WHERE invNo = 3005;

-- partsCounter/history
-- Get Request: {Type: 1, *Customer: “Red*”, *PartNumber: “101-254*”, *Date: “10/05/2020”}
SELECT * FROM Workorders -- Type
WHERE cusNo IN (SELECT cusNo FROM Customers WHERE name like 'Red%') -- Customer
AND workNo IN (SELECT ID FROM parts WHERE partID like '45125%') -- part number
AND date like '2020-10-01%'; -- date



