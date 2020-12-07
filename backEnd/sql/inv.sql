-- Delete Existing Tables--
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
	password VARCHAR(20),
	empNo INT PRIMARY KEY,
	address VARCHAR(50),
	phone VARCHAR(16),
	role VARCHAR(20) default '' -- Default data is blank
  );
  
CREATE TABLE Customers (
	cusNo INT PRIMARY KEY,
	name VARCHAR(50),
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
    description VARCHAR(100),
    margin1 REAL,
    margin2 REAL,
    margin3 REAL
);
 
CREATE TABLE Inventory (
	partID VARCHAR(20) PRIMARY KEY,
	description VARCHAR(100) default 'No description',
	quantity INT,
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
    cost REAL CHECK(cost >= 0),
    FOREIGN KEY(partID) REFERENCES Inventory(partID) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Invoices (
	invNo INT PRIMARY KEY CHECK (invNo >= 3000 AND invNo < 4000), -- RANGE: 3000~3999 
	cusNo INT, 
	empNo INT,
    subTotal REAL CHECK (subTotal >= 0),
	taxTotal REAL CHECK (taxTotal >= 0),
    total REAL CHECK (total >= 0),
    invDate DATE,
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
    date DATE,
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
    date DATE,
    FOREIGN KEY(cusNo) REFERENCES Customers(cusNo) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY(empNo) REFERENCES Employees(empNo) ON UPDATE CASCADE ON DELETE RESTRICT
  );

CREATE TABLE AccountReceivable(
	accountNo INT,
    amount float,
    dateDue DATE
);

CREATE TABLE Bills(
	accountNo INT,
    amount float,
    payDate DATE
);


-- Create TRIGGERS --
DROP TRIGGER IF EXISTS trg_add_parts_to_work;
DROP TRIGGER IF EXISTS trg_add_parts_to_inv;

DELIMITER //

CREATE TRIGGER trg_add_parts_to_work -- when adding new work orders, add parts data from quotes
AFTER INSERT ON workorders
FOR EACH ROW
BEGIN
INSERT INTO Parts (SELECT ID+1000, partID, quantity, cost FROM Parts WHERE ID = NEW.workNo - 1000);
END;
//

CREATE TRIGGER trg_add_parts_to_inv
AFTER INSERT ON Invoices
FOR EACH ROW
BEGIN
INSERT INTO Parts (SELECT ID+1000, partID, quantity, cost FROM Parts WHERE ID = NEW.invNo - 1000);
END;
//
DELIMITER ;


-- Insert Test data into table --
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('John Smith', 'john', '1234', 1000, '1000 Johnson, Jonesboro, AR, 72401', '123-456-7890', '');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Cade Powers', 'cade', '1234', 1001, '2134 Red Wold, Jonesboro, AR, 72142', '321-654-0987', 'admin');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Patrick Cade', 'patrick', '1234', 1002, '1234 Qwertrt, Jonesboro, AR, 72401', '456-789-7890', '');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Fady Farag', 'fady', '1234', 1003, '1345 Johnson, Jonesboro, AR, 72401', '759-186-4451', '');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Ryouji Sezai', 'ryouji', '1234', 1004, '2560 E Johnson, Jonesboro, AR, 72401', '758-458-7894', '');
INSERT INTO Employees(name, userName, password, empNo, address, phone, role) VALUES ('Xxx Xxxx', 'xxxx', '1234', 1005, '1000 Johnson, Jonesboro, AR, 72401', '123-456-7890', '');

INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (001, 'Redstone', '741-852-9306', 5113888844440000, 'redline@gmail.com', '1234 Elvin Lane, Carbot, AR 72023', 'POBox 203 Ruelle, AR, 72451', 'ATTN: Robby 1234 Redstone St. Ruelle, AR, 72451', 2000.00, 1000.00);
INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (002, 'Rust Bucket', '789-671-0549', 7415845795687135, 'rust@gmail.com', '7896 Carr, Jonesboro, AR 72467', 'POBox 310 Jonesboro, AR, 72451', '7896 Carr, Jonesboro, AR 72467', 3000.00, 500.24);
INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (003, 'Full of It trucking', '789-671-0549', 7415845795687135, 'full@gmail.com', '9842 Johnson, Jonesboro, AR 72467', 'POBox 203 Little Rock, AR, 72451', '9842 Johnson, Jonesboro, AR 72467', 3000.00, 500.24);
INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (004, 'Freightliner', '789-671-0549', 7415845795687135, 'freight@gmail.com', '7896 Johnson, University, AR 72467', 'POBox 456 University, AR 72467', '7896 Johnson, University, AR 72467', 3000.00, 500.24);
INSERT INTO Customers (cusNo, name, phone, credit, email, address, billing, shipping, chargeMax, currentCharge) VALUES (005, 'Peterbilt', '789-671-0549', 7415845795687135, 'peter@gmail.com', '1294 Johnson, Jonesboro, AR 72467', 'POBox 278 Jonesboro, AR 72467', '1294 Johnson, Jonesboro, AR 72467', 3000.00, 500.24);

INSERT INTO Class (classNo, description, margin1, margin2, margin3) VALUES (001, 'Gears', 1.2, 1.6, 2.0);
INSERT INTO Class (classNo, description, margin1, margin2, margin3) VALUES (002, 'Flywheel', 1.4, 1.8, 2.2);
INSERT INTO Class (classNo, description, margin1, margin2, margin3) VALUES (003, 'Tire', 1.1, 1.2, 1.5);

INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('45125A', 4, 320.00, 'Alpha', 80, 001);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('184125A', 10, 800.00, 'Bravo', 80.00, 001);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('175999B', 2, 80.00, 'Charlie', 40.00, 002);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('789000B', 28, 126, 'Delta', 4.50, 001);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('123456A', 70, 700, 'Echo', 100.00, 001);
INSERT INTO Inventory (partID, quantity, price, brand, cost, classNo) VALUES ('45125C', 5, 2000.00, 'Foxtrot', 400.00, 003);

INSERT INTO Invoices (invNo, cusNo, empNo, subTotal, taxTotal, total, invDate) VALUES (3001, 001, 1000, 480.00, 84.00, 564.00, '2020-10-01');
INSERT INTO Invoices (invNo, cusNo, empNo, subTotal, taxTotal, total, invDate) VALUES (3002, 002, 1001, 245, 42.88, 287.88, '2020-10-05');
INSERT INTO Invoices (invNo, cusNo, empNo, subTotal, taxTotal, total, invDate) VALUES (3003, 001, 1003, 400, 70, 470, '2020-10-10');
INSERT INTO Invoices (invNo, cusNo, empNo, subTotal, taxTotal, total, invDate) VALUES (3004, 005, 1003, 0, 0, 0, '2020-10-10');

INSERT INTO Parts (ID, partID, quantity, cost) VALUES (3001, '45125A', 2, 80);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (3001, '184125A', 3, 80.00);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (3001, '175999B', 1, 80.00);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (3002, '789000B', 10, 4.5);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (3002, '123456A', 2, 100);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (3003, '45125C', 1, 400);

INSERT INTO WorkOrders (workNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (2001, 001, 1000, 160.00, 28.00, 188.00, '2020-10-01');
INSERT INTO WorkOrders (workNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (2002, 002, 1001, 245, 42.88, 287.88, '2020-10-05');
INSERT INTO WorkOrders (workNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (2003, 003, 1003, 400, 70, 470, '2020-10-10');

INSERT INTO Parts (ID, partID, quantity, cost) VALUES (2001, '45125A', 2, 80);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (2001, '184125A', 3, 80.00);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (2001, '175999B', 1, 80.00);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (2002, '789000B', 10, 4.5);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (2002, '123456A', 2, 100);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (2003, '45125C', 1, 400);

INSERT INTO Quotes (quoteNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (1001, 001, 1000, 160.00, 28.00, 188.00, '2020-10-01');
INSERT INTO Quotes (quoteNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (1002, 002, 1001, 245, 42.88, 287.88, '2020-10-05');
INSERT INTO Quotes (quoteNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (1003, 003, 1003, 400, 70, 470, '2020-10-10');

INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1001, '45125A', 2, 80);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1001, '184125A', 3, 80.00);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1001, '175999B', 1, 80.00);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1002, '789000B', 10, 4.5);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1002, '123456A', 2, 100);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1003, '45125C', 1, 400);

INSERT INTO AccountReceivable (accountNo, amount, dateDue) VALUES (001, 12000.23, '2020-10-05');
INSERT INTO AccountReceivable (accountNo, amount, dateDue) VALUES (002, 10000.00, '2020-10-05');
INSERT INTO AccountReceivable (accountNo, amount, dateDue) VALUES (003, 5000.00, '2020-10-05');

INSERT INTO Bills (accountNo, amount, payDate) VALUES (001, 1200.23, '2020-10-05'); 
INSERT INTO Bills (accountNo, amount, payDate) VALUES (001, 1200.23, '2020-10-05'); 

-- Test for TRIGGER 
INSERT INTO Quotes (quoteNo, cusNo, empNo, subTotal, taxTotal, total, date) VALUES (1999, 003, 1003, 400, 70, 470, '2020-10-10'); 
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1999, '45125A', 2, 80);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1999, '184125A', 3, 80.00);
INSERT INTO Parts (ID, partID, quantity, cost) VALUES (1999, '175999B', 1, 80.00);

INSERT INTO WorkOrders (SELECT quoteNo+1000, cusNo, empNo, subTotal, taxTotal, total, date FROM Quotes WHERE quoteNo = 1999); -- Convert Quote to WorkOrder
INSERT INTO Invoices (SELECT workNo+1000, cusNo, empNo, subTotal, taxTotal, total, date FROM WorkOrders WHERE workNo = 2999);

-- Update data
UPDATE Employees SET role = 'admin' WHERE empNo = 1005; -- Change Role
UPDATE Customers SET cusNo = 006 WHERE cusNo = 005; -- Test for foreign key: change cusNo in customers, then cusNos in invoice, workorder, and quote are changed
UPDATE Employees SET empNo = 1006 WHERE empNo = 1005; -- Test for foreign key: change empNo in employees, then empNos in other tables are changed
UPDATE Class SET classNo = 004 WHERE classNo = 003; -- Test for foreign key