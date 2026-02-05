USE DigitalWalletDB
GO

INSERT INTO Country
    (iso_alpha2, name, nationality)
VALUES
    ('AE', 'United Arab Emirates', 'Emirati'),
    ('AF', 'Afghanistan', 'Afghan'),
    ('BH', 'Bahrain', 'Bahraini'),
    ('BD', 'Bangladesh', 'Bangladeshi'),
    ('DZ', 'Algeria', 'Algerian'),
    ('EG', 'Egypt', 'Egyptian'),
    ('IQ', 'Iraq', 'Iraqi'),
    ('JO', 'Jordan', 'Jordanian'),
    ('KW', 'Kuwait', 'Kuwaiti'),
    ('LB', 'Lebanon', 'Lebanese'),
    ('LY', 'Libya', 'Libyan'),
    ('MA', 'Morocco', 'Moroccan'),
    ('MR', 'Mauritania', 'Mauritanian'),
    ('OM', 'Oman', 'Omani'),
    ('PK', 'Pakistan', 'Pakistani'),
    ('PS', 'Palestine', 'Palestinian'),
    ('QA', 'Qatar', 'Qatari'),
    ('SA', 'Saudi Arabia', 'Saudi Arabian'),
    ('SD', 'Sudan', 'Sudanese'),
    ('SO', 'Somalia', 'Somali'),
    ('SY', 'Syria', 'Syrian'),
    ('TN', 'Tunisia', 'Tunisian'),
    ('TR', 'Turkey', 'Turkish'),
    ('YE', 'Yemen', 'Yemeni'),
    ('ID', 'Indonesia', 'Indonesian');

USE DigitalWalletDB;
GO

INSERT INTO [User]
    (username, password_hash, email, phone_number, address)
VALUES
    ('ali.hassan', 'hash1', 'ali.hassan@example.com', '+96170000001', 'Beirut, Lebanon'),
    ('sara.khalil', 'hash2', 'sara.khalil@example.com', '+96170000002', 'Tripoli, Lebanon'),
    ('omar.nasser', 'hash3', 'omar.nasser@example.com', '+97150000003', 'Dubai, UAE'),
    ('fatima.abbas', 'hash4', 'fatima.abbas@example.com', '+97430000004', 'Doha, Qatar'),
    ('yusuf.ali', 'hash5', 'yusuf.ali@example.com', '+96650000005', 'Riyadh, Saudi Arabia'),
    ('khaled.salem', 'hash6', 'khaled.salem@example.com', '+20110000006', 'Cairo, Egypt'),
    ('mariam.amin', 'hash7', 'mariam.amin@example.com', '+20120000007', 'Alexandria, Egypt'),
    ('hamza.farouk', 'hash8', 'hamza.farouk@example.com', '+96470000008', 'Baghdad, Iraq'),
    ('lina.jabbar', 'hash9', 'lina.jabbar@example.com', '+96270000009', 'Amman, Jordan'),
    ('bilal.azmi', 'hash10', 'bilal.azmi@example.com', '+97430000010', 'Doha, Qatar');

INSERT INTO Person
    (user_id, first_name, middle_name, last_name, nationality, national_id, birth_date)
VALUES
    (1, 'Ali', NULL, 'Hassan', 'LB', 'LB000001', '1998-01-10'),
    (2, 'Sara', NULL, 'Khalil', 'LB', 'LB000002', '1999-02-15'),
    (3, 'Omar', NULL, 'Nasser', 'AE', 'AE000003', '1995-03-20'),
    (4, 'Fatima', NULL, 'Abbas', 'QA', 'QA000004', '1997-04-25'),
    (5, 'Yusuf', NULL, 'Ali', 'SA', 'SA000005', '1996-05-30'),
    (6, 'Khaled', NULL, 'Salem', 'EG', 'EG000006', '1994-06-12'),
    (7, 'Mariam', NULL, 'Amin', 'EG', 'EG000007', '1999-07-08'),
    (8, 'Hamza', NULL, 'Farouk', 'IQ', 'IQ000008', '1993-08-19'),
    (9, 'Lina', NULL, 'Jabbar', 'JO', 'JO000009', '2000-09-22'),
    (10, 'Bilal', NULL, 'Azmi', 'QA', 'QA000010', '1995-10-05');

INSERT INTO [User]
    (username, password_hash, email, phone_number, address)
VALUES
    ('cedarpay', 'hash11', 'contact@cedarpay.com', '+96110000011', 'Beirut, Lebanon'),
    ('gulfwallet', 'hash12', 'info@gulfwallet.ae', '+97110000012', 'Dubai, UAE');

INSERT INTO Business
    (user_id, name, legal_name, registration_number, country, category, status)
VALUES
    (11, 'CedarPay', 'CedarPay SAL', 'LB-REG-0001', 'LB', 'Fintech', 'active'),
    (12, 'GulfWallet', 'GulfWallet FZ-LLC', 'AE-REG-0002', 'AE', 'Fintech', 'active');

INSERT INTO [User]
    (username, password_hash, email, phone_number, address)
VALUES
    ('agent.beirut', 'hash13', 'agent.beirut@example.com', '+96171000013', 'Beirut, Lebanon'),
    ('agent.tripoli', 'hash14', 'agent.tripoli@example.com', '+96171000014', 'Tripoli, Lebanon'),
    ('agent.dubai', 'hash15', 'agent.dubai@example.com', '+97150000015', 'Dubai, UAE');

INSERT INTO Agent
    (user_id, display_name, status)
VALUES
    (13, 'Independent Agent - Beirut', 'active'),
    (14, 'Independent Agent - Tripoli', 'active'),
    (15, 'Independent Agent - Dubai', 'active');

INSERT INTO [Account]
    (account_number, user_id, type, balance, currency, status, daily_limit)
VALUES
    -- 10 personal accounts
    ('ACC-0001', 1, 'personal', 1500.00, 'USD', 'active', 500.00),
    ('ACC-0002', 2, 'personal', 750.00, 'USD', 'active', 400.00),
    ('ACC-0003', 3, 'personal', 2200.00, 'AED', 'active', 1000.00),
    ('ACC-0004', 4, 'personal', 900.00, 'QAR', 'active', 600.00),
    ('ACC-0005', 5, 'personal', 1200.00, 'SAR', 'active', 800.00),
    ('ACC-0006', 6, 'personal', 500.00, 'EGP', 'active', 300.00),
    ('ACC-0007', 7, 'personal', 650.00, 'EGP', 'active', 300.00),
    ('ACC-0008', 8, 'personal', 800.00, 'IQD', 'active', 250.00),
    ('ACC-0009', 9, 'personal', 1100.00, 'JOD', 'active', 400.00),
    ('ACC-0010', 10, 'personal', 300.00, 'QAR', 'active', 200.00),

    -- 2 business accounts
    ('ACC-0011', 11, 'business', 9500.00, 'USD', 'active', 5000.00),
    ('ACC-0012', 12, 'business', 7200.00, 'AED', 'active', 6000.00),

    -- 3 agent accounts
    ('ACC-0013', 13, 'agent_float', 300.00, 'USD', 'active', 500.00),
    ('ACC-0014', 14, 'agent_float', 450.00, 'USD', 'active', 500.00),
    ('ACC-0015', 15, 'agent_float', 600.00, 'AED', 'active', 700.00);

INSERT INTO AuthMethod
    (user_id, method_type, description, is_active)
VALUES
    (1, 'password', 'Main login password for Ali', 1),
    (1, 'otp', 'SMS OTP to +96170000001', 1),
    (2, 'password', 'Main login password for Sara', 1),
    (3, 'pin', '4-digit wallet PIN for Omar', 1),
    (4, 'biometric', 'Mobile fingerprint for Fatima', 1);

INSERT INTO KYCRecord
    (user_id, document_type, document_number, issuing_country, expiry_date, verification_status, verification_date)
VALUES
    (1, 'national_id', 'LB000001', 'LB', NULL, 'verified', '2024-01-15'),
    (2, 'passport', 'P-LB0002', 'LB', '2030-06-30', 'pending', '2025-11-20'),
    (3, 'residency_card', 'AE-RES-03', 'AE', '2027-03-01', 'rejected', '2025-10-05');

INSERT INTO Fee
    (operation_type, payer_type, fee_type, fee_value, currency)
VALUES
    ('transfer', 'sender', 'percentage', 0.0050, 'USD'),
    ('transfer', 'receiver', 'fixed', 0.2500, 'USD'),
    ('vendor_payment', 'business', 'percentage', 0.0200, 'USD'),
    ('deposit', 'agent', 'fixed', 1.0000, 'USD'),
    ('withdraw', 'sender', 'fixed', 1.5000, 'USD');

INSERT INTO [Transaction]
    (source_account, destination_account, type, amount, currency, time, status, fee_amount, fee_currency, fee_id)
VALUES
    ('ACC-0013', 'ACC-0001', 'deposit', 200.00, 'USD', '2025-12-01T10:00:00', 'completed', 1.0000, 'USD', 4),
    ('ACC-0001', 'ACC-0002', 'transfer', 100.00, 'USD', '2025-12-01T11:00:00', 'completed', 0.5000, 'USD', 1),
    ('ACC-0003', 'ACC-0011', 'vendor_payment', 250.00, 'AED', '2025-12-02T09:30:00', 'completed', 5.0000, 'USD', 3),
    ('ACC-0005', 'ACC-0014', 'withdraw', 150.00, 'SAR', '2025-12-02T12:15:00', 'completed', 1.5000, 'USD', 5),
    ('ACC-0002', 'ACC-0004', 'transfer', 50.00, 'USD', '2025-12-03T08:45:00', 'failed', 0.0000, 'USD', 1),
    ('ACC-0006', 'ACC-0011', 'vendor_payment', 120.00, 'EGP', '2025-12-03T14:20:00', 'pending', 2.4000, 'USD', 3),
    ('ACC-0015', 'ACC-0012', 'deposit', 500.00, 'AED', '2025-12-04T10:05:00', 'completed', 1.0000, 'USD', 4),
    ('ACC-0010', 'ACC-0009', 'transfer', 75.00, 'QAR', '2025-12-04T18:40:00', 'completed', 0.3750, 'USD', 1),
    ('ACC-0013', 'ACC-0008', 'deposit', 300.00, 'USD', '2025-12-05T09:10:00', 'completed', 1.0000, 'USD', 4),
    ('ACC-0002', 'ACC-0014', 'withdraw', 120.00, 'USD', '2025-12-05T16:00:00', 'completed', 1.5000, 'USD', 5);
