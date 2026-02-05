USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DigitalWalletDB')
BEGIN
CREATE DATABASE DigitalWalletDB;
END
GO
