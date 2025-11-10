USE [ApartmentHub];
GO

-- View all data from all tables in the Apartment Management Database

PRINT '========================================';
PRINT '1. BUILDING';
PRINT '========================================';
SELECT * FROM BUILDING ORDER BY BuildingID;

PRINT '========================================';
PRINT '2. APARTMENT_UNIT';
PRINT '========================================';
SELECT * FROM APARTMENT_UNIT ORDER BY UnitID;

PRINT '========================================';
PRINT '3. RESIDENT';
PRINT '========================================';
SELECT * FROM RESIDENT ORDER BY ResidentID;

PRINT '========================================';
PRINT '4. PROPERTY_MANAGER';
PRINT '========================================';
SELECT * FROM PROPERTY_MANAGER ORDER BY ManagerID;

PRINT '========================================';
PRINT '5. VENDOR_COMPANY';
PRINT '========================================';
SELECT * FROM VENDOR_COMPANY ORDER BY VendorID;

PRINT '========================================';
PRINT '6. MAINTENANCE_CATEGORY';
PRINT '========================================';
SELECT * FROM MAINTENANCE_CATEGORY ORDER BY CategoryID;

PRINT '========================================';
PRINT '7. AMENITY';
PRINT '========================================';
SELECT * FROM AMENITY ORDER BY AmenityID;

PRINT '========================================';
PRINT '8. WORKER';
PRINT '========================================';
SELECT * FROM WORKER ORDER BY WorkerID;

PRINT '========================================';
PRINT '9. LEASE';
PRINT '========================================';
SELECT * FROM LEASE ORDER BY LeaseID;

PRINT '========================================';
PRINT '10. EMERGENCY_CONTACT';
PRINT '========================================';
SELECT * FROM EMERGENCY_CONTACT ORDER BY ContactID;

PRINT '========================================';
PRINT '11. LEASE_OCCUPANT';
PRINT '========================================';
SELECT * FROM LEASE_OCCUPANT ORDER BY OccupantID;

PRINT '========================================';
PRINT '12. BUILDING_AMENITY';
PRINT '========================================';
SELECT * FROM BUILDING_AMENITY ORDER BY BuildingAmenityID;

PRINT '========================================';
PRINT '13. APT_UNIT_AMENITY';
PRINT '========================================';
SELECT * FROM APT_UNIT_AMENITY ORDER BY UnitAmenityID;

PRINT '========================================';
PRINT '14. BUILDING_MANAGER_ASSIGNMENT';
PRINT '========================================';
SELECT * FROM BUILDING_MANAGER_ASSIGNMENT ORDER BY AssignmentID;

PRINT '========================================';
PRINT '15. MAINTENANCE_REQUEST';
PRINT '========================================';
SELECT * FROM MAINTENANCE_REQUEST ORDER BY RequestID;

PRINT '========================================';
PRINT '16. WORK_ORDER';
PRINT '========================================';
SELECT * FROM WORK_ORDER ORDER BY WorkOrderID;

PRINT '========================================';
PRINT '17. WORKER_ASSIGNMENT';
PRINT '========================================';
SELECT * FROM WORKER_ASSIGNMENT ORDER BY AssignmentID;

PRINT '========================================';
PRINT '18. INVOICE';
PRINT '========================================';
SELECT * FROM INVOICE ORDER BY InvoiceDate;

PRINT '========================================';
PRINT '19. ESCALATION';
PRINT '========================================';
SELECT * FROM ESCALATION ORDER BY EscalationID;

PRINT '========================================';
PRINT '20. NOTIFICATION';
PRINT '========================================';
SELECT * FROM NOTIFICATION ORDER BY NotificationID;

PRINT '========================================';
PRINT '21. PAYMENT_TRANSACTION';
PRINT '========================================';
SELECT * FROM PAYMENT_TRANSACTION ORDER BY TransactionDate;

PRINT '========================================';
PRINT 'SUMMARY - Record Counts';
PRINT '========================================';
SELECT 'BUILDING' AS TableName, COUNT(*) AS RecordCount FROM BUILDING
UNION ALL SELECT 'APARTMENT_UNIT', COUNT(*) FROM APARTMENT_UNIT
UNION ALL SELECT 'RESIDENT', COUNT(*) FROM RESIDENT
UNION ALL SELECT 'PROPERTY_MANAGER', COUNT(*) FROM PROPERTY_MANAGER
UNION ALL SELECT 'VENDOR_COMPANY', COUNT(*) FROM VENDOR_COMPANY
UNION ALL SELECT 'MAINTENANCE_CATEGORY', COUNT(*) FROM MAINTENANCE_CATEGORY
UNION ALL SELECT 'AMENITY', COUNT(*) FROM AMENITY
UNION ALL SELECT 'WORKER', COUNT(*) FROM WORKER
UNION ALL SELECT 'LEASE', COUNT(*) FROM LEASE
UNION ALL SELECT 'EMERGENCY_CONTACT', COUNT(*) FROM EMERGENCY_CONTACT
UNION ALL SELECT 'LEASE_OCCUPANT', COUNT(*) FROM LEASE_OCCUPANT
UNION ALL SELECT 'BUILDING_AMENITY', COUNT(*) FROM BUILDING_AMENITY
UNION ALL SELECT 'APT_UNIT_AMENITY', COUNT(*) FROM APT_UNIT_AMENITY
UNION ALL SELECT 'BUILDING_MANAGER_ASSIGNMENT', COUNT(*) FROM BUILDING_MANAGER_ASSIGNMENT
UNION ALL SELECT 'MAINTENANCE_REQUEST', COUNT(*) FROM MAINTENANCE_REQUEST
UNION ALL SELECT 'WORK_ORDER', COUNT(*) FROM WORK_ORDER
UNION ALL SELECT 'WORKER_ASSIGNMENT', COUNT(*) FROM WORKER_ASSIGNMENT
UNION ALL SELECT 'INVOICE', COUNT(*) FROM INVOICE
UNION ALL SELECT 'ESCALATION', COUNT(*) FROM ESCALATION
UNION ALL SELECT 'NOTIFICATION', COUNT(*) FROM NOTIFICATION
UNION ALL SELECT 'PAYMENT_TRANSACTION', COUNT(*) FROM PAYMENT_TRANSACTION
ORDER BY TableName;