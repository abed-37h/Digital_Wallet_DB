USE DigitalWalletDB;
GO

-- Account and User Creation Procedures --

CREATE OR ALTER PROCEDURE dbo.sp_CreateAccount(
    @user_id INT,
    @type VARCHAR(20),
    @currency CHAR(3) = 'USD',
    @account_number_out VARCHAR(30) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [User] WHERE user_id = @user_id)
    BEGIN
        RAISERROR('Invalid user_id: %d does not exist.', 16, 1, @user_id);
        RETURN;
    END;

    IF @type NOT IN ('personal', 'business', 'agent_float')
    BEGIN
        RAISERROR('Invalid account type: %s. Must be personal, business, or agent_float.', 16, 1, @type);
        RETURN;
    END;

    IF @currency NOT IN ('USD', 'AED', 'QAR', 'SAR', 'EGP', 'JOD', 'IQD')
    BEGIN
        RAISERROR('Invalid currency: %s. Supported: USD, AED, QAR, SAR, EGP, JOD, IQD.', 16, 1, @currency);
        RETURN;
    END;

    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;      
            DECLARE @account_number VARCHAR(30), @daily_limit DECIMAL(15, 2);

            DECLARE @next_id INT;
            SELECT @next_id = ISNULL(MAX(CAST(SUBSTRING(account_number, 5, 6) AS INT)), 0) + 1 
                FROM Account WITH (UPDLOCK);
            SET @account_number = CONCAT('ACC-', FORMAT(@next_id, '000000'));


            SET @daily_limit = 
                CASE @type
                    WHEN 'personal' THEN 1000.00
                    WHEN 'business' THEN 50000.00
                    WHEN 'agent_float' THEN 10000.00
                END;
            
            INSERT INTO Account (
                account_number,
                user_id,
                type,
                balance,
                currency,
                status,
                daily_limit
            )
            VALUES(
                @account_number,
                @user_id,
                @type,
                0.00,
                @currency,
                'active',
                @daily_limit
            );

            SET @account_number_out = @account_number;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CreateUserWithAccount(
    @username VARCHAR(50),
    @phone_number VARCHAR(20),
    @email VARCHAR(100),
    @password_hash VARCHAR(255),
    @type VARCHAR(20),
    @currency CHAR(3) = 'USD',
    @address VARCHAR(MAX) = NULL,
    @user_id INT OUTPUT,
    @account_number VARCHAR(30) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM [User] WHERE username = @username OR email = @email)
    BEGIN
        RAISERROR('Username or email already exists.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE @output_table TABLE (user_id INT);
            DECLARE @new_user_id INT, @temp_account VARCHAR(30);
        
            INSERT INTO [User] (
                username,
                phone_number,
                email,
                address,
                password_hash
            )
            OUTPUT INSERTED.user_id INTO @output_table
            VALUES (
                @username,
                @phone_number,
                @email,
                @address,
                @password_hash
            );

            SELECT @new_user_id = user_id FROM @output_table;
            
            EXEC dbo.sp_CreateAccount @new_user_id, @type, @currency, @temp_account OUTPUT;
            
            SET @user_id = @new_user_id;
            SET @account_number = @temp_account;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CreatePersonWithAccount(
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @username VARCHAR(50),
    @phone_number VARCHAR(20),
    @email VARCHAR(100),
    @password_hash VARCHAR(255),
    @birth_date DATE,
    @nationality CHAR(2),
    @national_id VARCHAR(30),
    @type VARCHAR(20),
    @currency CHAR(3) = 'USD',
    @middle_name VARCHAR(50) = NULL,
    @address VARCHAR(MAX) = NULL,
    @person_id INT OUTPUT,
    @user_id INT OUTPUT,
    @account_number VARCHAR(30) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF DATEDIFF(YEAR, @birth_date, GETDATE()) < 18
    BEGIN
        RAISERROR('Person must be at least 18 years old.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE @output_table TABLE (person_id INT);
            DECLARE @new_person_id INT, @new_user_id INT, @temp_account VARCHAR(30);

            EXEC dbo.sp_CreateUserWithAccount
                @username,
                @phone_number,
                @email,
                @password_hash,
                @type,
                @currency,
                @address,
                @new_user_id OUTPUT,
                @temp_account OUTPUT;

            INSERT INTO Person (
                user_id,
                first_name,
                middle_name,
                last_name,
                birth_date,
                nationality,
                national_id
            )
            OUTPUT INSERTED.person_id INTO @output_table
            VALUES (
                @new_user_id,
                @first_name,
                @middle_name,
                @last_name,
                @birth_date,
                @nationality,
                @national_id
            );
            
            SELECT @new_person_id = person_id FROM @output_table;

            SET @person_id = @new_person_id;
            SET @user_id = @new_user_id;
            SET @account_number = @temp_account;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CreateBusinessWithAccount(
    @name VARCHAR(100),
    @registration_number VARCHAR(50),
    @username VARCHAR(50),
    @phone_number VARCHAR(20),
    @email VARCHAR(100),
    @password_hash VARCHAR(255),
    @country CHAR(2),
    @category VARCHAR(50),
    @status VARCHAR(20),
    @type VARCHAR(20),
    @currency CHAR(3) = 'USD',
    @legal_name VARCHAR(150) = NULL,
    @address VARCHAR(MAX) = NULL,
    @business_id INT OUTPUT,
    @user_id INT OUTPUT,
    @account_number VARCHAR(30) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @status NOT IN ('active', 'pending', 'suspended')
    BEGIN
        RAISERROR('Invalid business status: %s', 16, 1, @status);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE @output_table TABLE (business_id INT);
            DECLARE @new_business_id INT, @new_user_id INT, @temp_account VARCHAR(30);

            EXEC dbo.sp_CreateUserWithAccount
                @username,
                @phone_number,
                @email,
                @password_hash,
                @type,
                @currency,
                @address,
                @new_user_id OUTPUT,
                @temp_account OUTPUT;

            INSERT INTO Business (
                user_id,
                name,
                legal_name,
                registration_number,
                country,
                category,
                status
            )
            OUTPUT INSERTED.business_id INTO @output_table
            VALUES (
                @new_user_id,
                @name,
                @legal_name,
                @registration_number,
                @country,
                @category,
                @status
            );
            
            SELECT @new_business_id = business_id FROM @output_table;

            SET @business_id = @new_business_id;
            SET @user_id = @new_user_id;
            SET @account_number = @temp_account;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CreateAgentWithAccount(
    @display_name VARCHAR(100),
    @username VARCHAR(50),
    @phone_number VARCHAR(20),
    @email VARCHAR(100),
    @password_hash VARCHAR(255),
    @status VARCHAR(20),
    @type VARCHAR(20),
    @currency CHAR(3) = 'USD',
    @legal_name VARCHAR(150) = NULL,
    @address VARCHAR(MAX) = NULL,
    @agent_id INT OUTPUT,
    @user_id INT OUTPUT,
    @account_number VARCHAR(30) OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @status NOT IN ('active', 'inactive')
    BEGIN
        RAISERROR('Invalid agent status: %s', 16, 1, @status);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE @output_table TABLE (agent_id INT);
            DECLARE @new_agent_id INT, @new_user_id INT, @temp_account VARCHAR(30);

            EXEC dbo.sp_CreateUserWithAccount
                @username,
                @phone_number,
                @email,
                @password_hash,
                @type,
                @currency,
                @address,
                @new_user_id OUTPUT,
                @temp_account OUTPUT;

            INSERT INTO Agent (
                user_id,
                display_name,
                status
            )
            OUTPUT INSERTED.agent_id INTO @output_table
            VALUES (
                @new_user_id,
                @display_name,
                @status
            );
            
            SELECT @new_agent_id = agent_id FROM @output_table;

            SET @agent_id = @new_agent_id;
            SET @user_id = @new_user_id;
            SET @account_number = @temp_account;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- Transaction Procedures --

CREATE OR ALTER PROCEDURE dbo.sp_TransferMoney(
    @type VARCHAR(20),
    @source_account VARCHAR(30),
    @destination_account VARCHAR(30),
    @amount DECIMAL(15, 2),
    @fee_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF @amount <= 0
    BEGIN
        RAISERROR('Amount must be positive.', 16, 1);
        RETURN;
    END

    IF @source_account = @destination_account
    BEGIN
        RAISERROR('Cannot transfer to same account.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Fee WHERE fee_id = @fee_id)
    BEGIN
        RAISERROR('Invalid fee_id.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Account WHERE account_number = @source_account AND status = 'active')
    BEGIN
        RAISERROR('Invalid or inactive source account.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Account WHERE account_number = @destination_account AND status = 'active')
    BEGIN
        RAISERROR('Invalid or inactive destination account.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
            DECLARE
                @source_balance DECIMAL(15, 2),
                @source_currency CHAR(3),
                @destination_balance DECIMAL(15, 2),
                @destination_currency CHAR(3),
                @fee_amount DECIMAL(15, 2),
                @operation_type VARCHAR(20),
                @payer_type VARCHAR(20);
            
            SELECT
                @source_balance = balance,
                @source_currency = currency
            FROM Account WITH (UPDLOCK, HOLDLOCK)
            WHERE account_number = @source_account;
            
            SELECT
                @destination_balance = balance,
                @destination_currency = currency
            FROM Account WITH (UPDLOCK, HOLDLOCK)
            WHERE account_number = @destination_account;

            SELECT
                @operation_type = operation_type,
                @payer_type = payer_type
            FROM Fee
            WHERE fee_id = @fee_id;

            SET @fee_amount = dbo.fn_CalculateFee(@amount, @operation_type, @payer_type);

            DECLARE @source_fee DECIMAL(15, 2) = 0;
            DECLARE @destination_fee DECIMAL(15, 2) = 0;

            SET @source_fee = CASE 
                WHEN @payer_type = 'sender' THEN @fee_amount
                WHEN @payer_type = 'agent' AND @type = 'withdraw' THEN @fee_amount
                WHEN @payer_type = 'shared' THEN @fee_amount / 2
                ELSE 0 
            END;

            SET @destination_fee = CASE 
                WHEN @payer_type IN ('receiver', 'business') THEN @fee_amount
                WHEN @payer_type = 'agent' AND @type = 'deposit' THEN @fee_amount
                WHEN @payer_type = 'shared' THEN @fee_amount / 2
                ELSE 0 
            END;

            IF @amount + @source_fee > @source_balance OR @destination_fee > @destination_balance
            BEGIN
                RAISERROR('Insufficient balance.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END;

            IF @source_currency != @destination_currency
            BEGIN
                RAISERROR('Currency mismatch between accounts.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
            
            UPDATE Account
                SET balance -= @amount + @source_fee
                WHERE account_number = @source_account;
            UPDATE Account
                SET balance += @amount - @destination_fee
                WHERE account_number = @destination_account;

            INSERT INTO [Transaction] (
                source_account,
                destination_account,
                type,
                amount,
                currency,
                time,
                status,
                fee_id,
                fee_amount,
                fee_currency
            )
            VALUES (
                @source_account,
                @destination_account,
                @type,
                @amount,
                @source_currency,
                SYSDATETIME(),
                'completed',
                @fee_id,
                @fee_amount,
                @source_currency
            );
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
