
-- ==============================================================================
-- Procedure 1: LIST OUTSTANDING INVOICES FOR RESIDENT
-- ==============================================================================

IF OBJECT_ID('dbo.usp_ListOutstandingInvoicesForResident','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ListOutstandingInvoicesForResident;
GO

CREATE OR ALTER PROCEDURE dbo.usp_ListOutstandingInvoicesForResident
    @ResidentID INT
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX) = N'';
    DECLARE @selectExtras NVARCHAR(400) = N'';
    DECLARE @needDecrypt BIT = 0;

    ----------------------------------------------------------------
    -- Decide which payment method / reference columns are available
    ----------------------------------------------------------------
    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod_Enc') IS NOT NULL
    BEGIN
        -- encrypted payment method present
        SET @selectExtras += N', CONVERT(VARCHAR(200), DecryptByKey(PaymentMethod_Enc)) AS PaymentMethod_Decrypted';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod') IS NOT NULL
    BEGIN
        SET @selectExtras += N', PaymentMethod';
    END
    ELSE
    BEGIN
        SET @selectExtras += N', NULL AS PaymentMethod';
    END

    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber_Enc') IS NOT NULL
    BEGIN
        SET @selectExtras += N', CONVERT(VARCHAR(300), DecryptByKey(ReferenceNumber_Enc)) AS ReferenceNumber_Decrypted';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber') IS NOT NULL
    BEGIN
        SET @selectExtras += N', ReferenceNumber';
    END
    ELSE
    BEGIN
        SET @selectExtras += N', NULL AS ReferenceNumber';
    END

    ----------------------------------------------------------------
    -- Build the final SQL; always reference only columns guaranteed by create.sql
    ----------------------------------------------------------------
    SET @sql = N'
    SELECT
        pt.TransactionID,
        pt.LeaseID,
        pt.ResidentID,
        pt.TransactionType,
        pt.TransactionDate,
        pt.DueDate,
        pt.AmountDue,
        pt.AmountPaid,
        (pt.AmountDue - ISNULL(pt.AmountPaid,0)) AS AmountOutstanding
        ' + @selectExtras + N',
        pt.TransactionStatus,
        pt.CreatedDate,
        pt.ModifiedDate
    FROM dbo.PAYMENT_TRANSACTION pt
    WHERE pt.ResidentID = @ResidentIdParam
      AND (ISNULL(pt.AmountPaid,0) < ISNULL(pt.AmountDue,0) OR (pt.TransactionStatus IS NULL OR pt.TransactionStatus <> ''Completed''))
    ORDER BY pt.DueDate ASC, pt.TransactionDate ASC;
    ';

    BEGIN TRY
        -- If decryption is needed, open symmetric key; do it in this scope so DecryptByKey works
        IF @needDecrypt = 1
        BEGIN
            BEGIN TRAN;  -- open a tiny transaction to ensure key handling stays consistent
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            COMMIT TRAN;
        END

        -- Execute the dynamic SQL safely with parameterization
        EXEC sp_executesql @sql, N'@ResidentIdParam INT', @ResidentIdParam = @ResidentID;

        -- Close key if opened
        IF @needDecrypt = 1
            CLOSE SYMMETRIC KEY SymKey_PII;
    END TRY
    BEGIN CATCH
        -- Ensure key closed and surface the error
        IF @needDecrypt = 1
        BEGIN
            BEGIN TRY
                CLOSE SYMMETRIC KEY SymKey_PII;
            END TRY
            BEGIN CATCH
                -- ignore secondary errors closing key
            END CATCH
        END

        DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('usp_ListOutstandingInvoicesForResident failed: %s',16,1,@Err);
        RETURN -1;
    END CATCH;
END
GO

DECLARE @ResidentID INT = 300;  

EXEC dbo.usp_ListOutstandingInvoicesForResident @ResidentID = @ResidentID;

-- ==============================================================================
-- Procedure 2: GENERATE MONTHLY STATEMENTS
-- ==============================================================================
IF OBJECT_ID('dbo.usp_GetMonthlyStatementFullDetails','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetMonthlyStatementFullDetails;
GO

CREATE PROCEDURE dbo.usp_GetMonthlyStatementFullDetails
    @Month INT,
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @startDate DATE = DATEFROMPARTS(@Year, @Month, 1);
    DECLARE @endDate DATE = EOMONTH(@startDate);

    DECLARE @needDecrypt BIT = 0;           -- whether to open symmetric key
    DECLARE @paySelectExtras NVARCHAR(MAX) = N'';  -- extra columns for payment select (payment method / ref)
    DECLARE @residentSelectExtras NVARCHAR(MAX) = N''; -- resident PII fields select
    DECLARE @residentJoin NVARCHAR(MAX) = N'';    -- join to resident (only if needed)
    DECLARE @sqlPayments NVARCHAR(MAX);


    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod_Enc') IS NOT NULL
    BEGIN
        SET @paySelectExtras += N', CONVERT(VARCHAR(200), DecryptByKey(pt.PaymentMethod_Enc)) AS PaymentMethod';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod') IS NOT NULL
    BEGIN
        SET @paySelectExtras += N', pt.PaymentMethod';
    END
    ELSE
    BEGIN
        SET @paySelectExtras += N', NULL AS PaymentMethod';
    END

    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber_Enc') IS NOT NULL
    BEGIN
        SET @paySelectExtras += N', CONVERT(VARCHAR(300), DecryptByKey(pt.ReferenceNumber_Enc)) AS ReferenceNumber';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber') IS NOT NULL
    BEGIN
        SET @paySelectExtras += N', pt.ReferenceNumber';
    END
    ELSE
    BEGIN
        SET @paySelectExtras += N', NULL AS ReferenceNumber';
    END

    IF COL_LENGTH('dbo.RESIDENT','EmailAddress_Enc') IS NOT NULL
    BEGIN
        SET @residentSelectExtras += N', CONVERT(VARCHAR(200), DecryptByKey(r.EmailAddress_Enc)) AS ResidentEmail';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','EmailAddress') IS NOT NULL
    BEGIN
        SET @residentSelectExtras += N', r.EmailAddress AS ResidentEmail';
    END
    ELSE
    BEGIN
        SET @residentSelectExtras += N', NULL AS ResidentEmail';
    END

    IF COL_LENGTH('dbo.RESIDENT','PrimaryPhone_Enc') IS NOT NULL
    BEGIN
        SET @residentSelectExtras += N', CONVERT(VARCHAR(50), DecryptByKey(r.PrimaryPhone_Enc)) AS ResidentPhone';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','PrimaryPhone') IS NOT NULL
    BEGIN
        SET @residentSelectExtras += N', r.PrimaryPhone AS ResidentPhone';
    END
    ELSE
    BEGIN
        SET @residentSelectExtras += N', NULL AS ResidentPhone';
    END

    SET @residentJoin = N' LEFT JOIN dbo.RESIDENT r ON r.ResidentID = pt.ResidentID ';


    SET @sqlPayments = N'
    SELECT
        pt.TransactionID,
        pt.LeaseID,
        pt.ResidentID,
        ISNULL(pt.TransactionType, ''Unknown'') AS TransactionType,
        pt.TransactionDate,
        pt.DueDate,
        pt.AmountDue,
        pt.AmountPaid,
        (pt.AmountDue - ISNULL(pt.AmountPaid,0)) AS AmountOutstanding
        ' + @paySelectExtras + N'
        , pt.TransactionStatus,
        pt.CreatedDate,
        pt.ModifiedDate
        , l.PaymentDueDay, l.MonthlyRentAmount
        , u.UnitID AS UnitID, u.UnitNumber, u.UnitType, u.UnitStatus
        , r.FirstName, r.LastName
        ' + @residentSelectExtras + N'
    FROM dbo.PAYMENT_TRANSACTION pt
    LEFT JOIN dbo.LEASE l ON l.LeaseID = pt.LeaseID
    LEFT JOIN dbo.APARTMENT_UNIT u ON u.UnitID = l.UnitID
    ' + @residentJoin + N'
    WHERE pt.TransactionDate >= @StartDateParam AND pt.TransactionDate <= @EndDateParam
    ORDER BY pt.TransactionDate, pt.DueDate, pt.TransactionID;
    ';

    BEGIN TRY
        -- Open key only if decryption needed
        IF @needDecrypt = 1
        BEGIN
            BEGIN TRY
                OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            END TRY
            BEGIN CATCH
                DECLARE @ekErr NVARCHAR(4000) = ERROR_MESSAGE();
                RAISERROR('Unable to open symmetric key for decryption: %s', 16, 1, @ekErr);
            END CATCH
        END

        -- 1) Detailed payment transactions result set
        EXEC sp_executesql
            @sqlPayments,
            N'@StartDateParam DATE, @EndDateParam DATE',
            @StartDateParam = @startDate,
            @EndDateParam = @endDate;

        -- 2) Summary totals for the month (overall)
        SELECT
            COUNT(1) AS TransactionCount,
            ISNULL(SUM(AmountDue),0) AS TotalAmountDue,
            ISNULL(SUM(AmountPaid),0) AS TotalAmountPaid,
            ISNULL(SUM(AmountDue - ISNULL(AmountPaid,0)),0) AS TotalOutstanding
        FROM dbo.PAYMENT_TRANSACTION
        WHERE TransactionDate >= @startDate AND TransactionDate <= @endDate;

        -- 3) Vendor invoices in the month (handles encrypted or plain InvoiceNumber)
            DECLARE @invExtras NVARCHAR(MAX) = N'';
            DECLARE @invNeedDecrypt BIT = 0;

            IF COL_LENGTH('dbo.INVOICE','InvoiceNumber_Enc') IS NOT NULL
            BEGIN
                SET @invExtras += N', CONVERT(VARCHAR(200), DecryptByKey(inv.InvoiceNumber_Enc)) AS InvoiceNumber';
                SET @invNeedDecrypt = 1;
            END
            ELSE IF COL_LENGTH('dbo.INVOICE','InvoiceNumber') IS NOT NULL
            BEGIN
                SET @invExtras += N', inv.InvoiceNumber';
            END
            ELSE
            BEGIN
                SET @invExtras += N', NULL AS InvoiceNumber';
            END

            DECLARE @sqlInvoice NVARCHAR(MAX) = N'
            SELECT
                inv.InvoiceID
                ' + @invExtras + N',
                inv.InvoiceDate,
                inv.DueDate AS InvoiceDueDate,
                inv.TotalAmount AS InvoiceTotal,
                inv.PaymentStatus AS InvoicePaymentStatus,
                wo.WorkOrderID,
                wo.WorkOrderNumber,
                wo.UnitID AS WO_UnitID,
                wo.WorkType,
                wo.WorkDescription,
                mr.RequestID,
                mr.ResidentID AS MR_ResidentID,
                mr.RequestTitle
            FROM dbo.INVOICE inv
            LEFT JOIN dbo.WORK_ORDER wo ON wo.WorkOrderID = inv.WorkOrderID
            LEFT JOIN dbo.MAINTENANCE_REQUEST mr ON mr.RequestID = wo.RequestID
            WHERE inv.InvoiceDate >= @StartDateParam AND inv.InvoiceDate <= @EndDateParam
            ORDER BY inv.InvoiceDate, inv.InvoiceID;
            ';

            IF @invNeedDecrypt = 1 AND @needDecrypt = 0
            BEGIN
                OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            END

            EXEC sp_executesql
                @sqlInvoice,
                N'@StartDateParam DATE, @EndDateParam DATE',
                @StartDateParam = @startDate,
                @EndDateParam = @endDate;

            IF @invNeedDecrypt = 1 AND @needDecrypt = 0
            BEGIN
                CLOSE SYMMETRIC KEY SymKey_PII;
            END


        -- 4) Maintenance requests submitted/updated in the month
        SELECT
            mr.RequestID,
            mr.ResidentID,
            mr.UnitID,
            mr.CategoryID,
            mr.RequestTitle,
            mr.RequestDescription,
            mr.RequestPriority,
            mr.RequestStatus,
            mr.SubmittedDate,
            mr.AcknowledgedDate,
            mr.CompletedDate,
            mr.CreatedDate,
            mr.ModifiedDate
        FROM dbo.MAINTENANCE_REQUEST mr
        WHERE (mr.SubmittedDate BETWEEN @startDate AND @endDate)
           OR (mr.AcknowledgedDate BETWEEN @startDate AND @endDate)
           OR (mr.CompletedDate BETWEEN @startDate AND @endDate)
           OR (mr.ModifiedDate BETWEEN @startDate AND @endDate)
        ORDER BY mr.SubmittedDate DESC;

        -- 5) Leases active during the month + resident & unit info
        --    (Lease overlaps the requested month)
        SELECT
            l.LeaseID,
            l.ResidentID,
            r.FirstName,
            r.LastName,
            l.UnitID,
            u.UnitNumber,
            u.UnitType,
            l.LeaseStartDate,
            l.LeaseEndDate,
            l.MonthlyRentAmount,
            l.LeaseStatus
        FROM dbo.LEASE l
        LEFT JOIN dbo.RESIDENT r ON r.ResidentID = l.ResidentID
        LEFT JOIN dbo.APARTMENT_UNIT u ON u.UnitID = l.UnitID
        WHERE NOT (l.LeaseEndDate < @startDate OR l.LeaseStartDate > @endDate)
        ORDER BY r.LastName, r.FirstName, l.LeaseID;

        -- Close symmetric key if opened
        IF @needDecrypt = 1
        BEGIN
            BEGIN TRY
                CLOSE SYMMETRIC KEY SymKey_PII;
            END TRY
            BEGIN CATCH
                -- ignore close errors
            END CATCH
        END

    END TRY
    BEGIN CATCH
        -- ensure key closed if open
        IF @needDecrypt = 1
        BEGIN
            BEGIN TRY
                CLOSE SYMMETRIC KEY SymKey_PII;
            END TRY
            BEGIN CATCH
                -- ignore
            END CATCH
        END

        DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('usp_GetMonthlyStatementFullDetails failed: %s', 16, 1, @err);
        RETURN -1;
    END CATCH;

    RETURN 0;
END
GO


EXEC dbo.usp_GetMonthlyStatementFullDetails @Month = 1, @Year = 2025;


-- ==============================================================================
-- Procedure 3: TRANSFER LEASE
-- ==============================================================================
IF OBJECT_ID('dbo.usp_TransferResidentUnit','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_TransferResidentUnit;
GO

CREATE PROCEDURE dbo.usp_TransferResidentUnit
    @LeaseID INT,
    @NewUnitID INT,
    @ResultMessage VARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @ResultMessage = NULL;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE @OldUnitID INT;
        SELECT @OldUnitID = UnitID FROM LEASE WHERE LeaseID = @LeaseID;

        IF @OldUnitID IS NULL
        BEGIN
            RAISERROR('LeaseID %d not found.',16,1,@LeaseID);
        END

        IF NOT EXISTS (SELECT 1 FROM APARTMENT_UNIT WHERE UnitID = @NewUnitID)
        BEGIN
            RAISERROR('New UnitID %d does not exist.',16,1,@NewUnitID);
        END

        -- Prevent transfer if new unit is currently marked 'Occupied'
        IF EXISTS (SELECT 1 FROM APARTMENT_UNIT WHERE UnitID = @NewUnitID AND UnitStatus = 'Occupied')
        BEGIN
            RAISERROR('New unit %d is currently Occupied.',16,1,@NewUnitID);
        END

        -- Update lease to point to the new unit
        UPDATE LEASE
        SET UnitID = @NewUnitID,
            ModifiedDate = GETDATE()
        WHERE LeaseID = @LeaseID;

        -- Mark old unit Available (only if it exists)
        UPDATE APARTMENT_UNIT
        SET UnitStatus = 'Available', ModifiedDate = GETDATE()
        WHERE UnitID = @OldUnitID;

        -- Mark new unit Occupied
        UPDATE APARTMENT_UNIT
        SET UnitStatus = 'Occupied', ModifiedDate = GETDATE()
        WHERE UnitID = @NewUnitID;

        SET @ResultMessage = CONCAT('Lease ', @LeaseID, ' transferred from Unit ', ISNULL(CONVERT(VARCHAR(20),@OldUnitID),'NULL'), ' to Unit ', @NewUnitID);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRAN;

        DECLARE @Err NVARCHAR(4000) = ERROR_MESSAGE();
        SET @ResultMessage = 'Error: ' + @Err;
        RAISERROR('usp_TransferResidentUnit failed: %s',16,1,@Err);
    END CATCH
END
GO

DECLARE @ResultMsg VARCHAR(250);

EXEC dbo.usp_TransferResidentUnit @LeaseID = 5000, @NewUnitID = 2000, @ResultMessage = @ResultMsg OUTPUT;
PRINT @ResultMsg;

SELECT LeaseID, ResidentID, UnitID, LeaseStatus FROM LEASE WHERE LeaseID = 5000;
SELECT UnitID, UnitNumber, UnitStatus FROM APARTMENT_UNIT WHERE UnitID IN (2000, 2000);  

-- ==============================================================================
-- Procedure 4: GET RESIDENT PROFILE BY FIRST NAME
-- ==============================================================================
IF OBJECT_ID('dbo.usp_GetResidentFullProfileByName','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GetResidentFullProfileByName;
GO

CREATE PROCEDURE dbo.usp_GetResidentFullProfileByName
    @FullName VARCHAR(200) 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @needDecrypt BIT = 0;
    DECLARE @residentCols NVARCHAR(MAX) = N'';
    DECLARE @paySelectExtras NVARCHAR(MAX) = N'';
    DECLARE @residentSql NVARCHAR(MAX) = N'';
    DECLARE @leasesSql NVARCHAR(MAX) = N'';
    DECLARE @unitsSql NVARCHAR(MAX) = N'';
    DECLARE @paymentsSql NVARCHAR(MAX) = N'';
    DECLARE @invoicesSql NVARCHAR(MAX) = N'';
    DECLARE @maintenanceSql NVARCHAR(MAX) = N'';

    ----------------------------------------------------------------
    -- Build resident select columns depending on what exists
    ----------------------------------------------------------------
    SET @residentCols = N'r.ResidentID, r.FirstName, r.LastName';

    -- Email
    IF COL_LENGTH('dbo.RESIDENT','EmailAddress_Enc') IS NOT NULL
    BEGIN
        SET @residentCols += N', CONVERT(VARCHAR(200), DecryptByKey(r.EmailAddress_Enc)) AS EmailAddress';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','EmailAddress') IS NOT NULL
    BEGIN
        SET @residentCols += N', r.EmailAddress AS EmailAddress';
    END
    ELSE
    BEGIN
        SET @residentCols += N', NULL AS EmailAddress';
    END

    -- PrimaryPhone
    IF COL_LENGTH('dbo.RESIDENT','PrimaryPhone_Enc') IS NOT NULL
    BEGIN
        SET @residentCols += N', CONVERT(VARCHAR(50), DecryptByKey(r.PrimaryPhone_Enc)) AS PrimaryPhone';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','PrimaryPhone') IS NOT NULL
    BEGIN
        SET @residentCols += N', r.PrimaryPhone AS PrimaryPhone';
    END
    ELSE
    BEGIN
        SET @residentCols += N', NULL AS PrimaryPhone';
    END

    -- AlternatePhone
    IF COL_LENGTH('dbo.RESIDENT','AlternatePhone_Enc') IS NOT NULL
    BEGIN
        SET @residentCols += N', CONVERT(VARCHAR(50), DecryptByKey(r.AlternatePhone_Enc)) AS AlternatePhone';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','AlternatePhone') IS NOT NULL
    BEGIN
        SET @residentCols += N', r.AlternatePhone AS AlternatePhone';
    END
    ELSE
    BEGIN
        SET @residentCols += N', NULL AS AlternatePhone';
    END

    -- Additional resident columns if present
    IF COL_LENGTH('dbo.RESIDENT','DateOfBirth') IS NOT NULL
        SET @residentCols += N', r.DateOfBirth';
    IF COL_LENGTH('dbo.RESIDENT','AccountStatus') IS NOT NULL
        SET @residentCols += N', r.AccountStatus';
    IF COL_LENGTH('dbo.RESIDENT','CreatedDate') IS NOT NULL
        SET @residentCols += N', r.CreatedDate';
    IF COL_LENGTH('dbo.RESIDENT','ModifiedDate') IS NOT NULL
        SET @residentCols += N', r.ModifiedDate';

    ----------------------------------------------------------------
    -- Build payment 
    ----------------------------------------------------------------
    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod_Enc') IS NOT NULL
    BEGIN
        SET @paySelectExtras += N', CONVERT(VARCHAR(200), DecryptByKey(pt.PaymentMethod_Enc)) AS PaymentMethod';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod') IS NOT NULL
    BEGIN
        SET @paySelectExtras += N', pt.PaymentMethod';
    END
    ELSE
    BEGIN
        SET @paySelectExtras += N', NULL AS PaymentMethod';
    END

    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber_Enc') IS NOT NULL
    BEGIN
        SET @paySelectExtras += N', CONVERT(VARCHAR(300), DecryptByKey(pt.ReferenceNumber_Enc)) AS ReferenceNumber';
        SET @needDecrypt = 1;
    END
    ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber') IS NOT NULL
    BEGIN
        SET @paySelectExtras += N', pt.ReferenceNumber';
    END
    ELSE
    BEGIN
        SET @paySelectExtras += N', NULL AS ReferenceNumber';
    END

    ----------------------------------------------------------------
    -- Build SQL for result sets; use exact full-name equality (trimmed, case-insensitive)
    ----------------------------------------------------------------

    -- 1) Resident details (single full name match)
    SET @residentSql = N'
    SELECT ' + @residentCols + N'
    FROM dbo.RESIDENT r
    WHERE LOWER(LTRIM(RTRIM(r.FirstName + '' '' + r.LastName))) = LOWER(LTRIM(RTRIM(@FullNameParam)));
    ';

    -- 2) Leases for that resident
    SET @leasesSql = N'
    SELECT l.LeaseID, l.ResidentID, l.UnitID, l.LeaseStartDate, l.LeaseEndDate, l.MonthlyRentAmount, l.PaymentDueDay, l.LeaseStatus, l.CreatedDate, l.ModifiedDate
    FROM dbo.LEASE l
    INNER JOIN dbo.RESIDENT r ON r.ResidentID = l.ResidentID
    WHERE LOWER(LTRIM(RTRIM(r.FirstName + '' '' + r.LastName))) = LOWER(LTRIM(RTRIM(@FullNameParam)));
    ';

    -- 3) Units for those leases
    SET @unitsSql = N'
    SELECT u.UnitID, u.UnitNumber, u.UnitType, u.FloorNumber, u.NumberBedrooms, u.NumberBathrooms, u.BaseRentAmount, u.UnitStatus, u.CreatedDate, u.ModifiedDate
    FROM dbo.APARTMENT_UNIT u
    INNER JOIN dbo.LEASE l ON u.UnitID = l.UnitID
    INNER JOIN dbo.RESIDENT r ON r.ResidentID = l.ResidentID
    WHERE LOWER(LTRIM(RTRIM(r.FirstName + '' '' + r.LastName))) = LOWER(LTRIM(RTRIM(@FullNameParam)));
    ';

    -- 4) Payments / transactions for that resident
    SET @paymentsSql = N'
    SELECT pt.TransactionID, pt.LeaseID, pt.ResidentID, pt.TransactionType, pt.TransactionDate, pt.DueDate, pt.AmountDue, pt.AmountPaid,
           (pt.AmountDue - ISNULL(pt.AmountPaid,0)) AS AmountOutstanding' + @paySelectExtras + N',
           pt.TransactionStatus, pt.CreatedDate, pt.ModifiedDate
    FROM dbo.PAYMENT_TRANSACTION pt
    WHERE pt.ResidentID IN (
        SELECT r.ResidentID FROM dbo.RESIDENT r
        WHERE LOWER(LTRIM(RTRIM(r.FirstName + '' '' + r.LastName))) = LOWER(LTRIM(RTRIM(@FullNameParam)))
    );
    ';

    -- 5) Vendor invoices related via work order -> maintenance request
    SET @invoicesSql = N'
    SELECT inv.InvoiceID, inv.InvoiceNumber, inv.InvoiceDate, inv.DueDate, inv.TotalAmount, inv.PaymentStatus, inv.PaymentDate, inv.PaymentMethod, inv.PaymentReference,
           wo.WorkOrderID, wo.WorkOrderNumber, wo.UnitID AS WO_UnitID, wo.WorkType, wo.WorkDescription,
           mr.RequestID, mr.ResidentID AS MR_ResidentID, mr.RequestTitle
    FROM dbo.INVOICE inv
    LEFT JOIN dbo.WORK_ORDER wo ON wo.WorkOrderID = inv.WorkOrderID
    LEFT JOIN dbo.MAINTENANCE_REQUEST mr ON mr.RequestID = wo.RequestID
    WHERE mr.ResidentID IN (
        SELECT r.ResidentID FROM dbo.RESIDENT r
        WHERE LOWER(LTRIM(RTRIM(r.FirstName + '' '' + r.LastName))) = LOWER(LTRIM(RTRIM(@FullNameParam)))
    );
    ';

    -- 6) Maintenance requests for that resident
    SET @maintenanceSql = N'
    SELECT mr.RequestID, mr.ResidentID, mr.UnitID, mr.CategoryID, mr.RequestTitle, mr.RequestDescription, mr.RequestPriority, mr.RequestStatus,
           mr.SubmittedDate, mr.AcknowledgedDate, mr.CompletedDate, mr.PermissionToEnter, mr.PetOnPremises, mr.CreatedDate, mr.ModifiedDate
    FROM dbo.MAINTENANCE_REQUEST mr
    INNER JOIN dbo.RESIDENT r ON r.ResidentID = mr.ResidentID
    WHERE LOWER(LTRIM(RTRIM(r.FirstName + '' '' + r.LastName))) = LOWER(LTRIM(RTRIM(@FullNameParam)));
    ';

    BEGIN TRY
        IF @needDecrypt = 1
        BEGIN
            BEGIN TRY
                OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            END TRY
            BEGIN CATCH
                DECLARE @ek NVARCHAR(4000) = ERROR_MESSAGE();
                RAISERROR('Unable to open SymKey_PII for decryption: %s',16,1,@ek);
            END CATCH
        END

        EXEC sp_executesql @residentSql, N'@FullNameParam VARCHAR(200)', @FullNameParam = @FullName;
        EXEC sp_executesql @leasesSql,   N'@FullNameParam VARCHAR(200)', @FullNameParam = @FullName;
        EXEC sp_executesql @unitsSql,    N'@FullNameParam VARCHAR(200)', @FullNameParam = @FullName;
        EXEC sp_executesql @paymentsSql, N'@FullNameParam VARCHAR(200)', @FullNameParam = @FullName;
        EXEC sp_executesql @invoicesSql, N'@FullNameParam VARCHAR(200)', @FullNameParam = @FullName;
        EXEC sp_executesql @maintenanceSql, N'@FullNameParam VARCHAR(200)', @FullNameParam = @FullName;

        IF @needDecrypt = 1
        BEGIN
            BEGIN TRY
                CLOSE SYMMETRIC KEY SymKey_PII;
            END TRY
            BEGIN CATCH
                -- ignore
            END CATCH
        END
    END TRY
    BEGIN CATCH
        IF @needDecrypt = 1
        BEGIN
            BEGIN TRY
                CLOSE SYMMETRIC KEY SymKey_PII;
            END TRY
            BEGIN CATCH
                -- ignore
            END CATCH
        END

        DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('usp_GetResidentFullProfileByName failed: %s',16,1,@err);
        RETURN -1;
    END CATCH;

    RETURN 0;
END
GO


EXEC dbo.usp_GetResidentFullProfileByName @FullName = 'John Smith';


-- ==============================================================================
-- View 1: Active Leases
-- ==============================================================================
    CREATE VIEW vw_ActiveLeaseDetails AS
    SELECT
        l.LeaseID,
        l.ResidentID,
        r.FirstName,
        r.LastName,
        r.PrimaryPhone,
        l.UnitID,
        u.UnitNumber,
        u.UnitType,
        l.LeaseStartDate,
        l.LeaseEndDate,
        l.MonthlyRentAmount,
        l.PaymentDueDay,
        l.LeaseStatus
    FROM LEASE l
    INNER JOIN RESIDENT r ON r.ResidentID = l.ResidentID
    INNER JOIN APARTMENT_UNIT u ON u.UnitID = l.UnitID
    WHERE l.LeaseStatus = 'Active';

SELECT * FROM vw_ActiveLeaseDetails;

-- ==============================================================================
-- View 2: Maintenance Request Summary
-- ==============================================================================
    CREATE VIEW vw_MaintenanceRequestSummary AS
    SELECT
        mr.RequestID,
        mr.ResidentID,
        r.FirstName + ' ' + r.LastName AS ResidentName,
        mr.UnitID,
        u.UnitNumber,
        mr.RequestTitle,
        mr.RequestPriority,
        mr.RequestStatus,
        mr.RequestDescription,
        mr.SubmittedDate,
        mr.CompletedDate
    FROM MAINTENANCE_REQUEST mr
    LEFT JOIN RESIDENT r ON r.ResidentID = mr.ResidentID
    LEFT JOIN APARTMENT_UNIT u ON u.UnitID = mr.UnitID;

SELECT * FROM vw_MaintenanceRequestSummary;


-- ==============================================================================
-- View 3: Unit Occupancy Status
-- ==============================================================================
CREATE VIEW dbo.vw_UnitOccupancyStatus AS
SELECT
    u.UnitID,
    u.UnitNumber,
    u.UnitType,
    u.FloorNumber,
    u.UnitStatus,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM LEASE l
            WHERE l.UnitID = u.UnitID
              AND l.LeaseStatus = 'Active'
              AND GETDATE() BETWEEN l.LeaseStartDate AND l.LeaseEndDate
        ) THEN 'Occupied'
        ELSE 'Vacant'
    END AS OccupancyStatus
FROM dbo.APARTMENT_UNIT u;
GO

CREATE VIEW dbo.vw_OccupancyVacancySummary AS
SELECT
    COUNT(*) AS TotalUnits,
    SUM(CASE WHEN OccupancyStatus = 'Occupied' THEN 1 ELSE 0 END) AS OccupiedUnits,
    SUM(CASE WHEN OccupancyStatus = 'Occupied' THEN 0 ELSE 1 END) AS VacantUnits,
    CAST(
        CASE WHEN COUNT(*) = 0 THEN 0
             ELSE SUM(CASE WHEN OccupancyStatus = 'Occupied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
        END
    AS DECIMAL(5,2)) AS OccupancyPercentage
FROM dbo.vw_UnitOccupancyStatus;
GO

SELECT * FROM vw_OccupancyVacancySummary;


-- ==============================================================================
-- View 4: Monthly Income Turnover
-- ==============================================================================
IF OBJECT_ID('dbo.INVOICE','U') IS NULL
BEGIN
    RAISERROR('INVOICE table not found. Aborting.',16,1);
    RETURN;
END

IF COL_LENGTH('dbo.INVOICE','InvoiceDate') IS NULL OR COL_LENGTH('dbo.INVOICE','TotalAmount') IS NULL
BEGIN
    RAISERROR('INVOICE must have InvoiceDate and TotalAmount columns.',16,1);
    RETURN;
END

IF OBJECT_ID('dbo.PAYMENT_TRANSACTION','U') IS NULL
BEGIN
    RAISERROR('PAYMENT_TRANSACTION table not found. Aborting.',16,1);
    RETURN;
END

-- Detect payment amount & date columns
DECLARE @payAmtCol SYSNAME = NULL;
IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','AmountPaid') IS NOT NULL SET @payAmtCol = 'AmountPaid';
ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentAmount') IS NOT NULL SET @payAmtCol = 'PaymentAmount';
ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','Amount') IS NOT NULL SET @payAmtCol = 'Amount';

IF @payAmtCol IS NULL
BEGIN
    RAISERROR('PAYMENT_TRANSACTION must have an amount column: AmountPaid or PaymentAmount or Amount.',16,1);
    RETURN;
END

DECLARE @payDateCol SYSNAME = NULL;
IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','TransactionDate') IS NOT NULL SET @payDateCol = 'TransactionDate';
ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentDate') IS NOT NULL SET @payDateCol = 'PaymentDate';

IF @payDateCol IS NULL
BEGIN
    RAISERROR('PAYMENT_TRANSACTION must have a date column: TransactionDate or PaymentDate.',16,1);
    RETURN;
END

-- Drop view if exists (same batch)
IF OBJECT_ID('dbo.vw_MonthlyTurnover','V') IS NOT NULL
    DROP VIEW dbo.vw_MonthlyTurnover;

-- Build the CREATE VIEW into a variable
DECLARE @viewSQL NVARCHAR(MAX);

SET @viewSQL =
N'CREATE VIEW dbo.vw_MonthlyTurnover AS
WITH
Inv AS (
    SELECT YEAR(InvoiceDate) AS [Year], MONTH(InvoiceDate) AS [Month], SUM(ISNULL(TotalAmount,0)) AS InvoiceTotal
    FROM dbo.INVOICE
    WHERE InvoiceDate IS NOT NULL
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
),
Pays AS (
    SELECT YEAR(' + QUOTENAME(@payDateCol) + N') AS [Year], MONTH(' + QUOTENAME(@payDateCol) + N') AS [Month],
           SUM(ISNULL(COALESCE(' + QUOTENAME(@payAmtCol) + N',0),0)) AS PaymentsReceived
    FROM dbo.PAYMENT_TRANSACTION
    WHERE ' + QUOTENAME(@payDateCol) + N' IS NOT NULL
    GROUP BY YEAR(' + QUOTENAME(@payDateCol) + N'), MONTH(' + QUOTENAME(@payDateCol) + N')
),
AllMonths AS (
    SELECT [Year],[Month] FROM Inv
    UNION
    SELECT [Year],[Month] FROM Pays
)
SELECT
    am.[Year],
    am.[Month],
    ISNULL(i.InvoiceTotal,0) AS InvoiceTotal,
    ISNULL(p.PaymentsReceived,0) AS PaymentsReceived,
    (ISNULL(i.InvoiceTotal,0) + ISNULL(p.PaymentsReceived,0)) AS GrossIncome,
    (ISNULL(i.InvoiceTotal,0) + ISNULL(p.PaymentsReceived,0)) AS NetTurnover
FROM AllMonths am
LEFT JOIN Inv i ON i.[Year] = am.[Year] AND i.[Month] = am.[Month]
LEFT JOIN Pays p ON p.[Year] = am.[Year] AND p.[Month] = am.[Month];';


EXEC sp_executesql @viewSQL;



SELECT * FROM dbo.vw_MonthlyTurnover ORDER BY [Year] DESC, [Month] DESC;



-- ==============================================================================
-- UDF 1: Payment Behaviour Score for Tenant
-- ==============================================================================
IF OBJECT_ID('dbo.fn_TenantPaymentBehaviorScore','FN') IS NOT NULL
    DROP FUNCTION dbo.fn_TenantPaymentBehaviorScore;
GO

CREATE FUNCTION dbo.fn_TenantPaymentBehaviorScore
(
    @ResidentID INT,
    @MonthsWindow INT = 12
)
RETURNS INT
AS
BEGIN
    DECLARE @Cutoff DATE = DATEADD(MONTH, -@MonthsWindow, GETDATE());
    DECLARE @TotalTx INT = 0;
    DECLARE @OnTime INT = 0;
    DECLARE @Late INT = 0;
    DECLARE @Missed INT = 0;
    DECLARE @Partial INT = 0;

    SELECT
        @TotalTx = COUNT(*),
        @OnTime  = SUM(CASE WHEN (pt.AmountPaid >= pt.AmountDue AND pt.DueDate IS NOT NULL AND pt.TransactionDate IS NOT NULL AND pt.TransactionDate <= pt.DueDate) THEN 1 ELSE 0 END),
        @Late    = SUM(CASE WHEN (pt.AmountPaid >= pt.AmountDue AND pt.DueDate IS NOT NULL AND pt.TransactionDate IS NOT NULL AND pt.TransactionDate > pt.DueDate) THEN 1 ELSE 0 END),
        @Partial = SUM(CASE WHEN (ISNULL(pt.AmountPaid,0) > 0 AND ISNULL(pt.AmountPaid,0) < ISNULL(pt.AmountDue,0)) THEN 1 ELSE 0 END),
        @Missed  = SUM(CASE WHEN (ISNULL(pt.AmountPaid,0) = 0 AND ISNULL(pt.AmountDue,0) > 0) THEN 1 ELSE 0 END)
    FROM dbo.PAYMENT_TRANSACTION pt
    WHERE pt.ResidentID = @ResidentID
      AND (pt.TransactionDate >= @Cutoff OR pt.DueDate >= @Cutoff);

    IF @TotalTx = 0 RETURN 50; -- neutral default when no history

    -- scoring weights (tweak as needed)
    DECLARE @weightOnTime    DECIMAL(6,4) = 0.6;   -- reward
    DECLARE @weightLate      DECIMAL(6,4) = -0.15; -- penalty
    DECLARE @weightPartial   DECIMAL(6,4) = -0.10; -- penalty
    DECLARE @weightMissed    DECIMAL(6,4) = -0.30; -- penalty

    DECLARE @score DECIMAL(8,4) = 50.0; -- start at neutral 50

    SET @score = @score
        + (CAST(@OnTime AS DECIMAL(10,4)) / @TotalTx) * 50.0 * @weightOnTime
        + (CAST(@Late AS DECIMAL(10,4)) / @TotalTx) * 50.0 * @weightLate
        + (CAST(@Partial AS DECIMAL(10,4)) / @TotalTx) * 50.0 * @weightPartial
        + (CAST(@Missed AS DECIMAL(10,4)) / @TotalTx) * 50.0 * @weightMissed;

    -- normalize to 0..100
    IF @score < 0 SET @score = 0;
    IF @score > 100 SET @score = 100;

    RETURN CAST(ROUND(@score,0) AS INT);
END;
GO

SELECT dbo.fn_TenantPaymentBehaviorScore(305,12) AS PaymentBehaviorScore;



-- ==============================================================================
-- UDF 2: Tenanat LTV prediction
-- ==============================================================================
IF OBJECT_ID('dbo.tvf_PredictedLTV','TF') IS NOT NULL
    DROP FUNCTION dbo.tvf_PredictedLTV;
GO

CREATE FUNCTION dbo.tvf_PredictedLTV
(
    @ResidentID INT,
    @ProjectionMonths INT = 12
)
RETURNS TABLE
AS
RETURN
(
    WITH Hist AS (
        -- average monthly collected (payments) for last 12 months
        SELECT AVG(MonthlyTotal) AS AvgMonthlyReceived
        FROM (
            SELECT YEAR(pt.TransactionDate) AS Yr, MONTH(pt.TransactionDate) AS Mon,
                   SUM(ISNULL(pt.AmountPaid,0)) AS MonthlyTotal
            FROM dbo.PAYMENT_TRANSACTION pt
            WHERE pt.ResidentID = @ResidentID
              AND pt.TransactionDate >= DATEADD(MONTH, -12, GETDATE())
            GROUP BY YEAR(pt.TransactionDate), MONTH(pt.TransactionDate)
        ) x
    ),
    Score AS (
        SELECT dbo.fn_TenantPaymentBehaviorScore(@ResidentID, 12) AS Score
    ),
    Params AS (
        SELECT
            COALESCE(h.AvgMonthlyReceived, 0.0) AS AvgMonthlyReceived,
            s.Score,
            -- retention probability: convert score to 0.5..0.98 (tunable)
            (0.5 + (COALESCE(s.Score,50) / 100.0) * 0.48) AS RetentionProb
        FROM Hist h CROSS JOIN Score s
    ),
    Months AS (
        SELECT 1 AS m
        UNION ALL
        SELECT m+1 FROM Months WHERE m+1 <= @ProjectionMonths
    )
    SELECT
        m AS MonthOffset,
        DATEADD(MONTH, m-1, CAST(GETDATE() AS DATE)) AS ProjectionMonthStart,
        CAST(p.AvgMonthlyReceived * POWER(p.RetentionProb, m-1) AS DECIMAL(18,2)) AS ExpectedMonthlyPayment,
        CAST( SUM(CAST(p.AvgMonthlyReceived * POWER(p.RetentionProb, m-1) AS DECIMAL(18,2))) OVER (ORDER BY m ROWS UNBOUNDED PRECEDING) AS DECIMAL(18,2)) AS CumulativeProjectedLTV
    FROM Months m CROSS JOIN Params p
);
GO

SELECT * FROM dbo.tvf_PredictedLTV(305,12);



-- ==============================================================================
-- UDF 3: Tenanat Churn Risk Value
-- ==============================================================================
IF OBJECT_ID('dbo.fn_ChurnRiskCategory','FN') IS NOT NULL
    DROP FUNCTION dbo.fn_ChurnRiskCategory;
GO

CREATE FUNCTION dbo.fn_ChurnRiskCategory
(
    @ResidentID INT,
    @MonthsWindow INT = 12
)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @score INT = dbo.fn_TenantPaymentBehaviorScore(@ResidentID, @MonthsWindow);
    DECLARE @mrCount INT = 0;

    SELECT @mrCount = COUNT(*)
    FROM dbo.MAINTENANCE_REQUEST mr
    WHERE mr.ResidentID = @ResidentID
      AND mr.SubmittedDate >= DATEADD(MONTH, -@MonthsWindow, GETDATE());

    -- simple rules:
    -- High churn risk: payment score < 40 OR maintenance requests >= 4 in window
    -- Medium: score 40..65 OR maintenance 2..3
    -- Low: otherwise
    IF @score < 30 OR @mrCount >= 4 RETURN 'High';
    IF @score BETWEEN 30 AND 65 OR @mrCount BETWEEN 2 AND 3 RETURN 'Medium';
    RETURN 'Low';
END;
GO

SELECT dbo.fn_ChurnRiskCategory(300,12) AS ChurnRisk;
SELECT dbo.fn_ChurnRiskCategory(305,12) AS ChurnRisk;


-- ==============================================================================
-- DML Trigger 1: RESIDENT AUDIT
-- ==============================================================================
DROP TABLE IF EXISTS dbo.RESIDENT_AUDIT;
GO

CREATE TABLE dbo.RESIDENT_AUDIT (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    ResidentID INT,
    ChangeType VARCHAR(10),
    ChangedColumn VARCHAR(150),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    ChangedBy SYSNAME DEFAULT SUSER_SNAME(),
    ChangedDate DATETIME DEFAULT GETDATE()
);
GO

GO
CREATE OR ALTER TRIGGER trg_Resident_Audit_EncryptionAware
ON dbo.RESIDENT
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @HasEnc BIT =
        CASE WHEN COL_LENGTH('dbo.RESIDENT','EmailAddress_Enc') IS NOT NULL THEN 1 ELSE 0 END;

    IF @HasEnc = 1
        OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;

    -------------------------------------------------------------------
    -- INSERT
    -------------------------------------------------------------------
    INSERT INTO dbo.RESIDENT_AUDIT (ResidentID, ChangeType, ChangedColumn, NewValue)
    SELECT
        i.ResidentID,
        'INSERT',
        'ALL',
        CONCAT(
            'FirstName=', i.FirstName, '; ',
            'LastName=', i.LastName, '; ',
            'Email=', 
                CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.EmailAddress_Enc))
                     ELSE i.EmailAddress_PLAIN_BAK END, '; ',
            'Phone=', 
                CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.PrimaryPhone_Enc))
                     ELSE i.PrimaryPhone_PLAIN_BAK END, '; ',
            'Address=', 
                CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.CurrentAddress_Enc))
                     ELSE i.CurrentAddress_PLAIN_BAK END
        )
    FROM inserted i
    WHERE NOT EXISTS (SELECT 1 FROM deleted d WHERE d.ResidentID = i.ResidentID);

    -------------------------------------------------------------------
    -- UPDATE – only log actual changed fields
    -------------------------------------------------------------------
    ;WITH Changed AS (

    ------------------------------------------------------------------
    -- FirstName
    ------------------------------------------------------------------
    SELECT
        d.ResidentID,
        'FirstName' AS ChangedColumn,
        d.FirstName AS OldValue,
        i.FirstName AS NewValue
    FROM deleted d JOIN inserted i ON d.ResidentID=i.ResidentID
    WHERE d.FirstName <> i.FirstName

    UNION ALL

    ------------------------------------------------------------------
    -- LastName
    ------------------------------------------------------------------
    SELECT
        d.ResidentID,
        'LastName',
        d.LastName,
        i.LastName
    FROM deleted d JOIN inserted i ON d.ResidentID=i.ResidentID
    WHERE d.LastName <> i.LastName

    UNION ALL

    ------------------------------------------------------------------
    -- EmailAddress (encrypted/plaintext-aware)
    ------------------------------------------------------------------
    SELECT
        d.ResidentID,
        'EmailAddress',
        CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.EmailAddress_Enc))
             ELSE d.EmailAddress_PLAIN_BAK END,
        CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.EmailAddress_Enc))
             ELSE i.EmailAddress_PLAIN_BAK END
    FROM deleted d JOIN inserted i ON d.ResidentID=i.ResidentID
    WHERE
        (CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.EmailAddress_Enc))
              ELSE d.EmailAddress_PLAIN_BAK END)
        <>
        (CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.EmailAddress_Enc))
              ELSE i.EmailAddress_PLAIN_BAK END)

    UNION ALL

    ------------------------------------------------------------------
    -- PrimaryPhone
    ------------------------------------------------------------------
    SELECT
        d.ResidentID,
        'PrimaryPhone',
        CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.PrimaryPhone_Enc))
             ELSE d.PrimaryPhone_PLAIN_BAK END,
        CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.PrimaryPhone_Enc))
             ELSE i.PrimaryPhone_PLAIN_BAK END
    FROM deleted d JOIN inserted i ON d.ResidentID=i.ResidentID
    WHERE
        (CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.PrimaryPhone_Enc))
              ELSE d.PrimaryPhone_PLAIN_BAK END)
        <>
        (CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.PrimaryPhone_Enc))
              ELSE i.PrimaryPhone_PLAIN_BAK END)

    UNION ALL

    ------------------------------------------------------------------
    -- CurrentAddress
    ------------------------------------------------------------------
    SELECT
        d.ResidentID,
        'CurrentAddress',
        CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.CurrentAddress_Enc))
             ELSE d.CurrentAddress_PLAIN_BAK END,
        CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.CurrentAddress_Enc))
             ELSE i.CurrentAddress_PLAIN_BAK END
    FROM deleted d JOIN inserted i ON d.ResidentID=i.ResidentID
    WHERE
        (CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.CurrentAddress_Enc))
              ELSE d.CurrentAddress_PLAIN_BAK END)
        <>
        (CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.CurrentAddress_Enc))
              ELSE i.CurrentAddress_PLAIN_BAK END)
)
INSERT INTO dbo.RESIDENT_AUDIT (ResidentID, ChangeType, ChangedColumn, OldValue, NewValue)
SELECT ResidentID, 'UPDATE', ChangedColumn, OldValue, NewValue
FROM Changed;


    -------------------------------------------------------------------
    -- DELETE
    -------------------------------------------------------------------
    INSERT INTO dbo.RESIDENT_AUDIT (ResidentID, ChangeType, ChangedColumn, OldValue)
    SELECT
        d.ResidentID,
        'DELETE',
        'ALL',
        CONCAT(
            'FirstName=', d.FirstName, '; ',
            'LastName=', d.LastName, '; ',
            'Email=', 
                CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.EmailAddress_Enc))
                     ELSE d.EmailAddress_PLAIN_BAK END, '; ',
            'Phone=',
                CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.PrimaryPhone_Enc))
                     ELSE d.PrimaryPhone_PLAIN_BAK END, '; ',
            'Address=',
                CASE WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.CurrentAddress_Enc))
                     ELSE d.CurrentAddress_PLAIN_BAK END
        )
    FROM deleted d
    WHERE NOT EXISTS (SELECT 1 FROM inserted i WHERE i.ResidentID = d.ResidentID);

    IF @HasEnc = 1
        CLOSE SYMMETRIC KEY SymKey_PII;

END;
GO

INSERT INTO dbo.RESIDENT
(FirstName, LastName, DateOfBirth,
 EmailAddress_PLAIN_BAK, PrimaryPhone_PLAIN_BAK, CurrentAddress_PLAIN_BAK)
VALUES
('Audit','User','1990-01-01',
 'audit@test.com','5551112222','123 Test St');
GO

UPDATE dbo.RESIDENT
SET FirstName = 'UpdatedUser'
WHERE PrimaryPhone_PLAIN_BAK = '5551112222';
GO

DELETE FROM dbo.RESIDENT
WHERE EmailAddress_PLAIN_BAK = 'audit@test.com';
GO

SELECT * FROM dbo.RESIDENT_AUDIT ORDER BY AuditID;
GO



-- =====================================================================================
-- DML Trigger 2: AUDIT LOGS AND TRIGGER TO RECORD PAYMENTS TABLE [DMLs]
-- =====================================================================================
DROP TABLE IF EXISTS dbo.PAYMENT_TRANSACTION_AUDIT;
GO

CREATE TABLE dbo.PAYMENT_TRANSACTION_AUDIT (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID INT,
    ChangeType VARCHAR(10),
    Field VARCHAR(200),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    AuditUser SYSNAME DEFAULT SUSER_SNAME(),
    AuditDate DATETIME DEFAULT GETDATE()
);
GO

GO
CREATE OR ALTER TRIGGER trg_PaymentTransaction_Audit
ON dbo.PAYMENT_TRANSACTION
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ---------------------------------------------------------
    -- Detect encryption
    ---------------------------------------------------------
    DECLARE @HasEnc BIT =
        CASE WHEN 
                COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod_Enc') IS NOT NULL 
                OR COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber_Enc') IS NOT NULL
             THEN 1 ELSE 0 END;

    IF @HasEnc = 1
        OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;


    ---------------------------------------------------------
    -- Build decrypted +/- plaintext values into a temp table
    ---------------------------------------------------------
    IF OBJECT_ID('tempdb..#VAL') IS NOT NULL DROP TABLE #VAL;

    CREATE TABLE #VAL (
        TransactionID INT PRIMARY KEY,
        PaymentMethod_Old NVARCHAR(MAX),
        PaymentMethod_New NVARCHAR(MAX),
        Reference_Old NVARCHAR(MAX),
        Reference_New NVARCHAR(MAX),
        AmountDue_Old DECIMAL(18,2),
        AmountDue_New DECIMAL(18,2),
        AmountPaid_Old DECIMAL(18,2),
        AmountPaid_New DECIMAL(18,2),
        Status_Old NVARCHAR(100),
        Status_New NVARCHAR(100)
    );

    INSERT INTO #VAL
    SELECT
        COALESCE(i.TransactionID, d.TransactionID) AS TransactionID,

        -- PaymentMethod Old
        CASE 
            WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.PaymentMethod_Enc))
            WHEN d.PaymentMethod_PLAIN_BAK IS NOT NULL THEN d.PaymentMethod_PLAIN_BAK
            ELSE NULL 
        END AS PaymentMethod_Old,

        -- PaymentMethod New
        CASE 
            WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.PaymentMethod_Enc))
            WHEN i.PaymentMethod_PLAIN_BAK IS NOT NULL THEN i.PaymentMethod_PLAIN_BAK
            ELSE NULL 
        END AS PaymentMethod_New,

        -- ReferenceNumber Old
        CASE 
            WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(d.ReferenceNumber_Enc))
            WHEN d.ReferenceNumber_PLAIN_BAK IS NOT NULL THEN d.ReferenceNumber_PLAIN_BAK
            ELSE NULL 
        END AS Reference_Old,

        -- ReferenceNumber New
        CASE 
            WHEN @HasEnc=1 THEN CONVERT(NVARCHAR(MAX),DecryptByKey(i.ReferenceNumber_Enc))
            WHEN i.ReferenceNumber_PLAIN_BAK IS NOT NULL THEN i.ReferenceNumber_PLAIN_BAK
            ELSE NULL 
        END AS Reference_New,

        d.AmountDue,
        i.AmountDue,
        d.AmountPaid,
        i.AmountPaid,
        d.TransactionStatus,
        i.TransactionStatus

    FROM inserted i
    FULL JOIN deleted d ON d.TransactionID = i.TransactionID;


    ---------------------------------------------------------
    -- INSERT
    ---------------------------------------------------------
    INSERT INTO dbo.PAYMENT_TRANSACTION_AUDIT
    (TransactionID, ChangeType, Field, NewValue)
    SELECT
        i.TransactionID,
        'INSERT',
        'ALL',
        CONCAT(
            'LeaseID=', i.LeaseID, '; ',
            'ResidentID=', i.ResidentID, '; ',
            'Type=', i.TransactionType, '; ',
            'AmountDue=', i.AmountDue, '; ',
            'AmountPaid=', i.AmountPaid, '; ',
            'PaymentMethod=', v.PaymentMethod_New, '; ',
            'ReferenceNumber=', v.Reference_New, '; ',
            'Status=', i.TransactionStatus
        )
    FROM inserted i
    JOIN #VAL v ON v.TransactionID = i.TransactionID
    WHERE NOT EXISTS (SELECT 1 FROM deleted d WHERE d.TransactionID = i.TransactionID);


    ---------------------------------------------------------
    -- DELETE
    ---------------------------------------------------------
    INSERT INTO dbo.PAYMENT_TRANSACTION_AUDIT
    (TransactionID, ChangeType, Field, OldValue)
    SELECT
        d.TransactionID,
        'DELETE',
        'ALL',
        CONCAT(
            'LeaseID=', d.LeaseID, '; ',
            'ResidentID=', d.ResidentID, '; ',
            'Type=', d.TransactionType, '; ',
            'AmountDue=', d.AmountDue, '; ',
            'AmountPaid=', d.AmountPaid, '; ',
            'PaymentMethod=', v.PaymentMethod_Old, '; ',
            'ReferenceNumber=', v.Reference_Old, '; ',
            'Status=', d.TransactionStatus
        )
    FROM deleted d
    JOIN #VAL v ON v.TransactionID = d.TransactionID
    WHERE NOT EXISTS (SELECT 1 FROM inserted i WHERE i.TransactionID = d.TransactionID);


    ---------------------------------------------------------
    -- UPDATE (field-level)
    ---------------------------------------------------------

    -- AmountDue
    INSERT INTO dbo.PAYMENT_TRANSACTION_AUDIT
    (TransactionID, ChangeType, Field, OldValue, NewValue)
    SELECT TransactionID, 'UPDATE', 'AmountDue',
           AmountDue_Old, AmountDue_New
    FROM #VAL
    WHERE AmountDue_Old <> AmountDue_New;

    -- AmountPaid
    INSERT INTO dbo.PAYMENT_TRANSACTION_AUDIT
    (TransactionID, ChangeType, Field, OldValue, NewValue)
    SELECT TransactionID, 'UPDATE', 'AmountPaid',
           AmountPaid_Old, AmountPaid_New
    FROM #VAL
    WHERE ISNULL(AmountPaid_Old,-1) <> ISNULL(AmountPaid_New,-1);

    -- TransactionStatus
    INSERT INTO dbo.PAYMENT_TRANSACTION_AUDIT
    (TransactionID, ChangeType, Field, OldValue, NewValue)
    SELECT TransactionID, 'UPDATE', 'TransactionStatus',
           Status_Old, Status_New
    FROM #VAL
    WHERE ISNULL(Status_Old,'') <> ISNULL(Status_New,'');

    -- PaymentMethod
    INSERT INTO dbo.PAYMENT_TRANSACTION_AUDIT
    (TransactionID, ChangeType, Field, OldValue, NewValue)
    SELECT TransactionID, 'UPDATE', 'PaymentMethod',
           PaymentMethod_Old, PaymentMethod_New
    FROM #VAL
    WHERE ISNULL(PaymentMethod_Old,'') <> ISNULL(PaymentMethod_New,'');

    -- ReferenceNumber
    INSERT INTO dbo.PAYMENT_TRANSACTION_AUDIT
    (TransactionID, ChangeType, Field, OldValue, NewValue)
    SELECT TransactionID, 'UPDATE', 'ReferenceNumber',
           Reference_Old, Reference_New
    FROM #VAL
    WHERE ISNULL(Reference_Old,'') <> ISNULL(Reference_New,'');


    IF @HasEnc = 1
        CLOSE SYMMETRIC KEY SymKey_PII;

END;
GO


INSERT INTO PAYMENT_TRANSACTION
(LeaseID, ResidentID, TransactionType, TransactionDate, DueDate, AmountDue, AmountPaid,
 PaymentMethod_PLAIN_BAK, ReferenceNumber_PLAIN_BAK, TransactionStatus, CreatedDate, ModifiedDate)
VALUES (5000, 300, 'Rent', GETDATE(), GETDATE()+3, 2000, 0, 'Cash', 'R001', 'Pending', GETDATE(), GETDATE());

UPDATE dbo.PAYMENT_TRANSACTION
SET AmountPaid = 500
WHERE ReferenceNumber_PLAIN_BAK = 'R001';

DELETE FROM dbo.PAYMENT_TRANSACTION
WHERE ReferenceNumber_PLAIN_BAK = 'R001';

SELECT * FROM dbo.PAYMENT_TRANSACTION_AUDIT ORDER BY AuditID;


