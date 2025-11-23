-- =====================================================
-- COMPLETE SEED DATA FOR APARTMENT MANAGEMENT DATABASE
-- (Original rows + added rows to bring each table to 10)
-- =====================================================


-- Clear existing data (in reverse order of dependencies)
TRUNCATE TABLE payment_transaction CASCADE;
TRUNCATE TABLE notification CASCADE;
TRUNCATE TABLE escalation CASCADE;
TRUNCATE TABLE invoice CASCADE;
TRUNCATE TABLE worker_assignment CASCADE;
TRUNCATE TABLE work_order CASCADE;
TRUNCATE TABLE maintenance_request CASCADE;
TRUNCATE TABLE building_manager_assignment CASCADE;
TRUNCATE TABLE apt_unit_amenity CASCADE;
TRUNCATE TABLE building_amenity CASCADE;
TRUNCATE TABLE lease_occupant CASCADE;
TRUNCATE TABLE emergency_contact CASCADE;
TRUNCATE TABLE lease CASCADE;
TRUNCATE TABLE worker CASCADE;
TRUNCATE TABLE amenity CASCADE;
TRUNCATE TABLE maintenance_category CASCADE;
TRUNCATE TABLE vendor_company CASCADE;
TRUNCATE TABLE property_manager CASCADE;
TRUNCATE TABLE resident CASCADE;
TRUNCATE TABLE apartment_unit CASCADE;
TRUNCATE TABLE building CASCADE;

-- ========================
-- BUILDING (10 rows total)
-- ========================
INSERT INTO building (building_id, building_name, street_address, city, state, zip_code, year_built, number_of_floors, total_units, building_type, has_elevator) VALUES
(1, 'Sunset Towers', '100 Main Street', 'Boston', 'MA', '02101', 2010, 10, 50, 'High Rise', TRUE),
(2, 'Riverside Apartments', '200 River Road', 'Cambridge', 'MA', '02139', 2015, 5, 25, 'Mid Rise', TRUE),
(3, 'Garden Court', '300 Oak Avenue', 'Somerville', 'MA', '02144', 2005, 3, 15, 'Low Rise', FALSE),
(4, 'Park Plaza', '400 Park Street', 'Boston', 'MA', '02102', 2018, 15, 75, 'High Rise', TRUE),
(5, 'Maple Gardens', '500 Maple Drive', 'Brookline', 'MA', '02445', 2008, 4, 20, 'Mid Rise', TRUE),
(6, 'Pine Heights', '600 Pine Street', 'Newton', 'MA', '02458', 2012, 6, 30, 'Mid Rise', TRUE),
(7, 'Downtown Lofts', '700 City Center', 'Boston', 'MA', '02103', 2020, 12, 60, 'High Rise', TRUE),
(8, 'Elm Residences', '800 Elm Way', 'Quincy', 'MA', '02169', 2007, 3, 18, 'Low Rise', FALSE),
(9, 'Harbor View', '900 Harbor Blvd', 'Boston', 'MA', '02104', 2019, 20, 100, 'High Rise', TRUE),
(10, 'Village Square', '1000 Village Rd', 'Medford', 'MA', '02155', 2011, 4, 24, 'Mid Rise', TRUE);

-- ===============================
-- APARTMENT_UNIT (10 rows total)
-- (Each row already contains number_bedrooms; left as-is)
-- ===============================
INSERT INTO apartment_unit (unit_id, building_id, unit_number, floor_number, unit_type, square_footage, number_bedrooms, number_bathrooms, base_rent_amount, unit_status) VALUES
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

-- =========================
-- RESIDENT (10 rows total)
-- (Added alternate_phone, current_address for random rows; ensured background_check_status and background_check_date for every row; credit_score present for each)
-- =========================
INSERT INTO resident (resident_id, first_name, last_name, date_of_birth, ssn_last4, primary_phone, alternate_phone, email_address, current_address, account_status, background_check_status, background_check_date, credit_score) VALUES
(1001, 'John', 'Smith', '1985-05-15', '1234', '6175550101', '6175550999', 'jsmith@email.com', '100 Main Street Apt 101, Boston, MA 02101', 'Active', 'Approved', '2024-12-01', 720),
(1002, 'Sarah', 'Johnson', '1990-08-22', '5678', '6175550102', NULL, 'sjohnson@email.com', NULL, 'Active', 'Approved', '2025-01-10', 680),
(1003, 'Michael', 'Brown', '1978-03-10', '9012', '6175550103', '6175550888', 'mbrown@email.com', '300 Oak Avenue Apt 2B, Somerville, MA 02144', 'Active', 'Approved', '2024-11-20', 750),
(1004, 'Emily', 'Davis', '1995-11-30', '3456', '6175550104', NULL, 'edavis@email.com', NULL, 'Active', 'Approved', '2025-01-05', 700),
(1005, 'Robert', 'Wilson', '1982-07-18', '7890', '6175550105', '6175550777', 'rwilson@email.com', '500 Maple Drive Apt 5, Brookline, MA 02445', 'Active', 'Approved', '2024-12-15', 690),
(1006, 'Lisa', 'Martinez', '1988-04-25', '2345', '6175550106', '6175550666', 'lmartinez@mail.com', NULL, 'Inactive', 'Approved', '2025-03-01', 650),
(1007, 'David', 'Anderson', '1975-09-05', '6789', '6175550107', NULL, 'danderson@mail.com', '700 City Center Apt 402, Boston, MA 02103', 'Active', 'Approved', '2024-10-10', 780),
(1008, 'Jennifer', 'Taylor', '1992-12-15', '0123', '6175550108', '6175550555', 'jtaylor@email.com', NULL, 'Active', 'Approved', '2025-02-20', 710),
(1009, 'William', 'Thomas', '1980-06-20', '4567', '6175550109', NULL, 'wthomas@email.com', '900 Harbor Blvd Apt 1101, Boston, MA 02104', 'Active', 'Approved', '2025-04-01', 730),
(1010, 'Patricia', 'Moore', '1987-02-14', '8901', '6175550110', '6175550444', 'pmoore@email.com', NULL, 'Active', 'Approved', '2024-12-20', 695);

-- ==================================
-- PROPERTY_MANAGER (10 rows total)
-- ==================================
INSERT INTO property_manager (manager_id, employee_id, first_name, last_name, email_address, phone_number, job_title, hire_date, manager_role, max_approval_limit, account_status) VALUES
(201, 'EMP001', 'James', 'Wilson', 'jwilson@apt.com', '6175550201', 'Senior Property Manager', '2015-03-01', 'Senior', 10000, 'Active'),
(202, 'EMP002', 'Mary', 'Garcia', 'mgarcia@apt.com', '6175550202', 'Property Manager', '2017-06-15', 'Standard', 5000, 'Active'),
(203, 'EMP003', 'Richard', 'Miller', 'rmiller@apt.com', '6175550203', 'Assistant Manager', '2019-09-01', 'Assistant', 2500, 'Active'),
(204, 'EMP004', 'Susan', 'Lee', 'slee@apt.com', '6175550204', 'Regional Manager', '2014-01-15', 'Executive', 25000, 'Active'),
(205, 'EMP005', 'Thomas', 'Clark', 'tclark@apt.com', '6175550205', 'Property Manager', '2018-04-01', 'Standard', 5000, 'Active'),
(206, 'EMP006', 'Karen', 'Lopez', 'klopez@apt.com', '6175550206', 'Property Manager', '2018-07-11', 'Standard', 5000, 'Active'),
(207, 'EMP007', 'Angela', 'Harris', 'aharris@apt.com', '6175550207', 'Assistant Manager', '2020-01-10', 'Assistant', 2500, 'Active'),
(208, 'EMP008', 'Steven', 'King', 'sking@apt.com', '6175550208', 'Property Manager', '2021-03-20', 'Standard', 5000, 'Active'),
(209, 'EMP009', 'Laura', 'Hall', 'lhall@apt.com', '6175550209', 'Senior Manager', '2016-10-05', 'Senior', 12000, 'Active'),
(210, 'EMP010', 'George', 'Young', 'gyoung@apt.com', '6175550210', 'Regional Manager', '2013-08-10', 'Executive', 25000, 'Active');

-- =================================
-- VENDOR_COMPANY (10 rows total)
-- (original 301-305, 306, 309 + 3 new)
-- =================================
INSERT INTO vendor_company (vendor_id, company_name, tax_id, primary_contact_name, phone_number, email_address, street_address, city, state, zip_code, license_number, vendor_status, is_preferred) VALUES
(301, 'ABC Plumbing', '12-3456789', 'Mike Johnson', '6175550301', 'info@abcplumb.com', '123 Trade St', 'Boston', 'MA', '02105', 'PLM-12345', 'Active', TRUE),
(302, 'Elite Electric', '23-4567890', 'Tom Brown', '6175550302', 'info@elite.com', '456 Power Ave', 'Cambridge', 'MA', '02140', 'ELE-67890', 'Active', TRUE),
(303, 'Pro Painters', '34-5678901', 'Sue White', '6175550303', 'info@paint.com', '789 Color Ln', 'Somerville', 'MA', '02145', 'PNT-11111', 'Active', FALSE),
(304, 'HVAC Masters', '45-6789012', 'Bob Green', '6175550304', 'info@hvac.com', '321 Air Way', 'Boston', 'MA', '02106', 'HVC-22222', 'Active', TRUE),
(305, 'Clean Sweep', '56-7890123', 'Amy Black', '6175550305', 'info@clean.com', '654 Mop Rd', 'Brookline', 'MA', '02446', 'CLN-33333', 'Active', FALSE),
(306, 'Locksmith Pro', '67-8901234', 'Joe Gray', '6175550306', 'info@locks.com', '987 Key St', 'Newton', 'MA', '02459', 'LCK-44444', 'Active', FALSE),
(309, 'Pest Control Plus', '90-1234567', 'Lisa Orange', '6175550309', 'info@pest.com', '369 Bug Ln', 'Medford', 'MA', '02156', 'PST-77777', 'Active', TRUE),
(310, 'Garden Landscaping Co', '78-2345678', 'Rick Moss', '6175550310', 'info@gardenland.com', '111 Green St', 'Boston', 'MA', '02107', 'LND-88888', 'Active', FALSE),
(311, 'Secure Locks', '89-3456789', 'Tim Stone', '6175550311', 'info@securelocks.com', '222 Safe Rd', 'Cambridge', 'MA', '02141', 'LCK-55555', 'Active', TRUE),
(312, 'Bright Windows', '90-4567890', 'Nina Glass', '6175550312', 'info@brightwindows.com', '333 Clear Ave', 'Somerville', 'MA', '02146', 'WND-99999', 'Active', FALSE);

-- =======================================
-- MAINTENANCE_CATEGORY (10 rows total)
-- (Added category_description for every row)
-- =======================================
INSERT INTO maintenance_category (category_id, category_code, category_name, category_description, default_priority, target_response_hours, target_resolution_hours) VALUES
(11, 'PLUMB', 'Plumbing', 'Issues related to plumbing fixtures, leaks, clogs, and pipe repair', 'High', 4.0, 24.0),
(12, 'ELEC', 'Electrical', 'Electrical faults, outlets, breakers, and internal wiring issues', 'High', 2.0, 12.0),
(13, 'HVAC', 'HVAC', 'Heating, ventilation, and air conditioning system maintenance and repair', 'Medium', 8.0, 48.0),
(14, 'APPL', 'Appliances', 'Major and minor appliance repair and replacement (dishwashers, ranges)', 'Medium', 12.0, 72.0),
(15, 'PAINT', 'Painting', 'Interior and exterior painting and touch-ups', 'Low', 24.0, 168.0),
(16, 'CLEAN', 'Cleaning', 'Deep cleaning, move-out cleaning, and special cleaning requests', 'Low', 48.0, 72.0),
(17, 'LOCK', 'Locksmith', 'Lockouts, rekeys, and lock hardware repairs', 'Medium', 6.0, 24.0),
(18, 'PEST', 'Pest Control', 'Pest inspections and treatment services', 'Medium', 12.0, 48.0),
(19, 'ROOF', 'Roofing', 'Roof leaks, shingle replacement, and gutter repairs', 'High', 4.0, 24.0),
(20, 'LAND', 'Landscaping', 'Groundskeeping, landscaping, and exterior plant maintenance', 'Low', 72.0, 168.0);

-- =========================
-- AMENITY (10 rows total)
-- (Added description for each amenity row)
-- =========================
INSERT INTO amenity (amenity_id, amenity_code, amenity_name, amenity_type, description, is_active) VALUES
(21, 'GYM', 'Fitness Center', 'Building', '24/7 fitness room with cardio and strength equipment', TRUE),
(22, 'POOL', 'Swimming Pool', 'Building', 'Outdoor heated pool, seasonal hours and lifeguard schedule', TRUE),
(23, 'PARK', 'Parking Space', 'Building', 'Assigned covered parking spaces with permit system', TRUE),
(24, 'WASH', 'Washer/Dryer', 'Unit', 'In-unit washer/dryer combo for resident convenience', TRUE),
(25, 'DISH', 'Dishwasher', 'Unit', 'Built-in dishwasher in kitchen', TRUE),
(26, 'AC', 'Air Conditioning', 'Unit', 'Central or window air conditioning depending on unit', TRUE),
(27, 'FRDG', 'Refrigerator', 'Unit', 'Full-size refrigerator included in unit', TRUE),
(28, 'STOR', 'Storage Unit', 'Building', 'Secured storage rooms available for rent', TRUE),
(29, 'SEC', 'Security System', 'Building', '24/7 monitored security and access control system', TRUE),
(30, 'COMM', 'Community Lounge', 'Building', 'Shared lounge for residents with kitchenette and seating', TRUE);

-- =========================
-- WORKER (10 rows total)
-- (Added employee_id and email_address for each worker)
-- =========================
INSERT INTO worker (worker_id, vendor_id, first_name, last_name, employee_id, worker_type, phone_number, email_address, hourly_rate, specialization, worker_status) VALUES
(401, 301, 'Joe', 'Plumber', 'WEMP001', 'Plumber', '6175550401', 'joe.plumber@abcplumb.com', 75.00, 'Residential', 'Active'),
(402, 301, 'Sam', 'Helper', 'WEMP002', 'Assistant', '6175550402', 'sam.helper@abcplumb.com', 35.00, 'General', 'Active'),
(403, 302, 'Bob', 'Electrician', 'WEMP003', 'Electrician', '6175550403', 'bob.electric@elite.com', 85.00, 'Residential', 'Active'),
(404, 302, 'Tim', 'Junior', 'WEMP004', 'Assistant', '6175550404', 'tim.junior@elite.com', 40.00, 'General', 'Active'),
(405, 304, 'Mike', 'Tech', 'WEMP005', 'HVAC Tech', '6175550405', 'mike.tech@hvac.com', 80.00, 'HVAC Systems', 'Active'),
(406, 306, 'Alan', 'Keyes', 'WEMP006', 'Locksmith', '6175550406', 'alan.keyes@locks.com', 70.00, 'Locks', 'Active'),
(407, 309, 'Paula', 'Buggs', 'WEMP007', 'Exterminator', '6175550407', 'paula.buggs@pest.com', 65.00, 'Pest Control', 'Active'),
(408, 310, 'Liam', 'Green', 'WEMP008', 'Landscaper', '6175550408', 'liam.green@gardenland.com', 50.00, 'Landscaping', 'Active'),
(409, 311, 'Nora', 'Latch', 'WEMP009', 'Locksmith', '6175550409', 'nora.latch@securelocks.com', 72.00, 'Locks', 'Active'),
(410, 312, 'Wendy', 'Pane', 'WEMP010', 'Installer', '6175550410', 'wendy.pane@brightwindows.com', 60.00, 'Windows', 'Active');

-- =========================
-- LEASE (10 rows total)
-- =========================
INSERT INTO lease (lease_id, resident_id, unit_id, prepared_by_manager_id, lease_start_date, lease_end_date, monthly_rent_amount, security_deposit_amount, lease_status, signed_date, move_in_date, payment_due_day, late_fee_amount, grace_period_days) VALUES
(5001, 1001, 102, 201, '2025-01-01', '2025-12-31', 2000.00, 2000.00, 'Active', '2024-12-15', '2025-01-01', 1, 50.00, 5),
(5002, 1002, 103, 201, '2025-02-01', '2026-01-31', 2800.00, 2800.00, 'Active', '2025-01-20', '2025-02-01', 1, 75.00, 5),
(5003, 1003, 104, 202, '2025-03-01', '2026-02-28', 1400.00, 1400.00, 'Active', '2025-02-15', '2025-03-01', 1, 40.00, 5),
(5004, 1004, 106, 202, '2025-01-15', '2026-01-14', 1800.00, 1800.00, 'Active', '2025-01-05', '2025-01-15', 1, 45.00, 5),
(5005, 1005, 109, 203, '2025-02-01', '2026-01-31', 1600.00, 1600.00, 'Active', '2025-01-20', '2025-02-01', 1, 40.00, 5),
(5006, 1006, 101, 204, '2025-03-15', '2026-03-14', 1500.00, 1500.00, 'Active', '2025-03-05', '2025-03-15', 1, 35.00, 5),
(5007, 1007, 107, 205, '2025-04-01', '2026-03-31', 2400.00, 2400.00, 'Active', '2025-03-20', '2025-04-01', 1, 60.00, 5),
(5008, 1008, 108, 201, '2025-04-15', '2026-04-14', 3500.00, 3500.00, 'Active', '2025-04-05', '2025-04-15', 1, 100.00, 5),
(5009, 1009, 110, 202, '2025-05-01', '2026-04-30', 2600.00, 2600.00, 'Active', '2025-04-20', '2025-05-01', 1, 80.00, 5),
(5010, 1010, 105, 203, '2025-05-15', '2026-05-14', 1900.00, 1900.00, 'Active', '2025-05-05', '2025-05-15', 1, 50.00, 5);

-- ===================================
-- EMERGENCY_CONTACT (10 rows total)
-- (Added some email_address values for random rows)
-- ===================================
INSERT INTO emergency_contact (contact_id, resident_id, contact_name, relationship, phone_number, alternate_phone, email_address, is_primary) VALUES
(601, 1001, 'Jane Smith', 'Spouse', '6175550501', NULL, 'jane.smith@gmail.com', TRUE),
(602, 1002, 'Mark Johnson', 'Father', '6175550502', NULL, NULL, TRUE),
(603, 1003, 'Susan Brown', 'Mother', '6175550503', '6175550660', 'susan.brown@yahoo.com', TRUE),
(604, 1004, 'Tom Davis', 'Brother', '6175550504', NULL, NULL, TRUE),
(605, 1005, 'Amy Wilson', 'Sister', '6175550505', '6175550661', 'amy.wilson@outlook.com', TRUE),
(606, 1006, 'Carlos Martinez', 'Brother', '6175550506', NULL, NULL, TRUE),
(607, 1007, 'Linda Anderson', 'Spouse', '6175550507', '6175550770', 'linda.anderson@mail.com', TRUE),
(608, 1008, 'Peter Taylor', 'Father', '6175550508', NULL, NULL, TRUE),
(609, 1009, 'Nina Thomas', 'Mother', '6175550509', NULL, 'nina.thomas@gmail.com', TRUE),
(610, 1010, 'Greg Moore', 'Brother', '6175550510', NULL, NULL, TRUE);

-- ==================================
-- LEASE_OCCUPANT (10 rows total)
-- (Added move_out_date either 6 or 12 months after move_in_date)
-- ==================================
INSERT INTO lease_occupant (occupant_id, lease_id, resident_id, occupant_type, move_in_date, move_out_date) VALUES
(701, 5001, 1001, 'Primary', '2025-01-01', '2025-07-01'),
(702, 5002, 1002, 'Primary', '2025-02-01', '2026-02-01'),
(703, 5003, 1003, 'Primary', '2025-03-01', '2025-09-01'),
(704, 5004, 1004, 'Primary', '2025-01-15', '2026-01-15'),
(705, 5005, 1005, 'Primary', '2025-02-01', '2025-08-01'),
(706, 5006, 1006, 'Primary', '2025-03-15', '2026-03-15'),
(707, 5007, 1007, 'Primary', '2025-04-01', '2025-10-01'),
(708, 5008, 1008, 'Primary', '2025-04-15', '2026-04-15'),
(709, 5009, 1009, 'Primary', '2025-05-01', '2025-11-01'),
(710, 5010, 1010, 'Primary', '2025-05-15', '2026-05-15');

-- =================================
-- BUILDING_AMENITY (10 rows total)
-- (Ensured access_restrictions not null and added additional_fee for every row; replaced NULLs with 'Public' and fees with 0.00 where appropriate)
-- =================================
INSERT INTO building_amenity (building_amenity_id, building_id, amenity_id, amenity_location, access_restrictions, additional_fee) VALUES
(801, 1, 21, 'Ground Floor', 'Residents Only', 0.00),
(802, 1, 22, 'Rooftop', 'Summer Only', 0.00),
(803, 1, 23, 'Basement', 'Assigned Permit', 10.00),
(804, 2, 21, 'Second Floor', 'Residents Only', 0.00),
(805, 2, 23, 'Basement', 'Assigned Permit', 5.00),
(806, 3, 28, 'Level 1', 'Residents Only', 25.00),
(807, 4, 29, 'Lobby', 'Staff Access', 0.00),
(808, 5, 30, 'First Floor', 'Residents Only', 0.00),
(809, 6, 21, 'Gym Level', 'Residents Only', 0.00),
(810, 7, 22, 'Rooftop', 'Summer Only', 0.00);

-- =================================
-- APT_UNIT_AMENITY (10 rows total)
-- (Added last_service_date random dates for every row)
-- =================================
INSERT INTO apt_unit_amenity (unit_amenity_id, unit_id, amenity_id, installation_date, condition, last_service_date) VALUES
(901, 101, 24, '2024-01-01', 'Good', '2025-02-10'),
(902, 101, 25, '2024-01-01', 'Good', '2024-12-15'),
(903, 102, 24, '2024-02-01', 'Excellent', '2025-01-20'),
(904, 102, 25, '2024-02-01', 'Good', '2025-03-05'),
(905, 103, 25, '2024-03-01', 'Fair', '2024-11-30'),
(906, 104, 26, '2024-03-15', 'Good', '2025-01-12'),
(907, 105, 27, '2024-04-01', 'Good', '2025-04-01'),
(908, 106, 24, '2024-04-15', 'Excellent', '2025-02-28'),
(909, 107, 25, '2024-05-01', 'Good', '2025-03-22'),
(910, 108, 26, '2024-05-15', 'Good', '2025-05-01');

-- ==============================================
-- BUILDING_MANAGER_ASSIGNMENT (10 rows total)
-- (Added assignment_end_date for every row)
-- ==============================================
INSERT INTO building_manager_assignment (assignment_id, building_id, manager_id, assignment_start_date, assignment_end_date, is_primary) VALUES
(1101, 1, 201, '2024-01-01', '2025-12-31', TRUE),
(1102, 2, 202, '2024-01-01', '2025-12-31', TRUE),
(1103, 3, 203, '2024-01-01', '2025-12-31', TRUE),
(1104, 4, 204, '2024-01-01', '2025-12-31', TRUE),
(1105, 5, 205, '2024-01-01', '2025-12-31', TRUE),
(1106, 6, 206, '2024-01-01', '2025-12-31', TRUE),
(1107, 7, 207, '2024-01-01', '2025-12-31', TRUE),
(1108, 8, 208, '2024-01-01', '2025-12-31', TRUE),
(1109, 9, 209, '2024-01-01', '2025-12-31', TRUE),
(1110, 10, 210, '2024-01-01', '2025-12-31', TRUE);

-- ===================================
-- MAINTENANCE_REQUEST (10 rows total)
-- (Assigned/ensured submitted_date values for each row)
-- ===================================
INSERT INTO maintenance_request (request_id, resident_id, unit_id, category_id, request_title, request_description, request_priority, request_status, submitted_date, completed_date) VALUES
(3001, 1001, 102, 11, 'Leaking Faucet', 'Kitchen faucet is dripping constantly', 'Medium', 'Completed', '2025-01-10 10:00:00', '2025-01-12 14:00:00'),
(3002, 1002, 103, 12, 'Outlet Not Working', 'Bedroom outlet has no power', 'High', 'Completed', '2025-01-11 14:30:00', '2025-01-13 16:00:00'),
(3003, 1003, 104, 13, 'No Heat', 'Heater not working in living room', 'High', 'Completed', '2025-01-12 08:15:00', '2025-01-14 17:00:00'),
(3004, 1004, 106, 14, 'Dishwasher Issue', 'Dishwasher not draining properly', 'Medium', 'Completed', '2025-01-13 11:00:00', '2025-01-15 15:00:00'),
(3005, 1005, 109, 11, 'Toilet Running', 'Guest bathroom toilet runs constantly', 'Medium', 'Completed', '2025-01-14 09:30:00', '2025-01-16 13:00:00'),
(3006, 1006, 101, 17, 'Locked Out', 'Resident lost keys to unit', 'High', 'Completed', '2025-03-16 09:00:00', '2025-03-16 10:00:00'),
(3007, 1007, 107, 18, 'Ants in Kitchen', 'Ant trail near sink', 'Medium', 'Completed', '2025-04-02 08:45:00', '2025-04-02 12:00:00'),
(3008, 1008, 108, 16, 'Move-out Cleaning', 'Request deep clean of unit', 'Low', 'Completed', '2025-04-16 10:15:00', '2025-04-16 17:00:00'),
(3009, 1009, 110, 12, 'Breaker Trips', 'Living room breaker keeps tripping', 'High', 'Completed', '2025-05-03 13:20:00', '2025-05-03 16:30:00'),
(3010, 1010, 105, 11, 'Slow Drain', 'Bathroom sink draining slowly', 'Medium', 'Completed', '2025-05-16 09:40:00', '2025-05-16 11:30:00');

-- ==============================
-- WORK_ORDER (10 rows total)
-- (Filled previously-missing approval fields and requires_approval flags)
-- ==============================
INSERT INTO work_order (work_order_id, work_order_number, request_id, unit_id, created_by_manager_id, vendor_id, work_type, work_description, scheduled_date, start_date_time, completion_date_time, work_status, estimated_cost, actual_cost, requires_approval, approved_by_manager_id, approval_date) VALUES
(4001, 'WO-2025-001', 3001, 102, 201, 301, 'Plumbing', 'Fix leaking kitchen faucet', '2025-01-12', '2025-01-12 09:00:00', '2025-01-12 14:00:00', 'Completed', 150.00, 145.80, FALSE, 201, '2025-01-11 16:00:00'),
(4002, 'WO-2025-002', 3002, 103, 202, 302, 'Electrical', 'Diagnose and repair bedroom outlet', '2025-01-13', '2025-01-13 09:00:00', '2025-01-13 16:00:00', 'Completed', 200.00, 210.60, FALSE, 202, '2025-01-12 15:00:00'),
(4003, 'WO-2025-003', 3003, 104, 201, 304, 'HVAC', 'Repair heater in living room', '2025-01-14', '2025-01-14 09:00:00', '2025-01-14 17:00:00', 'Completed', 350.00, 361.80, TRUE, 204, '2025-01-13 10:30:00'),
(4004, 'WO-2025-004', 3004, 106, 202, 301, 'Appliance', 'Fix dishwasher drainage', '2025-01-15', '2025-01-15 10:00:00', '2025-01-15 15:00:00', 'Completed', 175.00, 178.20, FALSE, 202, '2025-01-14 11:00:00'),
(4005, 'WO-2025-005', 3005, 109, 203, 301, 'Plumbing', 'Fix running toilet', '2025-01-16', '2025-01-16 10:00:00', '2025-01-16 13:00:00', 'Completed', 125.00, 124.20, FALSE, 203, '2025-01-15 13:00:00'),
(4006, 'WO-2025-006', 3006, 101, 204, 306, 'Locksmith', 'Open door and rekey lock', '2025-03-16', '2025-03-16 09:15:00', '2025-03-16 10:00:00', 'Completed', 120.00, 118.80, FALSE, 204, '2025-03-15 10:00:00'),
(4007, 'WO-2025-007', 3007, 107, 205, 309, 'Pest Control', 'Treat kitchen for ants', '2025-04-02', '2025-04-02 09:30:00', '2025-04-02 11:45:00', 'Completed', 160.00, 159.00, FALSE, 205, '2025-04-01 09:00:00'),
(4008, 'WO-2025-008', 3008, 108, 201, 305, 'Cleaning', 'Deep clean entire unit', '2025-04-16', '2025-04-16 10:30:00', '2025-04-16 16:30:00', 'Completed', 200.00, 205.20, FALSE, 201, '2025-04-15 14:00:00'),
(4009, 'WO-2025-009', 3009, 110, 202, 302, 'Electrical', 'Diagnose breaker tripping', '2025-05-03', '2025-05-03 13:45:00', '2025-05-03 16:15:00', 'Completed', 220.00, 219.60, FALSE, 202, '2025-05-02 12:00:00'),
(4010, 'WO-2025-010', 3010, 105, 203, 301, 'Plumbing', 'Clear bathroom sink drain', '2025-05-16', '2025-05-16 10:00:00', '2025-05-16 11:15:00', 'Completed', 110.00, 109.80, FALSE, 203, '2025-05-15 09:45:00');

-- ==================================
-- WORKER_ASSIGNMENT (10 rows total)
-- ==================================
INSERT INTO worker_assignment (assignment_id, work_order_id, worker_id, start_time, end_time, hours_worked, worker_role) VALUES
(1201, 4001, 401, '2025-01-12 09:00:00', '2025-01-12 14:00:00', 5.00, 'Lead Tech'),
(1202, 4002, 403, '2025-01-13 09:00:00', '2025-01-13 16:00:00', 7.00, 'Lead Tech'),
(1203, 4003, 405, '2025-01-14 09:00:00', '2025-01-14 17:00:00', 8.00, 'Lead Tech'),
(1204, 4004, 401, '2025-01-15 10:00:00', '2025-01-15 15:00:00', 5.00, 'Lead Tech'),
(1205, 4005, 401, '2025-01-16 10:00:00', '2025-01-16 13:00:00', 3.00, 'Lead Tech'),
(1206, 4006, 406, '2025-03-16 09:15:00', '2025-03-16 10:00:00', 0.75, 'Lead Tech'),
(1207, 4007, 407, '2025-04-02 09:30:00', '2025-04-02 11:45:00', 2.25, 'Lead Tech'),
(1208, 4008, 408, '2025-04-16 10:30:00', '2025-04-16 16:30:00', 6.00, 'Lead Tech'),
(1209, 4009, 403, '2025-05-03 13:45:00', '2025-05-03 16:15:00', 2.50, 'Lead Tech'),
(1210, 4010, 401, '2025-05-16 10:00:00', '2025-05-16 11:15:00', 1.25, 'Lead Tech');

-- ============================
-- INVOICE (10 rows total)
-- (Filled previously-missing columns: approved_by_manager_id, payment_date, payment_method, payment_reference, approval_date — no blanks)
-- ============================
INSERT INTO invoice (invoice_number, work_order_id, vendor_id, approved_by_manager_id, invoice_date, due_date, labor_cost, material_cost, tax_amount, total_amount, payment_status, payment_date, payment_method, payment_reference, approval_date) VALUES
('INV-2025-001', 4001, 301, 201, '2025-01-12', '2025-02-11', 100.00, 35.00, 10.80, 145.80, 'Paid', '2025-01-20', 'ACH Transfer', 'ACH-INV-001', '2025-01-13 10:00:00'),
('INV-2025-002', 4002, 302, 202, '2025-01-13', '2025-02-12', 150.00, 45.00, 15.60, 210.60, 'Paid', '2025-01-22', 'Check', 'CHK-INV-002', '2025-01-14 11:30:00'),
('INV-2025-003', 4003, 304, 204, '2025-01-14', '2025-02-13', 250.00, 85.00, 26.80, 361.80, 'Pending', '2025-02-05', 'Bank Transfer', 'BT-INV-003', '2025-01-15 09:00:00'),
('INV-2025-004', 4004, 301, 202, '2025-01-15', '2025-02-14', 140.00, 25.00, 13.20, 178.20, 'Paid', '2025-01-25', 'ACH Transfer', 'ACH-INV-004', '2025-01-16 14:00:00'),
('INV-2025-005', 4005, 301, 203, '2025-01-16', '2025-02-15', 75.00, 40.00, 9.20, 124.20, 'Pending', '2025-02-01', 'Credit Card', 'CC-INV-005', '2025-01-17 12:00:00'),
('INV-2025-006', 4006, 306, 204, '2025-03-16', '2025-04-15', 85.00, 25.00, 8.80, 118.80, 'Paid', '2025-03-20', 'ACH Transfer', 'ACH-INV-006', '2025-03-17 09:15:00'),
('INV-2025-007', 4007, 309, 205, '2025-04-02', '2025-05-02', 120.00, 30.00, 9.00, 159.00, 'Paid', '2025-04-07', 'Check', 'CHK-INV-007', '2025-04-03 11:00:00'),
('INV-2025-008', 4008, 305, 201, '2025-04-16', '2025-05-16', 150.00, 45.00, 10.20, 205.20, 'Paid', '2025-04-20', 'ACH Transfer', 'ACH-INV-008', '2025-04-17 10:30:00'),
('INV-2025-009', 4009, 302, 202, '2025-05-03', '2025-06-02', 170.00, 40.00, 9.60, 219.60, 'Pending', '2025-05-10', 'Bank Transfer', 'BT-INV-009', '2025-05-04 12:00:00'),
('INV-2025-010', 4010, 301, 203, '2025-05-16', '2025-06-15', 80.00, 20.00, 9.80, 109.80, 'Paid', '2025-05-20', 'Credit Card', 'CC-INV-010', '2025-05-16 09:50:00');

-- ===============================
-- NOTIFICATION (10 rows total)
-- ===============================
INSERT INTO notification (resident_id, request_id, notification_type, subject, message_body, priority, delivery_channel, scheduled_send_date, actual_sent_date, delivery_status) VALUES
(1001, 3001, 'Request Received', 'Maintenance Request Received', 'Your maintenance request for the leaking faucet has been received.', 'Normal', 'Email', '2025-01-10 10:30:00', '2025-01-10 10:30:00', 'Delivered'),
(1002, 3002, 'Request Received', 'Maintenance Request Received', 'Your request for the outlet repair has been received.', 'High', 'Email', '2025-01-11 15:00:00', '2025-01-11 15:00:00', 'Delivered'),
(1003, 3003, 'Request Received', 'Heating Request Received', 'We have received your heating repair request.', 'High', 'SMS', '2025-01-12 08:30:00', '2025-01-12 08:30:00', 'Delivered'),
(1001, 3001, 'Work Scheduled', 'Maintenance Scheduled', 'Your maintenance work has been scheduled for 01/12/2025.', 'Normal', 'Email', '2025-01-10 14:00:00', '2025-01-10 14:00:00', 'Delivered'),
(1002, 3002, 'Work In Progress', 'Work Started', 'Technician has started work on your electrical issue.', 'Normal', 'Email', '2025-01-13 09:00:00', '2025-01-13 09:00:00', 'Delivered'),
(1006, 3006, 'Request Received', 'Locksmith Dispatched', 'A locksmith has been dispatched to your unit.', 'High', 'SMS', '2025-03-16 09:05:00', '2025-03-16 09:05:00', 'Delivered'),
(1007, 3007, 'Request Received', 'Pest Control Scheduled', 'Pest control visit scheduled.', 'Normal', 'Email', '2025-04-02 09:00:00', '2025-04-02 09:00:00', 'Delivered'),
(1008, 3008, 'Work Completed', 'Cleaning Complete', 'Your unit has been cleaned.', 'Normal', 'Email', '2025-04-16 17:00:00', '2025-04-16 17:00:00', 'Delivered'),
(1009, 3009, 'Work Completed', 'Electrical Repair Complete', 'Breaker issue resolved.', 'High', 'SMS', '2025-05-03 16:30:00', '2025-05-03 16:30:00', 'Delivered'),
(1010, 3010, 'Work Completed', 'Plumbing Repair Complete', 'Bathroom drain cleared.', 'Normal', 'Email', '2025-05-16 11:30:00', '2025-05-16 11:30:00', 'Delivered');

-- =============================
-- ESCALATION (10 rows total)
-- (Added resolution_notes for every row)
-- =============================
INSERT INTO escalation (escalation_id, request_id, escalation_level, escalated_by_manager_id, escalation_reason, escalation_date, target_resolution_date, resolution_date, resolution_notes, escalation_status) VALUES
(1301, 3002, 1, 202, 'High priority electrical issue needs immediate attention', '2025-01-11 16:00:00', '2025-01-13', '2025-01-13 16:30:00', 'Outlet replaced and wiring tightened; tested successfully.', 'Resolved'),
(1302, 3003, 1, 201, 'Heating issue during cold weather', '2025-01-12 10:00:00', '2025-01-14', '2025-01-14 17:30:00', 'Thermostat replaced and furnace serviced; heating restored.', 'Resolved'),
(1303, 3006, 1, 204, 'Resident locked out of unit', '2025-03-16 09:10:00', '2025-03-16', '2025-03-16 10:05:00', 'Lock bypassed and new key issued; rekeyed lock cylinder.', 'Resolved'),
(1304, 3007, 1, 205, 'Pest activity near food areas', '2025-04-02 09:10:00', '2025-04-03', '2025-04-02 12:10:00', 'Pest treatment completed and bait stations installed.', 'Resolved'),
(1305, 3008, 1, 201, 'Expedited cleaning before inspection', '2025-04-16 10:00:00', '2025-04-17', '2025-04-16 17:10:00', 'Deep clean completed; unit passed inspection.', 'Resolved'),
(1306, 3009, 2, 202, 'Recurring breaker issues reported', '2025-05-03 13:30:00', '2025-05-04', '2025-05-03 16:40:00', 'Main breaker replaced and circuit loads balanced.', 'Resolved'),
(1307, 3010, 1, 203, 'Water backup risk', '2025-05-16 09:50:00', '2025-05-17', '2025-05-16 11:40:00', 'Drain cleared and trap checked; flow restored.', 'Resolved'),
(1308, 3001, 1, 201, 'Repeat faucet complaints', '2025-01-10 10:45:00', '2025-01-12', '2025-01-12 14:10:00', 'Faucet cartridge replaced and leak resolved.', 'Resolved'),
(1309, 3004, 1, 202, 'Appliance service delay concern', '2025-01-15 09:30:00', '2025-01-16', '2025-01-15 15:10:00', 'Appliance parts expedited and technician rescheduled to complete.', 'Resolved'),
(1310, 3005, 1, 203, 'Running toilet affecting water usage', '2025-01-16 09:45:00', '2025-01-17', '2025-01-16 13:10:00', 'Flapper valve replaced; system tested for leaks.', 'Resolved');

-- ======================================
-- PAYMENT_TRANSACTION (10 rows total)
-- (Filled due_date and amount_due for every row)
-- ======================================
INSERT INTO payment_transaction (lease_id, resident_id, transaction_type, transaction_date, due_date, amount_due, amount_paid, payment_method, reference_number, transaction_status) VALUES
(5001, 1001, 'Rent', '2025-01-01', '2025-01-01', 2000.00, 2000.00, 'ACH Transfer', 'ACH-202501-001', 'Completed'),
(5002, 1002, 'Rent', '2025-02-01', '2025-02-01', 2800.00, 2800.00, 'Check', 'CHK-202502-001', 'Completed'),
(5003, 1003, 'Rent', '2025-03-01', '2025-03-01', 1400.00, 1400.00, 'Credit Card', 'CC-202503-001', 'Completed'),
(5001, 1001, 'Security Deposit', '2024-12-15', '2024-12-15', 0.00, 2000.00, 'Check', 'CHK-DEPOSIT-001', 'Completed'),
(5002, 1002, 'Security Deposit', '2025-01-20', '2025-01-20', 0.00, 2800.00, 'ACH Transfer', 'ACH-DEPOSIT-001', 'Completed'),
(5006, 1006, 'Security Deposit', '2025-03-05', '2025-03-05', 0.00, 1500.00, 'ACH Transfer', 'ACH-DEPOSIT-006', 'Completed'),
(5007, 1007, 'Security Deposit', '2025-03-20', '2025-03-20', 0.00, 2400.00, 'Credit Card', 'CC-DEPOSIT-007', 'Completed'),
(5008, 1008, 'Security Deposit', '2025-04-05', '2025-04-05', 0.00, 3500.00, 'Check', 'CHK-DEPOSIT-008', 'Completed'),
(5009, 1009, 'Security Deposit', '2025-04-20', '2025-04-20', 0.00, 2600.00, 'ACH Transfer', 'ACH-DEPOSIT-009', 'Completed'),
(5010, 1010, 'Security Deposit', '2025-05-05', '2025-05-05', 0.00, 1900.00, 'Check', 'CHK-DEPOSIT-010', 'Completed');

-- ==============================
-- WORK_ORDER (already inserted above)
-- (Worker assignments and work orders covered earlier)
-- ==============================

-- ============================
-- INVOICE (already inserted above)
-- (Invoices filled earlier)
-- ============================

-- (No change to vendor, building, etc. beyond what was requested.)
