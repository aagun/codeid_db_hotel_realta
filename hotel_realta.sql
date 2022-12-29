-- membuat database
USE tempdb;
GO

DROP DATABASE IF EXISTS Hotel_Realta;
CREATE DATABASE Hotel_Realta;
-- menggunakan db hotel_realta
GO

USE Hotel_Realta;	
GO

CREATE SCHEMA Payment;
GO

CREATE SCHEMA Users;
GO
CREATE SCHEMA Booking;
GO

CREATE SCHEMA Resto;
GO

-- create dummy table Users.Users
CREATE TABLE Users.Users(
	user_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL
);

-- create dummy table Booking.BookingsOrders
CREATE TABLE Booking.BookingOrders(
	boor_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	boor_order_number NVARCHAR(55) UNIQUE NOT NULL
);

-- create dummy table Resto.OrderMenus
CREATE TABLE Resto.OrderMenus(
	orme_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	orme_order_number NVARCHAR(55) UNIQUE NOT NULL
);
GO

-- create tabel Payment.Entity
CREATE TABLE Payment.Entity(
	entity_id INT IDENTITY(1, 1) NOT NULL,
	CONSTRAINT PK_PaymentEntityId PRIMARY KEY (entity_id) 
)

-- create tabel Payment.Bank
CREATE TABLE Payment.Bank(
	bank_entity_id INT NOT NULL,
	bank_code NVARCHAR(10) UNIQUE NOT NULL,
	bank_name NVARCHAR(55) UNIQUE NOT NULL,
	bank_modified_date DATETIME
	CONSTRAINT PK_PaymentBankEntityId PRIMARY KEY(bank_entity_id),
	CONSTRAINT FK_PaymentBankEntityId FOREIGN KEY(bank_entity_id) 
		REFERENCES Payment.Entity (entity_id) 
		ON UPDATE CASCADE 
		ON DELETE CASCADE
)

-- create tabel Payment.PaymentGateway
CREATE TABLE Payment.PaymentGateway(
	paga_entity_id INT NOT NULL,
	paga_code NVARCHAR(10) UNIQUE NOT NULL,
	paga_name NVARCHAR(55) UNIQUE NOT NULL,
	paga_modified_date DATETIME,
	CONSTRAINT PK_PaymentGatewayEntityId PRIMARY KEY(paga_entity_id),
	CONSTRAINT FK_PaymentGatewayEntityId FOREIGN KEY(paga_entity_id)
		REFERENCES Payment.Entity (entity_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
)

-- create tabel Payment.UserAccount
CREATE TABLE Payment.UserAccounts(
	usac_entity_id INT NOT NULL,
	usac_user_id INT NOT NULL,
	usac_account_number VARCHAR(25) UNIQUE NOT NULL,
	usac_saldo MONEY,
	usac_type NVARCHAR(15),
	usac_expmonth TINYINT,
	usac_expyear SMALLINT,
	usac_modified_date DATETIME,
	CONSTRAINT CK_PaymentUserAccountsType CHECK (usac_type IN ('debet', 'credit card', 'payment')),
	CONSTRAINT PK_PaymentUserAccountsEntityId PRIMARY KEY(usac_entity_id, usac_user_id),
	CONSTRAINT FK_PaymentUserAccountsEntityPaymentGateway_Bank FOREIGN KEY(usac_entity_id) 
		REFERENCES Payment.Entity(entity_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT FK_PaymentUserAccountsUserId FOREIGN KEY(usac_user_id)
		REFERENCES Users.Users (user_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
)

-- create table Payment.PaymentTransaction
CREATE TABLE Payment.PaymentTransaction(
	patr_id INT IDENTITY(1,1) PRIMARY KEY,
	patr_trx_number NVARCHAR(55) UNIQUE,
	patr_debet MONEY,
	patr_credit MONEY,
	patr_type NCHAR(3) NOT NULL,
	patr_note NVARCHAR(255),
	patr_modified_date DATETIME,
	patr_order_number NVARCHAR(55),
	patr_source_id INT,
	patr_target_id INT,
	patr_trx_number_ref NVARCHAR(55) UNIQUE,
	patr_user_id INT,
	CONSTRAINT CK_PaymentPaymentTransactionType CHECK (patr_type IN ('TP', 'TRB', 'RPY', 'RF', 'ORM')),
	CONSTRAINT FK_PaymentPaymentTransactionUserId FOREIGN KEY (patr_user_id)
		REFERENCES Users.Users (user_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT FK_PaymentPaymentTransactionSourceId FOREIGN KEY (patr_source_id)
		REFERENCES Payment.Bank(bank_entity_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT FK_PaymentPaymentTransactionTargetId FOREIGN KEY (patr_target_id)
		REFERENCES Payment.Bank(bank_entity_id)
		ON UPDATE NO ACTION
		ON DELETE NO ACTION
)




