CREATE FUNCTION dbo.fn_GetUserRecentTransactions(@user_id INT, @limit INT = 30)
    RETURNS TABLE
AS
    RETURN (
        SELECT TOP (@limit) * FROM vw_TransactionDetails
            WHERE source_user_id = @user_id OR destination_user_id = @user_id
    );
GO

CREATE FUNCTION dbo.fn_GetUserBalance(@user_id INT)
    RETURNS TABLE
AS
    RETURN (
        SELECT
            account_number,
            balance
        FROM vw_UserAccountOverview
            WHERE user_id = @user_id

        UNION ALL

        SELECT
            'total_balance' AS account_number,
            SUM(balance) AS balance
        FROM vw_UserAccountOverview
            WHERE user_id = @user_id
    );
GO

CREATE FUNCTION dbo.fn_GetAccountTransactions(@account_number VARCHAR(50))
    RETURNS TABLE
AS
    RETURN (
        SELECT * FROM vw_TransactionDetails
            WHERE source_account = @account_number OR destination_account = @account_number
    );
GO

CREATE FUNCTION dbo.fn_CalculateFee(
    @amount DECIMAL(18,2), 
    @operation_type VARCHAR(20), 
    @payer_type VARCHAR(20)
)
    RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @fee DECIMAL(18,2);
    
    SELECT @fee = 
        CASE 
            WHEN fee_type = 'percentage' THEN @amount * fee_value
            WHEN fee_type = 'fixed' THEN fee_value
        END
    FROM Fee 
    WHERE operation_type = @operation_type 
      AND payer_type = @payer_type;
    
    RETURN ISNULL(@fee, 0);
END;
GO

CREATE FUNCTION dbo.fn_GetUserFullName(@user_id INT)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @full_name NVARCHAR(255);
    
    SELECT @full_name = 
        COALESCE(
            p.first_name + ' ' + ISNULL(p.middle_name + ' ', '') + p.last_name,
            b.name,
            a.display_name,
            u.username
        )
    FROM [User] u
    LEFT JOIN Person p ON u.user_id = p.user_id
    LEFT JOIN Business b ON u.user_id = b.user_id
    LEFT JOIN Agent a ON u.user_id = a.user_id
    WHERE u.user_id = @user_id;
    
    RETURN ISNULL(@full_name, 'Unknown');
END;
GO
