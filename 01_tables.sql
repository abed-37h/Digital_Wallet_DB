USE DigitalWalletDB;
GO

CREATE TABLE [User](
    user_id INT IDENTITY(1, 1) NOT NULL,
    username VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(MAX),
    password_hash VARCHAR(255)
);

CREATE TABLE Country(
    iso_alpha2 CHAR(2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(100)
);

CREATE TABLE Person(
    person_id INT IDENTITY(1, 1) NOT NULL,
    user_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    nationality CHAR(2) NOT NULL,
    national_id VARCHAR(30) NOT NULL
);

CREATE TABLE Business(
    business_id INT IDENTITY(1, 1) NOT NULL,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    legal_name VARCHAR(150),
    registration_number VARCHAR(50) NOT NULL,
    country CHAR(2),
    category VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE Agent(
    agent_id INT IDENTITY(1, 1) NOT NULL,
    user_id INT NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE AuthMethod(
    method_id INT IDENTITY(1, 1) NOT NULL,
    user_id INT NOT NULL,
    method_type VARCHAR(20) NOT NULL,
    description VARCHAR(MAX),
    is_active BIT NOT NULL
);

CREATE TABLE KYCRecord(
    record_id INT IDENTITY(1, 1) NOT NULL,
    user_id INT NOT NULL,
    document_type VARCHAR(30) NOT NULL,
    document_number VARCHAR(50) NOT NULL,
    issuing_country CHAR(2) NOT NULL,
    expiry_date DATE,
    verification_status VARCHAR(20) NOT NULL,
    verification_date DATETIME2
);

CREATE TABLE Account(
    account_number VARCHAR(30) NOT NULL,
    user_id INT NOT NULL,
    type VARCHAR(20) NOT NULL,
    balance DECIMAL(15, 2) NOT NULL,
    currency CHAR(3) NOT NULL,
    status VARCHAR(20) NOT NULL,
    daily_limit DECIMAL(15, 2) NOT NULL
);

CREATE TABLE [Transaction](
    transaction_id INT IDENTITY(1, 1) NOT NULL,
    source_account VARCHAR(30) NOT NULL,
    destination_account VARCHAR(30) NOT NULL,
    type VARCHAR(20) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    currency CHAR(3) NOT NULL,
    time DATETIME2 NOT NULL,
    status VARCHAR(20) NOT NULL,
    description VARCHAR(MAX),
    fee_id INT NOT NULL,
    fee_amount DECIMAL(15, 2) NOT NULL,
    fee_currency CHAR(3) NOT NULL
);

CREATE TABLE Fee(
    fee_id INT IDENTITY(1, 1) NOT NULL,
    operation_type VARCHAR(20) NOT NULL,
    payer_type VARCHAR(20) NOT NULL,
    fee_type VARCHAR(20) NOT NULL,
    fee_value DECIMAL(10, 4) NOT NULL,
    currency CHAR(3) NOT NULL
);