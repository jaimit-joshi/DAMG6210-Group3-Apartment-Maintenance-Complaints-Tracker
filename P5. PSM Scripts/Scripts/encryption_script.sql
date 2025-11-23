USE ApartmentHub;
GO

/***********************
  1) Create keys (idempotent)
************************/
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    PRINT 'Creating Database Master Key...';
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKey@Password#secure!';
END
ELSE
    PRINT 'Database Master Key already exists.';
GO

IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE name = 'PiiCert')
BEGIN
    PRINT 'Creating certificate PiiCert...';
    CREATE CERTIFICATE PiiCert WITH SUBJECT = 'Certificate to protect symmetric key for PII';
END
ELSE
    PRINT 'Certificate PiiCert already exists.';
GO

IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = 'SymKey_PII')
BEGIN
    PRINT 'Creating symmetric key SymKey_PII...';
    CREATE SYMMETRIC KEY SymKey_PII WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE PiiCert;
END
ELSE
    PRINT 'Symmetric key SymKey_PII already exists.';
GO


/************************************************************************
  2) RESIDENT: 
************************************************************************/
IF OBJECT_ID('dbo.RESIDENT','U') IS NOT NULL
BEGIN
    -- Add enc columns if missing 
    IF COL_LENGTH('dbo.RESIDENT','EmailAddress_Enc') IS NULL
    BEGIN
        ALTER TABLE dbo.RESIDENT ADD
            EmailAddress_Enc VARBINARY(MAX),
            SSNLast4_Enc VARBINARY(256),
            PrimaryPhone_Enc VARBINARY(256),
            AlternatePhone_Enc VARBINARY(256),
            CurrentAddress_Enc VARBINARY(MAX);
        PRINT 'Added encrypted columns to RESIDENT.';
    END
    ELSE
        PRINT 'RESIDENT encrypted columns already exist.';

    -- populate EmailAddress_Enc 
    IF COL_LENGTH('dbo.RESIDENT','EmailAddress') IS NOT NULL
    BEGIN
        PRINT 'Populating EmailAddress_Enc from EmailAddress (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET EmailAddress_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), EmailAddress))
            WHERE EmailAddress_Enc IS NULL AND EmailAddress IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','EmailAddress_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating EmailAddress_Enc from EmailAddress_PLAIN_BAK (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET EmailAddress_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), EmailAddress_PLAIN_BAK))
            WHERE EmailAddress_Enc IS NULL AND EmailAddress_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    -- SSNLast4 
    IF COL_LENGTH('dbo.RESIDENT','SSNLast4') IS NOT NULL
    BEGIN
        PRINT 'Populating SSNLast4_Enc from SSNLast4 (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET SSNLast4_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), SSNLast4))
            WHERE SSNLast4_Enc IS NULL AND SSNLast4 IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','SSNLast4_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating SSNLast4_Enc from SSNLast4_PLAIN_BAK (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET SSNLast4_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), SSNLast4_PLAIN_BAK))
            WHERE SSNLast4_Enc IS NULL AND SSNLast4_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    -- PrimaryPhone 
    IF COL_LENGTH('dbo.RESIDENT','PrimaryPhone') IS NOT NULL
    BEGIN
        PRINT 'Populating PrimaryPhone_Enc from PrimaryPhone (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET PrimaryPhone_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), PrimaryPhone))
            WHERE PrimaryPhone_Enc IS NULL AND PrimaryPhone IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','PrimaryPhone_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating PrimaryPhone_Enc from PrimaryPhone_PLAIN_BAK (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET PrimaryPhone_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), PrimaryPhone_PLAIN_BAK))
            WHERE PrimaryPhone_Enc IS NULL AND PrimaryPhone_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    -- AlternatePhone 
    IF COL_LENGTH('dbo.RESIDENT','AlternatePhone') IS NOT NULL
    BEGIN
        PRINT 'Populating AlternatePhone_Enc from AlternatePhone (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET AlternatePhone_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), AlternatePhone))
            WHERE AlternatePhone_Enc IS NULL AND AlternatePhone IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','AlternatePhone_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating AlternatePhone_Enc from AlternatePhone_PLAIN_BAK (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET AlternatePhone_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), AlternatePhone_PLAIN_BAK))
            WHERE AlternatePhone_Enc IS NULL AND AlternatePhone_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    -- CurrentAddress 
    IF COL_LENGTH('dbo.RESIDENT','CurrentAddress') IS NOT NULL
    BEGIN
        PRINT 'Populating CurrentAddress_Enc from CurrentAddress (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET CurrentAddress_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), CurrentAddress))
            WHERE CurrentAddress_Enc IS NULL AND CurrentAddress IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.RESIDENT','CurrentAddress_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating CurrentAddress_Enc from CurrentAddress_PLAIN_BAK (dynamic SQL)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.RESIDENT
            SET CurrentAddress_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), CurrentAddress_PLAIN_BAK))
            WHERE CurrentAddress_Enc IS NULL AND CurrentAddress_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    -- rename original plaintext to backups 
    IF COL_LENGTH('dbo.RESIDENT','EmailAddress') IS NOT NULL AND COL_LENGTH('dbo.RESIDENT','EmailAddress_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming EmailAddress -> EmailAddress_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.RESIDENT.EmailAddress'', ''EmailAddress_PLAIN_BAK'', ''COLUMN'';';
    END
    IF COL_LENGTH('dbo.RESIDENT','SSNLast4') IS NOT NULL AND COL_LENGTH('dbo.RESIDENT','SSNLast4_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming SSNLast4 -> SSNLast4_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.RESIDENT.SSNLast4'', ''SSNLast4_PLAIN_BAK'', ''COLUMN'';';
    END
    IF COL_LENGTH('dbo.RESIDENT','PrimaryPhone') IS NOT NULL AND COL_LENGTH('dbo.RESIDENT','PrimaryPhone_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming PrimaryPhone -> PrimaryPhone_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.RESIDENT.PrimaryPhone'', ''PrimaryPhone_PLAIN_BAK'', ''COLUMN'';';
    END
    IF COL_LENGTH('dbo.RESIDENT','AlternatePhone') IS NOT NULL AND COL_LENGTH('dbo.RESIDENT','AlternatePhone_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming AlternatePhone -> AlternatePhone_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.RESIDENT.AlternatePhone'', ''AlternatePhone_PLAIN_BAK'', ''COLUMN'';';
    END
    IF COL_LENGTH('dbo.RESIDENT','CurrentAddress') IS NOT NULL AND COL_LENGTH('dbo.RESIDENT','CurrentAddress_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming CurrentAddress -> CurrentAddress_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.RESIDENT.CurrentAddress'', ''CurrentAddress_PLAIN_BAK'', ''COLUMN'';';
    END
END
ELSE
    PRINT 'RESIDENT table not found; skipping RESIDENT block.';
GO

-- Create encrypted view and decryption procedure
IF OBJECT_ID('dbo.RESIDENT','U') IS NOT NULL AND COL_LENGTH('dbo.RESIDENT','EmailAddress_Enc') IS NOT NULL
BEGIN
    IF OBJECT_ID('dbo.vRESIDENT_Encrypted','V') IS NOT NULL DROP VIEW dbo.vRESIDENT_Encrypted;
    EXEC sp_executesql N'
    CREATE VIEW dbo.vRESIDENT_Encrypted
    AS
    SELECT
        ResidentID,
        FirstName,
        LastName,
        sys.fn_varbintohexstr(EmailAddress_Enc)   AS EmailAddress_Encrypted,
        sys.fn_varbintohexstr(SSNLast4_Enc)       AS SSNLast4_Encrypted,
        sys.fn_varbintohexstr(PrimaryPhone_Enc)   AS PrimaryPhone_Encrypted,
        sys.fn_varbintohexstr(AlternatePhone_Enc) AS AlternatePhone_Encrypted,
        sys.fn_varbintohexstr(CurrentAddress_Enc) AS CurrentAddress_Encrypted,
        AccountStatus, CreatedDate, ModifiedDate
    FROM dbo.RESIDENT;
    ';
    PRINT 'Created/Updated view vRESIDENT_Encrypted.';

    IF OBJECT_ID('dbo.GetResident_Decrypted','P') IS NOT NULL DROP PROCEDURE dbo.GetResident_Decrypted;
    EXEC sp_executesql N'
    CREATE PROCEDURE dbo.GetResident_Decrypted
        @ResidentID INT = NULL
    WITH EXECUTE AS OWNER
    AS
    BEGIN
        SET NOCOUNT ON;
        OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;

        SELECT
            ResidentID,
            FirstName,
            LastName,
            CONVERT(varchar(200), DecryptByKey(EmailAddress_Enc))   AS EmailAddress,
            CONVERT(varchar(50),  DecryptByKey(SSNLast4_Enc))       AS SSNLast4,
            CONVERT(varchar(20),  DecryptByKey(PrimaryPhone_Enc))   AS PrimaryPhone,
            CONVERT(varchar(20),  DecryptByKey(AlternatePhone_Enc)) AS AlternatePhone,
            CONVERT(varchar(300), DecryptByKey(CurrentAddress_Enc)) AS CurrentAddress,
            AccountStatus, CreatedDate, ModifiedDate
        FROM dbo.RESIDENT
        WHERE (@ResidentID IS NULL OR ResidentID = @ResidentID);

        CLOSE SYMMETRIC KEY SymKey_PII;
    END;
    ';
    PRINT 'Created/Updated proc GetResident_Decrypted.';
END
ELSE
    PRINT 'Skipping view/proc creation for RESIDENT (enc columns missing).';
GO

/************************************************************************
  3) INVOICE:
************************************************************************/
IF OBJECT_ID('dbo.INVOICE','U') IS NOT NULL
BEGIN
    IF COL_LENGTH('dbo.INVOICE','InvoiceNumber_Enc') IS NULL
    BEGIN
        ALTER TABLE dbo.INVOICE ADD
            InvoiceNumber_Enc VARBINARY(MAX),
            PaymentMethod_Enc VARBINARY(256),
            PaymentReference_Enc VARBINARY(MAX);
        PRINT 'Added encrypted columns to INVOICE.';
    END
    ELSE
        PRINT 'INVOICE encrypted columns already exist.';

    -- Populate related data
    IF COL_LENGTH('dbo.INVOICE','InvoiceNumber') IS NOT NULL
    BEGIN
        PRINT 'Populating InvoiceNumber_Enc from InvoiceNumber (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.INVOICE
            SET InvoiceNumber_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), InvoiceNumber))
            WHERE InvoiceNumber_Enc IS NULL AND InvoiceNumber IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.INVOICE','InvoiceNumber_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating InvoiceNumber_Enc from InvoiceNumber_PLAIN_BAK (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.INVOICE
            SET InvoiceNumber_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), InvoiceNumber_PLAIN_BAK))
            WHERE InvoiceNumber_Enc IS NULL AND InvoiceNumber_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    IF COL_LENGTH('dbo.INVOICE','PaymentMethod') IS NOT NULL
    BEGIN
        PRINT 'Populating PaymentMethod_Enc from PaymentMethod (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.INVOICE
            SET PaymentMethod_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), PaymentMethod))
            WHERE PaymentMethod_Enc IS NULL AND PaymentMethod IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.INVOICE','PaymentMethod_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating PaymentMethod_Enc from PaymentMethod_PLAIN_BAK (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.INVOICE
            SET PaymentMethod_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), PaymentMethod_PLAIN_BAK))
            WHERE PaymentMethod_Enc IS NULL AND PaymentMethod_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    IF COL_LENGTH('dbo.INVOICE','PaymentReference') IS NOT NULL
    BEGIN
        PRINT 'Populating PaymentReference_Enc from PaymentReference (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.INVOICE
            SET PaymentReference_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), PaymentReference))
            WHERE PaymentReference_Enc IS NULL AND PaymentReference IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.INVOICE','PaymentReference_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating PaymentReference_Enc from PaymentReference_PLAIN_BAK (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.INVOICE
            SET PaymentReference_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), PaymentReference_PLAIN_BAK))
            WHERE PaymentReference_Enc IS NULL AND PaymentReference_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    -- rename originals to backups 
    IF COL_LENGTH('dbo.INVOICE','InvoiceNumber') IS NOT NULL AND COL_LENGTH('dbo.INVOICE','InvoiceNumber_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming INVOICE.InvoiceNumber -> InvoiceNumber_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.INVOICE.InvoiceNumber'', ''InvoiceNumber_PLAIN_BAK'', ''COLUMN'';';
    END
    IF COL_LENGTH('dbo.INVOICE','PaymentMethod') IS NOT NULL AND COL_LENGTH('dbo.INVOICE','PaymentMethod_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming INVOICE.PaymentMethod -> PaymentMethod_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.INVOICE.PaymentMethod'', ''PaymentMethod_PLAIN_BAK'', ''COLUMN'';';
    END
    IF COL_LENGTH('dbo.INVOICE','PaymentReference') IS NOT NULL AND COL_LENGTH('dbo.INVOICE','PaymentReference_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming INVOICE.PaymentReference -> PaymentReference_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.INVOICE.PaymentReference'', ''PaymentReference_PLAIN_BAK'', ''COLUMN'';';
    END
END
ELSE
    PRINT 'INVOICE table not present; skipping INVOICE block.';
GO

-- Create view & proc for INVOICE 
IF OBJECT_ID('dbo.INVOICE','U') IS NOT NULL AND COL_LENGTH('dbo.INVOICE','InvoiceNumber_Enc') IS NOT NULL
BEGIN
    IF OBJECT_ID('dbo.vINVOICE_Encrypted','V') IS NOT NULL DROP VIEW dbo.vINVOICE_Encrypted;
    EXEC sp_executesql N'
    CREATE VIEW dbo.vINVOICE_Encrypted
    AS
    SELECT
        InvoiceID,
        WorkOrderID,
        VendorID,
        sys.fn_varbintohexstr(InvoiceNumber_Enc)     AS InvoiceNumber_Encrypted,
        InvoiceDate,
        DueDate,
        LaborCost,
        MaterialCost,
        TaxAmount,
        TotalAmount,
        sys.fn_varbintohexstr(PaymentMethod_Enc)     AS PaymentMethod_Encrypted,
        sys.fn_varbintohexstr(PaymentReference_Enc)  AS PaymentReference_Encrypted,
        PaymentStatus, PaymentDate, CreatedDate, ModifiedDate
    FROM dbo.INVOICE;
    ';
    PRINT 'Created/Updated view vINVOICE_Encrypted.';

    IF OBJECT_ID('dbo.GetInvoice_Decrypted','P') IS NOT NULL DROP PROCEDURE dbo.GetInvoice_Decrypted;
    EXEC sp_executesql N'
    CREATE PROCEDURE dbo.GetInvoice_Decrypted
        @InvoiceID INT = NULL
    WITH EXECUTE AS OWNER
    AS
    BEGIN
        SET NOCOUNT ON;
        OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;

        SELECT
            InvoiceID,
            InvoiceNumber = CONVERT(varchar(200), DecryptByKey(InvoiceNumber_Enc)),
            WorkOrderID, VendorID,
            InvoiceDate, DueDate,
            LaborCost, MaterialCost, TaxAmount, TotalAmount,
            PaymentMethod = CONVERT(varchar(100), DecryptByKey(PaymentMethod_Enc)),
            PaymentReference = CONVERT(varchar(300), DecryptByKey(PaymentReference_Enc)),
            PaymentStatus, PaymentDate, CreatedDate, ModifiedDate
        FROM dbo.INVOICE
        WHERE (@InvoiceID IS NULL OR InvoiceID = @InvoiceID);

        CLOSE SYMMETRIC KEY SymKey_PII;
    END;
    ';
    PRINT 'Created/Updated proc GetInvoice_Decrypted.';
END
ELSE
    PRINT 'Skipping creation of INVOICE view/proc (enc columns missing).';
GO

/************************************************************************
  4) PAYMENT_TRANSACTION: 
************************************************************************/
IF OBJECT_ID('dbo.PAYMENT_TRANSACTION','U') IS NOT NULL
BEGIN
    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber_Enc') IS NULL
    BEGIN
        ALTER TABLE dbo.PAYMENT_TRANSACTION ADD
            ReferenceNumber_Enc VARBINARY(MAX),
            PaymentMethod_Enc VARBINARY(256);
        PRINT 'Added encrypted columns to PAYMENT_TRANSACTION.';
    END
    ELSE
        PRINT 'PAYMENT_TRANSACTION encrypted columns already exist.';

    -- ReferenceNumber source
    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber') IS NOT NULL
    BEGIN
        PRINT 'Populating ReferenceNumber_Enc from ReferenceNumber (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.PAYMENT_TRANSACTION
            SET ReferenceNumber_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), ReferenceNumber))
            WHERE ReferenceNumber_Enc IS NULL AND ReferenceNumber IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating ReferenceNumber_Enc from ReferenceNumber_PLAIN_BAK (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.PAYMENT_TRANSACTION
            SET ReferenceNumber_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), ReferenceNumber_PLAIN_BAK))
            WHERE ReferenceNumber_Enc IS NULL AND ReferenceNumber_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    -- PaymentMethod source
    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod') IS NOT NULL
    BEGIN
        PRINT 'Populating PaymentMethod_Enc from PaymentMethod (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.PAYMENT_TRANSACTION
            SET PaymentMethod_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), PaymentMethod))
            WHERE PaymentMethod_Enc IS NULL AND PaymentMethod IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END
    ELSE IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod_PLAIN_BAK') IS NOT NULL
    BEGIN
        PRINT 'Populating PaymentMethod_Enc from PaymentMethod_PLAIN_BAK (dynamic)...';
        EXEC sp_executesql N'
            OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;
            UPDATE dbo.PAYMENT_TRANSACTION
            SET PaymentMethod_Enc = EncryptByKey(Key_GUID(''SymKey_PII''), CONVERT(varbinary(max), PaymentMethod_PLAIN_BAK))
            WHERE PaymentMethod_Enc IS NULL AND PaymentMethod_PLAIN_BAK IS NOT NULL;
            CLOSE SYMMETRIC KEY SymKey_PII;
        ';
    END

    -- rename originals to backups if present
    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber') IS NOT NULL AND COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming PAYMENT_TRANSACTION.ReferenceNumber -> ReferenceNumber_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.PAYMENT_TRANSACTION.ReferenceNumber'', ''ReferenceNumber_PLAIN_BAK'', ''COLUMN'';';
    END
    IF COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod') IS NOT NULL AND COL_LENGTH('dbo.PAYMENT_TRANSACTION','PaymentMethod_PLAIN_BAK') IS NULL
    BEGIN
        PRINT 'Renaming PAYMENT_TRANSACTION.PaymentMethod -> PaymentMethod_PLAIN_BAK';
        EXEC sp_executesql N'EXEC sp_rename ''dbo.PAYMENT_TRANSACTION.PaymentMethod'', ''PaymentMethod_PLAIN_BAK'', ''COLUMN'';';
    END
END
ELSE
    PRINT 'PAYMENT_TRANSACTION table not present; skipping PAYMENT_TRANSACTION block.';
GO

-- Create view & proc for PAYMENT_TRANSACTION 
IF OBJECT_ID('dbo.PAYMENT_TRANSACTION','U') IS NOT NULL AND COL_LENGTH('dbo.PAYMENT_TRANSACTION','ReferenceNumber_Enc') IS NOT NULL
BEGIN
    IF OBJECT_ID('dbo.vPAYMENT_TRANSACTION_Encrypted','V') IS NOT NULL DROP VIEW dbo.vPAYMENT_TRANSACTION_Encrypted;
    EXEC sp_executesql N'
    CREATE VIEW dbo.vPAYMENT_TRANSACTION_Encrypted
    AS
    SELECT
        TransactionID,
        LeaseID,
        ResidentID,
        TransactionType,
        TransactionDate,
        DueDate,
        AmountDue,
        AmountPaid,
        sys.fn_varbintohexstr(ReferenceNumber_Enc) AS ReferenceNumber_Encrypted,
        sys.fn_varbintohexstr(PaymentMethod_Enc)  AS PaymentMethod_Encrypted,
        TransactionStatus, CreatedDate, ModifiedDate
    FROM dbo.PAYMENT_TRANSACTION;
    ';
    PRINT 'Created/Updated view vPAYMENT_TRANSACTION_Encrypted.';

    IF OBJECT_ID('dbo.GetPaymentTransaction_Decrypted','P') IS NOT NULL DROP PROCEDURE dbo.GetPaymentTransaction_Decrypted;
    EXEC sp_executesql N'
    CREATE PROCEDURE dbo.GetPaymentTransaction_Decrypted
        @TransactionID INT = NULL
    WITH EXECUTE AS OWNER
    AS
    BEGIN
        SET NOCOUNT ON;
        OPEN SYMMETRIC KEY SymKey_PII DECRYPTION BY CERTIFICATE PiiCert;

        SELECT
            TransactionID,
            LeaseID,
            ResidentID,
            TransactionType,
            TransactionDate,
            DueDate,
            AmountDue,
            AmountPaid,
            ReferenceNumber = CONVERT(varchar(300), DecryptByKey(ReferenceNumber_Enc)),
            PaymentMethod = CONVERT(varchar(100), DecryptByKey(PaymentMethod_Enc)),
            TransactionStatus, CreatedDate, ModifiedDate
        FROM dbo.PAYMENT_TRANSACTION
        WHERE (@TransactionID IS NULL OR TransactionID = @TransactionID);

        CLOSE SYMMETRIC KEY SymKey_PII;
    END;
    ';
    PRINT 'Created/Updated proc GetPaymentTransaction_Decrypted.';
END
ELSE
    PRINT 'Skipping creation of PAYMENT_TRANSACTION view/proc (enc columns missing).';
GO


-- Verification  (run separately)
PRINT 'Verification examples (run separately):';
PRINT 'SELECT TOP 5 * FROM dbo.vRESIDENT_Encrypted;';
PRINT 'EXEC dbo.GetResident_Decrypted @ResidentID = 300;';
PRINT 'SELECT TOP 5 * FROM dbo.vINVOICE_Encrypted;';
PRINT 'EXEC dbo.GetInvoice_Decrypted @InvoiceID = 44445;';
PRINT 'SELECT TOP 5 * FROM dbo.vPAYMENT_TRANSACTION_Encrypted;';
PRINT 'EXEC dbo.GetPaymentTransaction_Decrypted @TransactionID = 676;';
GO

