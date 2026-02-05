USE DigitalWalletDB;
GO

CREATE OR ALTER VIEW vw_UserAccountOverview AS
    SELECT
        u.user_id,
        u.username,
        u.phone_number,
        u.email,
        u.address,
        a.account_number,
        a.balance,
        a.currency,
        a.status,
        a.daily_limit
    FROM Account a
    LEFT JOIN [User] u
    ON a.user_id = u.user_id;
GO

CREATE OR ALTER VIEW vw_PersonAccountOverview AS
    SELECT
        u.user_id,
        a.account_number,
        u.username,
        CONCAT(pu.first_name, pu.last_name) AS full_name,
        u.phone_number,
        u.email,
        pu.birth_date,
        c.nationality,
        pu.national_id,
        u.address,
        a.balance,
        a.currency,
        a.status,
        a.daily_limit
    FROM Account a
    LEFT JOIN [User] u
    ON a.user_id = u.user_id
    JOIN Person pu
    ON pu.user_id = u.user_id
    LEFT JOIN Country c
    ON pu.nationality = c.iso_alpha2;
GO

CREATE OR ALTER VIEW vw_BusinessAccountOverview AS
    SELECT
        u.user_id,
        a.account_number,
        u.username,
        bu.name,
        bu.legal_name,
        bu.registration_number,
        u.phone_number,
        u.email,
        c.name AS country,
        bu.category,
        bu.status AS business_status,
        u.address,
        a.balance,
        a.currency,
        a.status,
        a.daily_limit
    FROM Account a
    LEFT JOIN [User] u
    ON a.user_id = u.user_id
    JOIN Business bu
    ON bu.user_id = u.user_id
    LEFT JOIN Country c
    ON bu.country = c.iso_alpha2;
GO

CREATE OR ALTER VIEW vw_AgentAccountOverview AS
    SELECT
        u.user_id,
        a.account_number,
        au.display_name,
        u.username,
        u.phone_number,
        u.email,
        au.status AS agent_status,
        u.address,
        a.balance,
        a.currency,
        a.status,
        a.daily_limit
    FROM Account a
    LEFT JOIN [User] u
    ON a.user_id = u.user_id
    JOIN Agent au
    ON au.user_id = u.user_id;
GO

CREATE OR ALTER VIEW vw_TransactionDetails AS
    SELECT TOP (100) PERCENT
        t.transaction_id,
        t.time,
        t.type,
        t.source_account,
        sa.user_id      AS source_user_id,
        sa.type         AS source_account_type,
        t.destination_account,
        da.user_id      AS destination_user_id,
        da.type         AS destination_account_type,
        t.amount,
        t.currency,
        t.status,
        t.fee_amount,
        t.fee_currency,
        t.fee_id
    FROM [Transaction] t
    LEFT JOIN Account sa
    ON t.source_account = sa.account_number
    LEFT JOIN Account da
    ON t.destination_account = da.account_number
    ORDER BY time DESC;
GO