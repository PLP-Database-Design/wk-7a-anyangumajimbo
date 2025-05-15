-- answers.sql
-- Assignment: Database Design and Normalization (1NF, 2NF, 3NF)
-- Student: [Your Name]
-- Date: [Insert Date]
-- This script demonstrates normalization of a sample order data set up to Third Normal Form (3NF)
-- using SQL in MySQL Workbench.

-- Step 0: Create and select working database
CREATE DATABASE IF NOT EXISTS NormalizationAssignment;
USE NormalizationAssignment;

-- --------------------------------------------------------------------------------
-- Question 1: Achieving First Normal Form (1NF)
-- --------------------------------------------------------------------------------

-- Original data had multiple products in one column, violating 1NF.
-- This normalized version separates each product into its own row.

DROP TABLE IF EXISTS ProductDetail_1NF;
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- --------------------------------------------------------------------------------
-- Question 2: Achieving Second Normal Form (2NF)
-- --------------------------------------------------------------------------------

-- CustomerName depended only on OrderID, creating a partial dependency.
-- We split the data into Orders and OrderItems to meet 2NF.

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

DROP TABLE IF EXISTS OrderItems;
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- --------------------------------------------------------------------------------
-- Question 3: Achieving Third Normal Form (3NF)
-- --------------------------------------------------------------------------------

-- Products are now moved to a separate table to eliminate transitive dependencies.
-- OrderItems now uses ProductID as a foreign key.

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);

INSERT INTO Products (ProductID, ProductName) VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Tablet'),
(4, 'Keyboard'),
(5, 'Phone');

-- Recreate OrderItems to reference ProductID
DROP TABLE IF EXISTS OrderItems;
CREATE TABLE OrderItems (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES
(101, 1, 2),
(101, 2, 1),
(102, 3, 3),
(102, 4, 1),
(102, 2, 2),
(103, 5, 1);
