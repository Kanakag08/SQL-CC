--Kanak Agrawal Coding Challenge 1
--Car Rental 

--creating table for vehicle table
create database CarRental;

use CarRental;

create table Vehicle
(
  CarID int primary key,
   Make varchar(100),
   Model varchar(100),
   VYear int,
   Dailyrate float,
   Available varchar(50),
   PassengerCapacity int,
   Enginecapacity int
   );

   ALter table vehicle 
   drop column VYear 

   alter table Vehicle
   add VYear int

  EXEC sp_rename 'Vehicle.CarID', 'CarId', 'COLUMN';

   insert into Vehicle (CarID,Make,Model,Vyear,Dailyrate,Available,PassengerCapacity,Enginecapacity)
   Values 
   (1,'toyota','Camry',2022,50.00,'Available',4,1450),
   (2,'Honda','Civic',2023,45.00,'Available',7,1500),
   (3,'Ford','Focus',2022,48.00,'UnAvailable',4,1400),
   (4,'Nissan','Altima',2023,52.00,'Available',7,1200),
   (5,'Chevrolet','malibu',2022,47.00,'Available',4,1800),
   (6,'hyundai','Sonata',2023,49.00,'UnAvailable',7,1400),
   (7,'BMW','3 Series',2023,60.00,'Available',7,2499),
   (8,'Mercedes','C-Class',2022,58.00,'Available',8,2599),
   (9,'Audi','A4',2022,55.00,'UnAvailable',4,2500);

    insert into Vehicle (CarID,Make,Model,Vyear,Dailyrate,Available,PassengerCapacity,Enginecapacity)
   Values 
   (10,'Lexus','E5',2023,54.00,'Available',4,2500);


   select * from Vehicle


--creating table for customer

use CarRental;

create table Customer
(
CusromerID int primary key,
FirstName varchar(50),
LastName varchar(50),
Email Varchar(60),
PhoneNo int);

alter table Customer
drop column CusromerID

insert into Customer(CusromerID,FirstName,LastName,Email,PhoneNo)
values
(1,'John','Doe','johndoe@ex.com',555-555-5555),
(2,'Jane','Smith','janesmith@ex.com',555-123-4567),
(3,'Robert','Johnson','robertt@ex.com',555-798-1234),
(4,'Sarah','Brown','sarah@ex.com',555-002-5255),
(5,'David','Lee','david@ex.com',555-981-0125),
(6,'laura','HAll','lauradoe@ex.com',555-123-4565),
(7,'Micheal','Davis','micheal@ex.com',555-009-5123),
(8,'Emma','Wilson','emma@ex.com',555-852-1125),
(9,'William','Taylor','william@ex.com',555-147-9635),
(10,'Olivia','Adams','olivia@ex.com',555-753-0025);


--creating table for lease 

create table Lease
(
LeaseID int primary key,
VehicleId int foreign key 
references Vehicle(CarID),
CusromerID int Foreign key 
references Customer (CusromerID),
StartDate date,
EndDate date,
LeaseType Varchar(100));

EXEC sp_rename 'Lease.VehicleId', 'CarId', 'COLUMN';


insert into Lease(LeaseID,VehicleId,CusromerID,StartDate,EndDate,LeaseType)
values
(1,1,1,'2023-01-01','2023-01-05','daily');

insert into Lease(LeaseID,VehicleId,CusromerID,StartDate,EndDate,LeaseType)
values
(2,2,2,'2023-02-15','2023-02-28','Monthly'),
(3,3,3,'2023-03-10','2023-03-15','Daily'),
(4,4,4,'2023-04-20','2023-04-30','Monthly'),
(5,5,5,'2023-05-05','2023-05-10','Daily'),
(6,6,6,'2023-06-15','2023-06-30','Monthly'),
(7,7,7,'2023-07-01','2023-07-10','Daily'),
(8,8,8,'2023-08-12','2023-08-15','Monthly'),
(9,9,9,'2023-09-07','2023-09-10','Daily'),
(10,10,10,'2023-10-10','2023-10-31','Monthly');

select * from Lease

alter table Lease 
add IsActive int


--creating table for payment

create table payment
(
PaymentID int primary key,
LeaseId int foreign key 
references Lease(LeaseID),
PaymentDate date,
Amount float
);

insert into payment(PaymentID,LeaseId,PaymentDate,Amount)
values
(1,1,'2023-01-03',200.00),
(2,2,'2023-02-20',1000.00),
(3,3,'2023-03-12',75.00),
(4,4,'2023-04-25',900.00),
(5,5,'2023-05-07',60.00),
(6,6,'2023-06-18',1200.00),
(7,7,'2023-07-03',40.00),
(8,8,'2023-08-14',1100.00),
(9,9,'2023-09-09',80.00),
(10,10,'2023-10-2',1500.00);

select * from payment

--questionss
--1
update Vehicle 
set DailyRate =68
where Make='Mercedes';

select * from Vehicle

--2

DELETE FROM Payment
WHERE LeaseID IN (SELECT LeaseID FROM Lease WHERE CusromerID =7 );
DELETE FROM Lease
WHERE CusromerID = 7;
DELETE FROM Customer
WHERE CusromerID =7;

--3
EXEC sp_rename 'Payment.PaymentDate', 'TransactionDate', 'COLUMN';

--4
SELECT *
FROM Customer
WHERE Email = 'Olivia@ex.com';

--5
SELECT L.[LeaseID], V.make, V.model, V.VYear
FROM Lease AS L
INNER JOIN Vehicle AS V ON L.CarId = V.CarId
WHERE L.CusromerID = '7'
  AND L.StartDate <= '2023-09-12' 
  AND L.EndDate >= '2023-12-31';



--6
 SELECT P.[PaymentID], L.StartDate, L.EndDate, V.Make, V.Model
FROM Payment AS P
JOIN Lease AS L ON P.LeaseID = L.LeaseID
JOIN Customer AS C ON L.CusromerID = C.CusromerID
JOIN Vehicle AS V ON L.CarId = V.CarId
WHERE C.PhoneNo = '5554567890';

	
--7
	SELECT AVG(Dailyrate) AS AverageDailyRate
FROM Vehicle;

--8
select max(Dailyrate) as highestDailyRate
from vehicle;

--9
SELECT V.*
FROM [dbo].[Vehicle] AS V
JOIN [dbo].Lease AS L ON V.CarId = L.CarId
WHERE L.CusromerID = 5;

--10
SELECT TOP 1
    *
FROM
    Lease
ORDER BY
    StartDate DESC;

--11
select * 
from Payment
where year(PaymentDate) =2023;

--12
select * 
from Payment 
where Amount= null;

--13
select sum(Amount) as TotalPayment 
from Payment;

--14
SELECT
    C.*,
    COALESCE(SUM(P.Amount), 0) AS TotalPayments
FROM
    Vehicle  C
LEFT JOIN
    Lease L ON C.CarId = L.CarId
LEFT JOIN
    Payment P ON L.LeaseID = P.LeaseID
GROUP BY
    C.CarId, C.Make, C.Dailyrate, 
    L.LeaseID;

--15
SELECT
    L.LeaseID,
    C.*
FROM
    Lease L
JOIN
    Vehicle C ON L.CarId = C.CarId;


--16
SELECT
    L.LeaseID,
    C.CusromerID,
    C.FirstName,
    C.PhoneNo,
    Ca.CarId,
    Ca.Make,
    Ca.Dailyrate
FROM
    Lease L
JOIN
    Customer C ON L.CusromerID = C.CusromerID
JOIN
    Vehicle Ca ON L.CarId = Ca.CarId
WHERE
    L.IsActive = 1;



--17
SELECT C.CusromerID,C.FirstName,C.LastName,SUM(P.Amount) AS TotalSpentOnLease
FROM [dbo].[Customer] AS C
JOIN [dbo].[Lease] AS L ON C.CusromerID = L.CusromerID
JOIN [dbo].[Payment] AS P ON L.LeaseID = P.LeaseID
GROUP BY C.CusromerID, C.FirstName, C.LastName
ORDER BY TotalSpentOnLease DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;


--18
SELECT V.CarId, V.Make,V.Model,V.VYear, L.LeaseID,L.StartDate, L.EndDate, C.FirstName, C.LastName
FROM [dbo].[Vehicle] AS V
LEFT JOIN [dbo].[Lease] AS L ON V.CarId = L.CarId
LEFT JOIN [dbo].[Customer] AS C ON L.CusromerID = C.CusromerID
WHERE L.EndDate >= GETDATE() OR L.EndDate IS NULL;