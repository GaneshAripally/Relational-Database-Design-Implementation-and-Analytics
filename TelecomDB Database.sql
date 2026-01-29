# DATABASE CREATION
DROP DATABASE IF EXISTS TelecomDB;
CREATE DATABASE TelecomDB;
USE TelecomDB;

# CORE ENTITIES
-- Customer
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Address
CREATE TABLE Address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    postcode VARCHAR(10)
);
-- Customer_Address (M:N)
CREATE TABLE Customer_Address (
    customer_id INT,
    address_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id)
);

-- Plan
CREATE TABLE Plan (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL,
    monthly_fee DECIMAL(10,2) CHECK (monthly_fee >= 0),
    data_limit_gb INT
);

-- Service
CREATE TABLE Service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    service_type VARCHAR(30) CHECK (service_type IN ('VOICE','DATA','SMS'))
);

-- Subscription
CREATE TABLE Subscription (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (plan_id) REFERENCES Plan(plan_id)
);

-- Subscription_Service (M:N)
CREATE TABLE Subscription_Service (
    subscription_id INT,
    service_id INT,
    PRIMARY KEY (subscription_id, service_id),
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

-- Device
CREATE TABLE Device (
    device_id INT AUTO_INCREMENT PRIMARY KEY,
    device_name VARCHAR(50),
    manufacturer VARCHAR(50)
);

-- Customer_Device (M:N)
CREATE TABLE Customer_Device (
    customer_id INT,
    device_id INT,
    PRIMARY KEY (customer_id, device_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (device_id) REFERENCES Device(device_id)
);

-- Usage_Record
CREATE TABLE Usage_Record (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT,
    usage_date DATE,
    data_used_mb INT CHECK (data_used_mb >= 0),
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id)
);

-- Invoice
CREATE TABLE Invoice (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT,
    invoice_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id)
);

-- Payment
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

-- Support_Ticket
CREATE TABLE Support_Ticket (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    issue_type VARCHAR(100),
    created_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Ticket_Service (M:N)
CREATE TABLE Ticket_Service (
    ticket_id INT,
    service_id INT,
    PRIMARY KEY (ticket_id, service_id),
    FOREIGN KEY (ticket_id) REFERENCES Support_Ticket(ticket_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id)
);

# SAMPLE DATA INSERTION
-- Customer
INSERT INTO Customer VALUES
(1,'Arpan','Bhattacharjee','arpan@gmail.com','999001',NOW()),
(2,'John','Smith','john@gmail.com','999002',NOW()),
(3,'Aisha','Khan','aisha@gmail.com','999003',NOW()),
(4,'Maria','Lopez','maria@gmail.com','999004',NOW()),
(5,'Wei','Chen','wei@gmail.com','999005',NOW());

-- Address
INSERT INTO Address VALUES
(1,'MG Road','Bangalore','India','560001'),
(2,'Oxford Street','London','UK','W1D'),
(3,'Main Boulevard','Dubai','UAE','00000'),
(4,'Gran Via','Madrid','Spain','28001'),
(5,'Nanjing Road','Shanghai','China','200001');

-- . Customer_Address
INSERT INTO Customer_Address VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

-- Plan
INSERT INTO Plan VALUES
(1,'Basic',20.00,10),
(2,'Standard',35.00,30),
(3,'Premium',60.00,100);

-- Service
INSERT INTO Service VALUES
(1,'Voice Calling','VOICE'),
(2,'Mobile Data','DATA'),
(3,'SMS','SMS');

-- Subscription
INSERT INTO Subscription VALUES
(1,1,2,'2024-01-01','ACTIVE'),
(2,2,1,'2024-02-01','ACTIVE'),
(3,3,3,'2024-03-01','ACTIVE'),
(4,4,2,'2024-01-15','ACTIVE'),
(5,5,1,'2024-04-01','ACTIVE');

-- Subscription_Service
INSERT INTO Subscription_Service VALUES
(1,1),(1,2),
(2,1),
(3,1),(3,2),(3,3),
(4,1),(4,2),
(5,1);

-- Device
INSERT INTO Device VALUES
(1,'iPhone 14','Apple'),
(2,'Galaxy S23','Samsung'),
(3,'Pixel 8','Google'),
(4,'Redmi Note 12','Xiaomi'),
(5,'OnePlus 11','OnePlus');

-- Customer_Device
INSERT INTO Customer_Device VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

-- Usage_Record
INSERT INTO Usage_Record VALUES
(1,1,'2024-06-01',500),
(2,1,'2024-07-01',800),
(3,2,'2024-06-01',200),
(4,3,'2024-06-01',1200),
(5,4,'2024-06-01',600),
(6,5,'2024-06-01',300);

-- Invoice
INSERT INTO Invoice VALUES
(1,1,'2024-06-30',35.00),
(2,2,'2024-06-30',20.00),
(3,3,'2024-06-30',60.00),
(4,4,'2024-06-30',35.00),
(5,5,'2024-06-30',20.00);

-- Payment
INSERT INTO Payment VALUES
(1,1,'2024-07-01',35.00),
(2,2,'2024-07-01',20.00),
(3,3,'2024-07-01',60.00),
(4,4,'2024-07-01',35.00),
(5,5,'2024-07-01',20.00);

-- Support_Ticket
INSERT INTO Support_Ticket VALUES
(1,1,'Network Issue','2024-06-05','OPEN'),
(2,2,'Billing Query','2024-06-10','CLOSED'),
(3,3,'Data Speed Issue','2024-06-15','OPEN'),
(4,4,'SIM Replacement','2024-06-20','RESOLVED'),
(5,5,'Roaming Issue','2024-06-25','OPEN');

-- Ticket_Service
INSERT INTO Ticket_Service VALUES
(1,2),
(2,1),
(3,2),
(4,1),
(5,3);

# SQL VIEWS (TASK 2)
-- View 1 – Revenue per Plan
CREATE VIEW Plan_Revenue AS
SELECT p.plan_name, SUM(i.total_amount) AS total_revenue
FROM Invoice i
JOIN Subscription s ON i.subscription_id = s.subscription_id
JOIN Plan p ON s.plan_id = p.plan_id
GROUP BY p.plan_name;

-- View 2 – Monthly Usage Trend
CREATE VIEW Monthly_Usage AS
SELECT subscription_id,
       DATE_FORMAT(usage_date,'%Y-%m') AS month,
       SUM(data_used_mb) AS total_usage
FROM Usage_Record
GROUP BY subscription_id, month;

# ADVANCED ANALYTICAL QUERIES (TASK 3)
-- Q1. Top Revenue Customers (WINDOW FUNCTION)
SELECT customer_id, total_spent,
RANK() OVER (ORDER BY total_spent DESC) AS rank_position
FROM (
    SELECT c.customer_id, SUM(i.total_amount) AS total_spent
    FROM Customer c
    JOIN Subscription s ON c.customer_id = s.customer_id
    JOIN Invoice i ON s.subscription_id = i.subscription_id
    GROUP BY c.customer_id
) t;

-- Q2. Customers Exceeding Average Usage (SUBQUERY)
SELECT subscription_id, 
       SUM(data_used_mb) AS total_usage
FROM Usage_Record
GROUP BY subscription_id
HAVING SUM(data_used_mb) > (
    SELECT AVG(data_used_mb) 
    FROM Usage_Record
);

-- Q3. Usage Category (CASE)
SELECT subscription_id,
       SUM(data_used_mb) AS total_usage,
       CASE
         WHEN SUM(data_used_mb) > 1000 THEN 'High'
         WHEN SUM(data_used_mb) BETWEEN 500 AND 1000 THEN 'Medium'
         ELSE 'Low'
       END AS usage_category
FROM Usage_Record
GROUP BY subscription_id;

-- Q4. Multi-Table JOIN (3+ Tables)
SELECT c.first_name, p.plan_name, i.total_amount
FROM Customer c
JOIN Subscription s ON c.customer_id = s.customer_id
JOIN Plan p ON s.plan_id = p.plan_id
JOIN Invoice i ON s.subscription_id = i.subscription_id;

-- Q5. Service Popularity
SELECT srv.service_name, COUNT(*) AS usage_count
FROM Subscription_Service ss
JOIN Service srv ON ss.service_id = srv.service_id
GROUP BY srv.service_name
ORDER BY usage_count DESC;

# STORED PROCEDURE (TASK 3)
DELIMITER //
CREATE PROCEDURE GenerateInvoice(
    IN sub_id INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    INSERT INTO Invoice(subscription_id, invoice_date, total_amount)
    VALUES (sub_id, CURDATE(), amount);
END //
DELIMITER ;

-- USER-DEFINED FUNCTION
DELIMITER //
CREATE FUNCTION CustomerLifetimeValue(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(i.total_amount) INTO total
    FROM Invoice i
    JOIN Subscription s ON i.subscription_id = s.subscription_id
    WHERE s.customer_id = cust_id;
    RETURN IFNULL(total,0);
END //
DELIMITER ;

# PERFORMANCE OPTIMISATION (TASK 5)
CREATE INDEX idx_usage_subscription ON Usage_Record(subscription_id);
CREATE INDEX idx_invoice_subscription ON Invoice(subscription_id);









































