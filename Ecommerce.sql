--kanak Agrawal Coding Challenge 2 

--creating a table Customers

Create Database Ecommerce;
use Ecommerce;

create Table customer
(
customerID int primary key,
firstName varchar(50),
lastName varchar(50),
email varchar(60),
address varchar(60)
);

insert into customer(customerID,firstName,lastName,email,address)
values 
(1,'john','doe','janedoe@ex.com','123 Main city'),
(2,'Robert','Smith','robert@ex.gmail','456 elm town'),
(3,'jane','johson','jane@ex.com','789 Oak village'),
(4,'sarah','Smith','sarah@ex.gmail','101 pine suburb'),
(5,'david','Smith','david@ex.gmail','234 cedar district'),
(6,'laura','HAll','lauradoe@ex.com','567 birch country'),
(7,'Micheal','Davis','micheal@ex.com','890 Maple state'),
(8,'Emma','Wilson','emma@ex.com','321 redwood country'),
(9,'William','Taylor','william@ex.com','432 spruce '),
(10,'Olivia','Adams','olivia@ex.com','765 fir territory');


--create table product 

create table products
(
product_id int primary key,
name varchar(60),
price float,
description varchar(100),
stockQuantity int
);

insert into products(product_id,name,price,description,stockQuantity)
values
(1,'laptop',800.00,'high-performance laptop',10),
(2,'smartphones',600.00,'latest smartphones',15),
(3,'tablet',300.00,'portable tablet',20),
(4,'headphones',150.00,'noise canceling',30),
(5,'tv',900.00,'4k smart tv',5),
(6,'coffee maker',50.00,'automatic coffee maker',25),
(7,'refrigerator',700.00,'energy-efficient',10),
(8,'Microwave Oven',80.00,'Countertop microwave',15),
(9,'blender',70.00,'High-speed blender',20),
(10,'vaccum-cleaner',120.00,'bagless vaccum cleaner',10);


-- create table cart

create table cart(
cart_id int primary key,
customer_id int foreign key 
references customer(customerID),
product_id int foreign key 
references products(product_id),
quantity int);

insert into cart(cart_id,customer_id,product_id,quantity)
values 
(1,1,1,2),
(2,1,3,1),
(3,2,2,3),
(4,3,4,4),
(5,3,5,2),
(6,4,6,1),
(7,5,1,1),
(8,6,10,2),
(9,6,9,3),
(10,7,7,2);


--create table order table 

create table orders
(
order_id int primary key,
customer_id int foreign key 
references customer(customerID),
order_date date,
total_price float,
shipping_address varchar(100)
);

insert into orders(order_id,customer_id,order_date,total_price)
values
(1,1,'2023-01-05',1200.00),
(2,2,'2023-02-10',900.00),
(3,3,'2023-03-15',300.00),
(4,4,'2023-04-20',150.00),
(5,5,'2023-05-25',1800.00),
(6,6,'2023-06-30',400.00),
(7,7,'2023-07-05',700.00),
(8,8,'2023-08-10',160.00),
(9,9,'2023-09-15',140.00),
(10,10,'2023-10-20',1400.00);

select * from orders
--create a table order item

create table order_items(
order_item_id int primary key,
order_id int foreign key 
references orders(order_id),
product_id int foreign key 
references products(product_id),
quantity int,
itemAmount float);


insert into order_items(order_item_id,order_id,product_id,quantity,itemAmount)
values
(1,1,1,2,1600.00),
(2,1,3,1,300.00),
(3,2,2,3,1800.00),
(4,3,5,2,1800.00),
(5,4,4,4,600.00),
(6,4,6,1,50.00),
(7,5,1,1,800.00),
(8,5,2,2,1200.00),
(9,6,10,2,240.00),
(10,6,9,3,210.00);



--questions 
--1
update products
set price=800
where name='refrigerator';

--2
DELETE FROM cart
WHERE cart_id IN (SELECT cart_id FROM cart WHERE customer_id=5 );
DELETE FROM cart
WHERE customer_id = 5;
commit;

--3
select * from products 
where price <100;

--4
select * from products 
where stockQuantity>5;

--5
select * from orders
where total_price between 500 and 1000;

--6
select * from products
where name like '%r';

--7



--8
SELECT DISTINCT
    C.*
FROM
    customer C
JOIN
    Orders O ON C.customerID = O.customer_id
WHERE
    YEAR(O.order_date) = 2023;


--9

SELECT
    product_id,
    MIN(StockQuantity) AS MinStockQuantity
FROM
    Products
GROUP BY
    product_id;


--10
SELECT
    C.customerID,
    C.firstname,
    SUM(OD.quantity * OD.itemAmount) AS TotalAmountSpent
FROM
    customer C
	
JOIN
    orders O ON C.customerID = O.customer_id
JOIN
    order_items OD ON O.order_id = OD.order_id
GROUP BY
    C.customerID, C.firstName ;

--11
SELECT
    C.customerID,
    C.firstName,
    AVG(OD.quantity * OD.itemAmount) AS AverageOrderAmount
FROM
    customer C
JOIN
    orders O ON C.customerID = O.customer_id
JOIN
    order_items OD ON O.order_id = OD.order_id
GROUP BY
    C.customerID, C.firstName;


--12
SELECT
    C.customerID,
    C.firstName,
    COUNT(O.order_id) AS NumberOfOrders
FROM
    customer C
LEFT JOIN
    Orders O ON C.customerID = O.customer_id
GROUP BY
    C.customerID, C.firstName;


--13
SELECT
    C.customerID,
    C.firstName,
    MAX(OD.quantity * OD.itemAmount) AS MaxOrderAmount
FROM
    customer C
LEFT JOIN
    orders O ON C.CustomerID = O.customer_id
LEFT JOIN
    order_items OD ON O.order_id = OD.order_id
GROUP BY
    C.customerID, C.firstName;

--14
SELECT
    C.customerID,
    C.firstName
FROM
    customer C
JOIN
    Orders O ON C.CustomerID = O.customer_id
GROUP BY
    C.CustomerID, C.firstName
HAVING
    SUM(O.total_price) > 1000;


--15
SELECT
    product_id,
    name
FROM
    products
WHERE
    product_id NOT IN (SELECT DISTINCT product_id FROM order_items);


--16
SELECT
    customerID,
    firstName
FROM
    customer
WHERE
    customerID NOT IN (SELECT DISTINCT customerID FROM orders);


--17
SELECT
    product_id,
    name,
    (TotalProductRevenue / TotalRevenue) * 100 AS PercentageOfTotalRevenue
FROM
    (
        SELECT
            P.product_id,
            P.name,
            SUM(OD.quantity * OD.itemAmount) AS TotalProductRevenue,
            (SELECT SUM(OD2.quantity * OD2.itemAmount) FROM order_items OD2) AS TotalRevenue
        FROM
            products P
        LEFT JOIN
            order_items OD ON P.product_id = OD.product_id
        GROUP BY
            P.product_id, P.name
    ) AS Subquery;


--18
SELECT
    product_id,
    name
FROM
    products
WHERE
    StockQuantity < (SELECT MIN(LowStockThreshold) FROM ConfigurationTable);

--19
SELECT
    customerID,
    firstName
FROM
    customer
WHERE
    customerID IN (
        SELECT
            O.customer_id
        FROM
            Orders O
        JOIN
            order_items OD ON O.order_id = OD.order_id
        GROUP BY
            O.customer_id
        HAVING
            SUM(OD.Quantity * OD.itemAmount) > 1000
    );

