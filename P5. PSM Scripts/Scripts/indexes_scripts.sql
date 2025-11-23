USE ApartmentHub;
GO

-- create filtered index on MAINTENANCE_REQUEST for only 'Submitted' rows
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'IX_MAINT_REQ_Submitted_Filter'
      AND object_id = OBJECT_ID('dbo.MAINTENANCE_REQUEST')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_MAINT_REQ_Submitted_Filter
    ON dbo.MAINTENANCE_REQUEST (ResidentID, CategoryID)
    INCLUDE (SubmittedDate, RequestTitle)
    WHERE RequestStatus = 'Submitted';
END
GO

-- verify
SELECT t.name AS TableName, i.name AS IndexName, i.type_desc, i.is_unique, i.fill_factor
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name = 'IX_MAINT_REQ_Submitted_Filter';
GO

-- =========================================================================================================

-- add persisted computed column (safe division: NULLIF avoids divide-by-zero)
IF COL_LENGTH('dbo.APARTMENT_UNIT','RentPerSqFt') IS NULL
BEGIN
    ALTER TABLE dbo.APARTMENT_UNIT
    ADD RentPerSqFt AS (CASE WHEN NULLIF(SquareFootage,0) IS NULL THEN NULL 
                              ELSE BaseRentAmount / NULLIF(SquareFootage,0) END) PERSISTED;
END
GO

-- create index on the computed column
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = 'IX_APT_RentPerSqFt' AND object_id = OBJECT_ID('dbo.APARTMENT_UNIT')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_APT_RentPerSqFt
    ON dbo.APARTMENT_UNIT (RentPerSqFt)
    INCLUDE (BuildingID, UnitStatus, UnitNumber);
END
GO

-- verify columns on index
SELECT t.name AS TableName, i.name AS IndexName, ic.index_column_id, c.name AS ColumnName,
       CASE WHEN ic.is_included_column=1 THEN 'INCLUDED' ELSE 'KEY' END AS ColumnType
FROM sys.indexes i
JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
JOIN sys.tables t ON t.object_id = i.object_id
WHERE i.name = 'IX_APT_RentPerSqFt'
ORDER BY ic.index_column_id;
GO

-- =========================================================================================================


IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_WORK_ORDER_Status_Sched' AND object_id = OBJECT_ID('dbo.WORK_ORDER'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_WORK_ORDER_Status_Sched
    ON dbo.WORK_ORDER (WorkStatus, ScheduledDate)
    INCLUDE (WorkOrderNumber, VendorID, EstimatedCost, ActualCost);
END
GO

-- verify
SELECT t.name AS TableName, i.name AS IndexName, i.type_desc
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name = 'IX_WORK_ORDER_Status_Sched';
GO
