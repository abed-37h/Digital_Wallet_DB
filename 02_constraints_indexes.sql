USE DigitalWalletDB;
GO

-- Constraints --

-- User Constraints --

ALTER TABLE [User]
    ADD CONSTRAINT PK_User PRIMARY KEY (user_id);

ALTER TABLE [User]
    ADD CONSTRAINT UQ_User_username UNIQUE (username);

ALTER TABLE [User]
    ADD CONSTRAINT UQ_User_phone_number UNIQUE (phone_number);

ALTER TABLE [User]
    ADD CONSTRAINT UQ_User_email UNIQUE (email);

ALTER TABLE [User]
    ADD CONSTRAINT CK_User_username
    CHECK (
        username LIKE '%'
        AND LEN(username) BETWEEN 3 AND 50
        AND username NOT LIKE '% %'
        AND username NOT LIKE '%;%'
    );

ALTER TABLE [User]
    ADD CONSTRAINT CK_User_email
    CHECK (email LIKE '%_@_%._%');

-- Country Constraints --

ALTER TABLE Country
    ADD CONSTRAINT PK_Country PRIMARY KEY (iso_alpha2);

-- Person Constraints --

ALTER TABLE Person
    ADD CONSTRAINT PK_Person PRIMARY KEY (person_id);

ALTER TABLE Person
    ADD CONSTRAINT FK_Person_User
    FOREIGN KEY (user_id) REFERENCES [User](user_id);

ALTER TABLE Person
    ADD CONSTRAINT FK_Person_Country
    FOREIGN KEY (nationality) REFERENCES Country(iso_alpha2);

ALTER TABLE Person
    ADD CONSTRAINT UQ_Person_user_id UNIQUE (user_id);

ALTER TABLE Person
    ADD CONSTRAINT UQ_Person_national_id UNIQUE (nationality, national_id);

-- Business Constraints --

ALTER TABLE Business
    ADD CONSTRAINT PK_Business PRIMARY KEY (business_id);

ALTER TABLE Business
    ADD CONSTRAINT FK_Business_User
    FOREIGN KEY (user_id) REFERENCES [User](user_id);

ALTER TABLE Business
    ADD CONSTRAINT FK_Business_Country
    FOREIGN KEY (country) REFERENCES Country(iso_alpha2);

ALTER TABLE Business
    ADD CONSTRAINT UQ_Business_user_id UNIQUE (user_id);

ALTER TABLE Business
    ADD CONSTRAINT UQ_Business_registration_number UNIQUE (registration_number);

ALTER TABLE Business
    ADD CONSTRAINT CK_Business_status
    CHECK (status IN ('active', 'inactive', 'banned'));

-- Agent Constraints --

ALTER TABLE Agent
    ADD CONSTRAINT PK_Agent PRIMARY KEY (agent_id);

ALTER TABLE Agent
    ADD CONSTRAINT FK_Agent_User
    FOREIGN KEY (user_id) REFERENCES [User](user_id);

ALTER TABLE Agent
    ADD CONSTRAINT UQ_Agent_user_id UNIQUE (user_id);

ALTER TABLE Agent
    ADD CONSTRAINT CK_Agent_status
    CHECK (status IN ('active', 'suspended'));

-- AuthMethod Constrains --

ALTER TABLE AuthMethod
    ADD CONSTRAINT PK_AuthMethod PRIMARY KEY (method_id);

ALTER TABLE AuthMethod
    ADD CONSTRAINT FK_AuthMethod_User
    FOREIGN KEY (user_id) REFERENCES [User](user_id);

ALTER TABLE AuthMethod
    ADD CONSTRAINT CK_AuthMethod_method_type
    CHECK (method_type IN ('password', 'PIN', 'OTP', 'QR', 'biometric'));

-- KYCRecord Constrains --

ALTER TABLE KYCRecord
    ADD CONSTRAINT PK_KYCRecord PRIMARY KEY (record_id);

ALTER TABLE KYCRecord
    ADD CONSTRAINT FK_KYCRecord_User
    FOREIGN KEY (user_id) REFERENCES [User](user_id);

ALTER TABLE KYCRecord
    ADD CONSTRAINT CK_KYCRecord_document_type
    CHECK (document_type IN ('national_id', 'passport', 'residency_card'));

ALTER TABLE KYCRecord
    ADD CONSTRAINT CK_KYCRecord_verification_status
    CHECK (verification_status IN ('pending', 'verified', 'rejected', 'expired'));

ALTER TABLE KYCRecord
    ADD CONSTRAINT UQ_KYCRecord_document UNIQUE (user_id, document_type, document_number);

ALTER TABLE KYCRecord
    ADD CONSTRAINT CK_KYCRecord_expiry_date
    CHECK (
        (document_type = 'national_id' AND expiry_date IS NULL)
        OR
        (document_type <> 'national_id' AND expiry_date IS NOT NULL)
    );

-- Account Constraints --

ALTER TABLE Account
    ADD CONSTRAINT PK_Account PRIMARY KEY (account_number);

ALTER TABLE Account
    ADD CONSTRAINT FK_Account_User
    FOREIGN KEY (user_id) REFERENCES [User](user_id);

ALTER TABLE Account
    ADD CONSTRAINT CK_Account_type
    CHECK (type IN ('personal', 'business', 'agent_float'));

ALTER TABLE Account
    ADD CONSTRAINT CK_Account_balance
    CHECK (balance >= 0);

ALTER TABLE Account
    ADD CONSTRAINT CK_Account_status
    CHECK (status IN ('active', 'blocked', 'closed'));

ALTER TABLE Account
    ADD CONSTRAINT CK_Account_daily_limit
    CHECK (daily_limit >= 0);

-- Transactions Constraints --

ALTER TABLE [Transaction]
    ADD CONSTRAINT PK_Transaction PRIMARY KEY (transaction_id);

ALTER TABLE [Transaction]
    ADD CONSTRAINT FK_Transaction_Src_Account
    FOREIGN KEY (source_account) REFERENCES Account(account_number);

ALTER TABLE [Transaction]
    ADD CONSTRAINT FK_Transaction_Dest_Country
    FOREIGN KEY (destination_account) REFERENCES Account(account_number);

ALTER TABLE [Transaction]
    ADD CONSTRAINT FK_Transaction_Fee
    FOREIGN KEY (fee_id) REFERENCES Fee(fee_id);

ALTER TABLE [Transaction]
    ADD CONSTRAINT CK_Transaction_type
    CHECK (type IN ('transfer', 'deposit', 'withdraw', 'vendor_payment'));

ALTER TABLE [Transaction]
    ADD CONSTRAINT CK_Transaction_amount
    CHECK (amount > 0);

ALTER TABLE [Transaction]
    ADD CONSTRAINT CK_Transaction_status
    CHECK (status IN ('pending', 'completed', 'failed'));

ALTER TABLE [Transaction]
    ADD CONSTRAINT CK_Transaction_fee_amount
    CHECK (fee_amount >= 0);

ALTER TABLE [Transaction]
    ADD CONSTRAINT CK_Transaction_diff_accounts
    CHECK (source_account <> destination_account);

-- Fee Constraints --

ALTER TABLE Fee
    ADD CONSTRAINT PK_Fee PRIMARY KEY (fee_id);

ALTER TABLE Fee
    ADD CONSTRAINT CK_Fee_operation_type
    CHECK (operation_type IN ('transfer', 'deposit', 'withdraw', 'vendor_payment'));

ALTER TABLE Fee
    ADD CONSTRAINT CK_Fee_payer_type
    CHECK (payer_type IN ('sender', 'receiver', 'business', 'agent', 'shared'));

ALTER TABLE Fee
    ADD CONSTRAINT CK_Fee_fee_type
    CHECK (fee_type IN ('fixed', 'percentage'));

ALTER TABLE Fee
    ADD CONSTRAINT CK_Fee_fee_value
    CHECK (fee_value >= 0);


-- INDEXES --

-- Person Indexes --

CREATE INDEX IX_Person_user_id 
    ON Person(user_id);

-- Business Indexes --

CREATE INDEX IX_Business_user_id 
    ON Business(user_id);

-- Agent Indexes --

CREATE INDEX IX_Agent_user_id 
    ON Agent(user_id);

-- AuthMethod Indexes --

CREATE INDEX IX_AuthMethod_user_id
    ON AuthMethod(user_id);

-- KYCRecord Indexes --

CREATE INDEX IX_KYCRecord_user_id 
    ON KYCRecord(user_id);

-- Account Indexes --

CREATE INDEX IX_Account_user_id 
    ON Account(user_id) INCLUDE (balance, status, type);

-- Transaction Indexes --

CREATE INDEX IX_Transaction_source_account 
    ON [Transaction](source_account) INCLUDE (time, amount, currency, status, type);

CREATE INDEX IX_Transaction_destination_account 
    ON [Transaction](destination_account) INCLUDE (time, amount, currency, status, type);

CREATE INDEX IX_Transaction_time 
    ON [Transaction](time DESC) INCLUDE (amount, currency, status, type);
