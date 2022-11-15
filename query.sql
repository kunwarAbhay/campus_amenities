create database guest_house;
use guest_house;

create table Room_Expense (
	ERID int not null,
	RID int not null,
	Reason varchar(20),
	primary key (ERID)
);

create table Food_Expense (
	EFID int not null,
	Food_item varchar(20) not null,
	Units smallint not null,
	primary key (EFID)
);

create table Guest(
	GID int not null auto_increment,
	Name varchar(20) not null,
	Sex char,
	Mobile bigint,
	Email varchar(20),
	Designation varchar(20),
	Street_Address varchar(50),
	City varchar(20),
	State varchar(20),
	Pincode int,
	primary key (GID)
);

create table Bill(
	BID int not null,
	Date date,
	Amount int not null,
	GID int not null,
	primary key (BID),
	constraint Bill_fk foreign key (GID) references Guest(GID)
);

create table Guest_House(
	GUID int not null auto_increment,
	Name varchar(20) not null,
	Location varchar(20) not null,
	primary key (GUID)
);

create table Expense(
	EID int not null,
	Date date,
	Amount int not null,
	GUID int not null,
	primary key (EID),
	constraint Expense_fk foreign key (GUID) references Guest_House(GUID)
);

create table Room(
	RID int not null auto_increment,
	Type varchar(20),
	Price int,
	Floor smallint,
	No_of_beds smallint,
	hasAC char,
	isAvailable char,
	GUID int not null,
	primary key (RID),
	constraint Room_fk foreign key (GUID) references Guest_House(GUID)
);

create table Bookings(
	RID int not null,
	GID int not null,
	DoA date not null,
	DoD date not null,
	primary key (RID, GID, DoA),
	constraint Bookings_fk1 foreign key (RID) references Room(RID),
	constraint Bookings_fk2 foreign key (GID) references Guest(GID)
);

create table Room_Service(
	BRID int not null,
	Service_Name varchar(20) not null,
	primary key (BRID)
);

create table Food_Service(
	BFID int not null,
	Food_item varchar(20) not null,
	primary key (BFID)	
);

create table Staff(
	SID int not null auto_increment,
	Name varchar(20) not null,
	Sex char,
	Mobile bigint,
	Email varchar(20),
	Address varchar(20),
	Role varchar(20),
	primary key (SID)
);

create table WorksIn(
	GUID int not null,
	SID int not null,
	Date date not null,
	primary key (GUID, SID, Date),
	constraint WorksIn_fk1 foreign key (GUID) references Guest_House(GUID),
	constraint WorksIn_fk2 foreign key (SID) references Staff(SID)
);

create database landscaping;
use landscaping;

create table Gardener(
	GID int not null auto_increment,
	Name varchar(20) not null,
	DoB date,
	Address varchar(50),
	Mobile bigint,
	DoJ date,
	primary key (GID)
);

create table Attendance_log(
	AID int not null auto_increment,
	Date date,
	GID int not null,
	primary key (AID),
	constraint Attendance_log_fk foreign key (GID) references Gardener(GID)
);

create table Campus_Area(
	CID int not null auto_increment,
	Field_Area float not null,
	Location varchar(20),
	Flora_type varchar(20),
	primary key (CID)
);

create table Roster(
	GID int not null,
	CID int not null,
	Start_Date date not null,
	End_Date date not null,
	primary key (GID, CID, Start_Date),
	constraint Roster_fk1 foreign key (GID) references Gardener(GID),
	constraint Roster_fk2 foreign key (CID) references Campus_Area(CID)
);

create table Equipment(
	EID int not null auto_increment,
	Type varchar(20),
	needsRepair varchar(20),
	CID int not null,
	primary key (EID),
	constraint Equipment_fk foreign key (CID) references Campus_Area(CID)
);

create table Request(
	RID int not null auto_increment,
	Request_by varchar(20),
	isFinished char,
	Date date,
	CID int not null,
	primary key (RID),
	constraint Request_fk foreign key (CID) references Campus_Area(CID)
);

create database market;
use market;

create table Shopkeeper(
	SKID int not null auto_increment,
	Name varchar(20) not null,
	DoB date,
	Street_Address varchar(50),
	District varchar(20),
	State varchar(20),
	Zip_Code int,
	DoA date not null,
	hasSecurityPass char(1),
	ContactNo bigint,
	primary key (SKID)
);

create table Plot(
	PID int not null auto_increment,
	Location varchar(20),
	Size float,
	Rent int,
	primary key (PID)
);

create table Shop(
	PID int not null,
	SKID int not null,
	Start_Date date not null,
	Category varchar(20),
	License_Period smallint,
	Extension_Period smallint,
	Pending_Charge int,
	Performance float,
	primary key (PID, SKID, Start_Date),
	constraint Shop_fk1 foreign key (PID) references Plot(PID),
	constraint Shop_fk2 foreign key (SKID) references Shopkeeper(SKID)
);

create table Customer(
	CID int not null auto_increment,
	Name varchar(20) not null,
	Phone bigint,
	Street_Address varchar(50),
	District varchar(20),
	State varchar(20),
	Zip_Code int,
	primary key (CID)
);

create table Feedback(
    Start_Date date not null,
    PID int not null,
    SKID int not null,
    CID int not null,
    Feedback text,
    Rating smallint,
    primary key (Start_Date, PID, SKID, CID),
    constraint Feedback_fk1 foreign key (CID) references Customer(CID),
    constraint Feedback_fk2 foreign key (PID, SKID, Start_Date) references Shop(PID, SKID, Start_Date)
);

create table Payment(
	PAID int not null auto_increment,
	Amount int not null,
	PID int not null,
	SKID int not null,
	Start_Date date not null,
	primary key (PAID),
	constraint Payment_fk1 foreign key (PID, SKID, Start_Date) references Shop(PID, SKID, Start_Date)
);

----------TRIGGERS----------
-- 1. After trigger for marking room as booked //guest
DELIMITER $$

CREATE TRIGGER after_bookings_insert
AFTER INSERT
ON Bookings FOR EACH ROW 
BEGIN
	UPDATE Room
	SET isAvailable = 'F'
	WHERE Room.RID = new.RID;

END $$

DELIMITER ;

-- 2. Scheduled Event to update the status of rooms 
CREATE EVENT update_room_availability
ON SCHEDULE EVERY 1 HOUR
STARTS CURRENT_TIMESTAMP
DO 
	UPDATE Room 
	SET isAvailable = 'T'
	WHERE Room.RID NOT IN(
		SELECT DISTINCT(Bookings.RID) FROM Bookings
		WHERE Bookings.DoD > CURDATE()
	);

-- 3. After performance trigger to calculate performance from rating //market

DELIMITER $$

CREATE TRIGGER after_feedback_insert
AFTER INSERT
ON Feedback FOR EACH ROW 
BEGIN
	DECLARE avg_rating FLOAT DEFAULT 0;

	SELECT SUM(Rating)/COUNT(*) INTO avg_rating 
	FROM Feedback
	WHERE Feedback.SKID = new.SKID
	AND Feedback.PID = new.PID
	AND Feedback.Start_Date = new.Start_Date;

	UPDATE Shop
	SET Performance = avg_rating
	WHERE Shop.SKID = new.SKID
	AND Shop.PID = new.PID
	AND Shop.Start_Date = new.Start_Date;

END $$

DELIMITER ;

-- 4. After payment trigger to update pending charge //market
DELIMITER $$

CREATE TRIGGER after_payment_insert
AFTER INSERT
ON Payment FOR EACH ROW 
BEGIN
	UPDATE Shop
	SET Pending_Charge = Pending_Charge - new.Amount
	WHERE Shop.SKID = new.SKID
	AND Shop.PID = new.PID
	AND Shop.Start_Date = new.Start_Date;

END $$

DELIMITER ;


----------MARKET------------
-- 1.Current shop details of different areas of the campus
SELECT Shopkeeper.SKID, Shopkeeper.Name,
Plot.PID, Plot.Location, Plot.Rent, 
Shop.Category, Shop.Start_Date, Shop.License_Period, Shop.Extension_Period, Shop.Pending_Charge, Shop.Performance 
FROM Shop 
INNER JOIN Shopkeeper ON Shopkeeper.SKID = Shop.SKID
INNER JOIN Plot ON Plot.PID = Shop.PID;

-- 2.Details of shop keepers and their security pass validity
SELECT * FROM Shopkeeper;  

-- 3.Reminders for expiring license agreement period
SELECT SKID, PID, Start_Date, DATEDIFF(DATE_ADD(Start_Date,INTERVAL (License_Period+Extension_Period) MONTH), CURDATE()) as Diff FROM Shop
WHERE DATEDIFF(DATE_ADD(Start_Date,INTERVAL (License_Period+Extension_Period) MONTH), CURDATE()) <= 30;
-- use php to show "Already Expired" for negative Diff values (lmao)

-- 4.Pending charges from each shop
SELECT SKID, PID, Start_Date, Pending_Charge
FROM Shop;


-- 5.Summary of performances of each shop
SELECT SKID, PID, Start_Date, Performance
FROM Shop;

-- 6.Available plots to open shop
SELECT * FROM Plot
WHERE PID NOT IN (
	SELECT PID FROM Shop
	WHERE DATE_ADD(Start_Date,INTERVAL (License_Period+Extension_Period) MONTH) > CURDATE()
);


----------GUEST_HOUSE------------
-- 1.Monthly bookings for the guest house in different categories
SELECT Guest.GID, Guest.Name, Room.RID, Room.Type, EXTRACT(YEAR_MONTH FROM Bookings.DoA) as Booking_Month, Bookings.DoD
FROM Guest 
INNER JOIN Bookings ON Bookings.GID = Guest.GID
INNER JOIN Room ON Room.RID = Bookings.RID
GROUP BY Booking_month;

-- 2.The total monthly expenditure for the guest house

DELIMITER $$

CREATE PROCEDURE monthly_expenditure(IN iYear_Month INT)
BEGIN
	SELECT GUID, CONCAT(EXTRACT(YEAR FROM Date),"-",EXTRACT(MONTH FROM Date)) as YM, SUM(Amount) AS Total_Expenditure
	FROM Expense
	WHERE CONCAT(EXTRACT(YEAR_MONTH FROM Date),"") = CONCAT(iYear_Month,"")
	GROUP BY GUID;

END $$

DELIMITER ;

-- 3.Generation of bills
DELIMITER $$

CREATE PROCEDURE generate_bill(IN iGID INT)
BEGIN
	SELECT BID, GID, Date, Amount
	FROM Bill
	WHERE GID = iGID;

END $$

DELIMITER ;

-- 4.Availability of room
SELECT * FROM Room
WHERE isAvailable = 'T';

-- 5.Monthly food billing
SELECT Bill.BID, Bill.GID, EXTRACT(YEAR_MONTH FROM Bill.Date) AS Food_Billing_Month, Bill.Amount, Food_Service.Food_Item FROM Bill
INNER JOIN Food_Service ON Bill.BID = Food_Service.BFID
GROUP BY Food_Billing_Month;

-- 6.Staff Schedule 
SELECT Staff.SID, Staff.Name, Guest_House.GUID, Guest_House.Name, WorksIn.Date
FROM Guest_House
INNER JOIN WorksIn ON Guest_House.GUID = WorksIn.GUID
INNER JOIN Staff ON Staff.SID = WorksIn.SID
ORDER BY WorksIn.Date DESC;


----------Landscaping------------
-- 1.Find the details of active gardeners of a particular area
SELECT Gardener.GID, Gardener.Name, Gardener.DoB, Gardener.DoJ, Gardener.Address, Gardener.Mobile 
FROM Gardener
INNER JOIN Roster on Gardener.GID = Roster.GID
WHERE Roster.End_Date >= CURDATE() AND Roster.Start_Date <= CURDATE();

-- 2. Gardeners attendance details
DELIMITER $$

CREATE PROCEDURE attendance_log(IN iGID INT)
BEGIN
	SELECT GID, AID, Date
	FROM Attendance_log
	WHERE GID = iGID;

END $$

DELIMITER ;

-- 3. Monthly Duty Roster
SELECT Gardener.GID, Gardener.Name, Campus_Area.CID, Campus_Area.Location, EXTRACT(YEAR_MONTH FROM Roster.Start_Date) as Roster_Month, Roster.Start_Date, Roster.End_Date
FROM Gardener
INNER JOIN Roster ON Gardener.GID = Roster.GID
INNER JOIN Campus_Area ON Campus_Area.CID = Roster.CID
GROUP BY Roster_Month;

-- 4. Tracking grass cutting requests
SELECT * FROM Request;

-- 5. Tracking equipment repairing status
SELECT EID, Type, needsRepair FROM Equipment;

-- 6. Campus Area with most landscaping requests
SELECT Campus_Area.CID, Campus_Area.Field_Area, Campus_Area.Location, Campus_Area.Flora_Type,
(SELECT MAX(tempTable.tempcount) FROM (SELECT COUNT(*) AS tempcount FROM Request GROUP BY CID) tempTable) AS Req_Amt
FROM Campus_Area 
WHERE Campus_Area.CID IN(
SELECT Request.CID FROM Request 
GROUP BY Request.CID 
HAVING COUNT(*) = (SELECT MAX(sumTable.tempcount) FROM 
(SELECT COUNT(*) AS tempcount FROM Request
GROUP BY CID) sumTable))


-- Data Insertion Market

insert into Shopkeeper (Name, DoB, Street_Address, District, State, Zip_Code, DoA, hasSecurityPass, ContactNo) values
('Almire Wilder', '1986-02-07', '30 Waxwing Parkway', 'District35', 'Quebec', 126432, '2011-09-01', 'T', 8729135028),
('Ellie Bartelot', '1997-10-02', '7505 Knutson Hill', 'District24', 'New York', 674921, '2010-10-25', 'T', 8372948271),
('Sasha Dunn', '1989-04-03', '8 Larry Alley', 'District14', 'New York', 568653, '2012-10-25', 'T', 8135344563),
('Selby Cabral', '1993-08-13', '95411 Hovde Road', 'District74', 'New York', 892135, '2011-05-15', 'F', 8748938578),
('Farlay Coaten', '1997-01-17', '507 Schiller Center', 'District99', 'New York', 954126, '2012-12-21', 'T', 8892746528),
('Devondra Dilworth', '1988-11-07', '4 Waywood Crossing', 'District45', 'Indiana', 124312, '2015-01-11', 'T', 8490765284),
('Farlay Coaten', '1987-04-03', '6 Nobel Court', 'District54', 'Arizona', 245671, '2009-07-04', 'T', 8766472940),
('Ruthy Hartus', '1995-06-03', '483 Fulton Park', 'District66', 'Texas', 875432, '2014-04-05', 'T', 8223434554),
('Leicester Canape', '1982-05-25', '73984 Anniversary Drive', 'District34', 'Mississippi', 765456, '2010-02-17', 'F', 8345234122),
('Oren Leele', '1998-06-21', '753 Thackeray Crossing', 'District57', 'North Dakota', 765455, '2013-11-12', 'T', 8689008678),
('Denise Darkins', '1982-11-25', '631 New Castle Junction', 'District22', 'British Columbia', 537345, '2011-10-15', 'T', 8098766583),
('Glennie Gerrietz', '1997-08-30', '89886 Reinke Way', 'District13', 'California', 753457, '2008-05-23', 'F', 8143254377),
('Den Brahms', '1986-11-28', '1 Trailsway Center', 'District26', 'Washington', 564323, '2011-09-11', 'T', 8345567864),
('Benetta Rickard', '1982-10-19', '063 Mcbride Trail', 'District87', 'Scotland', 643523, '2012-06-22', 'F', 8987683970),
('Martha Trask', '1986-10-30', '4 Emmet Way', 'District85', 'Illinois', 234523, '2008-11-26', 'F', 8655567337);

select * from Shopkeeper;

insert into Plot (Location, Size, Rent) values 
('Admin Block', 125, 10000),
('Hostel Block', 150, 20000),
('Hostel Block', 125, 15000),
('Hostel Block', 225, 15000),
('Cycle Stand 1', 150, 25000),
('Cycle Stand 2', 225, 45000),
('Cycle Stand 3', 125, 35000),
('Canteen Block 1', 300, 15000),
('Canteen Block 2', 250, 12500),
('Residential Area 1', 150, 20000),
('Residential Area 2', 175, 10000),
('Tutorial Block 1', 75, 30000),
('Tutorial Block 2', 225, 10000),
('Guest House 1', 100, 20000),
('Guest House 2', 300, 15000);

select * from Plot;

insert into Customer (Name, Phone, Street_Address, District, State, Zip_Code) values 
('Jillian McQuie', 4414232382, '5 Eagle Crest Parkway', 'District28', 'Paget', 234212),
('Nana Beaument', 9202378585, '122 Mesta Way', 'District32', 'Fulton', 355346),
('Gail Dietz', 5051967834, '12988 Merrick Hill', 'District33', 'Hooker', 553314),
('Bea Slaney', 3676846461 ,'5 Homewood Hill', 'District45', 'Dayton', 442563),
('Latia Menendez', 5479955673, '537 Blaine Trail', 'District65', 'Hazelcrest', 543234),
('Reeva Baldack', 1047875665, '98801 Oak Point', 'District34', 'Roxbury', 442574),
('Kala Lannin', 9847301900, '1 Nobel Circle', 'District54', 'Fisk', 846642),
('Georgi Lukianovich', 4457366248, '40647 Meadow Ridge Street', 'District65', 'Acker', 574335),
('Richart Abazi', 7908682342, '597 Dovetail Crossing', 'District64', 'Knutson', 786456),
('Jamil Duce', 9915098877, '220 Heffernan Alley', 'District68', 'Shelley', 678432),
('Josefina Lagadu', 4352328197, '897 Buena Vista Parkway', 'District75', 'Rowland', 673522),
('Langston Malacrida', 8088937043, '2 Moose Way', 'District74', 'Steensland', 665284),
('Robers Cockrill', 7335687390, '4083 Colorado Point', 'District89', 'Goodland', 559856),
('Paul Kulicke', 2063180402, '505 Golden Leaf Crossing', 'District70', 'Menomonie', 678967),
('Vail Dadley', 3047150155, '57 Badeau Parkway', 'District90', 'Fulton', 439076);

select * from Customer;

insert into Shop values
(5, 2, '2020-04-10', 'Vegetable',22, 23, 2300, 3.7),
(7, 3, '2021-10-07', 'Fruits', 23, 15, 3400, 4.8),
(2, 1, '2019-01-01', 'Eggs', 21, 36, 13300, 2.1),
(3, 5, '2018-06-12', 'Cycle', 25, 33, 5400, 1.7),
(1, 6, '2020-12-21','Vegetable', 24, 25, 1100, 4.7),
(9, 6, '2017-10-22', 'Juice', 21, 43, 4400, 3.6),
(11, 10, '2019-11-13', 'Fast Food', 24, 17, 3400, 2.9),
(15, 11, '2021-01-15', 'Grocery', 21, 16, 9800, 3.9),
(13, 13, '2021-02-11', 'Grocery', 14, 11, 6400, 4.9),
(12, 13, '2020-03-21', 'Fast Food', 12, 25, 12300, 4.3),
(8, 7, '2018-07-10', 'Cafe', 11, 23, 3300, 1.2),
(6, 8, '2017-05-06', 'Cycle', 15, 10, 5600, 2.2),
(14, 2, '2020-12-06', 'Stationary', 6, 6, 2100, 3.3);

select * from Shop;

insert into Feedback (Start_Date, PID, SKID, CID, Feedback, Rating) values
('2020-12-21', 1, 6, 1, 'Good', 5),
('2020-12-21', 1, 6, 2, 'Good', 4);

select * from Feedback;

insert into Payment values
(1, 12, 1, 6, '2020-12-21'),
(2, 12, 1, 6, '2020-12-21');

select * from Payment;

-- Data Insertion Landscaping

insert into Gardener (Name, DoB, Address, Mobile, DoJ) values
('Kip Leif', '1998-09-01', '88444 Grayhawk Way', 4732974478, '2009-12-18'),
('Leda Rainard', '1986-01-26', '901 Oxford Trail', 7126406144, '2019-04-27'),
('Salaidh Gorvette', '1999-09-27', '6673 Oakridge Trail', 2448043215, '2014-12-02'),
('Camey Mico', '1983-04-08', '4 Anzinger Place', 8642170297, '2013-06-20'),
('Bev Fairebrother', '1990-03-20', '57 Evergreen Street', 8809804380, '2019-07-08'),
('Loreen Paterson', '1982-07-21', '15 Hayes Point', 5049770938, '2018-06-16'),
('Wendeline Ofer', '1985-07-13', '3063 Rieder Plaza', 9047099392, '2013-03-17'),
('Zaria Popplestone', '1991-08-02', '63901 Division Junction', 5742616069, '2011-12-21'),
('Kyla Buckwell', '1984-12-05', '2758 Pond Terrace', 8717553147, '2009-04-20'),
('Neron Barter', '1982-03-28', '20 Moland Junction', 4359862059, '2011-03-06'),
('Jeniffer Pouton', '1994-06-16', '55 Mendota Hill', 9467422667, '2008-06-23'),
('Lindon Kilgannon', '1983-04-22', '07 Parkside Point', 4011519350, '2016-04-06'),
('Welby Corneljes', '1990-12-12', '538 Colorado Way', 8859157445, '2013-11-17'),
('Madalena Govini', '1988-01-15', '8 Prairieview Drive', 6963811725, '2018-03-07'),
('Monah Gorgen', '1980-04-07', '64 Shasta Center', 8903626707, '2010-10-31');

select * from Gardener;

insert into Attendance_log (Date, GID) values
('2021-10-23', 4),
('2021-11-16', 13),
('2021-10-26', 10),
('2021-10-31', 2),
('2021-11-06', 12),
('2021-11-25', 14),
('2021-11-17', 10),
('2021-10-21', 4),
('2021-11-02', 14),
('2021-11-04', 14),
('2021-10-06', 12),
('2021-10-29', 13),
('2021-10-17', 9),
('2021-10-17', 9),
('2021-11-02', 9),
('2021-11-16', 10),
('2021-10-05', 1),
('2021-11-26', 9),
('2021-10-20', 14),
('2021-11-05', 5),
('2021-10-10', 10),
('2021-10-04', 13),
('2021-11-03', 13),
('2021-10-18', 12),
('2021-10-30', 14),
('2021-10-30', 1),
('2021-11-26', 10),
('2021-11-12', 5),
('2021-10-29', 14),
('2021-11-21', 15);

select * from Attendance_log;

insert into Campus_Area (Field_Area, Location, Flora_type) values
(1.1, 'Admin Block', 'Agricultural'),
(2.4, 'Hostel Block', 'Native'),
(1.3, 'Cycle Stand', 'Weed'),
(0.7, 'Canteen Block', 'Weed'),
(2.6, 'Residential Area 1', 'Weed'),
(3, 'Residential Area 2', 'Agricultural'),
(5, 'Tutorial Block 1', 'Native'),
(0.2, 'Tutorial Block 2', 'Native'),
(1.9, 'Guest House 1', 'Agricultural'),
(3, 'Guest House 2', 'Weed');

select * from Campus_Area;

insert into Roster values
(15, 1, '2021-10-16', '2021-10-26'),
(9, 6, '2021-10-12', '2021-10-08'),
(4, 10, '2021-10-11', '2021-10-15'),
(5, 2, '2021-11-01', '2021-11-07'),
(9, 10, '2021-10-29', '2021-11-02'),
(1, 7, '2021-10-17', '2021-10-26'),
(15, 6, '2021-11-25', '2021-11-28'),
(11, 5, '2021-10-09', '2021-10-14'),
(2, 7, '2021-10-10', '2021-10-15'),
(10, 9, '2021-10-02', '2021-10-05'),
(11, 5, '2021-11-10', '2021-11-16'),
(6, 7, '2021-10-20', '2021-10-25'),
(7, 9, '2021-10-03', '2021-10-10'),
(4, 10, '2021-11-10', '2021-11-14'),
(5, 4, '2021-11-19', '2021-11-23');

select * from Roster;

insert into Equipment (Type, needsRepair, CID) values
('Blades', 'T', 1),
('Rakes', 'T', 10),
('Shear', 'T', 3),
('Mulcher', 'F', 9),
('Broom', 'F', 3),
('Blades', 'T', 1),
('Saw', 'T', 8),
('Planer', 'F', 3),
('Hammer', 'T', 8),
('Saw', 'T', 2),
('Rakes', 'F', 4),
('Broom', 'F', 7),
('Planer', 'T', 7),
('Shear', 'T', 2),
('Saw', 'T', 6),
('Hammer', 'T', 3),
('Planer', 'F', 10),
('Shear', 'F', 4),
('Mulcher', 'F', 5),
('Blades', 'T', 4);

select * from Equipment;

insert into Request (Request_by, isFinished, Date, CID) values
('Ninetta Sutterfield', 'T', '2021-10-07', 10),
('Arturo Seeman', 'T', '2021-10-04', 3),
('Chilton Moberley', 'F', '2021-10-22', 8),
('Mirna Trengove', 'F', '2021-10-29', 10),
('Julius Showalter', 'F', '2021-10-14', 1),
('Nelson Ezzell', 'T', '2021-11-04', 7),
('Andrey Jerratsch', 'F', '2021-11-14', 6),
('Wiley Hillitt', 'T', '2021-10-24', 1),
('Karl Teulier', 'T', '2021-10-03', 10),
('Briano Tutchener', 'T', '2021-10-06', 7);

select * from Request;

-- Data Insertion Guest House

insert into Guest (Name, Sex, Mobile, Email, Designation, Street_Address, City, State, Pincode) values
('Hanan Usmar', 'M', 5085934450, 'smar0@google.pl', 'Manager', '3 Ridge Oak Center', 'Newton', 'Massachusetts', 02162),
('Celka Moyce', 'M', 3232597458, 'yce1@alibaba.com', 'Administration', '19748 Dayton Lane', 'Long Beach', 'California', 90805),
('Averyl Paulus', 'M', 5018201847, 'aulus2@answers.com', 'Student', '72 Barnett Drive', 'Little Rock', 'Arkansas', 72222),
('Caty Spinney', 'F', 2066888881, 'csney3@goodreads.com', 'Manager', '98 Pine View Crossing', 'Seattle', 'Washington', 98195),
('Liv Engledow', 'M', 3341600626, 'lene4@delicious.com', 'Security', '6 Eagle Crest Terrace', 'Montgomery', 'Alabama', 36114),
('Amble Seale', 'M', 9188077117, 'asele5@people.com.cn', 'Professor', '6 Iowa Hill', 'Tulsa', 'Oklahoma', 74126),
('Edyth Fussey', 'M', 9165636956, 'efy6@blogs.com', 'Accounting', '680 Rockefeller Place', 'Sacramento', 'California', 95818),
('Mic Le Friec', 'F', 2052120871, 'mle7@marketwatch.com', 'Security', '27913 Bashford Crossing', 'Birmingham', 'Alabama', 35285),
('Kipp Bonifas', 'M', 7189146827, 'kas8@paypal.com', 'Manager', '08 Di Loreto Park', 'Bronx', 'New York', 10459),
('Ianthe Traylen', 'F', 2028063152, 'itran9@reference.com', 'Student', '6533 Del Mar Trail', 'Washington', 'District of Columbia', 20268),
('Emanuele Vakhlov', 'F', 3201481166, 'evva@lycos.com', 'Security', '667 Pankratz Crossing', 'Saint Cloud', 'Minnesota', 56372),
('Celestyna Hasker', 'F', 2063718090, 'chrb@baidu.com', 'Student', '56982 Buhler Plaza', 'Tacoma', 'Washington', 98424),
('Zacharie Scullin', 'M', 3034054237, 'zsnc@auda.org.au', 'Administration', '43 Logan Junction', 'Denver', 'Colorado', 80262),
('Ianthe Sondland', 'M', 8648581429, 'iso@late.com', 'Manager', '6614 Pine View Place', 'Spartanburg', 'South Carolina', 29319),
('Clio Andrichuk', 'M', 9152802041, 'canke@fastany.com', 'Accounting', '6 Towne Place', 'El Paso', 'Texas', 79911),
('Alleen Rodder', 'M', 4148111300, 'arrf@furl.net', 'Manager', '455 Glacier Hill Park', 'Milwaukee', 'Wisconsin', 53263),
('Lilla Borit', 'F', 8607656814, 'lbtg@abods.info', 'Professor', '7566 Express Avenue', 'Hartford', 'Connecticut', 06140),
('Orson Shoebotham', 'M', 8132074827, 'oshmh@irs.gov', 'Professor', '5636 Cottonwood Parkway', 'Tampa', 'Florida', 43620),
('Maryanna Kitney', 'M', 9417401198, 'mkyi@naer.com', 'Security', '29 Nelson Circle', 'Port Charlotte', 'Florida', 33954),
('Kristopher Dugmore', 'F', 5179259384, 'kdorej@cnbc.com', 'Security', '4905 Carioca Terrace', 'Kalamazoo', 'Michigan', 49048);

select * from Guest;

insert into Bill values
(124, '2021-05-12', 400, 2),
(125, '2021-09-16', 550, 4),
(130, '2021-11-15', 600, 4),
(131, '2021-06-10', 750, 2),
(132, '2021-12-19', 800, 10),
(135, '2020-12-06', 900, 15),
(140, '2021-09-09', 850, 4),
(142, '2021-12-28', 650, 7),
(144, '2021-12-12', 450, 10),
(150, '2021-04-11', 500, 2),
(208, '2021-10-29', 400, 10),
(229, '2021-06-22', 550, 13),
(239, '2021-07-08', 600, 1),
(243, '2021-05-05', 750, 2),
(244, '2020-10-16', 800, 15),
(245, '2021-10-15', 900, 7),
(246, '2020-04-13', 850, 9),
(247, '2020-04-02', 650, 9),
(248, '2021-12-14', 450, 6),
(254, '2020-11-22', 500, 15);

select * from Bill;

insert into Food_Service values
(208, 'Tandoori Chicken'),
(229, 'Butter Chicken'),
(239, 'Paneer Butter Masala'),
(243, 'Fish Curry'),
(244, 'Cornflakes'),
(245, 'Gol Gappa'),
(246, 'Maggie'),
(247, 'Buger'),
(248, 'Cheese Sanswich'),
(254, 'Tandoori Chicken');

select * from Food_Service;

insert into Room_Service values
(124, 'Massage'),
(125, 'Cleaning'),
(130, 'Spa'),
(131, 'Karaoke'),
(132, 'Massage'),
(135, 'Massage'),
(140, 'Cleaning'),
(142, 'Spa'),
(144, 'Cleaning'),
(150, 'Karaoke');

select * from Room_Service;

insert into Guest_house (Name, Location) values
('CV Raman', 'Admin Block'),
('BR Ambedkar', 'Hostel Block'),
('MK Gandhi', 'Residential Area'),
('S Naidu', 'Tutorial Block');

select * from Guest_house;

insert into Expense values
(235, '2021-02-13', 5000, 2),
(236, '2021-08-13', 2500, 4),
(237, '2021-11-13', 3900, 3),
(238, '2021-09-13', 6700, 4),
(239, '2021-12-13', 8800, 1),
(245, '2021-10-13', 7500, 4),
(246, '2021-11-13', 2300, 1),
(247, '2021-04-13', 6000, 4),
(345, '2021-01-13', 5700, 1),
(346, '2021-03-13', 1300, 2),
(347, '2021-04-13', 5000, 3),
(348, '2021-08-13', 3800, 4),
(349, '2021-12-13', 4500, 3),
(355, '2021-08-13', 1200, 2),
(356, '2021-06-13', 3200, 4),
(357, '2021-07-13', 7800, 1);

select * from Expense;

insert into Room_Expense values
(235, 9, 'Bathroom Repair'),
(236, 17, 'Room Repair'),
(237, 6, 'Bed Repair'),
(238, 13, 'New Sofa'),
(239, 14, 'New Bathtub'),
(245, 18, 'Carpet'),
(246, 2, 'Furnishing'),
(247, 5, 'New Window');

select * from Room_Expense;

insert into Food_Expense values
(345, 'Meat', 4000),
(346, 'Potato', 5000),
(347, 'Spices', 400),
(348, 'Tomatoes', 1000),
(349, 'Rice', 7000),
(355, 'Wheat', 10000),
(356, 'Paneer', 3000),
(357, 'Meat', 5000);

select * from Food_Expense;

insert into Room (Type, Price, Floor, No_of_beds, hasAC, isAvailable, GUID) values 
('B', 48660, 3, 3, 'T', 'T', 2),
('B', 42921, 5, 4, 'T', 'T', 1),
('A', 50522, 2, 3, 'F', 'T', 3),
('A', 17642, 3, 2, 'T', 'T', 4),
('C', 35292, 3, 2, 'T', 'T', 4),
('B', 14615, 2, 2, 'F', 'T', 3),
('C', 46111, 1, 1, 'F', 'T', 3),
('B', 39219, 4, 2, 'F', 'T', 1),
('A', 40005, 5, 1, 'F', 'T', 2),
('B', 23175, 4, 4, 'F', 'T', 3),
('A', 35274, 3, 2, 'F', 'T', 3),
('A', 41650, 5, 3, 'T', 'T', 2),
('B', 27716, 4, 2, 'F', 'T', 4),
('B', 52454, 4, 4, 'T', 'T', 1),
('C', 37403, 3, 1, 'T', 'T', 1),
('B', 33261, 2, 4, 'T', 'T', 3),
('C', 58137, 5, 1, 'T', 'T', 4),
('A', 50916, 4, 2, 'T', 'T', 4),
('B', 37507, 1, 3, 'F', 'T', 1),
('C', 26999, 1, 3, 'F', 'T', 1),
('A', 52774, 2, 1, 'T', 'T', 1),
('C', 31229, 1, 3, 'F', 'T', 2),
('C', 25815, 2, 3, 'F', 'T', 4),
('A', 21978, 4, 2, 'T', 'T', 4),
('A', 17625, 4, 3, 'T', 'T', 4),
('C', 13692, 2, 4, 'F', 'T', 2),
('C', 51724, 1, 3, 'T', 'T', 3),
('B', 34471, 5, 1, 'T', 'T', 3),
('C', 44911, 4, 3, 'F', 'T', 4),
('C', 27836, 3, 1, 'T', 'T', 1);

select * from Room;

insert into Bookings values
(4, 1, '2021-04-21', '2021-12-23'),
(2, 2, '2020-03-13', '2020-06-12'),
(6, 13, '2021-05-11', '2021-12-04'),
(3, 4, '2021-08-01', '2021-12-07'),
(13, 15, '2020-10-02', '2021-02-14'),
(15, 6, '2019-11-05', '2020-02-24'),
(11, 7, '2021-10-06', '2022-01-11'),
(10, 8, '2021-06-13', '2021-11-22'),
(16, 9, '2020-03-17', '2020-05-16'),
(18, 10, '2021-09-26', '2022-02-13');

select * from Bookings;

insert into Staff (Name, Sex, Mobile, Email, Address, Role) values 
('Garey Stribbling', 'M', 4993293932, 'gsng0@creaticons.org', 'Geji', 'Cook'),
('Mariquilla Dewhurst', 'F', 4648308459, 'mdurst1@gcies.jp', 'Rendeng', 'Cook'),
('Trisha Donnett', 'F', 4298870860, 'tdott2@blger.com', 'Afareaitu', 'Security'),
('Olympie Vlach', 'F', 2099136371, 'ovh3@vkonte.ru', 'Kudara-Somon', 'Cleaner'),
('Marice Esp', 'F', 2133584751, 'mp4@scrid.com', 'Vicente Guerrero', 'Cleaner'),
('Eugene Bonnaire', 'M', 6324602117, 'ebore5@slhare.net', 'Kolomanu', 'Security'),
('Norrie McClaurie', 'M', 6481570950, 'nauie6@mtv.com', 'Cabuyao', 'Cleaner'),
('Ruggiero Slogrove', 'M', 1583089925, 'rsove7@ifeng.com', 'Santa', 'Security'),
('Odetta Brailey', 'F', 3453111965, 'obley8@phucket.com', 'Santo Niño', 'Security'),
('Clare McMichan', 'F', 1908929261, 'cmhan9@braites.com', 'West Kelowna', 'Cleaner'),
('Lyn Margaret', 'F', 4439452364, 'lmaeta@prld.com', 'Kyzyl-Oktyabr’skiy', 'Cleaner'),
('Merridie Roderigo', 'F', 1417327525, 'mrodob@pracy.gov.au', 'Guohuan', 'Security'),
('Barbara-anne', 'F', 3512858275, 'bhackc@wed.com', 'Vaasa', 'Security'),
('Willis Georgievski', 'M', 6122272319, 'wgeoskid@ine.uk', 'Billa', 'Cook'),
('Pincus Lambillion', 'M', 1761659312, 'plane@jiathis.com', 'Yuen Long Kau Hui', 'Cleaner'),
('Galven Wix', 'M', 8236378684, 'gwixf@google.de', 'Jiakexi', 'Receptionist'),
('Raymond Couve', 'M', 9164262166, 'rceg@commons.org', 'Sacramento', 'Receptionist'),
('Nil Habergham', 'M', 7572466942, 'nhabh@unicef.org', 'Norfolk', 'Receptionist'),
('Verine Courtliff', 'F', 7186399317, 'vfi@intel.com', 'Kostomuksha', 'Security'),
('Elnora Tillett', 'F', 5065708138, 'etitj@mmedia.com', 'Maubara', 'Security'),
('Currie Grass', 'M', 4976578122, 'cgsk@washgton.edu', 'San Isidro', 'Cleaner'),
('Rose Cathrae', 'F', 7183920343, 'rcael@naver.com', 'Hoàn Kiếm', 'Receptionist'),
('Danika Bailiss', 'F', 9918674338, 'dbsm@1688.com', 'Qesarya', 'Security'),
('Mamie Kinloch', 'F', 7553650375, 'mkinn@webmd.com', 'Rabat', 'Cleaner'),
('Lynnett Gent', 'F', 8038872174, 'lgo@instagram.com', 'San Pedro', 'Security'),
('Bobbee Bloxam', 'F', 6074948441, 'bbloamp@phcket.com', 'Meiqi', 'Security'),
('Corissa Fobidge', 'F', 9217517428, 'cfgeq@netions.com', 'Daja', 'Cleaner'),
('Kaleena Browell', 'F', 2861781757, 'kbrowr@baidu.com', 'Kuching', 'Security'),
('Dante Gledstane', 'M', 3201630108, 'dglanes@tinypic.com', 'Malusac', 'Security'),
('Ed Gillise', 'M', 6535732811, 'egset@state.gov', 'Limanowa', 'Cleaner');

select * from Staff;

insert into WorksIn values
(3, 13, '2021-12-23'),
(1, 18, '2021-11-27'),
(3, 21, '2021-10-02'),
(2, 25, '2021-11-05'),
(3, 9, '2021-12-21'),
(1, 19, '2021-10-26'),
(1, 14, '2021-10-31'),
(2, 20, '2021-10-27'),
(1, 17, '2021-11-07'),
(2, 7, '2021-10-30'),
(1, 8, '2021-10-14'),
(4, 28, '2021-11-11'),
(1, 28, '2021-10-29'),
(2, 25, '2021-10-06'),
(2, 1, '2021-10-03'),
(4, 9, '2021-10-14'),
(3, 28, '2021-12-19'),
(3, 18, '2021-10-13'),
(3, 21, '2021-12-07'),
(4, 21, '2021-12-21'),
(1, 22, '2021-12-21'),
(3, 23, '2021-10-05'),
(1, 19, '2021-10-06'),
(1, 10, '2021-12-26'),
(2, 9, '2021-11-24'),
(4, 22, '2021-11-03'),
(4, 20, '2021-12-27'),
(4, 30, '2021-11-24'),
(2, 3, '2021-10-29'),
(4, 10, '2021-10-26');

select * from WorksIn;