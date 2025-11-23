IF DB_ID(N'ApartmentHub') IS NULL
BEGIN
RAISERROR('Database [ApartmentHub] not found. Run create.sql first.', 16, 1);
RETURN;
END
GO

USE [ApartmentHub];
GO

DELETE FROM PAYMENT_TRANSACTION;
DELETE FROM NOTIFICATION;
DELETE FROM ESCALATION;
DELETE FROM INVOICE;
DELETE FROM WORKER_ASSIGNMENT;
DELETE FROM WORK_ORDER;
DELETE FROM MAINTENANCE_REQUEST;
DELETE FROM BUILDING_MANAGER_ASSIGNMENT;
DELETE FROM APT_UNIT_AMENITY;
DELETE FROM BUILDING_AMENITY;
DELETE FROM LEASE_OCCUPANT;
DELETE FROM EMERGENCY_CONTACT;
DELETE FROM LEASE;
DELETE FROM WORKER;
DELETE FROM AMENITY;
DELETE FROM MAINTENANCE_CATEGORY;
DELETE FROM VENDOR_COMPANY;
DELETE FROM PROPERTY_MANAGER;
DELETE FROM RESIDENT;
DELETE FROM APARTMENT_UNIT;
DELETE FROM BUILDING;

DBCC CHECKIDENT ('BUILDING', RESEED, 100);
DBCC CHECKIDENT ('APARTMENT_UNIT', RESEED, 2000);
DBCC CHECKIDENT ('RESIDENT', RESEED, 300);
DBCC CHECKIDENT ('PROPERTY_MANAGER', RESEED, 1100);
DBCC CHECKIDENT ('VENDOR_COMPANY', RESEED, 12000);
DBCC CHECKIDENT ('MAINTENANCE_CATEGORY', RESEED, 250);
DBCC CHECKIDENT ('AMENITY', RESEED, 3500);
DBCC CHECKIDENT ('WORKER', RESEED, 400);
DBCC CHECKIDENT ('LEASE', RESEED, 5000);
DBCC CHECKIDENT ('EMERGENCY_CONTACT', RESEED, 601);
DBCC CHECKIDENT ('LEASE_OCCUPANT', RESEED, 7020);
DBCC CHECKIDENT ('BUILDING_AMENITY', RESEED, 830);
DBCC CHECKIDENT ('APT_UNIT_AMENITY', RESEED, 9400);
DBCC CHECKIDENT ('BUILDING_MANAGER_ASSIGNMENT', RESEED, 10000);
DBCC CHECKIDENT ('MAINTENANCE_REQUEST', RESEED, 111);
DBCC CHECKIDENT ('WORK_ORDER', RESEED, 2222);
DBCC CHECKIDENT ('WORKER_ASSIGNMENT', RESEED, 333);
DBCC CHECKIDENT ('INVOICE', RESEED, 44444);
DBCC CHECKIDENT ('ESCALATION', RESEED, 555);
DBCC CHECKIDENT ('NOTIFICATION', RESEED, 1500);
DBCC CHECKIDENT ('PAYMENT_TRANSACTION', RESEED, 666);

CREATE TABLE #BuildingMap (BuildingName VARCHAR(150) NOT NULL, BuildingID INT NOT NULL);
CREATE TABLE #UnitMap (BuildingName VARCHAR(150) NOT NULL, UnitNumber VARCHAR(30) NOT NULL, UnitID INT NOT NULL);
CREATE TABLE #ResidentMap (EmailAddress VARCHAR(200) NOT NULL, ResidentID INT NOT NULL);
CREATE TABLE #ManagerMap (EmployeeID VARCHAR(50) NOT NULL, ManagerID INT NOT NULL);
CREATE TABLE #VendorMap (TaxID VARCHAR(50) NOT NULL, VendorID INT NOT NULL);
CREATE TABLE #CategoryMap (CategoryCode VARCHAR(50) NOT NULL, CategoryID INT NOT NULL);
CREATE TABLE #AmenityMap (AmenityCode VARCHAR(30) NOT NULL, AmenityID INT NOT NULL);
CREATE TABLE #WorkerMap (EmployeeID VARCHAR(20) NOT NULL, WorkerID INT NOT NULL);
CREATE TABLE #LeaseMap (ResidentEmail VARCHAR(200) NOT NULL, BuildingName VARCHAR(150) NOT NULL, UnitNumber VARCHAR(30) NOT NULL, LeaseID INT NOT NULL);

DECLARE @TempID INT;

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Sunset Towers', '100 Main Street', 'Boston', 'MA', '02101', 2010, 10, 50, 'High Rise', 1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Sunset Towers', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Riverside Apartments', '200 River Road', 'Cambridge', 'MA', '02139', 2015, 5, 25, 'Mid Rise', 1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Riverside Apartments', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Garden Court', '300 Oak Avenue', 'Somerville', 'MA', '02144', 2005, 3, 15, 'Low Rise', 0);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Garden Court', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Park Plaza', '400 Park Street', 'Boston', 'MA', '02102', 2018, 15, 75, 'High Rise', 1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Park Plaza', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Maple Gardens', '500 Maple Drive', 'Brookline', 'MA', '02445', 2008, 4, 20, 'Mid Rise', 1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Maple Gardens', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Pine Heights', '600 Pine Street', 'Newton', 'MA', '02458', 2012, 6, 30, 'Mid Rise', 1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Pine Heights', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Downtown Lofts', '700 City Center', 'Boston', 'MA', '02103', 2020, 12, 60, 'High Rise', 1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Downtown Lofts', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Elm Residences', '800 Elm Way', 'Quincy', 'MA', '02169', 2007, 3, 18, 'Low Rise', 0);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Elm Residences', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Harbor View', '900 Harbor Blvd', 'Boston', 'MA', '02104', 2019, 20, 100, 'High Rise', 1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Harbor View', @TempID);

INSERT INTO BUILDING (BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES ('Village Square', '1000 Village Rd', 'Medford', 'MA', '02155', 2011, 4, 24, 'Mid Rise', 1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #BuildingMap VALUES ('Village Square', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '101', 1, 'Studio', 500, 0, 1.00, 1500.00, 'Available', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Sunset Towers';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Sunset Towers','101', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '201', 2, '1BR', 750, 1, 1.00, 2000.00, 'Occupied', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Sunset Towers';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Sunset Towers','201', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '301', 3, '2BR', 1000, 2, 2.00, 2800.00, 'Occupied', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Sunset Towers';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Sunset Towers','301', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '102', 1, 'Studio', 480, 0, 1.00, 1400.00, 'Occupied', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Riverside Apartments';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Riverside Apartments','102', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '202', 2, '1BR', 720, 1, 1.00, 1900.00, 'Maintenance', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Riverside Apartments';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Riverside Apartments','202', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '103', 1, '1BR', 700, 1, 1.00, 1800.00, 'Occupied', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Garden Court';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Garden Court','103', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '203', 2, '2BR', 900, 2, 1.50, 2400.00, 'Available', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Garden Court';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Garden Court','203', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '401', 4, '3BR', 1300, 3, 2.00, 3500.00, 'Available', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Park Plaza';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Park Plaza','401', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '105', 1, 'Studio', 550, 0, 1.00, 1600.00, 'Occupied', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Maple Gardens';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Maple Gardens','105', @TempID);

INSERT INTO APARTMENT_UNIT (BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus, CreatedDate, ModifiedDate)
SELECT BuildingID, '306', 3, '2BR', 950, 2, 2.00, 2600.00, 'Occupied', GETDATE(), GETDATE() FROM #BuildingMap WHERE BuildingName = 'Pine Heights';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #UnitMap VALUES ('Pine Heights','306', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('John','Smith','1985-05-15','1234','6175550101','6175550201','[jsmith@email.com](mailto:jsmith@email.com)','123 Current St, Boston, MA','Active','Approved','2024-12-10',720,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[jsmith@email.com](mailto:jsmith@email.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('Sarah','Johnson','1990-08-22','5678','6175550102',NULL,'[sjohnson@email.com](mailto:sjohnson@email.com)','456 Present Ave, Cambridge, MA','Active','Approved','2024-12-15',680,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[sjohnson@email.com](mailto:sjohnson@email.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('Michael','Brown','1978-03-10','9012','6175550103','6175550203','[mbrown@email.com](mailto:mbrown@email.com)','789 Now Rd, Somerville, MA','Active','Approved','2024-12-20',750,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[mbrown@email.com](mailto:mbrown@email.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('Emily','Davis','1995-11-30','3456','6175550104',NULL,'[edavis@email.com](mailto:edavis@email.com)','321 Today Ln, Boston, MA','Active','Approved','2024-12-22',700,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[edavis@email.com](mailto:edavis@email.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('Robert','Wilson','1982-07-18','7890','6175550105','6175550205','[rwilson@email.com](mailto:rwilson@email.com)','654 Recent Blvd, Brookline, MA','Active','Approved','2024-12-25',690,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[rwilson@email.com](mailto:rwilson@email.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('Lisa','Martinez','1988-04-25','2345','6175550106',NULL,'[lmartinez@mail.com](mailto:lmartinez@mail.com)','987 Latest St, Newton, MA','Inactive','Approved','2024-11-01',650,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[lmartinez@mail.com](mailto:lmartinez@mail.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('David','Anderson','1975-09-05','6789','6175550107','6175550207','[danderson@mail.com](mailto:danderson@mail.com)','147 Modern Ave, Boston, MA','Active','Approved','2024-12-28',780,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[danderson@mail.com](mailto:danderson@mail.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('Jennifer','Taylor','1992-12-15','0123','6175550108',NULL,'[jtaylor@email.com](mailto:jtaylor@email.com)','258 New Rd, Quincy, MA','Active','Approved','2025-01-02',710,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[jtaylor@email.com](mailto:jtaylor@email.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('William','Thomas','1980-06-20','4567','6175550109','6175550209','[wthomas@email.com](mailto:wthomas@email.com)','369 Fresh Ln, Boston, MA','Active','Approved','2025-01-05',730,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[wthomas@email.com](mailto:wthomas@email.com)', @TempID);

INSERT INTO RESIDENT (FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore, CreatedDate, ModifiedDate)
VALUES ('Patricia','Moore','1987-02-14','8901','6175550110',NULL,'[pmoore@email.com](mailto:pmoore@email.com)','741 Young St, Medford, MA','Active','Approved','2025-01-08',695,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ResidentMap VALUES ('[pmoore@email.com](mailto:pmoore@email.com)', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP001','James','Wilson','[jwilson@apt.com](mailto:jwilson@apt.com)','6175550201','Senior Property Manager','Operations','2015-03-01','Senior',10000,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP001', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP002','Mary','Garcia','[mgarcia@apt.com](mailto:mgarcia@apt.com)','6175550202','Property Manager','Operations','2017-06-15','Standard',5000,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP002', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP003','Richard','Miller','[rmiller@apt.com](mailto:rmiller@apt.com)','6175550203','Assistant Manager','Operations','2019-09-01','Assistant',2500,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP003', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP004','Susan','Lee','[slee@apt.com](mailto:slee@apt.com)','6175550204','Regional Manager','Management','2014-01-15','Executive',25000,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP004', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP005','Thomas','Clark','[tclark@apt.com](mailto:tclark@apt.com)','6175550205','Property Manager','Operations','2018-04-01','Standard',5000,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP005', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP006','Nancy','Lewis','[nlewis@apt.com](mailto:nlewis@apt.com)','6175550206','Maintenance Manager','Maintenance','2016-07-01','Maintenance',7500,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP006', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP007','Chris','Walker','[cwalker@apt.com](mailto:cwalker@apt.com)','6175550207','Property Manager','Operations','2020-02-15','Standard',5000,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP007', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP008','Barbara','Hall','[bhall@apt.com](mailto:bhall@apt.com)','6175550208','Senior Property Manager','Operations','2013-11-01','Senior',10000,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP008', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP009','Daniel','Allen','[dallen@apt.com](mailto:dallen@apt.com)','6175550209','Assistant Manager','Operations','2021-05-01','Assistant',2500,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP009', @TempID);

INSERT INTO PROPERTY_MANAGER (EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus, CreatedDate, ModifiedDate)
VALUES ('EMP010','Elizabeth','Young','[eyoung@apt.com](mailto:eyoung@apt.com)','6175550210','Property Manager','Operations','2019-03-15','Standard',5000,'Active',GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #ManagerMap VALUES ('EMP010', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('ABC Plumbing','12-3456789','Mike Johnson','6175550301','[info@abcplumb.com](mailto:info@abcplumb.com)','123 Trade St','Boston','MA','02105','PLM-12345','2025-12-31','INS-PLM-001','2025-06-30','Active',1,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('12-3456789', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('Elite Electric','23-4567890','Tom Brown','6175550302','[info@elite.com](mailto:info@elite.com)','456 Power Ave','Cambridge','MA','02140','ELE-67890','2025-12-31','INS-ELE-001','2025-06-30','Active',1,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('23-4567890', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('Pro Painters','34-5678901','Sue White','6175550303','[info@paint.com](mailto:info@paint.com)','789 Color Ln','Somerville','MA','02145','PNT-11111','2025-12-31','INS-PNT-001','2025-06-30','Active',0,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('34-5678901', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('HVAC Masters','45-6789012','Bob Green','6175550304','[info@hvac.com](mailto:info@hvac.com)','321 Air Way','Boston','MA','02106','HVC-22222','2025-12-31','INS-HVC-001','2025-06-30','Active',1,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('45-6789012', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('Clean Sweep','56-7890123','Amy Black','6175550305','[info@clean.com](mailto:info@clean.com)','654 Mop Rd','Brookline','MA','02446','CLN-33333','2025-12-31','INS-CLN-001','2025-06-30','Active',0,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('56-7890123', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('Locksmith Pro','67-8901234','Joe Gray','6175550306','[info@locks.com](mailto:info@locks.com)','987 Key St','Newton','MA','02459','LCK-44444','2025-12-31','INS-LCK-001','2025-06-30','Active',0,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('67-8901234', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('Glass Works','78-9012345','Jane Blue','6175550307','[info@glass.com](mailto:info@glass.com)','147 Window Way','Boston','MA','02107','GLS-55555','2025-12-31','INS-GLS-001','2025-06-30','Active',0,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('78-9012345', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('Carpet Care','89-0123456','Mark Red','6175550308','[info@carpet.com](mailto:info@carpet.com)','258 Fabric Ave','Quincy','MA','02170','CRP-66666','2025-12-31','INS-CRP-001','2025-06-30','Active',0,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('89-0123456', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('Pest Control Plus','90-1234567','Lisa Orange','6175550309','[info@pest.com](mailto:info@pest.com)','369 Bug Ln','Medford','MA','02156','PST-77777','2025-12-31','INS-PST-001','2025-06-30','Active',1,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('90-1234567', @TempID);

INSERT INTO VENDOR_COMPANY (CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred, CreatedDate, ModifiedDate)
VALUES ('Appliance Repair','01-2345678','Steve Purple','6175550310','[info@repair.com](mailto:info@repair.com)','741 Machine Rd','Boston','MA','02108','APL-88888','2025-12-31','INS-APL-001','2025-06-30','Active',0,GETDATE(),GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #VendorMap VALUES ('01-2345678', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('PLUMB','Plumbing','All plumbing related issues including leaks and clogs','High',4.0,24.0,1,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('PLUMB', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('ELEC','Electrical','Electrical problems and repairs','High',2.0,12.0,1,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('ELEC', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('HVAC','HVAC','Heating, ventilation, and air conditioning issues','Medium',8.0,48.0,1,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('HVAC', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('APPL','Appliances','Appliance repairs and replacements','Medium',12.0,72.0,1,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('APPL', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('PAINT','Painting','Interior and exterior painting requests','Low',24.0,168.0,1,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('PAINT', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('CLEAN','Cleaning','General cleaning services','Low',24.0,48.0,0,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('CLEAN', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('PEST','Pest Control','Pest and rodent control services','High',6.0,24.0,1,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('PEST', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('LOCK','Locks/Keys','Lock repairs and key services','High',1.0,4.0,1,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('LOCK', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('GLASS','Glass/Windows','Window and glass repairs','Medium',12.0,72.0,1,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('GLASS', @TempID);

INSERT INTO MAINTENANCE_CATEGORY (CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive, CreatedDate)
VALUES ('GENERAL','General','Other maintenance requests','Medium',12.0,48.0,0,1,GETDATE());
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #CategoryMap VALUES ('GENERAL', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('GYM','Fitness Center','Building','Fully equipped gym with cardio and weights',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('GYM', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('POOL','Swimming Pool','Building','Outdoor swimming pool with deck area',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('POOL', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('PARK','Parking Space','Building','Covered parking space',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('PARK', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('WASH','Washer/Dryer','Unit','In-unit washer and dryer',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('WASH', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('DISH','Dishwasher','Unit','Built-in dishwasher',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('DISH', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('MICRO','Microwave','Unit','Built-in microwave',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('MICRO', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('BALC','Balcony','Unit','Private balcony or patio',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('BALC', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('FIRE','Fireplace','Unit','Gas or electric fireplace',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('FIRE', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('STOR','Storage Unit','Building','Additional storage space',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('STOR', @TempID);

INSERT INTO AMENITY (AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES ('CONC','Concierge','Building','24/7 concierge service',1);
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #AmenityMap VALUES ('CONC', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Joe', 'Plumber', 'PLM001', 'Plumber', '6175550401', '[joe@abc.com](mailto:joe@abc.com)', 75.00, 'PLM-W-001', '2025-12-31', 'Residential', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '12-3456789';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('PLM001', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Sam', 'Helper', 'PLM002', 'Assistant', '6175550402', '[sam@abc.com](mailto:sam@abc.com)', 35.00, 'PLM-W-002', '2025-12-31', 'General', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '12-3456789';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('PLM002', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Bob', 'Electrician', 'ELE001', 'Electrician', '6175550403', '[bob@elite.com](mailto:bob@elite.com)', 85.00, 'ELE-W-001', '2025-12-31', 'Residential', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '23-4567890';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('ELE001', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Tim', 'Junior', 'ELE002', 'Assistant', '6175550404', '[tim@elite.com](mailto:tim@elite.com)', 40.00, 'ELE-W-002', '2025-12-31', 'General', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '23-4567890';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('ELE002', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Mike', 'Tech', 'HVC001', 'HVAC Tech', '6175550405', '[mike@hvac.com](mailto:mike@hvac.com)', 80.00, 'HVC-W-001', '2025-12-31', 'HVAC Systems', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '45-6789012';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('HVC001', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Steve', 'Painter', 'PNT001', 'Painter', '6175550406', '[steve@paint.com](mailto:steve@paint.com)', 45.00, 'PNT-W-001', '2025-12-31', 'Interior', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '34-5678901';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('PNT001', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Amy', 'Cleaner', 'CLN001', 'Cleaner', '6175550407', '[amy@clean.com](mailto:amy@clean.com)', 25.00, 'CLN-W-001', '2025-12-31', 'General', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '56-7890123';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('CLN001', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'John', 'Lock', 'LCK001', 'Locksmith', '6175550408', '[john@locks.com](mailto:john@locks.com)', 65.00, 'LCK-W-001', '2025-12-31', 'Locks', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '67-8901234';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('LCK001', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Pete', 'Controller', 'PST001', 'Pest Tech', '6175550409', '[pete@pest.com](mailto:pete@pest.com)', 55.00, 'PST-W-001', '2025-12-31', 'Pest Control', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '90-1234567';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('PST001', @TempID);

INSERT INTO WORKER (VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus, CreatedDate, ModifiedDate)
SELECT v.VendorID, 'Carl', 'Repair', 'APL001', 'Technician', '6175550410', '[carl@repair.com](mailto:carl@repair.com)', 70.00, 'APL-W-001', '2025-12-31', 'Appliances', 'Active', GETDATE(), GETDATE()
FROM #VendorMap v WHERE v.TaxID = '01-2345678';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #WorkerMap VALUES ('APL001', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2025-01-01', '2025-12-31', 2000.00, 2000.00, 0.00, 1, 50.00, 5, 'Active', '2024-12-15', '2025-01-01', NULL, NULL, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Sunset Towers' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '201' JOIN #ManagerMap m ON m.EmployeeID = 'EMP001'
WHERE r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[jsmith@email.com](mailto:jsmith@email.com)','Sunset Towers','201', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2025-02-01', '2026-01-31', 2800.00, 2800.00, 500.00, 1, 50.00, 5, 'Active', '2025-01-20', '2025-02-01', NULL, NULL, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Sunset Towers' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '301' JOIN #ManagerMap m ON m.EmployeeID = 'EMP001'
WHERE r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[sjohnson@email.com](mailto:sjohnson@email.com)','Sunset Towers','301', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2025-03-01', '2026-02-28', 1400.00, 1400.00, 0.00, 1, 50.00, 5, 'Active', '2025-02-15', '2025-03-01', NULL, NULL, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Riverside Apartments' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '102' JOIN #ManagerMap m ON m.EmployeeID = 'EMP002'
WHERE r.EmailAddress = '[mbrown@email.com](mailto:mbrown@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[mbrown@email.com](mailto:mbrown@email.com)','Riverside Apartments','102', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2025-01-15', '2026-01-14', 1800.00, 1800.00, 0.00, 1, 50.00, 5, 'Active', '2025-01-05', '2025-01-15', NULL, NULL, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Garden Court' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '103' JOIN #ManagerMap m ON m.EmployeeID = 'EMP002'
WHERE r.EmailAddress = '[edavis@email.com](mailto:edavis@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[edavis@email.com](mailto:edavis@email.com)','Garden Court','103', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2025-02-01', '2026-01-31', 1600.00, 1600.00, 0.00, 1, 50.00, 5, 'Active', '2025-01-20', '2025-02-01', NULL, NULL, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Maple Gardens' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '105' JOIN #ManagerMap m ON m.EmployeeID = 'EMP003'
WHERE r.EmailAddress = '[rwilson@email.com](mailto:rwilson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[rwilson@email.com](mailto:rwilson@email.com)','Maple Gardens','105', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2025-01-01', '2025-12-31', 2600.00, 2600.00, 0.00, 1, 50.00, 5, 'Active', '2024-12-20', '2025-01-01', NULL, NULL, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Pine Heights' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '306' JOIN #ManagerMap m ON m.EmployeeID = 'EMP003'
WHERE r.EmailAddress = '[danderson@mail.com](mailto:danderson@mail.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[danderson@mail.com](mailto:danderson@mail.com)','Pine Heights','306', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2024-01-01', '2024-12-31', 1900.00, 1900.00, 0.00, 1, 50.00, 5, 'Completed', '2023-12-15', '2024-01-01', '2024-12-31', 'Lease Expired', GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Sunset Towers' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '101' JOIN #ManagerMap m ON m.EmployeeID = 'EMP001'
WHERE r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[jsmith@email.com](mailto:jsmith@email.com)','Sunset Towers','101', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2024-02-01', '2025-01-31', 2700.00, 2700.00, 500.00, 1, 50.00, 5, 'Completed', '2024-01-20', '2024-02-01', '2025-01-31', 'Lease Expired', GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Sunset Towers' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '201' JOIN #ManagerMap m ON m.EmployeeID = 'EMP002'
WHERE r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[sjohnson@email.com](mailto:sjohnson@email.com)','Sunset Towers','201', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2025-01-01', '2025-12-31', 2400.00, 2400.00, 0.00, 1, 50.00, 5, 'Active', '2024-12-20', '2025-01-01', NULL, NULL, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Garden Court' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '203' JOIN #ManagerMap m ON m.EmployeeID = 'EMP004'
WHERE r.EmailAddress = '[jtaylor@email.com](mailto:jtaylor@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[jtaylor@email.com](mailto:jtaylor@email.com)','Garden Court','203', @TempID);

INSERT INTO LEASE (ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, m.ManagerID, '2025-02-01', '2026-01-31', 3500.00, 3500.00, 0.00, 1, 50.00, 5, 'Active', '2025-01-25', '2025-02-01', NULL, NULL, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Park Plaza' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '401' JOIN #ManagerMap m ON m.EmployeeID = 'EMP004'
WHERE r.EmailAddress = '[wthomas@email.com](mailto:wthomas@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);
INSERT INTO #LeaseMap VALUES ('[wthomas@email.com](mailto:wthomas@email.com)','Park Plaza','401', @TempID);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Jane Smith','Spouse','6175550501',NULL,'[janes@mail.com](mailto:janes@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Mark Johnson','Father','6175550502','6175550602','[markj@mail.com](mailto:markj@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Susan Brown','Mother','6175550503',NULL,'[susanb@mail.com](mailto:susanb@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[mbrown@email.com](mailto:mbrown@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Tom Davis','Brother','6175550504',NULL,'[tomd@mail.com](mailto:tomd@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[edavis@email.com](mailto:edavis@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Amy Wilson','Sister','6175550505','6175550605','[amyw@mail.com](mailto:amyw@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[rwilson@email.com](mailto:rwilson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Paul Martinez','Son','6175550506',NULL,'[paulm@mail.com](mailto:paulm@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[lmartinez@mail.com](mailto:lmartinez@mail.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Mike Anderson','Friend','6175550507',NULL,'[mikea@mail.com](mailto:mikea@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[danderson@mail.com](mailto:danderson@mail.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Lisa Taylor','Wife','6175550508','6175550608','[lisat@mail.com](mailto:lisat@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[jtaylor@email.com](mailto:jtaylor@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'John Thomas','Husband','6175550509',NULL,'[johnt@mail.com](mailto:johnt@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[wthomas@email.com](mailto:wthomas@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO EMERGENCY_CONTACT (ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary, CreatedDate)
SELECT r.ResidentID, 'Karen Moore','Mother','6175550510',NULL,'[karenm@mail.com](mailto:karenm@mail.com)',1,GETDATE() FROM #ResidentMap r WHERE r.EmailAddress = '[pmoore@email.com](mailto:pmoore@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2025-01-01', NULL, GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Sunset Towers' AND lm.UnitNumber = '201';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2025-02-01', NULL, GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Sunset Towers' AND lm.UnitNumber = '301';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2025-03-01', NULL, GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Riverside Apartments' AND lm.UnitNumber = '102';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2025-01-15', NULL, GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Garden Court' AND lm.UnitNumber = '103';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2025-02-01', NULL, GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Maple Gardens' AND lm.UnitNumber = '105';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2025-01-01', NULL, GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Pine Heights' AND lm.UnitNumber = '306';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2024-01-01', '2024-12-31', GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Sunset Towers' AND lm.UnitNumber = '101';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2024-02-01', '2025-01-31', GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Sunset Towers' AND lm.UnitNumber = '201';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2025-01-01', NULL, GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Garden Court' AND lm.UnitNumber = '203';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO LEASE_OCCUPANT (LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate, CreatedDate)
SELECT lm.LeaseID, r.ResidentID, 'Primary', '2025-02-01', NULL, GETDATE()
FROM #LeaseMap lm JOIN #ResidentMap r ON r.EmailAddress = lm.ResidentEmail
WHERE lm.BuildingName = 'Park Plaza' AND lm.UnitNumber = '401';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Ground Floor', 'Residents Only', 0.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'GYM' WHERE b.BuildingName = 'Sunset Towers';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Rooftop', 'Summer Only', 0.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'POOL' WHERE b.BuildingName = 'Sunset Towers';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Basement', NULL, 100.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'PARK' WHERE b.BuildingName = 'Sunset Towers';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Second Floor', 'Residents Only', 0.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'GYM' WHERE b.BuildingName = 'Riverside Apartments';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Basement', NULL, 75.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'PARK' WHERE b.BuildingName = 'Riverside Apartments';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Ground Level', NULL, 50.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'PARK' WHERE b.BuildingName = 'Garden Court';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'First Floor', 'Residents Only', 0.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'GYM' WHERE b.BuildingName = 'Park Plaza';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Basement', 'By Assignment', 50.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'STOR' WHERE b.BuildingName = 'Park Plaza';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Lobby', '24/7', 0.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'CONC' WHERE b.BuildingName = 'Maple Gardens';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_AMENITY (BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee, CreatedDate)
SELECT b.BuildingID, a.AmenityID, 'Basement', 'By Assignment', 25.00, GETDATE()
FROM #BuildingMap b JOIN #AmenityMap a ON a.AmenityCode = 'STOR' WHERE b.BuildingName = 'Pine Heights';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2024-01-01', 'Good', '2024-12-01', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'WASH' WHERE u.BuildingName = 'Sunset Towers' AND u.UnitNumber = '101';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2024-01-01', 'Good', '2024-11-15', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'DISH' WHERE u.BuildingName = 'Sunset Towers' AND u.UnitNumber = '101';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2024-02-01', 'Excellent', '2024-12-10', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'WASH' WHERE u.BuildingName = 'Sunset Towers' AND u.UnitNumber = '201';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2024-02-01', 'Good', '2024-12-15', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'BALC' WHERE u.BuildingName = 'Sunset Towers' AND u.UnitNumber = '201';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2024-03-01', 'Fair', '2024-12-05', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'MICRO' WHERE u.BuildingName = 'Sunset Towers' AND u.UnitNumber = '301';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2024-01-01', 'Good', '2024-11-20', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'DISH' WHERE u.BuildingName = 'Riverside Apartments' AND u.UnitNumber = '102';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2024-02-01', 'Excellent', '2024-12-08', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'FIRE' WHERE u.BuildingName = 'Riverside Apartments' AND u.UnitNumber = '202';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2023-01-01', 'Good', '2024-11-25', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'WASH' WHERE u.BuildingName = 'Garden Court' AND u.UnitNumber = '103';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2023-01-01', 'Excellent', '2024-12-12', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'BALC' WHERE u.BuildingName = 'Garden Court' AND u.UnitNumber = '203';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO APT_UNIT_AMENITY (UnitID, AmenityID, InstallationDate, Condition, LastServiceDate, CreatedDate)
SELECT u.UnitID, a.AmenityID, '2023-06-01', 'Good', '2024-12-18', GETDATE()
FROM #UnitMap u JOIN #AmenityMap a ON a.AmenityCode = 'DISH' WHERE u.BuildingName = 'Park Plaza' AND u.UnitNumber = '401';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP001' WHERE b.BuildingName = 'Sunset Towers';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP002' WHERE b.BuildingName = 'Riverside Apartments';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP003' WHERE b.BuildingName = 'Garden Court';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' WHERE b.BuildingName = 'Park Plaza';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP005' WHERE b.BuildingName = 'Maple Gardens';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP006' WHERE b.BuildingName = 'Pine Heights';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP007' WHERE b.BuildingName = 'Downtown Lofts';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP008' WHERE b.BuildingName = 'Elm Residences';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP009' WHERE b.BuildingName = 'Harbor View';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO BUILDING_MANAGER_ASSIGNMENT (BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary, CreatedDate)
SELECT b.BuildingID, m.ManagerID, '2024-01-01', NULL, 1, GETDATE()
FROM #BuildingMap b JOIN #ManagerMap m ON m.EmployeeID = 'EMP010' WHERE b.BuildingName = 'Village Square';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Leaking Faucet', 'Kitchen faucet is dripping constantly', 'Medium', 'Completed', '2025-01-10 10:00:00', '2025-01-10 11:00:00', '2025-01-12 14:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Sunset Towers' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '201' JOIN #CategoryMap c ON c.CategoryCode = 'PLUMB'
WHERE r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Outlet Not Working', 'Bedroom outlet has no power', 'High', 'Completed', '2025-01-11 14:30:00', '2025-01-11 15:00:00', '2025-01-13 16:00:00', 1, 1, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Sunset Towers' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '301' JOIN #CategoryMap c ON c.CategoryCode = 'ELEC'
WHERE r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'No Heat', 'Heater not working in living room', 'High', 'Completed', '2025-01-12 08:15:00', '2025-01-12 09:00:00', '2025-01-14 17:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Riverside Apartments' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '102' JOIN #CategoryMap c ON c.CategoryCode = 'HVAC'
WHERE r.EmailAddress = '[mbrown@email.com](mailto:mbrown@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Dishwasher Issue', 'Dishwasher not draining properly', 'Medium', 'Completed', '2025-01-13 11:00:00', '2025-01-13 12:00:00', '2025-01-15 15:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Garden Court' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '103' JOIN #CategoryMap c ON c.CategoryCode = 'APPL'
WHERE r.EmailAddress = '[edavis@email.com](mailto:edavis@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Toilet Running', 'Guest bathroom toilet runs constantly', 'Medium', 'Completed', '2025-01-14 09:30:00', '2025-01-14 10:00:00', '2025-01-16 13:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Maple Gardens' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '105' JOIN #CategoryMap c ON c.CategoryCode = 'PLUMB'
WHERE r.EmailAddress = '[rwilson@email.com](mailto:rwilson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Touch Up Paint', 'Need paint touch up in bedroom', 'Low', 'Completed', '2025-01-15 15:00:00', '2025-01-15 16:00:00', '2025-01-22 14:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Garden Court' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '103' JOIN #CategoryMap c ON c.CategoryCode = 'PAINT'
WHERE r.EmailAddress = '[lmartinez@mail.com](mailto:lmartinez@mail.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Ants in Kitchen', 'Seeing ants near kitchen sink', 'High', 'Completed', '2025-01-16 07:45:00', '2025-01-16 08:30:00', '2025-01-18 12:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Pine Heights' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '306' JOIN #CategoryMap c ON c.CategoryCode = 'PEST'
WHERE r.EmailAddress = '[danderson@mail.com](mailto:danderson@mail.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Lock Sticking', 'Front door lock hard to turn', 'Medium', 'Completed', '2025-01-17 16:20:00', '2025-01-17 17:00:00', '2025-01-19 11:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Garden Court' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '203' JOIN #CategoryMap c ON c.CategoryCode = 'LOCK'
WHERE r.EmailAddress = '[jtaylor@email.com](mailto:jtaylor@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Cracked Window', 'Bedroom window has a crack', 'Medium', 'Completed', '2025-01-18 12:00:00', '2025-01-18 13:00:00', '2025-01-25 16:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Park Plaza' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '401' JOIN #CategoryMap c ON c.CategoryCode = 'GLASS'
WHERE r.EmailAddress = '[wthomas@email.com](mailto:wthomas@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO MAINTENANCE_REQUEST (ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises, CreatedDate, ModifiedDate)
SELECT r.ResidentID, u.UnitID, c.CategoryID, 'Squeaky Floor', 'Floor squeaks in hallway', 'Low', 'Completed', '2025-01-19 10:30:00', '2025-01-19 11:00:00', '2025-01-26 15:00:00', 1, 0, GETDATE(), GETDATE()
FROM #ResidentMap r JOIN #BuildingMap b ON b.BuildingName = 'Pine Heights' JOIN #UnitMap u ON u.BuildingName = b.BuildingName AND u.UnitNumber = '306' JOIN #CategoryMap c ON c.CategoryCode = 'GENERAL'
WHERE r.EmailAddress = '[pmoore@email.com](mailto:pmoore@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-001', mr.RequestID, u.UnitID, m.ManagerID, v.VendorID, 'Plumbing', 'Fix leaking kitchen faucet', '2025-01-12', '2025-01-12 09:00:00', '2025-01-12 14:00:00', 'Completed', 150.00, 145.80, 0, m.ManagerID, '2025-01-10 16:00:00', GETDATE(), GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #UnitMap u ON u.UnitNumber = '201' JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP001' JOIN #VendorMap v ON v.TaxID = '12-3456789'
WHERE mr.RequestTitle = 'Leaking Faucet';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-002', mr.RequestID, u.UnitID, m.ManagerID, v.VendorID, 'Electrical', 'Diagnose and repair bedroom outlet', '2025-01-13', '2025-01-13 09:00:00', '2025-01-13 16:00:00', 'Completed', 200.00, 210.60, 0, m.ManagerID, '2025-01-11 17:00:00', GETDATE(), GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #UnitMap u ON u.UnitNumber = '301' JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP002' JOIN #VendorMap v ON v.TaxID = '23-4567890'
WHERE mr.RequestTitle = 'Outlet Not Working';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-003', mr.RequestID, u.UnitID, m.ManagerID, v.VendorID, 'HVAC', 'Repair heater in living room', '2025-01-14', '2025-01-14 09:00:00', '2025-01-14 17:00:00', 'Completed', 350.00, 361.80, 1, m2.ManagerID, '2025-01-12 16:00:00', GETDATE(), GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #UnitMap u ON u.UnitNumber = '102' JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP001' JOIN #ManagerMap m2 ON m2.EmployeeID = 'EMP004' JOIN #VendorMap v ON v.TaxID = '45-6789012'
WHERE mr.RequestTitle = 'No Heat';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-004', mr.RequestID, u.UnitID, m.ManagerID, v.VendorID, 'Appliance', 'Fix dishwasher drainage', '2025-01-15', '2025-01-15 10:00:00', '2025-01-15 15:00:00', 'Completed', 175.00, 178.20, 0, m.ManagerID, '2025-01-13 14:00:00', GETDATE(), GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #UnitMap u ON u.UnitNumber = '103' JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP002' JOIN #VendorMap v ON v.TaxID = '01-2345678'
WHERE mr.RequestTitle = 'Dishwasher Issue';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-005', mr.RequestID, u.UnitID, m.ManagerID, v.VendorID, 'Plumbing', 'Fix running toilet', '2025-01-16', '2025-01-16 10:00:00', '2025-01-16 13:00:00', 'Completed', 125.00, 124.20, 0, m.ManagerID, '2025-01-14 13:00:00', GETDATE(), GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #UnitMap u ON u.UnitNumber = '105' JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP003' JOIN #VendorMap v ON v.TaxID = '12-3456789'
WHERE mr.RequestTitle = 'Toilet Running';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-006', NULL, u.UnitID, m.ManagerID, v.VendorID, 'Plumbing', 'Preventive maintenance check', '2025-01-17', '2025-01-17 10:00:00', '2025-01-17 12:00:00', 'Completed', 100.00, 97.20, 0, m.ManagerID, '2025-01-15 12:00:00', GETDATE(), GETDATE()
FROM #UnitMap u JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP003' JOIN #VendorMap v ON v.TaxID = '12-3456789'
WHERE u.BuildingName = 'Garden Court' AND u.UnitNumber = '103';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-007', NULL, u.UnitID, m.ManagerID, v.VendorID, 'Electrical', 'Annual electrical inspection', '2025-01-18', '2025-01-18 09:00:00', '2025-01-18 14:00:00', 'Completed', 150.00, 145.80, 0, m.ManagerID, '2025-01-16 11:00:00', GETDATE(), GETDATE()
FROM #UnitMap u JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' JOIN #VendorMap v ON v.TaxID = '23-4567890'
WHERE u.BuildingName = 'Garden Court' AND u.UnitNumber = '203';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-008', mr.RequestID, u.UnitID, m.ManagerID, v.VendorID, 'Pest Control', 'Treat ant infestation', '2025-01-18', '2025-01-18 08:00:00', '2025-01-18 12:00:00', 'Completed', 200.00, 199.80, 0, m.ManagerID, '2025-01-16 10:00:00', GETDATE(), GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #UnitMap u ON u.UnitNumber = '306' JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' JOIN #VendorMap v ON v.TaxID = '90-1234567'
WHERE mr.RequestTitle = 'Ants in Kitchen';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-009', mr.RequestID, u.UnitID, m.ManagerID, v.VendorID, 'Locksmith', 'Service front door lock', '2025-01-19', '2025-01-19 09:00:00', '2025-01-19 11:00:00', 'Completed', 85.00, 86.40, 0, m.ManagerID, '2025-01-17 09:00:00', GETDATE(), GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #UnitMap u ON u.UnitNumber = '203' JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP005' JOIN #VendorMap v ON v.TaxID = '67-8901234'
WHERE mr.RequestTitle = 'Lock Sticking';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORK_ORDER (WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'WO-2025-010', mr.RequestID, u.UnitID, m.ManagerID, v.VendorID, 'Glass', 'Replace cracked window', '2025-01-25', '2025-01-25 10:00:00', '2025-01-25 16:00:00', 'Completed', 450.00, 459.00, 1, m2.ManagerID, '2025-01-18 14:00:00', GETDATE(), GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #UnitMap u ON u.UnitNumber = '401' JOIN #BuildingMap b ON b.BuildingName = u.BuildingName JOIN #ManagerMap m ON m.EmployeeID = 'EMP005' JOIN #ManagerMap m2 ON m2.EmployeeID = 'EMP004' JOIN #VendorMap v ON v.TaxID = '78-9012345'
WHERE mr.RequestTitle = 'Cracked Window';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-10 14:00:00','2025-01-12 09:00:00','2025-01-12 14:00:00',5.00,'Lead Tech',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'PLM001' WHERE wo.WorkOrderNumber = 'WO-2025-001';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-11 15:00:00','2025-01-13 09:00:00','2025-01-13 16:00:00',7.00,'Lead Tech',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'ELE001' WHERE wo.WorkOrderNumber = 'WO-2025-002';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-12 09:00:00','2025-01-14 09:00:00','2025-01-14 17:00:00',8.00,'Lead Tech',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'HVC001' WHERE wo.WorkOrderNumber = 'WO-2025-003';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-13 10:00:00','2025-01-15 10:00:00','2025-01-15 15:00:00',5.00,'Lead Tech',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'APL001' WHERE wo.WorkOrderNumber = 'WO-2025-004';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-14 11:00:00','2025-01-16 10:00:00','2025-01-16 13:00:00',3.00,'Lead Tech',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'PLM001' WHERE wo.WorkOrderNumber = 'WO-2025-005';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-15 14:00:00','2025-01-17 10:00:00','2025-01-17 12:00:00',2.00,'Assistant',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'PLM002' WHERE wo.WorkOrderNumber = 'WO-2025-006';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-16 08:00:00','2025-01-18 09:00:00','2025-01-18 14:00:00',5.00,'Assistant',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'ELE002' WHERE wo.WorkOrderNumber = 'WO-2025-007';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-16 08:00:00','2025-01-18 08:00:00','2025-01-18 12:00:00',4.00,'Lead Tech',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'PST001' WHERE wo.WorkOrderNumber = 'WO-2025-008';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-17 13:00:00','2025-01-19 09:00:00','2025-01-19 11:00:00',2.00,'Lead Tech',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'LCK001' WHERE wo.WorkOrderNumber = 'WO-2025-009';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO WORKER_ASSIGNMENT (WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole, CreatedDate)
SELECT wo.WorkOrderID, w.WorkerID, '2025-01-18 10:00:00','2025-01-25 10:00:00','2025-01-25 16:00:00',6.00,'Lead Tech',GETDATE()
FROM WORK_ORDER wo JOIN #WorkerMap w ON w.EmployeeID = 'ELE001' WHERE wo.WorkOrderNumber = 'WO-2025-010';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-001', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-12', '2025-02-11', 100.00, 35.00, 10.80, 145.80, 'Paid', '2025-01-20', 'ACH Transfer', 'ACH-INV-001', '2025-01-12 16:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '12-3456789' JOIN #ManagerMap m ON m.EmployeeID = 'EMP001' WHERE wo.WorkOrderNumber = 'WO-2025-001';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-002', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-13', '2025-02-12', 150.00, 45.00, 15.60, 210.60, 'Paid', '2025-01-22', 'Check', 'CHK-INV-002', '2025-01-13 17:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '23-4567890' JOIN #ManagerMap m ON m.EmployeeID = 'EMP002' WHERE wo.WorkOrderNumber = 'WO-2025-002';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-003', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-14', '2025-02-13', 250.00, 85.00, 26.80, 361.80, 'Pending', NULL, NULL, NULL, '2025-01-14 15:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '45-6789012' JOIN #ManagerMap m ON m.EmployeeID = 'EMP001' WHERE wo.WorkOrderNumber = 'WO-2025-003';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-004', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-15', '2025-02-14', 140.00, 25.00, 13.20, 178.20, 'Paid', '2025-01-25', 'Check', 'CHK-INV-004', '2025-01-15 14:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '01-2345678' JOIN #ManagerMap m ON m.EmployeeID = 'EMP002' WHERE wo.WorkOrderNumber = 'WO-2025-004';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-005', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-16', '2025-02-15', 75.00, 40.00, 9.20, 124.20, 'Pending', NULL, NULL, NULL, '2025-01-16 13:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '12-3456789' JOIN #ManagerMap m ON m.EmployeeID = 'EMP003' WHERE wo.WorkOrderNumber = 'WO-2025-005';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-006', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-17', '2025-02-16', 75.00, 15.00, 7.20, 97.20, 'Pending', NULL, NULL, NULL, '2025-01-17 12:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '12-3456789' JOIN #ManagerMap m ON m.EmployeeID = 'EMP003' WHERE wo.WorkOrderNumber = 'WO-2025-006';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-007', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-18', '2025-02-17', 100.00, 35.00, 10.80, 145.80, 'Pending', NULL, NULL, NULL, '2025-01-18 11:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '23-4567890' JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' WHERE wo.WorkOrderNumber = 'WO-2025-007';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-008', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-18', '2025-02-17', 110.00, 75.00, 14.80, 199.80, 'Pending', NULL, NULL, NULL, '2025-01-18 10:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '90-1234567' JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' WHERE wo.WorkOrderNumber = 'WO-2025-008';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-009', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-19', '2025-02-18', 65.00, 15.00, 6.40, 86.40, 'Pending', NULL, NULL, NULL, '2025-01-19 09:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '67-8901234' JOIN #ManagerMap m ON m.EmployeeID = 'EMP005' WHERE wo.WorkOrderNumber = 'WO-2025-009';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate, CreatedDate, ModifiedDate)
SELECT 'INV-2025-010', wo.WorkOrderID, v.VendorID, m.ManagerID, '2025-01-25', '2025-02-24', 200.00, 225.00, 34.00, 459.00, 'Pending', NULL, NULL, NULL, '2025-01-25 08:00:00', GETDATE(), GETDATE()
FROM WORK_ORDER wo JOIN #VendorMap v ON v.TaxID = '78-9012345' JOIN #ManagerMap m ON m.EmployeeID = 'EMP005' WHERE wo.WorkOrderNumber = 'WO-2025-010';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 1, m.ManagerID, 'High priority electrical issue needs immediate attention', '2025-01-11 16:00:00', '2025-01-13', '2025-01-13 16:30:00', 'Resolved - outlet repaired successfully', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP002' WHERE mr.RequestTitle = 'Outlet Not Working';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 1, m.ManagerID, 'Heating issue during cold weather', '2025-01-12 10:00:00', '2025-01-14', '2025-01-14 17:30:00', 'Resolved - heater fixed and tested', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP001' WHERE mr.RequestTitle = 'No Heat';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 1, m.ManagerID, 'Pest control issue escalating', '2025-01-16 09:00:00', '2025-01-18', '2025-01-18 12:30:00', 'Resolved - ant treatment completed', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' WHERE mr.RequestTitle = 'Ants in Kitchen';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 1, m.ManagerID, 'Water damage risk from leak', '2025-01-10 12:00:00', '2025-01-12', '2025-01-12 14:30:00', 'Resolved - faucet replaced', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP001' WHERE mr.RequestTitle = 'Leaking Faucet';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 1, m.ManagerID, 'Water waste concern', '2025-01-14 11:00:00', '2025-01-16', '2025-01-16 13:30:00', 'Resolved - toilet mechanism replaced', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP003' WHERE mr.RequestTitle = 'Toilet Running';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 2, m.ManagerID, 'Safety concern with cracked glass', '2025-01-18 14:00:00', '2025-01-25', '2025-01-25 16:30:00', 'Resolved - window replaced', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' WHERE mr.RequestTitle = 'Cracked Window';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 2, m.ManagerID, 'Electrical safety concern', '2025-01-11 09:00:00', '2025-01-13', '2025-01-13 16:30:00', 'Resolved - comprehensive electrical check completed', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' WHERE mr.RequestTitle = 'Outlet Not Working';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 2, m.ManagerID, 'Multiple units affected', '2025-01-12 08:00:00', '2025-01-14', '2025-01-14 17:30:00', 'Resolved - HVAC system repaired', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' WHERE mr.RequestTitle = 'No Heat';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 2, m.ManagerID, 'Repeat issue escalation', '2025-01-10 10:00:00', '2025-01-12', '2025-01-12 14:30:00', 'Resolved - permanent fix applied', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP004' WHERE mr.RequestTitle = 'Leaking Faucet';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO ESCALATION (RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus, CreatedDate)
SELECT mr.RequestID, 1, m.ManagerID, 'Security concern', '2025-01-17 17:00:00', '2025-01-19', '2025-01-19 11:30:00', 'Resolved - lock replaced', 'Resolved', GETDATE()
FROM MAINTENANCE_REQUEST mr JOIN #ManagerMap m ON m.EmployeeID = 'EMP005' WHERE mr.RequestTitle = 'Lock Sticking';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, mr.RequestID, 'Request Received', 'Maintenance Request Received', 'Your maintenance request for the leaking faucet has been received.', 'Normal', 'Email', '2025-01-10 10:30:00', '2025-01-10 10:30:00', 'Delivered', '2025-01-10 11:00:00', GETDATE()
FROM #ResidentMap r JOIN MAINTENANCE_REQUEST mr ON mr.RequestTitle = 'Leaking Faucet' WHERE r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, mr.RequestID, 'Request Received', 'Maintenance Request Received', 'Your request for the outlet repair has been received.', 'High', 'Email', '2025-01-11 15:00:00', '2025-01-11 15:00:00', 'Delivered', '2025-01-11 15:30:00', GETDATE()
FROM #ResidentMap r JOIN MAINTENANCE_REQUEST mr ON mr.RequestTitle = 'Outlet Not Working' WHERE r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, mr.RequestID, 'Request Received', 'Heating Request Received', 'We have received your heating repair request.', 'High', 'SMS', '2025-01-12 08:30:00', '2025-01-12 08:30:00', 'Delivered', '2025-01-12 09:00:00', GETDATE()
FROM #ResidentMap r JOIN MAINTENANCE_REQUEST mr ON mr.RequestTitle = 'No Heat' WHERE r.EmailAddress = '[mbrown@email.com](mailto:mbrown@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, mr.RequestID, 'Work Scheduled', 'Maintenance Scheduled', 'Your maintenance work has been scheduled for 01/12/2025.', 'Normal', 'Email', '2025-01-10 14:00:00', '2025-01-10 14:00:00', 'Delivered', '2025-01-10 14:15:00', GETDATE()
FROM #ResidentMap r JOIN MAINTENANCE_REQUEST mr ON mr.RequestTitle = 'Leaking Faucet' WHERE r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, mr.RequestID, 'Work In Progress', 'Work Started', 'Technician has started work on your electrical issue.', 'Normal', 'Email', '2025-01-13 09:00:00', '2025-01-13 09:00:00', 'Delivered', '2025-01-13 09:30:00', GETDATE()
FROM #ResidentMap r JOIN MAINTENANCE_REQUEST mr ON mr.RequestTitle = 'Outlet Not Working' WHERE r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, NULL, 'General', 'Building Maintenance Notice', 'Annual fire alarm testing scheduled for next week.', 'Normal', 'Email', '2025-01-15 09:00:00', '2025-01-15 09:00:00', 'Delivered', '2025-01-15 10:00:00', GETDATE()
FROM #ResidentMap r WHERE r.EmailAddress = '[mbrown@email.com](mailto:mbrown@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, NULL, 'Lease Renewal', 'Lease Renewal Reminder', 'Your lease expires in 330 days. Please contact us to discuss renewal.', 'Normal', 'Email', '2025-02-05 08:00:00', '2025-02-05 08:00:00', 'Delivered', '2025-02-05 08:30:00', GETDATE()
FROM #ResidentMap r WHERE r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, NULL, 'Payment Reminder', 'Rent Due Reminder', 'Your monthly rent payment is due in 3 days.', 'Normal', 'Email', '2025-01-28 09:00:00', '2025-01-28 09:00:00', 'Delivered', '2025-01-28 09:15:00', GETDATE()
FROM #ResidentMap r WHERE r.EmailAddress = '[edavis@email.com](mailto:edavis@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, mr.RequestID, 'Request Received', 'Pest Control Request Received', 'We have received your pest control request.', 'High', 'SMS', '2025-01-16 08:00:00', '2025-01-16 08:00:00', 'Delivered', '2025-01-16 08:30:00', GETDATE()
FROM #ResidentMap r JOIN MAINTENANCE_REQUEST mr ON mr.RequestTitle = 'Ants in Kitchen' WHERE r.EmailAddress = '[danderson@mail.com](mailto:danderson@mail.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate, CreatedDate)
SELECT r.ResidentID, NULL, 'Building Update', 'Pool Maintenance', 'The pool will be closed for maintenance this weekend.', 'Low', 'Email', '2025-01-20 10:00:00', '2025-01-20 10:00:00', 'Delivered', '2025-01-20 10:30:00', GETDATE()
FROM #ResidentMap r WHERE r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Rent', '2025-01-01', '2025-01-01', 2000.00, 1400.00, 'ACH Transfer', 'ACH-202501-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Sunset Towers' AND l.UnitNumber = '201';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Rent', '2025-02-01', '2025-02-01', 2800.00, 2800.00, 'Check', 'CHK-202502-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Sunset Towers' AND l.UnitNumber = '301';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Rent', '2025-03-01', '2025-03-01', 1400.00, 1400.00, 'Credit Card', 'CC-202503-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Riverside Apartments' AND l.UnitNumber = '102';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Rent', '2025-02-01', '2025-02-01', 2000.00, 2000.00, 'ACH Transfer', 'ACH-202502-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Sunset Towers' AND l.UnitNumber = '201' AND r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Rent', '2025-03-01', '2025-03-01', 2800.00, 2800.00, 'Check', 'CHK-202503-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Sunset Towers' AND l.UnitNumber = '301' AND r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Rent', '2025-02-01', '2025-02-01', 1400.00, 1400.00, 'Credit Card', 'CC-202502-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Riverside Apartments' AND l.UnitNumber = '102' AND r.EmailAddress = '[mbrown@email.com](mailto:mbrown@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Security Deposit', '2024-12-15', '2024-12-15', 2000.00, 2000.00, 'Check', 'CHK-DEPOSIT-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Sunset Towers' AND l.UnitNumber = '101' AND r.EmailAddress = '[jsmith@email.com](mailto:jsmith@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Security Deposit', '2025-01-20', '2025-01-20', 2800.00, 2800.00, 'ACH Transfer', 'ACH-DEPOSIT-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Sunset Towers' AND l.UnitNumber = '301' AND r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Pet Deposit', '2025-01-20', '2025-01-20', 500.00, 500.00, 'Credit Card', 'CC-PET-001', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Sunset Towers' AND l.UnitNumber = '301' AND r.EmailAddress = '[sjohnson@email.com](mailto:sjohnson@email.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus, CreatedDate, ModifiedDate)
SELECT l.LeaseID, r.ResidentID, 'Security Deposit', '2024-12-20', '2024-12-20', 2600.00, 2600.00, 'ACH Transfer', 'ACH-DEPOSIT-002', 'Completed', GETDATE(), GETDATE()
FROM #LeaseMap l JOIN #ResidentMap r ON r.EmailAddress = l.ResidentEmail WHERE l.BuildingName = 'Pine Heights' AND l.UnitNumber = '306' AND r.EmailAddress = '[danderson@mail.com](mailto:danderson@mail.com)';
SET @TempID = CAST(SCOPE_IDENTITY() AS INT);

DROP TABLE #BuildingMap;
DROP TABLE #UnitMap;
DROP TABLE #ResidentMap;
DROP TABLE #ManagerMap;
DROP TABLE #VendorMap;
DROP TABLE #CategoryMap;
DROP TABLE #AmenityMap;
DROP TABLE #WorkerMap;
DROP TABLE #LeaseMap;
