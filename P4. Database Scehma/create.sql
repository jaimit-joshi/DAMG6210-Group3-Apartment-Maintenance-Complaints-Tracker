-- =====================================================
-- APARTMENT MANAGEMENT DATABASE
-- =====================================================

-- =====================================================
-- DROP ALL EXISTING OBJECTS (IN REVERSE DEPENDENCY ORDER)
-- =====================================================

IF OBJECT_ID('dbo.PAYMENT_TRANSACTION', 'U') IS NOT NULL DROP TABLE dbo.PAYMENT_TRANSACTION;
IF OBJECT_ID('dbo.NOTIFICATION', 'U') IS NOT NULL DROP TABLE dbo.NOTIFICATION;
IF OBJECT_ID('dbo.ESCALATION', 'U') IS NOT NULL DROP TABLE dbo.ESCALATION;
IF OBJECT_ID('dbo.INVOICE', 'U') IS NOT NULL DROP TABLE dbo.INVOICE;
IF OBJECT_ID('dbo.WORKER_ASSIGNMENT', 'U') IS NOT NULL DROP TABLE dbo.WORKER_ASSIGNMENT;
IF OBJECT_ID('dbo.WORK_ORDER', 'U') IS NOT NULL DROP TABLE dbo.WORK_ORDER;
IF OBJECT_ID('dbo.MAINTENANCE_REQUEST', 'U') IS NOT NULL DROP TABLE dbo.MAINTENANCE_REQUEST;
IF OBJECT_ID('dbo.BUILDING_MANAGER_ASSIGNMENT', 'U') IS NOT NULL DROP TABLE dbo.BUILDING_MANAGER_ASSIGNMENT;
IF OBJECT_ID('dbo.APT_UNIT_AMENITY', 'U') IS NOT NULL DROP TABLE dbo.APT_UNIT_AMENITY;
IF OBJECT_ID('dbo.BUILDING_AMENITY', 'U') IS NOT NULL DROP TABLE dbo.BUILDING_AMENITY;
IF OBJECT_ID('dbo.LEASE_OCCUPANT', 'U') IS NOT NULL DROP TABLE dbo.LEASE_OCCUPANT;
IF OBJECT_ID('dbo.EMERGENCY_CONTACT', 'U') IS NOT NULL DROP TABLE dbo.EMERGENCY_CONTACT;
IF OBJECT_ID('dbo.LEASE', 'U') IS NOT NULL DROP TABLE dbo.LEASE;
IF OBJECT_ID('dbo.WORKER', 'U') IS NOT NULL DROP TABLE dbo.WORKER;
IF OBJECT_ID('dbo.AMENITY', 'U') IS NOT NULL DROP TABLE dbo.AMENITY;
IF OBJECT_ID('dbo.MAINTENANCE_CATEGORY', 'U') IS NOT NULL DROP TABLE dbo.MAINTENANCE_CATEGORY;
IF OBJECT_ID('dbo.VENDOR_COMPANY', 'U') IS NOT NULL DROP TABLE dbo.VENDOR_COMPANY;
IF OBJECT_ID('dbo.PROPERTY_MANAGER', 'U') IS NOT NULL DROP TABLE dbo.PROPERTY_MANAGER;
IF OBJECT_ID('dbo.RESIDENT', 'U') IS NOT NULL DROP TABLE dbo.RESIDENT;
IF OBJECT_ID('dbo.APARTMENT_UNIT', 'U') IS NOT NULL DROP TABLE dbo.APARTMENT_UNIT;
IF OBJECT_ID('dbo.BUILDING', 'U') IS NOT NULL DROP TABLE dbo.BUILDING;

-- =====================================================
-- CREATE TABLES
-- =====================================================

-- 1. BUILDING Table
CREATE TABLE BUILDING (
    BuildingID INT NOT NULL,
    BuildingName VARCHAR(150) NOT NULL,
    StreetAddress VARCHAR(100) NOT NULL,
    City VARCHAR(30) NOT NULL,
    State VARCHAR(20) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL,
    YearBuilt INT NOT NULL,
    NumberOfFloors INT NOT NULL,
    TotalUnits INT NOT NULL,
    BuildingType VARCHAR(50) NOT NULL,
    HasElevator BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (BuildingID),
    CHECK (YearBuilt >= 1900 AND YearBuilt <= YEAR(GETDATE())),
    CHECK (NumberOfFloors > 0),
    CHECK (TotalUnits > 0)
);

-- 2. APARTMENT_UNIT Table
CREATE TABLE APARTMENT_UNIT (
    UnitID INT NOT NULL,
    BuildingID INT NOT NULL,
    UnitNumber VARCHAR(30) NOT NULL,
    FloorNumber INT NOT NULL,
    UnitType VARCHAR(50) NOT NULL,
    SquareFootage INT NOT NULL,
    NumberBedrooms INT NOT NULL,
    NumberBathrooms DECIMAL(3,2) NOT NULL,
    BaseRentAmount DECIMAL(10,2) NOT NULL,
    UnitStatus VARCHAR(50) NOT NULL DEFAULT 'Available',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (UnitID),
    FOREIGN KEY (BuildingID) REFERENCES BUILDING(BuildingID),
    UNIQUE (BuildingID, UnitNumber),
    CHECK (SquareFootage > 0),
    CHECK (NumberBedrooms >= 0),
    CHECK (NumberBathrooms > 0),
    CHECK (BaseRentAmount >= 0)
);

-- 3. RESIDENT Table
CREATE TABLE RESIDENT (
    ResidentID INT NOT NULL,
    FirstName VARCHAR(150) NOT NULL,
    LastName VARCHAR(150) NOT NULL,
    DateOfBirth DATE NOT NULL,
    SSNLast4 VARCHAR(4),
    PrimaryPhone VARCHAR(10) NOT NULL,
    AlternatePhone VARCHAR(10),
    EmailAddress VARCHAR(100) NOT NULL,
    CurrentAddress VARCHAR(300),
    AccountStatus VARCHAR(50) NOT NULL DEFAULT 'Active',
    BackgroundCheckStatus VARCHAR(50),
    BackgroundCheckDate DATE,
    CreditScore INT,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (ResidentID),
    CHECK (CreditScore IS NULL OR (CreditScore >= 300 AND CreditScore <= 850))
);

-- 4. PROPERTY_MANAGER Table
CREATE TABLE PROPERTY_MANAGER (
    ManagerID INT NOT NULL,
    EmployeeID VARCHAR(50) NOT NULL UNIQUE,
    FirstName VARCHAR(150) NOT NULL,
    LastName VARCHAR(150) NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(10) NOT NULL,
    JobTitle VARCHAR(50) NOT NULL,
    Department VARCHAR(50),
    HireDate DATE NOT NULL,
    ManagerRole VARCHAR(40) NOT NULL,
    MaxApprovalLimit INT,
    AccountStatus VARCHAR(30) NOT NULL DEFAULT 'Active',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (ManagerID),
    CHECK (MaxApprovalLimit >= 0)
);

-- 5. VENDOR_COMPANY Table
CREATE TABLE VENDOR_COMPANY (
    VendorID INT NOT NULL,
    CompanyName VARCHAR(100) NOT NULL,
    TaxID VARCHAR(50) NOT NULL UNIQUE,
    PrimaryContactName VARCHAR(150) NOT NULL,
    PhoneNumber VARCHAR(10) NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL,
    StreetAddress VARCHAR(100) NOT NULL,
    City VARCHAR(30) NOT NULL,
    State VARCHAR(30) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL,
    LicenseNumber VARCHAR(20),
    LicenseExpiryDate DATE,
    InsurancePolicyNumber VARCHAR(50),
    InsuranceExpiryDate DATE,
    VendorStatus VARCHAR(15) NOT NULL DEFAULT 'Active',
    IsPreferred BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (VendorID)
);

-- 6. MAINTENANCE_CATEGORY Table
CREATE TABLE MAINTENANCE_CATEGORY (
    CategoryID INT NOT NULL,
    CategoryCode VARCHAR(50) NOT NULL UNIQUE,
    CategoryName VARCHAR(150) NOT NULL,
    CategoryDescription VARCHAR(300),
    DefaultPriority VARCHAR(50) NOT NULL,
    TargetResponseHours DECIMAL(5,2) NOT NULL,
    TargetResolutionHours DECIMAL(5,2) NOT NULL,
    RequiresWorkOrder BIT NOT NULL DEFAULT 1,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (CategoryID),
    CHECK (TargetResponseHours > 0),
    CHECK (TargetResolutionHours > 0)
);

-- 7. AMENITY Table
CREATE TABLE AMENITY (
    AmenityID INT NOT NULL,
    AmenityCode VARCHAR(30) NOT NULL UNIQUE,
    AmenityName VARCHAR(40) NOT NULL,
    AmenityType VARCHAR(50) NOT NULL,
    Description VARCHAR(300),
    IsActive BIT NOT NULL DEFAULT 1,
    PRIMARY KEY (AmenityID)
);

-- 8. WORKER Table
CREATE TABLE WORKER (
    WorkerID INT NOT NULL,
    VendorID INT NOT NULL,
    FirstName VARCHAR(150) NOT NULL,
    LastName VARCHAR(150) NOT NULL,
    EmployeeID VARCHAR(20),
    WorkerType VARCHAR(20) NOT NULL,
    PhoneNumber VARCHAR(10) NOT NULL,
    EmailAddress VARCHAR(100),
    HourlyRate DECIMAL(6,2),
    LicenseNumber VARCHAR(50),
    LicenseExpiryDate DATE,
    Specialization VARCHAR(30),
    WorkerStatus VARCHAR(15) NOT NULL DEFAULT 'Active',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (WorkerID),
    FOREIGN KEY (VendorID) REFERENCES VENDOR_COMPANY(VendorID),
    CHECK (HourlyRate > 0)
);

-- 9. LEASE Table
CREATE TABLE LEASE (
    LeaseID INT NOT NULL,
    ResidentID INT NOT NULL,
    UnitID INT NOT NULL,
    PreparedByManagerID INT NOT NULL,
    LeaseStartDate DATE NOT NULL,
    LeaseEndDate DATE NOT NULL,
    MonthlyRentAmount DECIMAL(10,2) NOT NULL,
    SecurityDepositAmount DECIMAL(10,2) NOT NULL,
    PetDepositAmount DECIMAL(10,2) DEFAULT 0,
    PaymentDueDay INT NOT NULL,
    LateFeeAmount DECIMAL(10,2) DEFAULT 0,
    GracePeriodDays INT DEFAULT 5,
    LeaseStatus VARCHAR(50) NOT NULL DEFAULT 'Draft',
    SignedDate DATE,
    MoveInDate DATE,
    MoveOutDate DATE,
    TerminationReason VARCHAR(200),
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (LeaseID),
    FOREIGN KEY (ResidentID) REFERENCES RESIDENT(ResidentID),
    FOREIGN KEY (UnitID) REFERENCES APARTMENT_UNIT(UnitID),
    FOREIGN KEY (PreparedByManagerID) REFERENCES PROPERTY_MANAGER(ManagerID),
    CHECK (LeaseEndDate > LeaseStartDate),
    CHECK (MonthlyRentAmount > 0),
    CHECK (SecurityDepositAmount >= 0),
    CHECK (PetDepositAmount >= 0),
    CHECK (PaymentDueDay >= 1 AND PaymentDueDay <= 31),
    CHECK (LateFeeAmount >= 0),
    CHECK (GracePeriodDays >= 0)
);

-- 10. EMERGENCY_CONTACT Table
CREATE TABLE EMERGENCY_CONTACT (
    ContactID INT NOT NULL,
    ResidentID INT NOT NULL,
    ContactName VARCHAR(150) NOT NULL,
    Relationship VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(10) NOT NULL,
    AlternatePhone VARCHAR(10),
    EmailAddress VARCHAR(100),
    IsPrimary BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (ContactID),
    FOREIGN KEY (ResidentID) REFERENCES RESIDENT(ResidentID)
);

-- 11. LEASE_OCCUPANT Table
CREATE TABLE LEASE_OCCUPANT (
    OccupantID INT NOT NULL,
    LeaseID INT NOT NULL,
    ResidentID INT NOT NULL,
    OccupantType VARCHAR(100) NOT NULL,
    MoveInDate DATE NOT NULL,
    MoveOutDate DATE,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (OccupantID),
    FOREIGN KEY (LeaseID) REFERENCES LEASE(LeaseID),
    FOREIGN KEY (ResidentID) REFERENCES RESIDENT(ResidentID)
);

-- 12. BUILDING_AMENITY Table (Bridge table - no direct FK to BUILDING or AMENITY in other tables)
CREATE TABLE BUILDING_AMENITY (
    BuildingAmenityID INT NOT NULL,
    BuildingID INT NOT NULL,
    AmenityID INT NOT NULL,
    AmenityLocation VARCHAR(50),
    AccessRestrictions VARCHAR(50),
    AdditionalFee DECIMAL(10,2) DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (BuildingAmenityID),
    FOREIGN KEY (BuildingID) REFERENCES BUILDING(BuildingID),
    FOREIGN KEY (AmenityID) REFERENCES AMENITY(AmenityID),
    CHECK (AdditionalFee >= 0)
);

-- 13. APT_UNIT_AMENITY Table (Bridge table - no direct FK to APARTMENT_UNIT or AMENITY in other tables)
CREATE TABLE APT_UNIT_AMENITY (
    UnitAmenityID INT NOT NULL,
    UnitID INT NOT NULL,
    AmenityID INT NOT NULL,
    InstallationDate DATE,
    Condition VARCHAR(100),
    LastServiceDate DATE,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (UnitAmenityID),
    FOREIGN KEY (UnitID) REFERENCES APARTMENT_UNIT(UnitID),
    FOREIGN KEY (AmenityID) REFERENCES AMENITY(AmenityID)
);

-- 14. BUILDING_MANAGER_ASSIGNMENT Table
CREATE TABLE BUILDING_MANAGER_ASSIGNMENT (
    AssignmentID INT NOT NULL,
    BuildingID INT NOT NULL,
    ManagerID INT NOT NULL,
    AssignmentStartDate DATE NOT NULL,
    AssignmentEndDate DATE,
    IsPrimary BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (AssignmentID),
    FOREIGN KEY (BuildingID) REFERENCES BUILDING(BuildingID),
    FOREIGN KEY (ManagerID) REFERENCES PROPERTY_MANAGER(ManagerID)
);

-- 15. MAINTENANCE_REQUEST Table
CREATE TABLE MAINTENANCE_REQUEST (
    RequestID INT NOT NULL,
    ResidentID INT NOT NULL,
    UnitID INT NOT NULL,
    CategoryID INT NOT NULL,
    RequestTitle VARCHAR(75) NOT NULL,
    RequestDescription VARCHAR(500) NOT NULL,
    RequestPriority VARCHAR(100) NOT NULL,
    RequestStatus VARCHAR(100) NOT NULL DEFAULT 'Submitted',
    SubmittedDate DATETIME NOT NULL DEFAULT GETDATE(),
    AcknowledgedDate DATETIME,
    CompletedDate DATETIME,
    PermissionToEnter BIT NOT NULL DEFAULT 0,
    PetOnPremises BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (RequestID),
    FOREIGN KEY (ResidentID) REFERENCES RESIDENT(ResidentID),
    FOREIGN KEY (UnitID) REFERENCES APARTMENT_UNIT(UnitID),
    FOREIGN KEY (CategoryID) REFERENCES MAINTENANCE_CATEGORY(CategoryID)
);

-- 16. WORK_ORDER Table
CREATE TABLE WORK_ORDER (
    WorkOrderID INT NOT NULL,
    WorkOrderNumber VARCHAR(50) NOT NULL UNIQUE,
    RequestID INT,
    UnitID INT NOT NULL,
    CreatedByManagerID INT NOT NULL,
    VendorID INT,
    WorkType VARCHAR(50) NOT NULL,
    WorkDescription VARCHAR(200) NOT NULL,
    ScheduledDate DATE,
    StartDateTime DATETIME,
    CompletionDateTime DATETIME,
    WorkStatus VARCHAR(15) NOT NULL DEFAULT 'Pending',
    EstimatedCost DECIMAL(10,2),
    ActualCost DECIMAL(10,2),
    RequiresApproval BIT NOT NULL DEFAULT 0,
    ApprovedByManagerID INT,
    ApprovalDate DATETIME,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (WorkOrderID),
    FOREIGN KEY (RequestID) REFERENCES MAINTENANCE_REQUEST(RequestID),
    FOREIGN KEY (UnitID) REFERENCES APARTMENT_UNIT(UnitID),
    FOREIGN KEY (CreatedByManagerID) REFERENCES PROPERTY_MANAGER(ManagerID),
    FOREIGN KEY (VendorID) REFERENCES VENDOR_COMPANY(VendorID),
    FOREIGN KEY (ApprovedByManagerID) REFERENCES PROPERTY_MANAGER(ManagerID),
    CHECK (EstimatedCost >= 0),
    CHECK (ActualCost >= 0)
);

-- 17. WORKER_ASSIGNMENT Table
CREATE TABLE WORKER_ASSIGNMENT (
    AssignmentID INT NOT NULL,
    WorkOrderID INT NOT NULL,
    WorkerID INT NOT NULL,
    AssignedDate DATETIME NOT NULL DEFAULT GETDATE(),
    StartTime DATETIME,
    EndTime DATETIME,
    HoursWorked DECIMAL(5,2),
    WorkerRole VARCHAR(30) NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (AssignmentID),
    FOREIGN KEY (WorkOrderID) REFERENCES WORK_ORDER(WorkOrderID),
    FOREIGN KEY (WorkerID) REFERENCES WORKER(WorkerID),
    CHECK (HoursWorked >= 0)
);

-- 18. INVOICE Table
CREATE TABLE INVOICE (
    InvoiceID UNIQUEIDENTIFIER DEFAULT NEWID(),
    InvoiceNumber VARCHAR(70) NOT NULL UNIQUE,
    WorkOrderID INT NOT NULL,
    VendorID INT NOT NULL,
    ApprovedByManagerID INT,
    InvoiceDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    LaborCost DECIMAL(10,2) DEFAULT 0,
    MaterialCost DECIMAL(10,2) DEFAULT 0,
    TaxAmount DECIMAL(10,2) DEFAULT 0,
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(30) NOT NULL DEFAULT 'Pending',
    PaymentDate DATE,
    PaymentMethod VARCHAR(100),
    PaymentReference VARCHAR(200),
    ApprovalDate DATETIME,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (InvoiceID),
    FOREIGN KEY (WorkOrderID) REFERENCES WORK_ORDER(WorkOrderID),
    FOREIGN KEY (VendorID) REFERENCES VENDOR_COMPANY(VendorID),
    FOREIGN KEY (ApprovedByManagerID) REFERENCES PROPERTY_MANAGER(ManagerID),
    CHECK (LaborCost >= 0),
    CHECK (MaterialCost >= 0),
    CHECK (TaxAmount >= 0),
    CHECK (TotalAmount >= 0)
);

-- 19. ESCALATION Table
CREATE TABLE ESCALATION (
    EscalationID INT NOT NULL,
    RequestID INT NOT NULL,
    EscalationLevel INT NOT NULL,
    EscalatedByManagerID INT NOT NULL,
    EscalationReason VARCHAR(500) NOT NULL,
    EscalationDate DATETIME NOT NULL DEFAULT GETDATE(),
    TargetResolutionDate DATE,
    ResolutionDate DATETIME,
    ResolutionNotes VARCHAR(500),
    EscalationStatus VARCHAR(50) NOT NULL DEFAULT 'Active',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (EscalationID),
    FOREIGN KEY (RequestID) REFERENCES MAINTENANCE_REQUEST(RequestID),
    FOREIGN KEY (EscalatedByManagerID) REFERENCES PROPERTY_MANAGER(ManagerID),
    CHECK (EscalationLevel >= 1)
);

-- 20. NOTIFICATION Table (ONLY TABLE WITH IDENTITY)
CREATE TABLE NOTIFICATION (
    NotificationID INT IDENTITY(1500,1),
    ResidentID INT NOT NULL,
    RequestID INT,
    NotificationType VARCHAR(100) NOT NULL,
    Subject VARCHAR(200) NOT NULL,
    MessageBody VARCHAR(500) NOT NULL,
    Priority VARCHAR(50) NOT NULL DEFAULT 'Normal',
    DeliveryChannel VARCHAR(50) NOT NULL,
    ScheduledSendDate DATETIME,
    ActualSentDate DATETIME,
    DeliveryStatus VARCHAR(60) NOT NULL DEFAULT 'Pending',
    ReadDate DATETIME,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (NotificationID),
    FOREIGN KEY (ResidentID) REFERENCES RESIDENT(ResidentID),
    FOREIGN KEY (RequestID) REFERENCES MAINTENANCE_REQUEST(RequestID)
);

-- 21. PAYMENT_TRANSACTION Table
CREATE TABLE PAYMENT_TRANSACTION (
    TransactionID UNIQUEIDENTIFIER DEFAULT NEWID(),
    LeaseID INT NOT NULL,
    ResidentID INT NOT NULL,
    TransactionType VARCHAR(50) NOT NULL,
    TransactionDate DATE NOT NULL,
    DueDate DATE,
    AmountDue DECIMAL(10,2),
    AmountPaid DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(100) NOT NULL,
    ReferenceNumber VARCHAR(200),
    TransactionStatus VARCHAR(40) NOT NULL DEFAULT 'Pending',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY (TransactionID),
    FOREIGN KEY (LeaseID) REFERENCES LEASE(LeaseID),
    FOREIGN KEY (ResidentID) REFERENCES RESIDENT(ResidentID),
    CHECK (AmountDue >= 0),
    CHECK (AmountPaid >= 0)
);