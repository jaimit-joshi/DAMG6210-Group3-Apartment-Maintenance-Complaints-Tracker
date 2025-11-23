-- =====================================================
-- FRESH START: Drop all tables and recreate
-- =====================================================
-- This script will drop all existing tables and recreate them fresh
-- Run this if you get "relation already exists" errors

-- Drop all tables in reverse dependency order
DROP TABLE IF EXISTS payment_transaction CASCADE;
DROP TABLE IF EXISTS notification CASCADE;
DROP TABLE IF EXISTS escalation CASCADE;
DROP TABLE IF EXISTS invoice CASCADE;
DROP TABLE IF EXISTS worker_assignment CASCADE;
DROP TABLE IF EXISTS work_order CASCADE;
DROP TABLE IF EXISTS maintenance_request CASCADE;
DROP TABLE IF EXISTS building_manager_assignment CASCADE;
DROP TABLE IF EXISTS apt_unit_amenity CASCADE;
DROP TABLE IF EXISTS building_amenity CASCADE;
DROP TABLE IF EXISTS lease_occupant CASCADE;
DROP TABLE IF EXISTS emergency_contact CASCADE;
DROP TABLE IF EXISTS lease CASCADE;
DROP TABLE IF EXISTS worker CASCADE;
DROP TABLE IF EXISTS amenity CASCADE;
DROP TABLE IF EXISTS maintenance_category CASCADE;
DROP TABLE IF EXISTS vendor_company CASCADE;
DROP TABLE IF EXISTS property_manager CASCADE;
DROP TABLE IF EXISTS resident CASCADE;
DROP TABLE IF EXISTS apartment_unit CASCADE;
DROP TABLE IF EXISTS building CASCADE;

-- =====================================================
-- CREATE ALL TABLES (from supabase-schema.sql)
-- =====================================================

-- 1. BUILDING Table
CREATE TABLE IF NOT EXISTS building (
    building_id INT PRIMARY KEY,
    building_name VARCHAR(150) NOT NULL,
    street_address VARCHAR(100) NOT NULL,
    city VARCHAR(30) NOT NULL,
    state VARCHAR(20) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    year_built INT NOT NULL CHECK (year_built >= 1900 AND year_built <= EXTRACT(YEAR FROM NOW())),
    number_of_floors INT NOT NULL CHECK (number_of_floors > 0),
    total_units INT NOT NULL CHECK (total_units > 0),
    building_type VARCHAR(50) NOT NULL,
    has_elevator BOOLEAN NOT NULL DEFAULT FALSE,
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 2. APARTMENT_UNIT Table
CREATE TABLE IF NOT EXISTS apartment_unit (
    unit_id INT PRIMARY KEY,
    building_id INT NOT NULL REFERENCES building(building_id),
    unit_number VARCHAR(30) NOT NULL,
    floor_number INT NOT NULL,
    unit_type VARCHAR(50) NOT NULL,
    square_footage INT NOT NULL CHECK (square_footage > 0),
    number_bedrooms INT NOT NULL CHECK (number_bedrooms >= 0),
    number_bathrooms DECIMAL(3,2) NOT NULL CHECK (number_bathrooms > 0),
    base_rent_amount DECIMAL(10,2) NOT NULL CHECK (base_rent_amount >= 0),
    unit_status VARCHAR(50) NOT NULL DEFAULT 'Available',
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (building_id, unit_number)
);

-- 3. RESIDENT Table
CREATE TABLE IF NOT EXISTS resident (
    resident_id INT PRIMARY KEY,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    date_of_birth DATE NOT NULL,
    ssn_last4 VARCHAR(4),
    primary_phone VARCHAR(10) NOT NULL,
    alternate_phone VARCHAR(10),
    email_address VARCHAR(100) NOT NULL,
    current_address VARCHAR(300),
    account_status VARCHAR(50) NOT NULL DEFAULT 'Active',
    background_check_status VARCHAR(50),
    background_check_date DATE,
    credit_score INT CHECK (credit_score IS NULL OR (credit_score >= 300 AND credit_score <= 850)),
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 4. PROPERTY_MANAGER Table
CREATE TABLE IF NOT EXISTS property_manager (
    manager_id INT PRIMARY KEY,
    employee_id VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email_address VARCHAR(100) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    hire_date DATE NOT NULL,
    manager_role VARCHAR(40) NOT NULL,
    max_approval_limit INT CHECK (max_approval_limit >= 0),
    account_status VARCHAR(30) NOT NULL DEFAULT 'Active',
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 5. VENDOR_COMPANY Table
CREATE TABLE IF NOT EXISTS vendor_company (
    vendor_id INT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    tax_id VARCHAR(50) NOT NULL UNIQUE,
    primary_contact_name VARCHAR(150) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    email_address VARCHAR(100) NOT NULL,
    street_address VARCHAR(100) NOT NULL,
    city VARCHAR(30) NOT NULL,
    state VARCHAR(30) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    license_number VARCHAR(20),
    license_expiry_date DATE,
    insurance_policy_number VARCHAR(50),
    insurance_expiry_date DATE,
    vendor_status VARCHAR(15) NOT NULL DEFAULT 'Active',
    is_preferred BOOLEAN NOT NULL DEFAULT FALSE,
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 6. MAINTENANCE_CATEGORY Table
CREATE TABLE IF NOT EXISTS maintenance_category (
    category_id INT PRIMARY KEY,
    category_code VARCHAR(50) NOT NULL UNIQUE,
    category_name VARCHAR(150) NOT NULL,
    category_description VARCHAR(300),
    default_priority VARCHAR(50) NOT NULL,
    target_response_hours DECIMAL(5,2) NOT NULL CHECK (target_response_hours > 0),
    target_resolution_hours DECIMAL(5,2) NOT NULL CHECK (target_resolution_hours > 0),
    requires_work_order BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 7. AMENITY Table
CREATE TABLE IF NOT EXISTS amenity (
    amenity_id INT PRIMARY KEY,
    amenity_code VARCHAR(30) NOT NULL UNIQUE,
    amenity_name VARCHAR(40) NOT NULL,
    amenity_type VARCHAR(50) NOT NULL,
    description VARCHAR(300),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- 8. WORKER Table
CREATE TABLE IF NOT EXISTS worker (
    worker_id INT PRIMARY KEY,
    vendor_id INT NOT NULL REFERENCES vendor_company(vendor_id),
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    employee_id VARCHAR(20),
    worker_type VARCHAR(20) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    email_address VARCHAR(100),
    hourly_rate DECIMAL(6,2) CHECK (hourly_rate > 0),
    license_number VARCHAR(50),
    license_expiry_date DATE,
    specialization VARCHAR(30),
    worker_status VARCHAR(15) NOT NULL DEFAULT 'Active',
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 9. LEASE Table
CREATE TABLE IF NOT EXISTS lease (
    lease_id INT PRIMARY KEY,
    resident_id INT NOT NULL REFERENCES resident(resident_id),
    unit_id INT NOT NULL REFERENCES apartment_unit(unit_id),
    prepared_by_manager_id INT NOT NULL REFERENCES property_manager(manager_id),
    lease_start_date DATE NOT NULL,
    lease_end_date DATE NOT NULL,
    monthly_rent_amount DECIMAL(10,2) NOT NULL CHECK (monthly_rent_amount > 0),
    security_deposit_amount DECIMAL(10,2) NOT NULL CHECK (security_deposit_amount >= 0),
    pet_deposit_amount DECIMAL(10,2) DEFAULT 0 CHECK (pet_deposit_amount >= 0),
    payment_due_day INT NOT NULL CHECK (payment_due_day >= 1 AND payment_due_day <= 31),
    late_fee_amount DECIMAL(10,2) DEFAULT 0 CHECK (late_fee_amount >= 0),
    grace_period_days INT DEFAULT 5 CHECK (grace_period_days >= 0),
    lease_status VARCHAR(50) NOT NULL DEFAULT 'Draft',
    signed_date DATE,
    move_in_date DATE,
    move_out_date DATE,
    termination_reason VARCHAR(200),
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (lease_end_date > lease_start_date)
);

-- 10. EMERGENCY_CONTACT Table
CREATE TABLE IF NOT EXISTS emergency_contact (
    contact_id INT PRIMARY KEY,
    resident_id INT NOT NULL REFERENCES resident(resident_id),
    contact_name VARCHAR(150) NOT NULL,
    relationship VARCHAR(100) NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    alternate_phone VARCHAR(10),
    email_address VARCHAR(100),
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 11. LEASE_OCCUPANT Table
CREATE TABLE IF NOT EXISTS lease_occupant (
    occupant_id INT PRIMARY KEY,
    lease_id INT NOT NULL REFERENCES lease(lease_id),
    resident_id INT NOT NULL REFERENCES resident(resident_id),
    occupant_type VARCHAR(100) NOT NULL,
    move_in_date DATE NOT NULL,
    move_out_date DATE,
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 12. BUILDING_AMENITY Table
CREATE TABLE IF NOT EXISTS building_amenity (
    building_amenity_id INT PRIMARY KEY,
    building_id INT NOT NULL REFERENCES building(building_id),
    amenity_id INT NOT NULL REFERENCES amenity(amenity_id),
    amenity_location VARCHAR(50),
    access_restrictions VARCHAR(50),
    additional_fee DECIMAL(10,2) DEFAULT 0 CHECK (additional_fee >= 0),
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 13. APT_UNIT_AMENITY Table
CREATE TABLE IF NOT EXISTS apt_unit_amenity (
    unit_amenity_id INT PRIMARY KEY,
    unit_id INT NOT NULL REFERENCES apartment_unit(unit_id),
    amenity_id INT NOT NULL REFERENCES amenity(amenity_id),
    installation_date DATE,
    condition VARCHAR(100),
    last_service_date DATE,
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 14. BUILDING_MANAGER_ASSIGNMENT Table
CREATE TABLE IF NOT EXISTS building_manager_assignment (
    assignment_id INT PRIMARY KEY,
    building_id INT NOT NULL REFERENCES building(building_id),
    manager_id INT NOT NULL REFERENCES property_manager(manager_id),
    assignment_start_date DATE NOT NULL,
    assignment_end_date DATE,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 15. MAINTENANCE_REQUEST Table
CREATE TABLE IF NOT EXISTS maintenance_request (
    request_id INT PRIMARY KEY,
    resident_id INT NOT NULL REFERENCES resident(resident_id),
    unit_id INT NOT NULL REFERENCES apartment_unit(unit_id),
    category_id INT NOT NULL REFERENCES maintenance_category(category_id),
    request_title VARCHAR(75) NOT NULL,
    request_description VARCHAR(500) NOT NULL,
    request_priority VARCHAR(100) NOT NULL,
    request_status VARCHAR(100) NOT NULL DEFAULT 'Submitted',
    submitted_date TIMESTAMP NOT NULL DEFAULT NOW(),
    acknowledged_date TIMESTAMP,
    completed_date TIMESTAMP,
    permission_to_enter BOOLEAN NOT NULL DEFAULT FALSE,
    pet_on_premises BOOLEAN NOT NULL DEFAULT FALSE,
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 16. WORK_ORDER Table
CREATE TABLE IF NOT EXISTS work_order (
    work_order_id INT PRIMARY KEY,
    work_order_number VARCHAR(50) NOT NULL UNIQUE,
    request_id INT REFERENCES maintenance_request(request_id),
    unit_id INT NOT NULL REFERENCES apartment_unit(unit_id),
    created_by_manager_id INT NOT NULL REFERENCES property_manager(manager_id),
    vendor_id INT REFERENCES vendor_company(vendor_id),
    work_type VARCHAR(50) NOT NULL,
    work_description VARCHAR(200) NOT NULL,
    scheduled_date DATE,
    start_date_time TIMESTAMP,
    completion_date_time TIMESTAMP,
    work_status VARCHAR(15) NOT NULL DEFAULT 'Pending',
    estimated_cost DECIMAL(10,2) CHECK (estimated_cost >= 0),
    actual_cost DECIMAL(10,2) CHECK (actual_cost >= 0),
    requires_approval BOOLEAN NOT NULL DEFAULT FALSE,
    approved_by_manager_id INT REFERENCES property_manager(manager_id),
    approval_date TIMESTAMP,
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 17. WORKER_ASSIGNMENT Table
CREATE TABLE IF NOT EXISTS worker_assignment (
    assignment_id INT PRIMARY KEY,
    work_order_id INT NOT NULL REFERENCES work_order(work_order_id),
    worker_id INT NOT NULL REFERENCES worker(worker_id),
    assigned_date TIMESTAMP NOT NULL DEFAULT NOW(),
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    hours_worked DECIMAL(5,2) CHECK (hours_worked >= 0),
    worker_role VARCHAR(30) NOT NULL,
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 18. INVOICE Table
CREATE TABLE IF NOT EXISTS invoice (
    invoice_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_number VARCHAR(70) NOT NULL UNIQUE,
    work_order_id INT NOT NULL REFERENCES work_order(work_order_id),
    vendor_id INT NOT NULL REFERENCES vendor_company(vendor_id),
    approved_by_manager_id INT REFERENCES property_manager(manager_id),
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    labor_cost DECIMAL(10,2) DEFAULT 0 CHECK (labor_cost >= 0),
    material_cost DECIMAL(10,2) DEFAULT 0 CHECK (material_cost >= 0),
    tax_amount DECIMAL(10,2) DEFAULT 0 CHECK (tax_amount >= 0),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    payment_status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    payment_date DATE,
    payment_method VARCHAR(100),
    payment_reference VARCHAR(200),
    approval_date TIMESTAMP,
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 19. ESCALATION Table
CREATE TABLE IF NOT EXISTS escalation (
    escalation_id INT PRIMARY KEY,
    request_id INT NOT NULL REFERENCES maintenance_request(request_id),
    escalation_level INT NOT NULL CHECK (escalation_level >= 1),
    escalated_by_manager_id INT NOT NULL REFERENCES property_manager(manager_id),
    escalation_reason VARCHAR(500) NOT NULL,
    escalation_date TIMESTAMP NOT NULL DEFAULT NOW(),
    target_resolution_date DATE,
    resolution_date TIMESTAMP,
    resolution_notes VARCHAR(500),
    escalation_status VARCHAR(50) NOT NULL DEFAULT 'Active',
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 20. NOTIFICATION Table
CREATE TABLE IF NOT EXISTS notification (
    notification_id SERIAL PRIMARY KEY,
    resident_id INT NOT NULL REFERENCES resident(resident_id),
    request_id INT REFERENCES maintenance_request(request_id),
    notification_type VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message_body VARCHAR(500) NOT NULL,
    priority VARCHAR(50) NOT NULL DEFAULT 'Normal',
    delivery_channel VARCHAR(50) NOT NULL,
    scheduled_send_date TIMESTAMP,
    actual_sent_date TIMESTAMP,
    delivery_status VARCHAR(60) NOT NULL DEFAULT 'Pending',
    read_date TIMESTAMP,
    created_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 21. PAYMENT_TRANSACTION Table
CREATE TABLE IF NOT EXISTS payment_transaction (
    transaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lease_id INT NOT NULL REFERENCES lease(lease_id),
    resident_id INT NOT NULL REFERENCES resident(resident_id),
    transaction_type VARCHAR(50) NOT NULL,
    transaction_date DATE NOT NULL,
    due_date DATE,
    amount_due DECIMAL(10,2) CHECK (amount_due >= 0),
    amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid >= 0),
    payment_method VARCHAR(100) NOT NULL,
    reference_number VARCHAR(200),
    transaction_status VARCHAR(40) NOT NULL DEFAULT 'Pending',
    created_date TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_date TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_building_city ON building(city);
CREATE INDEX idx_apartment_unit_building ON apartment_unit(building_id);
CREATE INDEX idx_resident_email ON resident(email_address);
CREATE INDEX idx_lease_resident ON lease(resident_id);
CREATE INDEX idx_lease_unit ON lease(unit_id);
CREATE INDEX idx_maintenance_request_resident ON maintenance_request(resident_id);
CREATE INDEX idx_maintenance_request_status ON maintenance_request(request_status);
CREATE INDEX idx_work_order_status ON work_order(work_status);
CREATE INDEX idx_invoice_status ON invoice(payment_status);
CREATE INDEX idx_payment_transaction_status ON payment_transaction(transaction_status);
