CREATE DATABASE motorcycle;
DROP DATABASE motorcycle;
-- Department
CREATE TABLE DEPARTMENT
(Department_ID VARCHAR(10) NOT NULL PRIMARY KEY,
Department_name NVARCHAR(30) not null,
Location_ NVARCHAR(50) not null,
Manager_ID VARCHAR(10))

--Employee
create table EMPLOYEE(
	Employee_ID varchar(10) not null,  
	Name_ nvarchar(100) not null, 
	Phone_Number nvarchar(10) NOT NULL, 
	Gender char(1) NOT NULL,
	Date_Of_Birth date NOT NULL,  
	Address_ nvarchar(100), 
	Email nvarchar(30) NOT NULL, 
	Salary NUMERIC(11) NOT NULL, 
	Department_ID varchar(10) NOT NULL,
	Manager_ID varchar(10)
	primary key(Employee_ID) ,
	FOREIGN KEY (Manager_ID) REFERENCES EMPLOYEE(Employee_ID),
	FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID))
-- ALTER DEPARTMENT

ALTER TABLE DEPARTMENT
ADD CONSTRAINT FK_Manager_ID 
FOREIGN KEY (Manager_ID) REFERENCES EMPLOYEE(Employee_ID);
--customer
create table CUSTOMER (
	Customer_ID varchar(10) not null,  
	Name_ nvarchar(50) not null,
	Phone_Number nvarchar(10) not null, 
	Gender char(1) not null, 
	Date_Of_Birth date not null,  
	Address_ nvarchar(100) 
	primary key(Customer_ID) 
)
--SUpplier
create table SUPPLIER (
	Supplier_ID varchar(10) not null,  
	Supplier_Name nvarchar(50) NOT NULL, 
	Phone_Number nvarchar(10) NOT NULL, 
	Email nvarchar(50) NOT NULL
	primary key(Supplier_ID))
--SERVICE 
create table SERVICE (
	Service_ID varchar(10) not null  PRIMARY KEY,  
	Service_des nvarchar(50) NOT NULL, 
	MuPrice NUMERIC(11) not null,
	AuPrice NUMERIC(11) not null )

--Product
CREATE TABLE PRODUCT
(Product_ID VARCHAR(10) NOT NULL PRIMARY KEY,
Pur_Price NUMERIC(11) not null,
Product_Name NVARCHAR(50) not null,
Motor_Type NVARCHAR(30) NOT NULL,
Orgin NVARCHAR(20) not null,
Brand NVARCHAR(30) not null) 
--motorcycle
CREATE TABLE MOTORCYCLE (
    MProduct_ID VARCHAR(10) NOT NULL,
	VIN VARCHAR(10) NOT NULL,
	Engine_Number VARCHAR(10),
    Color NVARCHAR(20) NOT NULL,
    Engine_Displacement CHAR(8) NOT NULL,
	Sale_Price NUMERIC(11) not null,
    Version_ NVARCHAR(50), 
	PRIMARY KEY (MProduct_ID, VIN, Engine_Number),
    CONSTRAINT FK_MProductID FOREIGN KEY (MProduct_ID) REFERENCES PRODUCT(Product_ID)
);
-- spare_part
CREATE TABLE SPARE_PART
(SProduct_ID VARCHAR(10) NOT NULL PRIMARY KEY,
Material NVARCHAR(30) not null,
CONSTRAINT FK_SProductID FOREIGN KEY (SProduct_ID) REFERENCES PRODUCT(Product_ID))
-- inventory
CREATE TABLE INVENTORY
(Inventory_ID VARCHAR(10) NOT NULL ,
Inventory_Name NVARCHAR(50) NOT NULL,
Location_ NVARCHAR(50) NOT NULL,
PRIMARY KEY (Inventory_ID))
-- Purchase Order 
CREATE TABLE PURCHASE_ORDER
(POrder_ID VARCHAR(10) NOT NULL PRIMARY KEY,
Date DATETIME not null,
Contact_Name VARCHAR(50) NOT NULL,
Supplier_ID VARCHAR(10) NOT NULL,
Employee_ID VARCHAR(10) NOT NULL,
FOREIGN KEY (Supplier_ID) REFERENCES SUPPLIER(Supplier_ID),
FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID))
-- Purchase_order_invoice
CREATE TABLE PURCHASE_ORDER_INVOICE
(PInvoice_ID VARCHAR(10) NOT NULL PRIMARY KEY,
Create_Date DATETIME not null,
Exp_Date DATETIME not null,
POrder_ID VARCHAR(10) not null,
Total NUMERIC(11) not null,
FOREIGN KEY (POrder_ID) REFERENCES PURCHASE_ORDER(POrder_ID))
-- payment_purchase_order
CREATE TABLE PAYMENT_PURCHASE_ORDER
(Payment_ID VARCHAR(10) NOT NULL PRIMARY KEY,
Payment_Date DATETIME not null,
PInvoice_ID VARCHAR(10) not null,
Payment_Type VARCHAR(1),
Method VARCHAR(1),
Total NUMERIC(11) not null,
FOREIGN KEY (PInvoice_ID) REFERENCES PURCHASE_ORDER_INVOICE(PInvoice_ID))
-- purchase_order_motor_model
create table PURCHASE_ORDER_LINE (
	POrder_ID varchar(10) not null,  
	Product_ID varchar(10) not null, 
	Quantity int 
	primary key(POrder_ID, Product_ID)
	FOREIGN KEY (POrder_ID) REFERENCES PURCHASE_ORDER(POrder_ID),
	FOREIGN KEY (Product_ID)  REFERENCES PRODUCT(Product_ID)
)
-- SALES_ORDER_INVOICE
CREATE TABLE SALES_ORDER_INVOICE
(SInvoice_ID VARCHAR(10) NOT NULL PRIMARY KEY,
Invoice_Date DATETIME NOT NULL,
Customer_ID VARCHAR(10) NOT NULL,
Employee_ID VARCHAR(10) NOT NULL,
Payment_Type VARCHAR(1),
Total Numeric(11) NOT NULL,
FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID))
-- Inventory_Product
CREATE TABLE Inventory_Product (
    Inventory_ID VARCHAR(10) NOT NULL,
    Product_ID VARCHAR(10) NOT NULL,
    Quantity INT,
    PRIMARY KEY (Inventory_ID, Product_ID),
    FOREIGN KEY (Inventory_ID) REFERENCES INVENTORY(Inventory_ID),
    FOREIGN KEY (Product_ID) REFERENCES PRODUCT(Product_ID)
);

-- MOTORCYCLE_DELIVERY_NOTE
CREATE TABLE MOTORCYCLE_DELIVERY_NOTE (
    MNote_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Employee_ID VARCHAR(10) NOT NULL,
    Date DATETIME,
    Inventory_ID VARCHAR(10) NOT NULL,
    SInvoice_ID VARCHAR(10) NOT NULL,
    FOREIGN KEY (Inventory_ID)  REFERENCES INVENTORY(Inventory_ID),
    FOREIGN KEY (SInvoice_ID)  REFERENCES SALES_ORDER_INVOICE(SInvoice_ID),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID)
);

-- DETAILED_MOTORCYCLE_DELIVERY_NOTE
CREATE TABLE DETAILED_MOTORCYCLE_DELIVERY_NOTE (
    MNote_ID VARCHAR(10) NOT NULL,
    MProduct_ID VARCHAR(10) NOT NULL,
    Engine_Number VARCHAR(10) NOT NULL,
    VIN VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL,
    Price NUMERIC(11) NOT NULL,
    PRIMARY KEY (MNote_ID, MProduct_ID, Engine_Number, VIN),
    FOREIGN KEY (MNote_ID) REFERENCES MOTORCYCLE_DELIVERY_NOTE(MNote_ID),
    FOREIGN KEY (MProduct_ID, VIN, Engine_Number) REFERENCES MOTORCYCLE(MProduct_ID, VIN, Engine_Number)
);


-- Warranty_Card
CREATE TABLE WARRANTY_CARD (
    Warranty_ID VARCHAR(10) NOT NULL PRIMARY KEY,
	MNote_ID VARCHAR(10) NOT NULL,
	MProduct_ID VARCHAR(10) NOT NULL,
    Engine_Number VARCHAR(10) NOT NULL,
    VIN VARCHAR(10) NOT NULL,
    Warranty_Period NVARCHAR(10),
    Warranty_Status NVARCHAR(20),
    Start_Date DATETIME,
	FOREIGN KEY (MNote_ID, MProduct_ID, Engine_Number, VIN) REFERENCES DETAILED_MOTORCYCLE_DELIVERY_NOTE(MNote_ID, MProduct_ID, Engine_Number, VIN)
);
-- Repair_proposal
CREATE TABLE REPAIR_PROPOSAL (
    Repair_Proposal_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Date DATETIME,
    Customer_ID VARCHAR(10),
    Licence_Plate VARCHAR(10),
    Required_Spare_Part NVARCHAR(100),
    Relative_Service NVARCHAR(100),
    Employee_ID VARCHAR(10),
    FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID)
);
--REPAIR ORDER
CREATE TABLE REPAIR_ORDER (
    RORDER_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Employee_ID VARCHAR(10) NOT NULL,
	Customer_ID VARCHAR(10),
    Licence_Plate VARCHAR(10),
    Motor_Type NVARCHAR(20),
    Date DATETIME NOT NULL,
    Price NUMERIC(11) NOT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID),
);
ALTER TABLE REPAIR_ORDER
DROP COLUMN Price;

--Repair_order_service
CREATE TABLE REPAIR_ORDER_SERVICE (
    ROrder_ID VARCHAR(10) NOT NULL,
    Service_ID VARCHAR(10) NOT NULL,
    Price NUMERIC(11),
    PRIMARY KEY (ROrder_ID, Service_ID),
    FOREIGN KEY (ROrder_ID) REFERENCES REPAIR_ORDER(ROrder_ID),
    FOREIGN KEY (Service_ID) REFERENCES SERVICE(Service_ID)
);
-- SPARE_PART_DELIVERY_NOTE
CREATE TABLE SPARE_PART_DELIVERY_NOTE (
    SNote_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Inventory_ID VARCHAR(10) NOT NULL,
    Employee_ID VARCHAR(10) NOT NULL,
    ROrder_ID VARCHAR(10) NOT NULL,
    Date DATETIME NOT NULL,
    FOREIGN KEY (Inventory_ID) REFERENCES INVENTORY(Inventory_ID),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID),
    FOREIGN KEY (ROrder_ID) REFERENCES REPAIR_ORDER(ROrder_ID)
);
-- DETAILED_SPARE_PART_DELIVERY_NOTE
CREATE TABLE DETAILED_SPARE_PART_DELIVERY_NOTE (
    SNote_ID VARCHAR(10) NOT NULL,
    SProduct_ID VARCHAR(10) NOT NULL,
    Quantity INT,
    Price NUMERIC(11) NOT NULL,
    PRIMARY KEY (SNote_ID, SProduct_ID),
    FOREIGN KEY (SNote_ID) REFERENCES SPARE_PART_DELIVERY_NOTE(SNote_ID),
    FOREIGN KEY (SProduct_ID) REFERENCES SPARE_PART(SProduct_ID)
);
--REPAIR_INVOICE
CREATE TABLE REPAIR_INVOICE (
    RInvoice_ID VARCHAR(10) NOT NULL PRIMARY KEY,
    Date DATETIME NOT NULL,
	Warranty_ID VARCHAR(10),
    Discount NUMERIC(11),
    Total NUMERIC(11),
	Payment_Type VARCHAR(1),
    ROrder_ID VARCHAR(10) ,
    Employee_ID VARCHAR(10) NOT NULL,
    FOREIGN KEY (ROrder_ID) REFERENCES REPAIR_ORDER(ROrder_ID),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID),
	FOREIGN KEY (Warranty_ID) REFERENCES WARRANTY_CARD(Warranty_ID)
);


-- INSERT VALUES
-- Nhập liệu service 
INSERT INTO SERVICE (Service_ID, Service_Des, MuPrice, AuPrice)
VALUES
('S1', 'Vệ sinh họng ga', 100000, 120000),
('S2', 'Thay nhông sên đĩa', 280000, 300000),
('S3', 'Thay bugi', 60000, 80000),
('S4', 'Thay công tơ mét', 60000, 10000),
('S6', 'Công vệ sinh lọc gió', 20000, 40000),
('S7', 'Công thay bơm dầu xe máy', 100000, 15000),
('S8', 'Công láng đĩa phanh xe máy', 120000, 120000),
('S9', 'Làm côn xe máy', 60000, 80000),
('S11', 'Thay lốp xe máy', 320000, 400000),
('S12', 'Vệ sinh buồng đốt động cơ', 80000, 100000),
('S13', 'Hàn cổ bô xe', 50000, 50000),
('S14', 'Thay ắc quy', 650000, 650000),
('S15', 'Thay đèn pha', 150000, 180000),
('S16', 'Thay gương', 100000, 120000),
('S17', 'Thay ống xả', 250000, 300000),
('S18', 'Thay dây curoa', 250000, 350000),
('S19', 'Thay giảm xóc', 300000, 350000),
('S20', 'Thay đèn xi nhan', 250000, 250000),
('S21', 'Thay yên xe', 250000, 300000),
('S22', 'Thay dây ga', 300000, 280000),
('S23', 'Thay pô xe', 450000, 550000);

-- Nhập liệu customer
INSERT INTO CUSTOMER
VALUES
(1, 'Lê Thanh Q', '0123456789','M','01-01-2004','Ký túc xá khu B ĐHQG'),
(2, 'Nguyễn Thị A', '0342456280', 'F', '06-05-1983','Khu phố A,Linh Trung'),
(3, 'Trần Tiến C', '0924571949', 'M','08-07-1999', 'Đường 669, ql 1A, Linh Trung, Thủ Đức'),
(4, 'Đặng Thị C', '0127593483', 'F', '02-03-1976','Chung cư bcon,TP HCM'),
(5, 'Trần Thanh E', '0123456789','M','01-01-2004','Ký túc xá khu A ĐHQG'),
(6, 'Lý Thanh D', '0103157889','F','12-21-1985','Đường B, Quận 6, TP HCM'),
(7, 'Trần Mỹ T', '0123456789','F','11-01-2000','Đường O, Quận 5, TP HCM'),
(8, 'Lê Thành R', '0110943789','M','07-11-2004','Đường K, Quận 12, TP HCM'),
(9, 'Trần Yên N', '0123832059','M','09-01-2004','Ký túc xá khu A ĐHQG')
;
-- DEpartment 
INSERT INTO DEPARTMENT (Department_ID, Department_Name, Manager_ID, Location_)
VALUES
(1, 'Executives', NULL, 'Room 310, Floor 4'),
(2, 'Sales', NULL, 'Room 101-104, Floor 1'),
(3, 'Marketing', NULL, 'Room 105-108, Floor 1'),
(4, 'Accounting', NULL, 'Room 109-110, Floor 1'),
(5, 'Human Resources', NULL, 'Room 301, Floor 3'),
(6, 'Inventory', NULL, 'Room 201-210, Floor 2'),
(7, 'IT', NULL, 'Room 302-305, Floor 3'),
(8, 'Customer Service', NULL, 'Room 306-309, Floor 3'),
(9, 'Purchasing', NULL, 'Room 310, Floor 3');

-- EMPLOYEE
INSERT INTO EMPLOYEE(Employee_ID, Name_, Phone_number, Gender,Date_Of_Birth, Address_, Email, Salary, Department_ID, Manager_ID)
VALUES
(100, 'Nguyễn Văn T', '0990472395','M', '01-01-1975','Đường C, THP Thủ Đức, TP HCM','employee0@example.com',50000000, 1, Null),
(101, 'Lương Chí T', '0290472385','M', '01-01-1985','Đường C, THP Thủ Đức, TP HCM','employee1@example.com',30000000,2, 100),
(102, 'Lương Văn W', '0290423567','M', '06-07-1995','Đường B, Quận 6, TP HCM','employee2@example.com',10000000,3, 100),
(103, 'Trần Ngọc P', '0980345199','F', '06-08-1994','Đường E, THP Thủ Đức, TP HCM','employee3@example.com',15000000 ,4, 100),
(104, 'Trần Van Y', '035675199','M', '09-10-1992','Đường E, Quan 8, TP HCM','employee4@example.com',10000000 ,2, 101),
(105, 'Đặng Ngọc P', '0980738903','F', '04-12-1998','Đường R, THP Thủ Đức, TP HCM','employee5@example.com',15000000 ,3, 102),
(106, 'Trần Cao K', '0321890456','M', '04-11-1990','Đường H, Quận 1, TP HCM','employee6@example.com',15000000 ,4, 103),
(107, 'Nguyễn Trần Ngọc M', '0371930467','F', '05-09-1990','Đường K,　Quan 9, TP HCM','employee7@example.com',12000000 ,5, 100),
(108, 'Cao Phan H', '0938904570','M', '06-01-1992','Đường Q, Quan 12, TP HCM','employee8@example.com',10000000 ,8, 113),
(109, 'Nguyễn Thị Ngọc Y', '0371340467','F', '09-09-1989','Đường K,　Quan 3, TP HCM','employee9@example.com',18000000 ,5, 107),
(110, 'Nguyễn Trần Ngọc M', '0371930467','F', '05-09-1990','Đường K,　Quan 9, TP HCM','employee7@example.com',12000000 ,4, 103),
(111, 'Nguyễn Văn A', '0987654321', 'M', '01-01-1980', 'Đường X, Quận 1, TP HCM', 'employee10@example.com', 30000000, 2, 101), 
(112, 'Trần Thị B', '0987654322', 'F', '01-01-1982', 'Đường Y, Quận 1, TP HCM', 'employee11@example.com', 30000000, 6, 100), 
(113, 'Lê Văn C', '0987654323', 'M', '01-01-1984', 'Đường Z, Quận 1, TP HCM', 'employee12@example.com', 30000000, 8, 100), 
(114, 'Phạm Thị D', '0987654324', 'F', '01-01-1986', 'Đường K, Quận 1, TP HCM', 'employee13@example.com', 30000000, 6, 112), 
(115, 'Vũ Văn E', '0987654325', 'M', '01-01-1988', 'Đường L, Quận 1, TP HCM', 'employee14@example.com', 30000000, 8, 113), 
(116, 'Hoàng Thị F', '0987654326', 'F', '01-01-1990', 'Đường M, Quận 1, TP HCM', 'employee15@example.com', 30000000, 9, 100), 
(117, 'Nguyễn Văn G', '0987654327', 'M', '01-01-1992', 'Đường N, Quận 1, TP HCM', 'employee16@example.com', 30000000, 7, 100), 
(118, 'Nguyễn Ngọc G', '0987653327', 'M', '01-01-1990', 'Đường O, Quận 1, TP HCM', 'employee17@example.com', 30000000, 6, 112);

-- Cập nhật lại các giá trị Manager_ID cho từng bộ phận (Department) trong bảng DEPARTMENT

UPDATE DEPARTMENT
SET Manager_ID = 
    CASE Department_Name
        WHEN 'Executives' THEN 100
        WHEN 'Sales' THEN 101
        WHEN 'Marketing' THEN 102
        WHEN 'Accounting' THEN 103
        WHEN 'Human Resources' THEN 107
        WHEN 'Inventory' THEN 112
        WHEN 'IT' THEN 117
        WHEN 'Customer Service' THEN 113
        WHEN 'Purchasing' THEN 116
        ELSE NULL  -- Đặt Manager_ID thành NULL cho các bộ phận khác (nếu có)
    END
WHERE Department_Name IN ('Executives', 'Sales', 'Marketing', 'Accounting
', 'Human Resources', 'Inventory', 'IT', 'Customer Service', 'Purchasing');

-- Supplier 
INSERT INTO SUPPLIER (Supplier_ID, Supplier_Name, Phone_Number,
Email)
VALUES
(1, 'Supplier A', 0123456789, 'supplierA@example.com'),
(2, 'Supplier B', 0987654321, 'supplierB@example.com'),
(3, 'Supplier C', 0456789123, 'supplierC@example.com'),
(4, 'Supplier D', 0321654987, 'supplierD@example.com'),
(5, 'Supplier E', 0789123456, 'supplierE@example.com');


-- Product
INSERT INTO  PRODUCT(Product_ID, Product_name, Motor_Type, Brand,Orgin, Pur_Price)
VALUES 
    ('P001', N'Exciter 150', N'Xe số', N'Yamaha', N'Nhật Bản', 50000000),
    ('P002', N'Wave Alpha', N'Xe số', N'Honda', N'Nhật Bản', 20000000),
    ('P003', N'Air Blade 125', N'Xe ga', N'Honda', N'Nhật Bản', 45000000),
    ('P004', N'Winner X', N'Xe số', N'Honda', N'Nhật Bản', 28000000),
    ('P005', N'Vision 110', N'Xe ga', N'Honda', N'Nhật Bản', 22000000),
    ('P006', N'Mio', N'Xe ga', N'Yamaha', N'Nhật Bản', 21000000),
    ('P007', N'Exciter 135', N'Xe số', N'Yamaha', N'Nhật Bản', 29000000),
    ('P008', N'PCX 150', N'Xe ga', N'Honda', N'Nhật Bản', 32000000),
    ('P009', N'Future Neo', N'Xe số', N'Honda', N'Nhật Bản', 20000000),
    ('P010', N'Blade 110', N'Xe số', N'Honda', N'Nhật Bản', 18000000),
    ('P011', N'Shark', N'Xe ga', N'Sym', N'Taiwan', 24000000),
    ('P012', N'Liberty 125', N'Xe ga', N'Piaggio', N'Ý', 35000000),
    ('P013', N'Sh Mode 125', N'Xe ga', N'Honda', N'Nhật Bản', 27000000),
    ('P014', N'Sirius 50', N'Xe số', N'Honda', N'Nhật Bản', 15000000),
    ('P015', N'Dream 50', N'Xe số', N'Honda', N'Nhật Bản', 16000000),
    ('P016', N'Spacy', N'Xe số', N'Honda', N'Nhật Bản', 17000000),
    ('P017', N'Future 125', N'Xe số', N'Honda', N'Nhật Bản', 28000000),
    ('P018', N'Vario 125', N'Xe ga', N'Honda', N'Nhật Bản', 30000000),
    ('P019', N'Exciter 155', N'Xe số', N'Yamaha', N'Nhật Bản', 31000000),
    ('P020', N'Wave 110 RSX', N'Xe số', N'Honda', N'Nhật Bản', 19000000),
    ('P021', N'Sirius 110', N'Xe số', N'Honda', N'Nhật Bản', 17000000),
    ('P022', N'Lead 125', N'Xe ga', N'Honda', N'Nhật Bản', 28000000),
    ('P023', N'Sh Mode 150', N'Xe ga', N'Honda', N'Nhật Bản', 33000000),
    ('P024', N'PCX 160', N'Xe ga', N'Honda', N'Nhật Bản', 34000000),
    ('P025', N'Shark Mini 50', N'Xe số', N'Sym', N'Taiwan', 20000000),
    ('P026', N'Lốp xe', N'Xe số', N'Michelin', N'Pháp', 100000),
    ('P027', N'Lốp xe', N'Xe ga', N'Michelin', N'Pháp', 150000),
    ('P028', N'Acquy', N'Xe số', N'GS Yuasa', N'Nhật Bản', 500000),
    ('P029', N'Acquy', N'Xe ga', N'GS Yuasa', N'Nhật Bản', 500000),
    ('P030', N'Đèn pha', N'Xe số', N'Philips', N'Hà Lan', 80000),
    ('P031', N'Đèn pha', N'Xe ga', N'Philips', N'Hà Lan', 100000),
    ('P032', N'Dầu Nhớt', N'Xe ga', N'Yamahe', N'Nhật Bản', 160000),
	('P033', N' Dầu Nhớt', N'Xe số', N'Yamaha', N'Nhật Bản', 100000),
    ('P034', N'Ống xả', N'Xe ga', N'LeoVince', N'Italia', 150000),
	('P035', N'Ống xả', N'Xe số', N'LeoVince', N'Italia', 200000),
    ('P036', N'Dây curoa', N'Xe số', N'NGK', N'Nhật Bản', 200000),
    ('P037', N'Dây curoa', N'Xe ga', N'NGK', N'Nhật Bản', 250000),
    ('P038', N'Giảm xóc', N'Xe số', N'Ohlins', N'Sweden', 200000),
    ('P039', N'Giảm xóc', N'Xe ga', N'Ohlins', N'Sweden', 250000),
    ('P040', N'Đèn xi nhanh', N'Xe số', N'Goodridge', N'Anh', 200000),
    ('P041', N'Đèn xi nhanh', N'Xe số', N'Goodridge', N'Anh', 200000),
    ('P042', N'Yên xe', N'Xe số', N'Sargent', N'Mỹ', 180000),
    ('P043', N'Yên xe', N'Xe ga', N'Sargent', N'Mỹ', 250000),
    ('P044', N'Pô xe', N'Xe số', N'Akrapovic', N'Slovenia', 300000),
    ('P045', N'Pô xe', N'Xe ga', N'Akrapovic', N'Slovenia', 450000);


-- motorcycle
INSERT INTO MOTORCYCLE  (MProduct_ID, Engine_number, VIN, Engine_Displacement, Version_, Sale_Price, Color)
VALUES 
    ('P001', 'EN00010', 'VIN00010', N'150cc', N'Tiêu chuẩn', 54000000, N'Đỏ'),
	('P001', 'EN00011', 'VIN00011', N'150cc', N'Tiêu chuẩn', 54000000, N'Đen'),
	('P001', 'EN00013', 'VIN00013', N'150cc', N'Tiêu chuẩn', 54000000, N'Đỏ'),
	('P001', 'EN00014', 'VIN00014', N'150cc', N'Tiêu chuẩn', 54000000, N'Đỏ'),
	('P001', 'EN00015', 'VIN00015', N'150cc', N'Tiêu chuẩn', 54000000, N'Đỏ'),
	('P001', 'EN00016', 'VIN00017', N'150cc', N'Tiêu chuẩn', 54000000, N'Đen'),


    ('P002', 'EN00021', 'VIN00021', N'110cc', N'Tiêu chuẩn', 24000000, N'Xanh dương đậm'),
    ('P002', 'EN00022', 'VIN00022', N'110cc', N'Tiêu chuẩn', 24000000, N'Xanh dương'),
    ('P002', 'EN00023', 'VIN00023', N'110cc', N'Tiêu chuẩn', 24000000, N'Xanh dương'),
    ('P002', 'EN00024', 'VIN00024', N'110cc', N'Tiêu chuẩn', 24000000, N'Xanh dương'),
    ('P002', 'EN00025', 'VIN00025', N'110cc', N'Tiêu chuẩn', 24000000, N'Trắng'),
    ('P002', 'EN00026', 'VIN00026', N'110cc', N'Tiêu chuẩn', 24000000, N'Đen'),
    ('P002', 'EN00027', 'VIN00027', N'110cc', N'Tiêu chuẩn', 24000000, N'Trắng'),

    ('P003', 'EN00031', 'VIN00031', N'125cc', N'Cao cấp', 49000000, N'Đỏ'),
	('P003', 'EN00032', 'VIN00032', N'125cc', N'Cao cấp', 49000000, N'Trắng'),
    ('P003', 'EN00033', 'VIN00033', N'125cc', N'Cao cấp', 49000000, N'Trắng'),
    ('P003', 'EN00034', 'VIN00034', N'125cc', N'Cao cấp', 49000000, N'Trắng'),
    ('P003', 'EN00035', 'VIN00035', N'125cc', N'Cao cấp', 49000000, N'Xanh'),
    ('P003', 'EN00036', 'VIN00036', N'125cc', N'Cao cấp', 49000000, N'Xanh'),
    ('P003', 'EN00037', 'VIN00037', N'125cc', N'Cao cấp', 49000000, N'Xanh'),
    ('P003', 'EN00038', 'VIN00038', N'125cc', N'Cao cấp', 49000000, N'Xanh'),


    ('P004', 'EN00041', 'VIN00041', N'150cc', N'Tiêu chuẩn', 32000000, N'Đỏ'),
    ('P004', 'EN00042', 'VIN00042', N'150cc', N'Tiêu chuẩn', 32000000, N'Đen'),
    ('P004', 'EN00043', 'VIN00043', N'150cc', N'Tiêu chuẩn', 32000000, N'Đen'),
    ('P004', 'EN00044', 'VIN00044', N'150cc', N'Tiêu chuẩn', 32000000, N'Đỏ đậm'),
    ('P004', 'EN00045', 'VIN00045', N'150cc', N'Tiêu chuẩn', 32000000, N'Đen'),

    ('P005', 'EN00051', 'VIN00051', N'110cc', N'Tiêu chuẩn', 26000000, N'Bạc'),
	('P005', 'EN00052', 'VIN00052', N'110cc', N'Tiêu chuẩn', 26000000, N'Xám'),
    ('P005', 'EN00053', 'VIN00053', N'110cc', N'Tiêu chuẩn', 26000000, N'Bạc'),
    ('P005', 'EN00054', 'VIN00054', N'110cc', N'Tiêu chuẩn', 26000000, N'Nâu'),
    ('P005', 'EN00055', 'VIN00055', N'110cc', N'Tiêu chuẩn', 26000000, N'Bạc'),

	('P006', 'EN00061', 'VIN00061', N'115cc', N'Tiêu chuẩn', 25000000, N'Vàng'),
	('P006', 'EN00062', 'VIN00062', N'115cc', N'Tiêu chuẩn', 25000000, N'Xanh'),
    ('P006', 'EN00063', 'VIN00063', N'115cc', N'Tiêu chuẩn', 25000000, N'Đỏ'), 
    ('P006', 'EN00064', 'VIN00064', N'115cc', N'Tiêu chuẩn', 25000000, N'Đen'), 
    ('P006', 'EN00065', 'VIN00065', N'115cc', N'Tiêu chuẩn', 25000000, N'Trắng'),

	('P007', 'EN00071', 'VIN00071', N'135cc', N'Tiêu chuẩn', 32000000, N'Lục'),
    ('P007', 'EN00072', 'VIN00072', N'135cc', N'Tiêu chuẩn', 32000000, N'Đen'),
    ('P007', 'EN00073', 'VIN00073', N'135cc', N'Tiêu chuẩn', 32000000, N'Đỏ'),
    ('P007', 'EN00074', 'VIN00074', N'135cc', N'Tiêu chuẩn', 32000000, N'Xanh dương'),
    ('P007', 'EN00075', 'VIN00075', N'135cc', N'Tiêu chuẩn', 32000000, N'Vàng'),

    ('P008', 'EN00081', 'VIN00081', N'150cc', N'Tiêu chuẩn', 36000000, N'Cam'),
    ('P008', 'EN00082', 'VIN00082', N'150cc', N'Tiêu chuẩn', 36000000, N'Tím'),
    ('P008', 'EN00083', 'VIN00083', N'150cc', N'Tiêu chuẩn', 36000000, N'Hồng'),
    ('P008', 'EN00084', 'VIN00084', N'150cc', N'Tiêu chuẩn', 36000000, N'Xám'),
    ('P008', 'EN00085', 'VIN00085', N'150cc', N'Tiêu chuẩn', 36000000, N'Nâu'),

    ('P009', 'EN00091', 'VIN00091', N'110cc', N'Tiêu chuẩn', 24000000, N'Đỏ'),
    ('P009', 'EN00092', 'VIN00092', N'110cc', N'Tiêu chuẩn', 24000000, N'Xanh dương'),
    ('P009', 'EN00093', 'VIN00093', N'110cc', N'Tiêu chuẩn', 24000000, N'Đen'),
    ('P009', 'EN00094', 'VIN00094', N'110cc', N'Tiêu chuẩn', 24000000, N'Vàng'),
    ('P009', 'EN00095', 'VIN00095', N'110cc', N'Tiêu chuẩn', 24000000, N'Xám'),

	('P010', 'EN00101', 'VIN00101', N'110cc', N'Tiêu chuẩn', 22000000, N'Xanh dương'),
    ('P010', 'EN00102', 'VIN00102', N'110cc', N'Tiêu chuẩn', 22000000, N'Đỏ'),
    ('P010', 'EN00103', 'VIN00103', N'110cc', N'Tiêu chuẩn', 22000000, N'Trắng'),
    ('P010', 'EN00104', 'VIN00104', N'110cc', N'Tiêu chuẩn', 22000000, N'Đen'),
    ('P010', 'EN00105', 'VIN00105', N'110cc', N'Tiêu chuẩn', 22000000, N'Vàng'),

    ('P011', 'EN00111', 'VIN00111', N'125cc', N'Tiêu chuẩn', 28000000, N'Xám'),
    ('P011', 'EN00112', 'VIN00112', N'125cc', N'Tiêu chuẩn', 28000000, N'Đỏ'),
    ('P011', 'EN00113', 'VIN00113', N'125cc', N'Tiêu chuẩn', 28000000, N'Trắng'),
    ('P011', 'EN00114', 'VIN00114', N'125cc', N'Tiêu chuẩn', 28000000, N'Đen'),
    ('P011', 'EN00115', 'VIN00115', N'125cc', N'Tiêu chuẩn', 28000000, N'Xanh dương'),

    ('P012', 'EN00121', 'VIN00121', N'125cc', N'Tiêu chuẩn', 39000000, N'Nâu'),
    ('P012', 'EN00122', 'VIN00122', N'125cc', N'Tiêu chuẩn', 39000000, N'Hồng'),
    ('P012', 'EN00123', 'VIN00123', N'125cc', N'Tiêu chuẩn', 39000000, N'Đỏ'),
    ('P012', 'EN00124', 'VIN00124', N'125cc', N'Tiêu chuẩn', 39000000, N'Xám'),
    ('P012', 'EN00125', 'VIN00125', N'125cc', N'Tiêu chuẩn', 39000000, N'Vàng'),

	('P013', 'EN00131', 'VIN00131', N'125cc', N'Tiêu chuẩn', 31000000, N'Vàng'),
    ('P013', 'EN00132', 'VIN00132', N'125cc', N'Tiêu chuẩn', 31000000, N'Đỏ'),
    ('P013', 'EN00133', 'VIN00133', N'125cc', N'Tiêu chuẩn', 31000000, N'Trắng'),
    ('P013', 'EN00134', 'VIN00134', N'125cc', N'Tiêu chuẩn', 31000000, N'Đen'),
    ('P013', 'EN00135', 'VIN00135', N'125cc', N'Tiêu chuẩn', 3100000, N'Xanh dương'),

    ('P014', 'EN00141', 'VIN00141', N'50cc', N'Tiêu chuẩn', 18000000, N'Bạc'),
    ('P014', 'EN00142', 'VIN00142', N'50cc', N'Tiêu chuẩn', 18000000, N'Đỏ'),
    ('P014', 'EN00143', 'VIN00143', N'50cc', N'Tiêu chuẩn', 18000000, N'Xanh dương'),
    ('P014', 'EN00144', 'VIN00144', N'50cc', N'Tiêu chuẩn', 18000000, N'Đen'),
    ('P014', 'EN00145', 'VIN00145', N'50cc', N'Tiêu chuẩn', 18000000, N'Trắng'),

    ('P015', 'EN00151', 'VIN00151', N'50cc', N'Tiêu chuẩn', 18000000, N'Nâu'),
    ('P015', 'EN00152', 'VIN00152', N'50cc', N'Tiêu chuẩn', 18000000, N'Hồng'),
    ('P015', 'EN00153', 'VIN00153', N'50cc', N'Tiêu chuẩn', 18000000, N'Xanh dương'),
    ('P015', 'EN00154', 'VIN00154', N'50cc', N'Tiêu chuẩn', 18000000, N'Đen'),
    ('P015', 'EN00155', 'VIN00155', N'50cc', N'Tiêu chuẩn', 18000000, N'Đỏ'),

    ('P016', 'EN00216', 'VIN0216', N'110cc', N'Tiêu chuẩn', 24000000, N'Xanh dương'),
    ('P017', 'EN00217', 'VIN0217', N'125cc', N'Tiêu chuẩn', 32000000, N'Trắng'),
    ('P017', 'EN00218', 'VIN0218', N'125cc', N'Tiêu chuẩn', 32000000, N'Trắng'),
    ('P017', 'EN00219', 'VIN0219', N'125cc', N'Tiêu chuẩn', 32000000, N'Trắng'),

    ('P018', 'EN00220', 'VIN0220', N'125cc', N'Tiêu chuẩn', 34000000, N'Đen'),
    ('P019', 'EN00221', 'VIN0221', N'155cc', N'Tiêu chuẩn', 35000000, N'Đỏ'),
    ('P020', 'EN00222', 'VIN0222', N'110cc', N'Tiêu chuẩn', 24000000, N'Xanh dương'),
    ('P021', 'EN00223', 'VIN0223', N'110cc', N'Tiêu chuẩn', 23000000, N'Trắng'),
    ('P022', 'EN00224', 'VIN0224', N'125cc', N'Tiêu chuẩn', 21000000, N'Đen'),
    ('P023', 'EN00223', 'VIN0223', N'150cc', N'Tiêu chuẩn', 37000000, N'Đỏ'),
    ('P024', 'EN00224', 'VIN0224', N'160cc', N'Tiêu chuẩn', 38000000, N'Xanh dương'),
    ('P025', 'EN00225', 'VIN0225', N'50cc', N'Tiêu chuẩn', 24000000, N'Đen');


--Spare_Part
INSERT INTO SPARE_PART (Material, SProduct_ID)
VALUES 
    (N'Cao su', 'P026'),
    (N'Chì', 'P027'),
    (N'Sắt', 'P028'),
    (N'Nhựa', 'P029'),
    (N'Kính', 'P030'),
    (N'Kim loại', 'P031'),
    (N'Nhôm', 'P032'),
    (N'Kim loại', 'P033'),
    (N'Cao su', 'P034'),
    (N'Nhôm', 'P035'),
    (N'Inox', 'P036'),
    (N'Kim loại', 'P037'),
    (N'Cao su', 'P038'),
    (N'Kim loại', 'P039'),
    (N'Inox', 'P040'),
    (N'Carbon', 'P041'),
    (N'Nhựa', 'P042'),
    (N'Kim loại', 'P043'),
    (N'Bạc', 'P044'),
    (N'Vải', 'P045');


 -- INVENTORY 
 INSERT INTO Inventory (Inventory_ID, Inventory_Name, Location_) 
VALUES 
    ('KH001', 'Kho 1', 'Địa điểm A'),
    ('KH002', 'Kho 2', 'Địa điểm B'),
    ('KH003', 'Kho 3', 'Địa điểm C');

-- Thêm dữ liệu vào bảng INVENTORY_PRODUCT với "KH001"
INSERT INTO INVENTORY_PRODUCT (Inventory_ID, Product_ID, Quantity)
VALUES 
    ('KH001', 'P001', 5),
    ('KH001', 'P002', 5),
    ('KH003', 'P003', 5),
    ('KH001', 'P004', 5),
    ('KH003', 'P005', 5),
    ('KH003', 'P006', 5),
    ('KH001', 'P007', 5),
    ('KH003', 'P008', 5),
    ('KH003', 'P009', 5),
    ('KH001', 'P010', 5),
    ('KH001', 'P011', 5),
    ('KH001', 'P012', 5),
    ('KH003', 'P013', 5),
    ('KH001', 'P014', 5),
    ('KH003', 'P015', 5),
    ('KH003', 'P016', 1),
    ('KH001', 'P017', 1),
    ('KH001', 'P018', 1),
    ('KH003', 'P019', 1),
    ('KH001', 'P020', 1),
    ('KH001', 'P021', 1),
    ('KH003', 'P022', 1),
    ('KH003', 'P023', 1),
    ('KH001', 'P024', 1),
    ('KH001', 'P025', 1),
    ('KH002', 'P026', 10),
    ('KH002', 'P027', 10),
    ('KH002', 'P028', 10),
    ('KH002', 'P029', 10),
    ('KH002', 'P030', 10),
    ('KH002', 'P031', 10),
    ('KH002', 'P032', 12),
    ('KH002', 'P033', 12),
    ('KH002', 'P034', 12),
    ('KH002', 'P035', 12),
    ('KH002', 'P036', 12),
    ('KH002', 'P037', 12),
    ('KH002', 'P038', 12),
    ('KH002', 'P039', 12),
    ('KH002', 'P040', 12),
    ('KH002', 'P041', 12),
    ('KH002', 'P042', 12),
    ('KH002', 'P043', 12),
    ('KH002', 'P044', 12),
    ('KH002', 'P045', 12);


-- Purchase_Order
INSERT INTO PURCHASE_ORDER (POrder_ID, Date,Contact_Name, Supplier_ID, Employee_ID )
VALUES 
    ('PO001', '2024-03-01',N'Nguyễn Văn A', 1, 116),
    ('PO002', '2024-03-01',N'Trần Thị B', 2, 116),
    ('PO003', '2024-03-02',N'Nguyễn Văn A', 1, 116),
    ('PO004', '2024-03-03',N'Nguyễn Văn A', 1, 116),
    ('PO005', '2024-03-02',N'Phạm Văn C', 3, 116);

-- PURCHASE ORDERLINE
INSERT INTO PURCHASE_ORDER_LINE (POrder_ID, Product_ID, Quantity)
VALUES 
    ('PO001', 'P001', 6),
    ('PO002', 'P002', 7),
    ('PO003', 'P003', 8),
    ('PO004', 'P017', 3),
    ('PO005', 'P045', 15);
-- PURCHASE_ORDER_INVOICE
INSERT INTO PURCHASE_ORDER_INVOICE (PInvoice_ID, Create_Date, Exp_Date, POrder_ID, Total)
VALUES 
    ('PI001', '2024-03-15', '2024-04-01', 'PO001', 300000000),
    ('PI002', '2024-03-15', '2024-04-02', 'PO002', 140000000),
    ('PI003', '2024-03-15', '2024-04-03', 'PO003', 360000000),
    ('PI004', '2024-03-15', '2024-04-04', 'PO004', 84000000),
    ('PI005', '2024-03-15', '2024-04-05', 'PO005', 6750000);
--PAYMENT_PURCHASE_ORDER
INSERT INTO PAYMENT_PURCHASE_ORDER (Payment_ID, Payment_Date, PInvoice_ID, Payment_Type, Total)
VALUES 
    ('PA001', '2024-03-30', 'PI001', '1',300000000),
    ('PA002', '2024-03-30', 'PI002', '2',140000000),
    ('PA003', '2024-03-30', 'PI003', '3', 360000000),
    ('PA004', '2024-03-30', 'PI004', '1', 84000000),
    ('PA005', '2024-03-30', 'PI005', '2',  6750000);
--SALES_ORDER_INVOICE
INSERT INTO SALES_ORDER_INVOICE (SInvoice_ID, Invoice_Date, Customer_ID, Employee_ID,Payment_Type,Total)
VALUES 
    ('SI001', '2024-05-01 08:00:00', 1, 110,'1', 54000000),
    ('SI002', '2024-05-02 15:30:00', 2, 106,'2' ,24000000),
    ('SI003', '2024-05-02 12:45:00', 3, 110, '2',24000000),
    ('SI004', '2024-05-03 13:15:00', 4, 106, '1',49000000),
    ('SI005', '2024-05-03 14:30:00', 5, 110, '2',49000000),
	('SI006', '2024-05-04 11:00:00', 6, 103, '2',49000000),
    ('SI007', '2024-05-04 16:30:00', 7, 103, '1',32000000),
    ('SI008', '2024-05-05 11:45:00', 8, 106, '2',32000000);
--MOTORCYCLE_DELIVERY_NOTE
INSERT INTO MOTORCYCLE_DELIVERY_NOTE (MNote_ID, Inventory_ID, SInvoice_ID, Employee_ID, Date)
VALUES 
    ('M001', 'KH001', 'SI001', 112, '2024-05-01 08:10:00'),
    ('M002', 'KH001', 'SI002', 112, '2024-05-02 15:45:00'),
    ('M003', 'KH001', 'SI003', 112, '2024-05-02 13:15:00'),
    ('M004', 'KH001', 'SI004', 112, '2024-05-03 13:40:00'),
    ('M005', 'KH001', 'SI005', 112, '2024-05-03 14:50:00'),
    ('M006', 'KH001', 'SI006', 112, '2024-05-04 11:16:00'),
    ('M007', 'KH001', 'SI007', 112, '2024-05-04 16:50:00'),
    ('M008', 'KH001', 'SI008', 112, '2024-05-05 11:55:00');

--MOTORCYCLE_DELIVERY_NOTE_DETAIL
INSERT INTO DETAILED_MOTORCYCLE_DELIVERY_NOTE (MNote_ID, MProduct_ID, Engine_Number, VIN, Quantity, Price)
VALUES 
	('M001', 'P001', 'EN00010', 'VIN00010', 1, 50000000),
    ('M002', 'P002', 'EN00021', 'VIN00021', 1, 20000000),
    ('M003', 'P002', 'EN00022', 'VIN00022', 1, 20000000),
    ('M004', 'P003', 'EN00031', 'VIN00031', 1, 20000000),
    ('M005', 'P003', 'EN00032', 'VIN00032', 1, 45000000),
    ('M006', 'P003', 'EN00033', 'VIN00033', 1, 45000000),
    ('M007', 'P017', 'EN00217', 'VIN0217', 1, 28000000),
    ('M008', 'P017', 'EN00218', 'VIN0218', 1, 28000000);

--WARRANTY_CARD
INSERT INTO WARRANTY_CARD(Warranty_ID, MNote_ID,MProduct_ID,Engine_Number, VIN, Warranty_Period, Warranty_Status, Start_Date)
VALUES
('W0001','M001', 'P001', 'EN00010', 'VIN00010', '2 years', 'CONBAOHANH', '2024-05-01'),
 ('W0002','M002',  'P002','EN00021', 'VIN00021', '1 years', 'CONBAOHANH', '2024-05-02'),
 ('W0003','M003', 'P002', 'EN00022', 'VIN00022', '1 years', 'CONBAOHANH', '2024-05-02'),
 ('W0004', 'M004', 'P003','EN00031', 'VIN00031', '1 years', 'CONBAOHANH', '2024-05-03'),
 ('W0005','M005', 'P003', 'EN00032', 'VIN00032', '2 years', 'CONBAOHANH', '2024-05-03'),
 ('W0006','M006', 'P003', 'EN00033', 'VIN00033', '2 years', 'CONBAOHANH', '2024-05-04'),
 ('W0007', 'M007', 'P017','EN00217', 'VIN0217', '1 years', 'CONBAOHANH', '2023-05-04'),
 ('W0008', 'M008', 'P017','EN00218', 'VIN0218', '1 years', 'CONBAOHANH', '2023-05-05');



-- Thêm dữ liệu vào bảng REPAIR_ORDER
INSERT INTO REPAIR_ORDER (ROrder_ID, Employee_ID, Date, Customer_ID, Licence_Plate, Motor_Type) 
VALUES 
    ('R001', 115, '2024-05-01 10:30:00', 9, 'XYZ123', 'Xe số'),
    ('R002', 113, '2024-05-02 11:15:00', 8, 'ABC456', 'Xe ga'),
    ('R003', 115, '2024-05-03 09:45:00', 7, 'DEF789', 'Xe số'),
    ('R004', 113, '2024-05-04 14:00:00', 6, 'GHI012', 'Xe số'),
    ('R005', 115, '2024-05-05 13:30:00', 5, 'JKL345', 'Xe ga');
	-- Thêm dữ liệu vào bảng REPAIR_ORDER_SERVICE
INSERT INTO REPAIR_ORDER_SERVICE (ROrder_ID, Service_ID, Price) 
VALUES 
    ('R001', 'S23', 450000),
    ('R001', 'S1', 100000),
    ('R002', 'S23', 500000),
    ('R002', 'S12', 100000),
    ('R003', 'S23', 450000),
    ('R003', 'S8', 120000),
    ('R004', 'S13', 50000),
    ('R005', 'S18', 350000), 
    ('R005', 'S19', 350000); 
-- Thêm dữ liệu vào bảng SPARE_PART_DELIVERY_NOTE
INSERT INTO SPARE_PART_DELIVERY_NOTE (SNote_ID, Inventory_ID, Employee_ID, ROrder_ID, Date) 
VALUES 
    ('S001', 'KH003', 118, 'R001', '2024-05-01 10:35:00'),
    ('S002', 'KH003', 118, 'R002', '2024-05-02 11:20:00'),
    ('S003', 'KH003', 118, 'R003', '2024-05-03 09:50:00'),
    ('S004', 'KH003', 118, 'R004', '2024-05-04 14:05:00'),
    ('S005', 'KH003', 118, 'R005', '2024-05-05 13:35:00');
-- Thêm dữ liệu vào bảng DETAILED_SPARE_PART_DELIVERY_NOTE
INSERT INTO DETAILED_SPARE_PART_DELIVERY_NOTE (SNote_ID, SProduct_ID, Quantity, Price) 
VALUES 
    ('S001', 'P045', 1, 300000),
    ('S002', 'P045', 1, 300000),
    ('S003', 'P045', 1, 300000),
    ('S005', 'P037', 1, 250000),
    ('S005', 'P039', 1, 250000);
-- Thêm dữ liệu vào bảng REPAIR_INVOICE
INSERT INTO REPAIR_INVOICE (RInvoice_ID, Date, Warranty_ID, Discount, Total, ROrder_ID, Employee_ID,Payment_Type) 
VALUES 
    ('RI001', '2024-05-04 14:30:00', NULL, 0, 550000, 'R001', 103,'1'),
    ('RI002', '2024-05-05 15:15:00', NULL, 0, 600000, 'R002', 110,'1'),
    ('RI003', '2024-05-06 12:45:00', NULL, 0, 570000, 'R003', 110,'2'),
    ('RI004', '2024-05-07 17:00:00', NULL, 0, 50000, 'R004', 103,'2'),
    ('RI005', '2024-05-08 16:30:00', NULL, 0, 700000, 'R005', 110,'1');
-- Vấn tin kinh doanh 
-- Doanh thu bán xe theo tháng 
SELECT YEAR(Invoice_Date) AS years, MONTH(Invoice_Date) AS months, SUM(Total) AS Revenue
FROM SALES_ORDER_INVOICE
GROUP BY  YEAR(Invoice_Date), MONTH(Invoice_Date) 
ORDER BY Revenue
-- Doanh thu từ việc sửa xe 
SELECT YEAR(Date) AS years, MONTH(Date) AS months, SUM(Total) AS Revenue
FROM Repair_INVOICE
GROUP BY  YEAR(Date), MONTH(Date) 
ORDER BY Revenue
--doanh thu theo dòng xe 
SELECT p.Product_ID,p.Product_Name, SUM(s.Total) AS Revenue
FROM SALES_ORDER_INVOICE s
JOIN MOTORCYCLE_DELIVERY_NOTE m on m.SInvoice_ID = s.SInvoice_ID
JOIN DETAILED_MOTORCYCLE_DELIVERY_NOTE n ON n.MNote_ID = m.MNote_ID
JOIN PRODUCT p ON p.Product_ID = n.MProduct_ID
GROUP BY  p.Product_ID,p.Product_Name
--Chi phí đầu vào của mua xe theo tháng năm 
SELECT YEAR(Create_Date) AS years, MONTH(Create_Date) AS months, SUM(Total) AS Cost
FROM PURCHASE_ORDER_INVOICE
GROUP BY  YEAR(Create_Date), MONTH(Create_Date) 
ORDER BY Cost
--MẪU BÁO CÁO SỐ CHI TIÊU NHẬP SẢN PHẨM THEO THÁNG, NĂM
SELECT YEAR(n.Create_Date) AS years, MONTH(n.Create_Date) AS months,p.Product_ID, p.Product_Name,
SUM(l.Quantity) AS Quantity,SUM(n.Total) AS Cost
FROM PURCHASE_ORDER_INVOICE n 
JOIN PURCHASE_ORDER o ON o.POrder_ID= n.POrder_ID
JOIN PURCHASE_ORDER_LINE l ON l.POrder_ID = o.POrder_ID
JOIN PRODUCT p ON p.Product_ID = l.Product_ID
GROUP BY  YEAR(Create_Date), MONTH(Create_Date), p.Product_ID, p.Product_Name
ORDER BY Cost
-- Báo cáo số lượng phụ tùng đã sử dụng 
SELECT YEAR(n.Date) AS years, MONTH(n.Date) AS months,p.Product_ID,p.Product_Name, 
SUM(d.Quantity) quantity,SUM(d.Price) AS total
FROM Repair_INVOICE i
JOIN REPAIR_ORDER r ON i.ROrder_ID = r.RORDER_ID
JOIN SPARE_PART_DELIVERY_NOTE n ON n.ROrder_ID = r.RORDER_ID
JOIN DETAILED_SPARE_PART_DELIVERY_NOTE d ON d.SNote_ID = n.SNote_ID
JOIN PRODUCT p ON p.Product_ID = d.SProduct_ID
GROUP BY  YEAR(n.Date), MONTH(n.Date),p.Product_ID,p.Product_Name
-- BÁO CÁO LƯƠNG NHÂN VIÊN THEO THỨ TỰ
SELECT E.Employee_ID, E.Name_, E.Salary, E.Manager_ID,
D.Department_ID, D.Department_Name
FROM EMPLOYEE E JOIN DEPARTMENT D
ON E.Department_ID = D.Department_ID
ORDER BY D.Department_ID, D.Department_Name,E.Salary DESC
-- BÁO CÁO LƯƠNG NHÂN VIÊN THEO PHÒNG BAN HIỆN HÀNH THEO PHONG BAN (DEPARTMENT_ID)
SELECT D.Department_ID, D.Department_Name, SUM(Salary) AS
TONG_TIEN_LUONG
FROM EMPLOYEE E JOIN DEPARTMENT D
ON E.Department_ID = D.Department_ID
GROUP BY D.Department_ID, D.Department_Name
ORDER BY SUM(Salary) DESC