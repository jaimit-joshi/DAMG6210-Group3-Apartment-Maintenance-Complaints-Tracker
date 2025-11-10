-- Require the DB to exist, then use it
IF DB_ID(N'ApartmentHub') IS NULL
BEGIN
    RAISERROR('Database [ApartmentHub] not found. Run create.sql first.', 16, 1);
    RETURN; -- or THROW 50000, '...', 1;
END
GO

USE [ApartmentHub];
GO

-- =====================================================
-- APARTMENT MANAGEMENT DATABASE
-- =====================================================

-- Clear existing data (in reverse order of dependencies)
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

-- Reset NOTIFICATION identity 
DBCC CHECKIDENT ('NOTIFICATION', RESEED, 1500);

-- =====================================================
-- INSERT DATA INTO BASE TABLES
-- =====================================================

-- 1. INSERT INTO BUILDING 
INSERT INTO BUILDING (BuildingID, BuildingName, StreetAddress, City, State, ZipCode, YearBuilt, NumberOfFloors, TotalUnits, BuildingType, HasElevator)
VALUES 
(1, 'Sunset Towers', '100 Main Street', 'Boston', 'MA', '02101', 2010, 10, 50, 'High Rise', 1),
(2, 'Riverside Apartments', '200 River Road', 'Cambridge', 'MA', '02139', 2015, 5, 25, 'Mid Rise', 1),
(3, 'Garden Court', '300 Oak Avenue', 'Somerville', 'MA', '02144', 2005, 3, 15, 'Low Rise', 0),
(4, 'Park Plaza', '400 Park Street', 'Boston', 'MA', '02102', 2018, 15, 75, 'High Rise', 1),
(5, 'Maple Gardens', '500 Maple Drive', 'Brookline', 'MA', '02445', 2008, 4, 20, 'Mid Rise', 1),
(6, 'Pine Heights', '600 Pine Street', 'Newton', 'MA', '02458', 2012, 6, 30, 'Mid Rise', 1),
(7, 'Downtown Lofts', '700 City Center', 'Boston', 'MA', '02103', 2020, 12, 60, 'High Rise', 1),
(8, 'Elm Residences', '800 Elm Way', 'Quincy', 'MA', '02169', 2007, 3, 18, 'Low Rise', 0),
(9, 'Harbor View', '900 Harbor Blvd', 'Boston', 'MA', '02104', 2019, 20, 100, 'High Rise', 1),
(10, 'Village Square', '1000 Village Rd', 'Medford', 'MA', '02155', 2011, 4, 24, 'Mid Rise', 1);

-- 2. INSERT INTO APARTMENT_UNIT 
INSERT INTO APARTMENT_UNIT (UnitID, BuildingID, UnitNumber, FloorNumber, UnitType, SquareFootage, NumberBedrooms, NumberBathrooms, BaseRentAmount, UnitStatus)
VALUES 
(101, 1, '101', 1, 'Studio', 500, 0, 1.00, 1500.00, 'Available'),
(102, 1, '201', 2, '1BR', 750, 1, 1.00, 2000.00, 'Occupied'),
(103, 1, '301', 3, '2BR', 1000, 2, 2.00, 2800.00, 'Occupied'),
(104, 2, '102', 1, 'Studio', 480, 0, 1.00, 1400.00, 'Occupied'),
(105, 2, '202', 2, '1BR', 720, 1, 1.00, 1900.00, 'Maintenance'),
(106, 3, '103', 1, '1BR', 700, 1, 1.00, 1800.00, 'Occupied'),
(107, 3, '203', 2, '2BR', 900, 2, 1.50, 2400.00, 'Available'),
(108, 4, '401', 4, '3BR', 1300, 3, 2.00, 3500.00, 'Available'),
(109, 5, '105', 1, 'Studio', 550, 0, 1.00, 1600.00, 'Occupied'),
(110, 6, '306', 3, '2BR', 950, 2, 2.00, 2600.00, 'Occupied');

-- 3. INSERT INTO RESIDENT  
INSERT INTO RESIDENT (ResidentID, FirstName, LastName, DateOfBirth, SSNLast4, PrimaryPhone, AlternatePhone, EmailAddress, CurrentAddress, AccountStatus, BackgroundCheckStatus, BackgroundCheckDate, CreditScore)
VALUES 
(1001, 'John', 'Smith', '1985-05-15', '1234', '6175550101', '6175550201', 'jsmith@email.com', '123 Current St, Boston, MA', 'Active', 'Approved', '2024-12-10', 720),
(1002, 'Sarah', 'Johnson', '1990-08-22', '5678', '6175550102', NULL, 'sjohnson@email.com', '456 Present Ave, Cambridge, MA', 'Active', 'Approved', '2024-12-15', 680),
(1003, 'Michael', 'Brown', '1978-03-10', '9012', '6175550103', '6175550203', 'mbrown@email.com', '789 Now Rd, Somerville, MA', 'Active', 'Approved', '2024-12-20', 750),
(1004, 'Emily', 'Davis', '1995-11-30', '3456', '6175550104', NULL, 'edavis@email.com', '321 Today Ln, Boston, MA', 'Active', 'Approved', '2024-12-22', 700),
(1005, 'Robert', 'Wilson', '1982-07-18', '7890', '6175550105', '6175550205', 'rwilson@email.com', '654 Recent Blvd, Brookline, MA', 'Active', 'Approved', '2024-12-25', 690),
(1006, 'Lisa', 'Martinez', '1988-04-25', '2345', '6175550106', NULL, 'lmartinez@mail.com', '987 Latest St, Newton, MA', 'Inactive', 'Approved', '2024-11-01', 650),
(1007, 'David', 'Anderson', '1975-09-05', '6789', '6175550107', '6175550207', 'danderson@mail.com', '147 Modern Ave, Boston, MA', 'Active', 'Approved', '2024-12-28', 780),
(1008, 'Jennifer', 'Taylor', '1992-12-15', '0123', '6175550108', NULL, 'jtaylor@email.com', '258 New Rd, Quincy, MA', 'Active', 'Approved', '2025-01-02', 710),
(1009, 'William', 'Thomas', '1980-06-20', '4567', '6175550109', '6175550209', 'wthomas@email.com', '369 Fresh Ln, Boston, MA', 'Active', 'Approved', '2025-01-05', 730),
(1010, 'Patricia', 'Moore', '1987-02-14', '8901', '6175550110', NULL, 'pmoore@email.com', '741 Young St, Medford, MA', 'Active', 'Approved', '2025-01-08', 695);

-- 4. INSERT INTO PROPERTY_MANAGER  
INSERT INTO PROPERTY_MANAGER (ManagerID, EmployeeID, FirstName, LastName, EmailAddress, PhoneNumber, JobTitle, Department, HireDate, ManagerRole, MaxApprovalLimit, AccountStatus)
VALUES 
(201, 'EMP001', 'James', 'Wilson', 'jwilson@apt.com', '6175550201', 'Senior Property Manager', 'Operations', '2015-03-01', 'Senior', 10000, 'Active'),
(202, 'EMP002', 'Mary', 'Garcia', 'mgarcia@apt.com', '6175550202', 'Property Manager', 'Operations', '2017-06-15', 'Standard', 5000, 'Active'),
(203, 'EMP003', 'Richard', 'Miller', 'rmiller@apt.com', '6175550203', 'Assistant Manager', 'Operations', '2019-09-01', 'Assistant', 2500, 'Active'),
(204, 'EMP004', 'Susan', 'Lee', 'slee@apt.com', '6175550204', 'Regional Manager', 'Management', '2014-01-15', 'Executive', 25000, 'Active'),
(205, 'EMP005', 'Thomas', 'Clark', 'tclark@apt.com', '6175550205', 'Property Manager', 'Operations', '2018-04-01', 'Standard', 5000, 'Active'),
(206, 'EMP006', 'Nancy', 'Lewis', 'nlewis@apt.com', '6175550206', 'Maintenance Manager', 'Maintenance', '2016-07-01', 'Maintenance', 7500, 'Active'),
(207, 'EMP007', 'Chris', 'Walker', 'cwalker@apt.com', '6175550207', 'Property Manager', 'Operations', '2020-02-15', 'Standard', 5000, 'Active'),
(208, 'EMP008', 'Barbara', 'Hall', 'bhall@apt.com', '6175550208', 'Senior Property Manager', 'Operations', '2013-11-01', 'Senior', 10000, 'Active'),
(209, 'EMP009', 'Daniel', 'Allen', 'dallen@apt.com', '6175550209', 'Assistant Manager', 'Operations', '2021-05-01', 'Assistant', 2500, 'Active'),
(210, 'EMP010', 'Elizabeth', 'Young', 'eyoung@apt.com', '6175550210', 'Property Manager', 'Operations', '2019-03-15', 'Standard', 5000, 'Active');

-- 5. INSERT INTO VENDOR_COMPANY  
INSERT INTO VENDOR_COMPANY (VendorID, CompanyName, TaxID, PrimaryContactName, PhoneNumber, EmailAddress, StreetAddress, City, State, ZipCode, LicenseNumber, LicenseExpiryDate, InsurancePolicyNumber, InsuranceExpiryDate, VendorStatus, IsPreferred)
VALUES 
(301, 'ABC Plumbing', '12-3456789', 'Mike Johnson', '6175550301', 'info@abcplumb.com', '123 Trade St', 'Boston', 'MA', '02105', 'PLM-12345', '2025-12-31', 'INS-PLM-001', '2025-06-30', 'Active', 1),
(302, 'Elite Electric', '23-4567890', 'Tom Brown', '6175550302', 'info@elite.com', '456 Power Ave', 'Cambridge', 'MA', '02140', 'ELE-67890', '2025-12-31', 'INS-ELE-001', '2025-06-30', 'Active', 1),
(303, 'Pro Painters', '34-5678901', 'Sue White', '6175550303', 'info@paint.com', '789 Color Ln', 'Somerville', 'MA', '02145', 'PNT-11111', '2025-12-31', 'INS-PNT-001', '2025-06-30', 'Active', 0),
(304, 'HVAC Masters', '45-6789012', 'Bob Green', '6175550304', 'info@hvac.com', '321 Air Way', 'Boston', 'MA', '02106', 'HVC-22222', '2025-12-31', 'INS-HVC-001', '2025-06-30', 'Active', 1),
(305, 'Clean Sweep', '56-7890123', 'Amy Black', '6175550305', 'info@clean.com', '654 Mop Rd', 'Brookline', 'MA', '02446', 'CLN-33333', '2025-12-31', 'INS-CLN-001', '2025-06-30', 'Active', 0),
(306, 'Locksmith Pro', '67-8901234', 'Joe Gray', '6175550306', 'info@locks.com', '987 Key St', 'Newton', 'MA', '02459', 'LCK-44444', '2025-12-31', 'INS-LCK-001', '2025-06-30', 'Active', 0),
(307, 'Glass Works', '78-9012345', 'Jane Blue', '6175550307', 'info@glass.com', '147 Window Way', 'Boston', 'MA', '02107', 'GLS-55555', '2025-12-31', 'INS-GLS-001', '2025-06-30', 'Active', 0),
(308, 'Carpet Care', '89-0123456', 'Mark Red', '6175550308', 'info@carpet.com', '258 Fabric Ave', 'Quincy', 'MA', '02170', 'CRP-66666', '2025-12-31', 'INS-CRP-001', '2025-06-30', 'Active', 0),
(309, 'Pest Control Plus', '90-1234567', 'Lisa Orange', '6175550309', 'info@pest.com', '369 Bug Ln', 'Medford', 'MA', '02156', 'PST-77777', '2025-12-31', 'INS-PST-001', '2025-06-30', 'Active', 1),
(310, 'Appliance Repair', '01-2345678', 'Steve Purple', '6175550310', 'info@repair.com', '741 Machine Rd', 'Boston', 'MA', '02108', 'APL-88888', '2025-12-31', 'INS-APL-001', '2025-06-30', 'Active', 0);

-- 6. INSERT INTO MAINTENANCE_CATEGORY  
INSERT INTO MAINTENANCE_CATEGORY (CategoryID, CategoryCode, CategoryName, CategoryDescription, DefaultPriority, TargetResponseHours, TargetResolutionHours, RequiresWorkOrder, IsActive)
VALUES 
(11, 'PLUMB', 'Plumbing', 'All plumbing related issues including leaks and clogs', 'High', 4.0, 24.0, 1, 1),
(12, 'ELEC', 'Electrical', 'Electrical problems and repairs', 'High', 2.0, 12.0, 1, 1),
(13, 'HVAC', 'HVAC', 'Heating, ventilation, and air conditioning issues', 'Medium', 8.0, 48.0, 1, 1),
(14, 'APPL', 'Appliances', 'Appliance repairs and replacements', 'Medium', 12.0, 72.0, 1, 1),
(15, 'PAINT', 'Painting', 'Interior and exterior painting requests', 'Low', 24.0, 168.0, 1, 1),
(16, 'CLEAN', 'Cleaning', 'General cleaning services', 'Low', 24.0, 48.0, 0, 1),
(17, 'PEST', 'Pest Control', 'Pest and rodent control services', 'High', 6.0, 24.0, 1, 1),
(18, 'LOCK', 'Locks/Keys', 'Lock repairs and key services', 'High', 1.0, 4.0, 1, 1),
(19, 'GLASS', 'Glass/Windows', 'Window and glass repairs', 'Medium', 12.0, 72.0, 1, 1),
(20, 'GENERAL', 'General', 'Other maintenance requests', 'Medium', 12.0, 48.0, 0, 1);

-- 7. INSERT INTO AMENITY  
INSERT INTO AMENITY (AmenityID, AmenityCode, AmenityName, AmenityType, Description, IsActive)
VALUES 
(21, 'GYM', 'Fitness Center', 'Building', 'Fully equipped gym with cardio and weights', 1),
(22, 'POOL', 'Swimming Pool', 'Building', 'Outdoor swimming pool with deck area', 1),
(23, 'PARK', 'Parking Space', 'Building', 'Covered parking space', 1),
(24, 'WASH', 'Washer/Dryer', 'Unit', 'In-unit washer and dryer', 1),
(25, 'DISH', 'Dishwasher', 'Unit', 'Built-in dishwasher', 1),
(26, 'MICRO', 'Microwave', 'Unit', 'Built-in microwave', 1),
(27, 'BALC', 'Balcony', 'Unit', 'Private balcony or patio', 1),
(28, 'FIRE', 'Fireplace', 'Unit', 'Gas or electric fireplace', 1),
(29, 'STOR', 'Storage Unit', 'Building', 'Additional storage space', 1),
(30, 'CONC', 'Concierge', 'Building', '24/7 concierge service', 1);

-- 8. INSERT INTO WORKER  
INSERT INTO WORKER (WorkerID, VendorID, FirstName, LastName, EmployeeID, WorkerType, PhoneNumber, EmailAddress, HourlyRate, LicenseNumber, LicenseExpiryDate, Specialization, WorkerStatus)
VALUES 
(401, 301, 'Joe', 'Plumber', 'PLM001', 'Plumber', '6175550401', 'joe@abc.com', 75.00, 'PLM-W-001', '2025-12-31', 'Residential', 'Active'),
(402, 301, 'Sam', 'Helper', 'PLM002', 'Assistant', '6175550402', 'sam@abc.com', 35.00, 'PLM-W-002', '2025-12-31', 'General', 'Active'),
(403, 302, 'Bob', 'Electrician', 'ELE001', 'Electrician', '6175550403', 'bob@elite.com', 85.00, 'ELE-W-001', '2025-12-31', 'Residential', 'Active'),
(404, 302, 'Tim', 'Junior', 'ELE002', 'Assistant', '6175550404', 'tim@elite.com', 40.00, 'ELE-W-002', '2025-12-31', 'General', 'Active'),
(405, 304, 'Mike', 'Tech', 'HVC001', 'HVAC Tech', '6175550405', 'mike@hvac.com', 80.00, 'HVC-W-001', '2025-12-31', 'HVAC Systems', 'Active'),
(406, 303, 'Steve', 'Painter', 'PNT001', 'Painter', '6175550406', 'steve@paint.com', 45.00, 'PNT-W-001', '2025-12-31', 'Interior', 'Active'),
(407, 305, 'Amy', 'Cleaner', 'CLN001', 'Cleaner', '6175550407', 'amy@clean.com', 25.00, 'CLN-W-001', '2025-12-31', 'General', 'Active'),
(408, 306, 'John', 'Lock', 'LCK001', 'Locksmith', '6175550408', 'john@locks.com', 65.00, 'LCK-W-001', '2025-12-31', 'Locks', 'Active'),
(409, 309, 'Pete', 'Controller', 'PST001', 'Pest Tech', '6175550409', 'pete@pest.com', 55.00, 'PST-W-001', '2025-12-31', 'Pest Control', 'Active'),
(410, 310, 'Carl', 'Repair', 'APL001', 'Technician', '6175550410', 'carl@repair.com', 70.00, 'APL-W-001', '2025-12-31', 'Appliances', 'Active');

-- 9. INSERT INTO LEASE  
INSERT INTO LEASE (LeaseID, ResidentID, UnitID, PreparedByManagerID, LeaseStartDate, LeaseEndDate, MonthlyRentAmount, SecurityDepositAmount, PetDepositAmount, PaymentDueDay, LateFeeAmount, GracePeriodDays, LeaseStatus, SignedDate, MoveInDate, MoveOutDate, TerminationReason)
VALUES 
(5001, 1001, 102, 201, '2025-01-01', '2025-12-31', 2000.00, 2000.00, 0.00, 1, 50.00, 5, 'Active', '2024-12-15', '2025-01-01', NULL, NULL),
(5002, 1002, 103, 201, '2025-02-01', '2026-01-31', 2800.00, 2800.00, 500.00, 1, 50.00, 5, 'Active', '2025-01-20', '2025-02-01', NULL, NULL),
(5003, 1003, 104, 202, '2025-03-01', '2026-02-28', 1400.00, 1400.00, 0.00, 1, 50.00, 5, 'Active', '2025-02-15', '2025-03-01', NULL, NULL),
(5004, 1004, 106, 202, '2025-01-15', '2026-01-14', 1800.00, 1800.00, 0.00, 1, 50.00, 5, 'Active', '2025-01-05', '2025-01-15', NULL, NULL),
(5005, 1005, 109, 203, '2025-02-01', '2026-01-31', 1600.00, 1600.00, 0.00, 1, 50.00, 5, 'Active', '2025-01-20', '2025-02-01', NULL, NULL),
(5006, 1007, 110, 203, '2025-01-01', '2025-12-31', 2600.00, 2600.00, 0.00, 1, 50.00, 5, 'Active', '2024-12-20', '2025-01-01', NULL, NULL),
(5007, 1001, 101, 201, '2024-01-01', '2024-12-31', 1900.00, 1900.00, 0.00, 1, 50.00, 5, 'Completed', '2023-12-15', '2024-01-01', '2024-12-31', 'Lease Expired'),
(5008, 1002, 102, 202, '2024-02-01', '2025-01-31', 2700.00, 2700.00, 500.00, 1, 50.00, 5, 'Completed', '2024-01-20', '2024-02-01', '2025-01-31', 'Lease Expired'),
(5009, 1008, 107, 204, '2025-01-01', '2025-12-31', 2400.00, 2400.00, 0.00, 1, 50.00, 5, 'Active', '2024-12-20', '2025-01-01', NULL, NULL),
(5010, 1009, 108, 204, '2025-02-01', '2026-01-31', 3500.00, 3500.00, 0.00, 1, 50.00, 5, 'Active', '2025-01-25', '2025-02-01', NULL, NULL);

-- 10. INSERT INTO EMERGENCY_CONTACT   
INSERT INTO EMERGENCY_CONTACT (ContactID, ResidentID, ContactName, Relationship, PhoneNumber, AlternatePhone, EmailAddress, IsPrimary)
VALUES 
(601, 1001, 'Jane Smith', 'Spouse', '6175550501', NULL, 'janes@mail.com', 1),
(602, 1002, 'Mark Johnson', 'Father', '6175550502', '6175550602', 'markj@mail.com', 1),
(603, 1003, 'Susan Brown', 'Mother', '6175550503', NULL, 'susanb@mail.com', 1),
(604, 1004, 'Tom Davis', 'Brother', '6175550504', NULL, 'tomd@mail.com', 1),
(605, 1005, 'Amy Wilson', 'Sister', '6175550505', '6175550605', 'amyw@mail.com', 1),
(606, 1006, 'Paul Martinez', 'Son', '6175550506', NULL, 'paulm@mail.com', 1),
(607, 1007, 'Mike Anderson', 'Friend', '6175550507', NULL, 'mikea@mail.com', 1),
(608, 1008, 'Lisa Taylor', 'Wife', '6175550508', '6175550608', 'lisat@mail.com', 1),
(609, 1009, 'John Thomas', 'Husband', '6175550509', NULL, 'johnt@mail.com', 1),
(610, 1010, 'Karen Moore', 'Mother', '6175550510', NULL, 'karenm@mail.com', 1);

-- 11. INSERT INTO LEASE_OCCUPANT  
INSERT INTO LEASE_OCCUPANT (OccupantID, LeaseID, ResidentID, OccupantType, MoveInDate, MoveOutDate)
VALUES 
(701, 5001, 1001, 'Primary', '2025-01-01', NULL),
(702, 5002, 1002, 'Primary', '2025-02-01', NULL),
(703, 5003, 1003, 'Primary', '2025-03-01', NULL),
(704, 5004, 1004, 'Primary', '2025-01-15', NULL),
(705, 5005, 1005, 'Primary', '2025-02-01', NULL),
(706, 5006, 1007, 'Primary', '2025-01-01', NULL),
(707, 5007, 1001, 'Primary', '2024-01-01', '2024-12-31'),
(708, 5008, 1002, 'Primary', '2024-02-01', '2025-01-31'),
(709, 5009, 1008, 'Primary', '2025-01-01', NULL),
(710, 5010, 1009, 'Primary', '2025-02-01', NULL);

-- 12. INSERT INTO BUILDING_AMENITY  
INSERT INTO BUILDING_AMENITY (BuildingAmenityID, BuildingID, AmenityID, AmenityLocation, AccessRestrictions, AdditionalFee)
VALUES 
(801, 1, 21, 'Ground Floor', 'Residents Only', 0.00),
(802, 1, 22, 'Rooftop', 'Summer Only', 0.00),
(803, 1, 23, 'Basement', NULL, 100.00),
(804, 2, 21, 'Second Floor', 'Residents Only', 0.00),
(805, 2, 23, 'Basement', NULL, 75.00),
(806, 3, 23, 'Ground Level', NULL, 50.00),
(807, 4, 21, 'First Floor', 'Residents Only', 0.00),
(808, 4, 29, 'Basement', 'By Assignment', 50.00),
(809, 5, 30, 'Lobby', '24/7', 0.00),
(810, 6, 29, 'Basement', 'By Assignment', 25.00);

-- 13. INSERT INTO APT_UNIT_AMENITY  
INSERT INTO APT_UNIT_AMENITY (UnitAmenityID, UnitID, AmenityID, InstallationDate, Condition, LastServiceDate)
VALUES 
(901, 101, 24, '2024-01-01', 'Good', '2024-12-01'),
(902, 101, 25, '2024-01-01', 'Good', '2024-11-15'),
(903, 102, 24, '2024-02-01', 'Excellent', '2024-12-10'),
(904, 102, 27, '2024-02-01', 'Good', '2024-12-15'),
(905, 103, 26, '2024-03-01', 'Fair', '2024-12-05'),
(906, 104, 25, '2024-01-01', 'Good', '2024-11-20'),
(907, 105, 28, '2024-02-01', 'Excellent', '2024-12-08'),
(908, 106, 24, '2023-01-01', 'Good', '2024-11-25'),
(909, 107, 27, '2023-01-01', 'Excellent', '2024-12-12'),
(910, 108, 25, '2023-06-01', 'Good', '2024-12-18');

-- 14. INSERT INTO BUILDING_MANAGER_ASSIGNMENT  
INSERT INTO BUILDING_MANAGER_ASSIGNMENT (AssignmentID, BuildingID, ManagerID, AssignmentStartDate, AssignmentEndDate, IsPrimary)
VALUES 
(1101, 1, 201, '2024-01-01', NULL, 1),
(1102, 2, 202, '2024-01-01', NULL, 1),
(1103, 3, 203, '2024-01-01', NULL, 1),
(1104, 4, 204, '2024-01-01', NULL, 1),
(1105, 5, 205, '2024-01-01', NULL, 1),
(1106, 6, 206, '2024-01-01', NULL, 1),
(1107, 7, 207, '2024-01-01', NULL, 1),
(1108, 8, 208, '2024-01-01', NULL, 1),
(1109, 9, 209, '2024-01-01', NULL, 1),
(1110, 10, 210, '2024-01-01', NULL, 1);

-- 15. INSERT INTO MAINTENANCE_REQUEST  
INSERT INTO MAINTENANCE_REQUEST (RequestID, ResidentID, UnitID, CategoryID, RequestTitle, RequestDescription, RequestPriority, RequestStatus, SubmittedDate, AcknowledgedDate, CompletedDate, PermissionToEnter, PetOnPremises)
VALUES 
(3001, 1001, 102, 11, 'Leaking Faucet', 'Kitchen faucet is dripping constantly', 'Medium', 'Completed', '2025-01-10 10:00:00', '2025-01-10 11:00:00', '2025-01-12 14:00:00', 1, 0),
(3002, 1002, 103, 12, 'Outlet Not Working', 'Bedroom outlet has no power', 'High', 'Completed', '2025-01-11 14:30:00', '2025-01-11 15:00:00', '2025-01-13 16:00:00', 1, 1),
(3003, 1003, 104, 13, 'No Heat', 'Heater not working in living room', 'High', 'Completed', '2025-01-12 08:15:00', '2025-01-12 09:00:00', '2025-01-14 17:00:00', 1, 0),
(3004, 1004, 106, 14, 'Dishwasher Issue', 'Dishwasher not draining properly', 'Medium', 'Completed', '2025-01-13 11:00:00', '2025-01-13 12:00:00', '2025-01-15 15:00:00', 1, 0),
(3005, 1005, 109, 11, 'Toilet Running', 'Guest bathroom toilet runs constantly', 'Medium', 'Completed', '2025-01-14 09:30:00', '2025-01-14 10:00:00', '2025-01-16 13:00:00', 1, 0),
(3006, 1006, 106, 15, 'Touch Up Paint', 'Need paint touch up in bedroom', 'Low', 'Completed', '2025-01-15 15:00:00', '2025-01-15 16:00:00', '2025-01-22 14:00:00', 1, 0),
(3007, 1007, 110, 17, 'Ants in Kitchen', 'Seeing ants near kitchen sink', 'High', 'Completed', '2025-01-16 07:45:00', '2025-01-16 08:30:00', '2025-01-18 12:00:00', 1, 0),
(3008, 1008, 107, 18, 'Lock Sticking', 'Front door lock hard to turn', 'Medium', 'Completed', '2025-01-17 16:20:00', '2025-01-17 17:00:00', '2025-01-19 11:00:00', 1, 0),
(3009, 1009, 108, 19, 'Cracked Window', 'Bedroom window has a crack', 'Medium', 'Completed', '2025-01-18 12:00:00', '2025-01-18 13:00:00', '2025-01-25 16:00:00', 1, 0),
(3010, 1010, 110, 20, 'Squeaky Floor', 'Floor squeaks in hallway', 'Low', 'Completed', '2025-01-19 10:30:00', '2025-01-19 11:00:00', '2025-01-26 15:00:00', 1, 0);

-- 16. INSERT INTO WORK_ORDER   
INSERT INTO WORK_ORDER (WorkOrderID, WorkOrderNumber, RequestID, UnitID, CreatedByManagerID, VendorID, WorkType, WorkDescription, ScheduledDate, StartDateTime, CompletionDateTime, WorkStatus, EstimatedCost, ActualCost, RequiresApproval, ApprovedByManagerID, ApprovalDate)
VALUES 
(4001, 'WO-2025-001', 3001, 102, 201, 301, 'Plumbing', 'Fix leaking kitchen faucet', '2025-01-12', '2025-01-12 09:00:00', '2025-01-12 14:00:00', 'Completed', 150.00, 145.80, 0, 201, '2025-01-10 16:00:00'),
(4002, 'WO-2025-002', 3002, 103, 202, 302, 'Electrical', 'Diagnose and repair bedroom outlet', '2025-01-13', '2025-01-13 09:00:00', '2025-01-13 16:00:00', 'Completed', 200.00, 210.60, 0, 202, '2025-01-11 17:00:00'),
(4003, 'WO-2025-003', 3003, 104, 201, 304, 'HVAC', 'Repair heater in living room', '2025-01-14', '2025-01-14 09:00:00', '2025-01-14 17:00:00', 'Completed', 350.00, 361.80, 1, 204, '2025-01-12 16:00:00'),
(4004, 'WO-2025-004', 3004, 106, 202, 310, 'Appliance', 'Fix dishwasher drainage', '2025-01-15', '2025-01-15 10:00:00', '2025-01-15 15:00:00', 'Completed', 175.00, 178.20, 0, 202, '2025-01-13 14:00:00'),
(4005, 'WO-2025-005', 3005, 109, 203, 301, 'Plumbing', 'Fix running toilet', '2025-01-16', '2025-01-16 10:00:00', '2025-01-16 13:00:00', 'Completed', 125.00, 124.20, 0, 203, '2025-01-14 13:00:00'),
(4006, 'WO-2025-006', NULL, 106, 203, 301, 'Plumbing', 'Preventive maintenance check', '2025-01-17', '2025-01-17 10:00:00', '2025-01-17 12:00:00', 'Completed', 100.00, 97.20, 0, 203, '2025-01-15 12:00:00'),
(4007, 'WO-2025-007', NULL, 107, 204, 302, 'Electrical', 'Annual electrical inspection', '2025-01-18', '2025-01-18 09:00:00', '2025-01-18 14:00:00', 'Completed', 150.00, 145.80, 0, 204, '2025-01-16 11:00:00'),
(4008, 'WO-2025-008', 3007, 110, 204, 309, 'Pest Control', 'Treat ant infestation', '2025-01-18', '2025-01-18 08:00:00', '2025-01-18 12:00:00', 'Completed', 200.00, 199.80, 0, 204, '2025-01-16 10:00:00'),
(4009, 'WO-2025-009', 3008, 107, 205, 306, 'Locksmith', 'Service front door lock', '2025-01-19', '2025-01-19 09:00:00', '2025-01-19 11:00:00', 'Completed', 85.00, 86.40, 0, 205, '2025-01-17 09:00:00'),
(4010, 'WO-2025-010', 3009, 108, 205, 307, 'Glass', 'Replace cracked window', '2025-01-25', '2025-01-25 10:00:00', '2025-01-25 16:00:00', 'Completed', 450.00, 459.00, 1, 204, '2025-01-18 14:00:00');

-- 17. INSERT INTO WORKER_ASSIGNMENT   
INSERT INTO WORKER_ASSIGNMENT (AssignmentID, WorkOrderID, WorkerID, AssignedDate, StartTime, EndTime, HoursWorked, WorkerRole)
VALUES 
(1201, 4001, 401, '2025-01-10 14:00:00', '2025-01-12 09:00:00', '2025-01-12 14:00:00', 5.00, 'Lead Tech'),
(1202, 4002, 403, '2025-01-11 15:00:00', '2025-01-13 09:00:00', '2025-01-13 16:00:00', 7.00, 'Lead Tech'),
(1203, 4003, 405, '2025-01-12 09:00:00', '2025-01-14 09:00:00', '2025-01-14 17:00:00', 8.00, 'Lead Tech'),
(1204, 4004, 410, '2025-01-13 10:00:00', '2025-01-15 10:00:00', '2025-01-15 15:00:00', 5.00, 'Lead Tech'),
(1205, 4005, 401, '2025-01-14 11:00:00', '2025-01-16 10:00:00', '2025-01-16 13:00:00', 3.00, 'Lead Tech'),
(1206, 4006, 402, '2025-01-15 14:00:00', '2025-01-17 10:00:00', '2025-01-17 12:00:00', 2.00, 'Assistant'),
(1207, 4007, 404, '2025-01-16 08:00:00', '2025-01-18 09:00:00', '2025-01-18 14:00:00', 5.00, 'Assistant'),
(1208, 4008, 409, '2025-01-16 08:00:00', '2025-01-18 08:00:00', '2025-01-18 12:00:00', 4.00, 'Lead Tech'),
(1209, 4009, 408, '2025-01-17 13:00:00', '2025-01-19 09:00:00', '2025-01-19 11:00:00', 2.00, 'Lead Tech'),
(1210, 4010, 403, '2025-01-18 10:00:00', '2025-01-25 10:00:00', '2025-01-25 16:00:00', 6.00, 'Lead Tech');

-- 18. INSERT INTO INVOICE  
INSERT INTO INVOICE (InvoiceNumber, WorkOrderID, VendorID, ApprovedByManagerID, InvoiceDate, DueDate, LaborCost, MaterialCost, TaxAmount, TotalAmount, PaymentStatus, PaymentDate, PaymentMethod, PaymentReference, ApprovalDate)
VALUES 
('INV-2025-001', 4001, 301, 201, '2025-01-12', '2025-02-11', 100.00, 35.00, 10.80, 145.80, 'Paid', '2025-01-20', 'ACH Transfer', 'ACH-INV-001', '2025-01-12 16:00:00'),
('INV-2025-002', 4002, 302, 202, '2025-01-13', '2025-02-12', 150.00, 45.00, 15.60, 210.60, 'Paid', '2025-01-22', 'Check', 'CHK-INV-002', '2025-01-13 17:00:00'),
('INV-2025-003', 4003, 304, 201, '2025-01-14', '2025-02-13', 250.00, 85.00, 26.80, 361.80, 'Pending', NULL, NULL, NULL, '2025-01-14 15:00:00'),
('INV-2025-004', 4004, 310, 202, '2025-01-15', '2025-02-14', 140.00, 25.00, 13.20, 178.20, 'Paid', '2025-01-25', 'Check', 'CHK-INV-004', '2025-01-15 14:00:00'),
('INV-2025-005', 4005, 301, 203, '2025-01-16', '2025-02-15', 75.00, 40.00, 9.20, 124.20, 'Pending', NULL, NULL, NULL, '2025-01-16 13:00:00'),
('INV-2025-006', 4006, 301, 203, '2025-01-17', '2025-02-16', 75.00, 15.00, 7.20, 97.20, 'Pending', NULL, NULL, NULL, '2025-01-17 12:00:00'),
('INV-2025-007', 4007, 302, 204, '2025-01-18', '2025-02-17', 100.00, 35.00, 10.80, 145.80, 'Pending', NULL, NULL, NULL, '2025-01-18 11:00:00'),
('INV-2025-008', 4008, 309, 204, '2025-01-18', '2025-02-17', 110.00, 75.00, 14.80, 199.80, 'Pending', NULL, NULL, NULL, '2025-01-18 10:00:00'),
('INV-2025-009', 4009, 306, 205, '2025-01-19', '2025-02-18', 65.00, 15.00, 6.40, 86.40, 'Pending', NULL, NULL, NULL, '2025-01-19 09:00:00'),
('INV-2025-010', 4010, 307, 205, '2025-01-25', '2025-02-24', 200.00, 225.00, 34.00, 459.00, 'Pending', NULL, NULL, NULL, '2025-01-25 08:00:00');

-- 19. INSERT INTO ESCALATION  
INSERT INTO ESCALATION (EscalationID, RequestID, EscalationLevel, EscalatedByManagerID, EscalationReason, EscalationDate, TargetResolutionDate, ResolutionDate, ResolutionNotes, EscalationStatus)
VALUES 
(1301, 3002, 1, 202, 'High priority electrical issue needs immediate attention', '2025-01-11 16:00:00', '2025-01-13', '2025-01-13 16:30:00', 'Resolved - outlet repaired successfully', 'Resolved'),
(1302, 3003, 1, 201, 'Heating issue during cold weather', '2025-01-12 10:00:00', '2025-01-14', '2025-01-14 17:30:00', 'Resolved - heater fixed and tested', 'Resolved'),
(1303, 3007, 1, 204, 'Pest control issue escalating', '2025-01-16 09:00:00', '2025-01-18', '2025-01-18 12:30:00', 'Resolved - ant treatment completed', 'Resolved'),
(1304, 3001, 1, 201, 'Water damage risk from leak', '2025-01-10 12:00:00', '2025-01-12', '2025-01-12 14:30:00', 'Resolved - faucet replaced', 'Resolved'),
(1305, 3005, 1, 203, 'Water waste concern', '2025-01-14 11:00:00', '2025-01-16', '2025-01-16 13:30:00', 'Resolved - toilet mechanism replaced', 'Resolved'),
(1306, 3009, 2, 204, 'Safety concern with cracked glass', '2025-01-18 14:00:00', '2025-01-25', '2025-01-25 16:30:00', 'Resolved - window replaced', 'Resolved'),
(1307, 3002, 2, 204, 'Electrical safety concern', '2025-01-11 09:00:00', '2025-01-13', '2025-01-13 16:30:00', 'Resolved - comprehensive electrical check completed', 'Resolved'),
(1308, 3003, 2, 204, 'Multiple units affected', '2025-01-12 08:00:00', '2025-01-14', '2025-01-14 17:30:00', 'Resolved - HVAC system repaired', 'Resolved'),
(1309, 3001, 2, 204, 'Repeat issue escalation', '2025-01-10 10:00:00', '2025-01-12', '2025-01-12 14:30:00', 'Resolved - permanent fix applied', 'Resolved'),
(1310, 3008, 1, 205, 'Security concern', '2025-01-17 17:00:00', '2025-01-19', '2025-01-19 11:30:00', 'Resolved - lock replaced', 'Resolved');

-- 20. INSERT INTO NOTIFICATION  
INSERT INTO NOTIFICATION (ResidentID, RequestID, NotificationType, Subject, MessageBody, Priority, DeliveryChannel, ScheduledSendDate, ActualSentDate, DeliveryStatus, ReadDate)
VALUES 
(1001, 3001, 'Request Received', 'Maintenance Request Received', 'Your maintenance request for the leaking faucet has been received.', 'Normal', 'Email', '2025-01-10 10:30:00', '2025-01-10 10:30:00', 'Delivered', '2025-01-10 11:00:00'),
(1002, 3002, 'Request Received', 'Maintenance Request Received', 'Your request for the outlet repair has been received.', 'High', 'Email', '2025-01-11 15:00:00', '2025-01-11 15:00:00', 'Delivered', '2025-01-11 15:30:00'),
(1003, 3003, 'Request Received', 'Heating Request Received', 'We have received your heating repair request.', 'High', 'SMS', '2025-01-12 08:30:00', '2025-01-12 08:30:00', 'Delivered', '2025-01-12 09:00:00'),
(1001, 3001, 'Work Scheduled', 'Maintenance Scheduled', 'Your maintenance work has been scheduled for 01/12/2025.', 'Normal', 'Email', '2025-01-10 14:00:00', '2025-01-10 14:00:00', 'Delivered', '2025-01-10 14:15:00'),
(1002, 3002, 'Work In Progress', 'Work Started', 'Technician has started work on your electrical issue.', 'Normal', 'Email', '2025-01-13 09:00:00', '2025-01-13 09:00:00', 'Delivered', '2025-01-13 09:30:00'),
(1003, NULL, 'General', 'Building Maintenance Notice', 'Annual fire alarm testing scheduled for next week.', 'Normal', 'Email', '2025-01-15 09:00:00', '2025-01-15 09:00:00', 'Delivered', '2025-01-15 10:00:00'),
(1001, NULL, 'Lease Renewal', 'Lease Renewal Reminder', 'Your lease expires in 330 days. Please contact us to discuss renewal.', 'Normal', 'Email', '2025-02-05 08:00:00', '2025-02-05 08:00:00', 'Delivered', '2025-02-05 08:30:00'),
(1004, NULL, 'Payment Reminder', 'Rent Due Reminder', 'Your monthly rent payment is due in 3 days.', 'Normal', 'Email', '2025-01-28 09:00:00', '2025-01-28 09:00:00', 'Delivered', '2025-01-28 09:15:00'),
(1007, 3007, 'Request Received', 'Pest Control Request Received', 'We have received your pest control request.', 'High', 'SMS', '2025-01-16 08:00:00', '2025-01-16 08:00:00', 'Delivered', '2025-01-16 08:30:00'),
(1002, NULL, 'Building Update', 'Pool Maintenance', 'The pool will be closed for maintenance this weekend.', 'Low', 'Email', '2025-01-20 10:00:00', '2025-01-20 10:00:00', 'Delivered', '2025-01-20 10:30:00');

-- 21. INSERT INTO PAYMENT_TRANSACTION  
INSERT INTO PAYMENT_TRANSACTION (LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid, PaymentMethod, ReferenceNumber, TransactionStatus)
VALUES 
(5001, 1001, 'Rent', '2025-01-01', '2025-01-01', 2000.00, 2000.00, 'ACH Transfer', 'ACH-202501-001', 'Completed'),
(5002, 1002, 'Rent', '2025-02-01', '2025-02-01', 2800.00, 2800.00, 'Check', 'CHK-202502-001', 'Completed'),
(5003, 1003, 'Rent', '2025-03-01', '2025-03-01', 1400.00, 1400.00, 'Credit Card', 'CC-202503-001', 'Completed'),
(5001, 1001, 'Rent', '2025-02-01', '2025-02-01', 2000.00, 2000.00, 'ACH Transfer', 'ACH-202502-001', 'Completed'),
(5002, 1002, 'Rent', '2025-03-01', '2025-03-01', 2800.00, 2800.00, 'Check', 'CHK-202503-001', 'Completed'),
(5003, 1003, 'Rent', '2025-02-01', '2025-02-01', 1400.00, 1400.00, 'Credit Card', 'CC-202502-001', 'Completed'),
(5001, 1001, 'Security Deposit', '2024-12-15', '2024-12-15', 2000.00, 2000.00, 'Check', 'CHK-DEPOSIT-001', 'Completed'),
(5002, 1002, 'Security Deposit', '2025-01-20', '2025-01-20', 2800.00, 2800.00, 'ACH Transfer', 'ACH-DEPOSIT-001', 'Completed'),
(5002, 1002, 'Pet Deposit', '2025-01-20', '2025-01-20', 500.00, 500.00, 'Credit Card', 'CC-PET-001', 'Completed'),
(5006, 1007, 'Security Deposit', '2024-12-20', '2024-12-20', 2600.00, 2600.00, 'ACH Transfer', 'ACH-DEPOSIT-002', 'Completed');
