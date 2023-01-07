USE tempdb;
GO

DROP DATABASE IF EXISTS Hotel_Realta;
GO

CREATE DATABASE Hotel_Realta;
GO

USE Hotel_Realta;
GO

CREATE SCHEMA Users;
GO

CREATE SCHEMA Master;
GO

CREATE SCHEMA Hotel;
GO 

CREATE SCHEMA HR;
GO

CREATE SCHEMA Booking;
GO

CREATE SCHEMA Resto;

GO

CREATE SCHEMA Payment;
GO

CREATE SCHEMA Purchasing;
GO

-- MODULE MASTERS --
CREATE TABLE Master.regions (
  region_code int IDENTITY(1, 1),
  region_name nvarchar(35) UNIQUE NOT NULL,
  CONSTRAINT pk_region_code PRIMARY KEY(region_code)
);

CREATE TABLE Master.country (
  country_id int IDENTITY(1, 1),
  country_name nvarchar(55) UNIQUE NOT NULL,
  country_region_id int,
  CONSTRAINT pk_country_id PRIMARY KEY (country_id),
  CONSTRAINT fk_country_region_id FOREIGN KEY(country_region_id) REFERENCES Master.regions(region_code) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Master.provinces (
  prov_id int IDENTITY (1, 1),
  prov_name nvarchar(85) NOT NULL,
  prov_country_id int CONSTRAINT pk_prov_id PRIMARY KEY(prov_id),
  CONSTRAINT fk_prov_country_name FOREIGN KEY(prov_country_id) REFERENCES Master.country(country_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Master.address (
  addr_id int IDENTITY(1, 1),
  addr_line1 nvarchar(255) NOT NULL,
  addr_line2 nvarchar(255),
  addr_postal_code nvarchar(5),
  addr_spatial_location geography,
  addr_prov_id int,
  CONSTRAINT pk_addr_id PRIMARY KEY(addr_id),
  CONSTRAINT fk_addr_prov_id FOREIGN KEY(addr_prov_id) REFERENCES Master.provinces(prov_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);


CREATE TABLE Master.category_group (
  cagro_id int IDENTITY(1, 1),
  cagro_name nvarchar(25) UNIQUE NOT NULL,
  cagro_description nvarchar(255),
  cagro_type nvarchar(25) NOT NULL CHECK (cagro_type IN('category', 'service', 'facility')),
  cagro_icon nvarchar(255),
  cagro_icon_url nvarchar(255),
  CONSTRAINT pk_cagro_id PRIMARY KEY(cagro_id)
);

CREATE TABLE Master.policy (
  poli_id int IDENTITY(1, 1),
  poli_name nvarchar(55) NOT NULL,
  poli_description nvarchar(255),
  CONSTRAINT pk_poli_id PRIMARY KEY(poli_id)
);

CREATE TABLE Master.policy_category_group (
  poca_poli_id int NOT NULL,
  poca_cagro_id int NOT NULL,
  CONSTRAINT fk_poca_poli_id FOREIGN KEY(poca_poli_id) REFERENCES Master.policy(poli_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT fk_poca_cagro_id FOREIGN KEY(poca_cagro_id) REFERENCES Master.category_group(cagro_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Master.price_item (
  prit_id int IDENTITY(1, 1),
  prit_name nvarchar(55) UNIQUE NOT NULL,
  prit_price money NOT NULL,
  prit_description nvarchar(255),
  prit_type nvarchar(15) NOT NULL CHECK (prit_type IN ('SNACK', 'FACILITY', 'SOFTDRINK', 'FOOD', 'SERVICE')),
  prit_modified_date datetime,
  CONSTRAINT pk_prit_id PRIMARY KEY(prit_id)
);

CREATE TABLE Master.service_task (
  seta_id int IDENTITY(1, 1),
  seta_name nvarchar(85) UNIQUE NOT NULL,
  seta_seq smallint CONSTRAINT pk_set_id PRIMARY KEY(seta_id)
);

CREATE TABLE Master.members (
  memb_name nvarchar(15) NOT NULL,
  memb_description nvarchar(200),
  CONSTRAINT pk_memb_name PRIMARY KEY(memb_name)
);

-- MODULE USERS	--
CREATE TABLE Users.users (
  user_id int IDENTITY(1,1) NOT NULL,
  user_full_name nvarchar (55) DEFAULT 'guest' NOT NULL,
  user_type nvarchar (15) CHECK(user_type IN('T','C','I')),
  user_company_name nvarchar (255),
  user_email nvarchar(256),
  user_phone_number nvarchar (25) UNIQUE NOT NULL,
  user_modified_date datetime,
	CONSTRAINT pk_user_id PRIMARY KEY(user_id)
);

CREATE TABLE Users.user_members (
  usme_user_id int,
  usme_memb_name nvarchar(15) CHECK(usme_memb_name IN('Silver','Gold','VIP','Wizard')),
  usme_promote_date datetime,
  usme_points smallint,
  usme_type nvarchar(15) DEFAULT 'Expired',
	CONSTRAINT pk_usme_user_id PRIMARY KEY(usme_user_id),
	CONSTRAINT fk_usme_user_id FOREIGN KEY(usme_user_id) REFERENCES Users.users (user_id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	CONSTRAINT fk_usme_memb_name FOREIGN KEY (usme_memb_name) REFERENCES Master.members(memb_name)
	  ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Users.roles (
  role_id int IDENTITY(1,1),
  role_name nvarchar (35) NOT NULL,
	CONSTRAINT pk_role_id PRIMARY KEY(role_id)
);

CREATE TABLE Users.user_roles (
  usro_user_id int,
  usro_role_id int,
	CONSTRAINT pk_usro_user_id PRIMARY KEY(usro_user_id),
	CONSTRAINT fk_usro_user_id FOREIGN KEY (usro_user_id) REFERENCES Users.users(user_id) 
	  ON DELETE CASCADE 
    ON UPDATE CASCADE,
	CONSTRAINT fk_usro_role_id FOREIGN KEY (usro_role_id) REFERENCES Users.roles(role_id) 
	  ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Users.user_profiles (
  uspro_id int IDENTITY(1,1),
  uspro_national_id nvarchar (20) NOT NULL,
  uspro_birth_date date NOT NULL,
  uspro_job_title nvarchar (50),
  uspro_marital_status nchar(1) CHECK(uspro_marital_status IN('M','S')),
  uspro_gender nchar(1) CHECK(uspro_gender IN('M','F')),
  uspro_addr_id int,
  uspro_user_id int,
	CONSTRAINT pk_usro_id PRIMARY KEY(uspro_id),
	CONSTRAINT fk_uspro_user_id FOREIGN KEY (uspro_user_id) REFERENCES Users.users (user_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
	CONSTRAINT fk_uspro_addr_id FOREIGN KEY (uspro_addr_id) REFERENCES Master.address (addr_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Users.bonus_points (
  ubpo_id int IDENTITY(1,1),
  ubpo_user_id int,
  ubpo_total_points smallint,
  ubpo_bonus_type nchar (1),
  ubpo_created_on datetime,
	CONSTRAINT pk_ubpo_id PRIMARY KEY(ubpo_id),
	CONSTRAINT fk_ubpo_user_id FOREIGN KEY (ubpo_user_id) REFERENCES Users.users (user_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Users.user_password (
  uspa_user_id int IDENTITY(1,1),
  uspa_passwordHash varchar(128),
  uspa_passwordSalt varchar(10),
	CONSTRAINT pk_uspa_user_id PRIMARY KEY(uspa_user_id),
	CONSTRAINT fk_uspa_user_id FOREIGN KEY (uspa_user_id) REFERENCES users.users (user_id) 
);

--MODULE HOTELS --
IF OBJECT_ID('Hotel.hotels', 'U') IS NOT NULL DROP TABLE Hotel.hotels
CREATE TABLE Hotel.hotels (
  hotel_id int IDENTITY(1, 1) NOT NULL CONSTRAINT pk_hotel_id PRIMARY KEY,
  hotel_name nvarchar(85) NOT NULL,
  hotel_description nvarchar(500) NULL,
  hotel_rating_star smallint NULL,
  hotel_phonenumber nvarchar(25) NOT NULL,
  hotel_modified_date datetime NULL,
  hotel_addr_id int NOT NULL,
  CONSTRAINT fk_hotel_addr_id FOREIGN KEY (hotel_addr_id) REFERENCES Master.address(addr_id)
);

IF OBJECT_ID('Hotel.hotel_reviews', 'U') IS NOT NULL DROP TABLE Hotel.hotel_reviews
CREATE TABLE Hotel.hotel_reviews (
  hore_id int IDENTITY(1, 1) NOT NULL CONSTRAINT pk_hore_id PRIMARY KEY,
  hore_user_review nvarchar(125) NOT NULL,
  hore_rating bit NOT NULL CHECK(hore_rating IN(1, 2, 3, 4, 5)) DEFAULT 5,
  hore_created_on datetime NULL,
  hore_user_id int NOT NULL,
  hore_hotel_id int NOT NULL,
  CONSTRAINT pk_hore_user_id FOREIGN KEY (hore_user_id) REFERENCES Users.users(user_id),
  CONSTRAINT fk_hore_hotel_id FOREIGN KEY (hore_hotel_id) REFERENCES Hotel.hotels(hotel_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

IF OBJECT_ID('Hotel.facilities', 'U') IS NOT NULL DROP TABLE Hotel.facilities
CREATE TABLE Hotel.facilities (
  faci_id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_faci_id PRIMARY KEY,
  -- primary key column
  faci_name nvarchar(125) NOT NULL,
  faci_description nvarchar(255) NULL,
  faci_max_number INT NULL,
  faci_measure_unit VARCHAR(15) NULL CHECK(faci_measure_unit IN('People', 'Beds')),
  faci_room_number nvarchar(6) NOT NULL,
  faci_startdate DATETIME NOT NULL,
  faci_endate DATETIME NOT NULL,
  faci_low_price MONEY NOT NULL,
  faci_high_price MONEY NOT NULL,
  faci_rate_price MONEY NOT NULL,
  faci_discount SMALLMONEY NULL,
  faci_tax_rate SMALLMONEY NULL,
  faci_modified_date DATETIME NULL,
  --FOREIGN KEY
  faci_cagro_id INTEGER NOT NULL,
  faci_hotel_id INT NOT NULL,
  -- UNIQUE ID
  CONSTRAINT uq_faci_room_number UNIQUE (faci_room_number),
  CONSTRAINT fk_faci_cagro_id FOREIGN KEY (faci_cagro_id) REFERENCES Master.category_group(cagro_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT fk_faci_hotel_id FOREIGN KEY (faci_cagro_id) REFERENCES Hotel.hotels(hotel_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);


IF OBJECT_ID('Hotel.facility_price_history', 'U') IS NOT NULL DROP TABLE Hotel.facility_price_history
CREATE TABLE Hotel.facility_price_history (
  faph_id int IDENTITY(1, 1) NOT NULL CONSTRAINT pk_faph_id PRIMARY KEY,
  faph_startdate datetime NOT NULL,
  faph_enddate datetime NOT NULL,
  faph_low_price money NOT NULL,
  faph_high_price money NOT NULL,
  faph_rate_price money NOT NULL,
  faph_discount smallmoney NOT NULL,
  faph_tax_rate smallmoney NOT NULL,
  faph_modified_date datetime,
  faph_faci_id int NOT NULL,
  faph_user_id int NOT NULL,
  CONSTRAINT fk_faph_faci_id FOREIGN KEY (faph_faci_id) REFERENCES Hotel.facilities(faci_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_faph_user_id FOREIGN KEY (faph_user_id) REFERENCES Users.users(user_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

IF OBJECT_ID('Hotel.facility_photos', 'U') IS NOT NULL DROP TABLE Hotel.facility_photos
CREATE TABLE Hotel.facility_photos (
  fapho_id int IDENTITY(1, 1) NOT NULL CONSTRAINT pk_fapho_id PRIMARY KEY,
  fapho_thumbnail_filename nvarchar(50) NULL,
  fapho_photo_filename nvarchar(50) NULL,
  fapho_primary bit NULL CHECK(fapho_primary IN(0, 1)),
  fapho_url nvarchar(255) NULL,
  fapho_modified_date datetime,
  fapho_faci_id int NOT NULL,
  CONSTRAINT pk_fapho_faci_id FOREIGN KEY (fapho_faci_id) REFERENCES Hotel.facilities(faci_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- MODULE HR --
CREATE TABLE HR.job_role (
	joro_id int IDENTITY(1, 1) NOT NULL,
	joro_name nvarchar(55) NOT NULL,
	joro_modified_date datetime,
	CONSTRAINT pk_joro_id PRIMARY KEY(joro_id),
	CONSTRAINT uq_joro_name UNIQUE (joro_name)
);

CREATE TABLE HR.department (
	dept_id int IDENTITY(1,1) NOT NULL,
	dept_name nvarchar(50) NOT NULL,
	dept_modified_date datetime,
	CONSTRAINT pk_dept_id PRIMARY KEY (dept_id)
);

CREATE TABLE HR.employee (
	emp_id int IDENTITY(1,1) NOT NULL,
	emp_national_id nvarchar(25) NOT NULL,
	emp_birth_date datetime NOT NULL,
	emp_marital_status nchar(1) NOT NULL,
	emp_gender nchar(1) NOT NULL,
	emp_hire_date datetime NOT NULL,
	emp_salaried_flag nchar(1) NOT NULL,
	emp_vacation_hours int,
	emp_sickleave_hourse int,
	emp_current_flag int,
	emp_emp_id int,
	emp_photo nvarchar(255),
	emp_modified_date datetime,
	emp_joro_id int NOT NULL,
	CONSTRAINT pk_emp_id PRIMARY KEY (emp_id),
	CONSTRAINT uq_emp_national_id UNIQUE (emp_national_id),
	CONSTRAINT fk_emp_joro_id FOREIGN KEY (emp_joro_id) REFERENCES HR.job_role(joro_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_emp_id FOREIGN KEY (emp_emp_id) REFERENCES hr.employee(emp_id)
);

CREATE TABLE HR.employee_pay_history (
	ephi_emp_id int NOT NULL,
	ephi_rate_change_date datetime NOT NULL,
	ephi_rate_salary money,
	ephi_pay_frequence int,
	ephi_modified_date datetime,
	CONSTRAINT pk_ephi_emp_id_ephi_rate_change_date PRIMARY KEY(ephi_emp_id, ephi_rate_change_date),
	CONSTRAINT fk_ephi_emp_id FOREIGN KEY(ephi_emp_id) REFERENCES HR.employee(emp_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE HR.shift(
	shift_id int IDENTITY(1,1),
	shift_name nvarchar(25) NOT NULL,
	shift_start_time datetime NOT NULL,
	shift_end_time datetime NOT NULL,
	CONSTRAINT pk_shift_id PRIMARY KEY(shift_id),
	CONSTRAINT uq_shift_name UNIQUE (shift_name),
	CONSTRAINT uq_shift_start_time UNIQUE (shift_start_time),
	CONSTRAINT uq_shift_end_time UNIQUE (shift_end_time)
);

CREATE TABLE HR.employee_department_history (
	edhi_id int IDENTITY(1,1) NOT NULL,
	edhi_emp_id int NOT NULL,
	edhi_start_date datetime,
	edhi_end_date datetime,
	edhi_modified_date datetime,
	edhi_dept_id int NOT NULL,
	edhi_shift_id int NOT NULL,
	CONSTRAINT pk_edhi_id_edhi_emp_id PRIMARY KEY (edhi_id, edhi_emp_id),
	CONSTRAINT fk_edhi_emp_id FOREIGN KEY(edhi_emp_id) REFERENCES HR.employee(emp_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_shift_id FOREIGN KEY (edhi_shift_id) REFERENCES HR.shift(shift_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_edhi_dept_id FOREIGN KEY (edhi_dept_id) REFERENCES HR.department(dept_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE HR.work_orders (
	woro_id int IDENTITY(1,1),
	woro_date datetime NOT NULL,
	woro_status nvarchar(15), 
	woro_user_id int,
	CONSTRAINT pk_woro_id PRIMARY KEY(woro_id),
	CONSTRAINT fk_woro_user_id FOREIGN KEY(woro_user_id) REFERENCES Users.users(user_id)
)

CREATE TABLE HR.work_order_detail (
	wode_id int IDENTITY(1,1),
	wode_task_name nvarchar(255),
	wode_status nvarchar(15),
	wode_start_date datetime,
	wode_end_date datetime,
	wode_notes nvarchar(255),
	wode_emp_id int,
	wode_seta_id int,
	wode_faci_id int,
	wode_woro_id int,
	CONSTRAINT pk_wode_id PRIMARY KEY(wode_id),
	CONSTRAINT fk_woro_wode_id FOREIGN KEY(wode_woro_id) REFERENCES HR.work_orders(woro_id),
	CONSTRAINT fk_wode_emp_id FOREIGN KEY(wode_emp_id) REFERENCES HR.employee(emp_id), 
	CONSTRAINT fk_wode_seta_id FOREIGN KEY(wode_seta_id) REFERENCES Master.service_task(seta_id), 
	CONSTRAINT fk_faci_id FOREIGN KEY(wode_faci_id) REFERENCES Hotel.facilities(faci_id)
);

-- MODULE BOOKING --
CREATE TABLE Booking.special_offers(
    spof_id int IDENTITY(1,1) NOT NULL,
    spof_name nvarchar(55) NOT NULL,
    spof_description nvarchar(255) NOT NULL,
    spof_type nchar(5) NOT NULL CHECK (spof_type IN ('T','C','I')),
    spof_discount smallmoney NOT NULL,
    spof_start_date datetime NOT NULL,
    spof_end_date datetime NOT NULL,
    spof_min_qty int,
    spof_max_qty int,
    spof_modified_date datetime
    CONSTRAINT pk_spof_id PRIMARY KEY(spof_id)
);

CREATE TABLE Booking.booking_orders(
	boor_id int	IDENTITY (1,1),
	boor_order_number nvarchar(55) NOT NULL,
	boor_order_date datetime NOT NULL,
	boor_arrival_date datetime,
	boor_total_room smallint,
	boor_total_guest smallint,
	boor_discount smallmoney,
	boor_total_tax smallmoney,
	boor_total_ammount money,
	boor_down_payment money,
	boor_pay_type nchar(2) NOT NULL CHECK (boor_pay_type IN ('CR','C','D ','PG')),
	boor_is_paid nchar(2) NOT NULL CHECK (boor_is_paid IN ('DP','P','R ')),
	boor_type nvarchar(15) NOT NULL CHECK (boor_type IN ('T','C','I')),
	boor_cardnumber nvarchar(25),
	boor_member_type nvarchar(15),
	boor_status nvarchar(15) CHECK (boor_status IN ('BOOKING','CHECKIN','CHECKOUT','CLEANING','CANCELED')),
	boor_user_id int,
	boor_hotel_id int
	CONSTRAINT pk_boor_id PRIMARY KEY (boor_id),
	CONSTRAINT unique_boor_order_number UNIQUE (boor_order_number),
	CONSTRAINT fk_boor_user_id FOREIGN KEY (boor_user_id) REFERENCES Users.users (user_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
	CONSTRAINT fk_boor_hotel_id FOREIGN KEY (boor_hotel_id) REFERENCES Hotel.hotels (hotel_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Booking.booking_order_detail(
	borde_boor_id integer,
	borde_id int IDENTITY (1,1) UNIQUE NOT NULL,
	borde_checkin datetime NOT NULL,
	borde_checkout datetime NOT NULL,
	borde_adults integer,
	borde_kids integer,
	borde_price money,
	borde_extra money,
	borde_discount smallmoney,
	borde_tax smallmoney,
	borde_subtotal money,
	borde_faci_id integer,
	CONSTRAINT pk_borde_id_boor_id PRIMARY KEY (borde_id, borde_boor_id),
	CONSTRAINT fk_border_boor_id FOREIGN KEY(borde_boor_id)	REFERENCES Booking.booking_orders(boor_id),
	CONSTRAINT fk_borde_faci_id FOREIGN KEY(borde_faci_id) REFERENCES Hotel.facilities(faci_id) 
		ON DELETE CASCADE 
    ON UPDATE CASCADE 
);

CREATE TABLE Booking.booking_order_detail_extra(
	boex_id int IDENTITY (1,1),
	boex_price money,
	boex_qty smallint,
	boex_subtotal money,
	boex_measure_unit nvarchar (50), CHECK(boex_measure_unit IN ('people','unit','kg')),
	boex_borde_id int,
	boex_prit_id int
	CONSTRAINT pk_boex_id PRIMARY KEY (boex_id),
	CONSTRAINT fk_boex_borde_id FOREIGN KEY (boex_borde_id) REFERENCES Booking.booking_order_detail (borde_id) 
		ON DELETE CASCADE 
    ON UPDATE CASCADE,
	CONSTRAINT fk_boex_prit_id FOREIGN KEY (boex_prit_id) REFERENCES Master.price_item(prit_id) 
		ON DELETE CASCADE 
    ON UPDATE CASCADE
)

CREATE TABLE Booking.special_offer_coupons(
    soco_id int IDENTITY(1,1),
    soco_borde_id int,
    soco_spof_id int,
    CONSTRAINT pk_soco_id PRIMARY KEY(soco_id),
    CONSTRAINT fk_soco_borde_id FOREIGN KEY(soco_borde_id) REFERENCES Booking.booking_order_detail(borde_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE,
    CONSTRAINT fk_soco_spof_id FOREIGN KEY(soco_spof_id) REFERENCES Booking.special_offers(spof_id) 
		  ON DELETE CASCADE 
      ON UPDATE CASCADE
);

CREATE TABLE Booking.user_breakfast(
    usbr_borde_id int,
    usbr_modified_date datetime,
    usbr_total_vacant smallint NOT NULL,
    CONSTRAINT pk_usbr_borde_id_usbr_modified_date PRIMARY KEY(usbr_borde_id,usbr_modified_date),
    CONSTRAINT fk_usbr_borde_id FOREIGN KEY(usbr_borde_id) 
		REFERENCES Booking.booking_order_detail(borde_id) 
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- MODULE RESTO --
CREATE TABLE Resto.resto_menus(
    reme_faci_id int,
    reme_id int IDENTITY(1,1),
    reme_name nvarchar(55) NOT NULL,
    reme_description nvarchar(255),
    reme_price money NOT NULL,
    reme_status nvarchar(15) NOT NULL,
    reme_modified_date datetime,
    CONSTRAINT pk_reme_faci_id PRIMARY KEY (reme_id),
    CONSTRAINT reme_faci_id FOREIGN KEY (reme_faci_id) REFERENCES Hotel.facilities(faci_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE
);

CREATE TABLE Resto.order_menus(
    orme_id int IDENTITY,
    orme_order_number nvarchar (55) UNIQUE NOT NULL,
    orme_order_date datetime NOT NULL,
    orme_total_item smallint,
    orme_total_discount smallmoney,
    orme_total_amount money,
    orme_pay_type nchar(2) NOT NULL,
    orme_cardnumber nvarchar(25),
    orme_is_paid nchar(2),
    orme_modified_date datetime,
    orme_user_id integer,
    CONSTRAINT pk_orme_id PRIMARY KEY (orme_id),
    CONSTRAINT fk_orme_user_id FOREIGN KEY (orme_user_id) REFERENCES Users.users(user_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE
);

CREATE TABLE Resto.order_menu_detail(
    omde_id int IDENTITY,
    orme_price money NOT NULL,
    orme_qty smallint NOT NULL,
    orme_subtotal money NOT NULL,
    orme_discount smallmoney,
    omde_orme_id integer,
    omde_reme_id integer,
    CONSTRAINT pk_omme_id PRIMARY KEY (omde_id),
    CONSTRAINT fk_omde_orme_id FOREIGN KEY (omde_orme_id) REFERENCES Resto.order_menus(orme_id)
      ON DELETE CASCADE 
      ON UPDATE CASCADE,
    CONSTRAINT fk_omde_reme_id FOREIGN KEY (omde_reme_id) REFERENCES Resto.resto_menus(reme_id)
      ON DELETE CASCADE 
      ON UPDATE CASCADE
);

CREATE TABLE Resto.resto_menu_photos(
    remp_id int IDENTITY,
    remp_thumbnial_filname nvarchar (50),
    remp_photo_filename nvarchar (50),
    remp_primary BIT,
    remp_url nvarchar (255),
    remp_reme_id int,
    CONSTRAINT pk_remp_id PRIMARY KEY (remp_id),
    CONSTRAINT fk_remp_reme_id FOREIGN KEY (remp_reme_id) REFERENCES Resto.resto_menus(reme_id)
);

-- MODULE PAYMENT --
CREATE TABLE Payment.entity(
	entity_id int IDENTITY(1, 1) NOT NULL,
	CONSTRAINT PK_PaymentEntityId PRIMARY KEY (entity_id) 
);

CREATE TABLE Payment.bank(
	bank_entity_id int NOT NULL,
	bank_code nvarchar(10) UNIQUE NOT NULL,
	bank_name nvarchar(55) UNIQUE NOT NULL,
	bank_modified_date datetime
	CONSTRAINT PK_PaymentBankEntityId PRIMARY KEY(bank_entity_id),
	CONSTRAINT FK_PaymentBankEntityId FOREIGN KEY(bank_entity_id) 
		REFERENCES Payment.Entity (entity_id) 
		ON UPDATE CASCADE 
		ON DELETE CASCADE
);

CREATE TABLE Payment.payment_gateway(
	paga_entity_id int NOT NULL,
	paga_code nvarchar(10) UNIQUE NOT NULL,
	paga_name nvarchar(55) UNIQUE NOT NULL,
	paga_modified_date datetime,
	CONSTRAINT PK_PaymentGatewayEntityId PRIMARY KEY(paga_entity_id),
	CONSTRAINT FK_PaymentGatewayEntityId FOREIGN KEY(paga_entity_id)
		REFERENCES Payment.Entity (entity_id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE Payment.user_accounts(
	usac_entity_id int NOT NULL,
	usac_user_id int NOT NULL,
	usac_account_number varchar(25) UNIQUE NOT NULL,
	usac_saldo money,
	usac_type nvarchar(15),
	usac_expmonth tinyint,
	usac_expyear smallint,
	usac_modified_date datetime,
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
);

CREATE TABLE Payment.payment_transaction(
  patr_id int IDENTITY(1,1) PRIMARY KEY,
	patr_trx_number nvarchar(55) UNIQUE,
	patr_debet money,
	patr_credit money,
	patr_type nchar(3) NOT NULL,
	patr_note nvarchar(255),
	patr_modified_date datetime,
	patr_order_number nvarchar(55),
	patr_source_id int,
	patr_target_id int,
	patr_trx_number_ref nvarchar(55) UNIQUE,
	patr_user_id int,
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
);

-- MODULE PURCHASING --
CREATE TABLE Purchasing.stocks(
	stock_id int IDENTITY (1,1),
	stock_name nvarchar(255) NOT NULL,
	stock_description nvarchar(255),
	stock_quantity smallint NOT NULL,
	stock_reorder_point smallint NOT NULL,
	stock_used smallint,
	stock_scrap smallint,
	stock_price money NOT NULL,
	stock_standar_cost money NOT NULL,
	stock_size nvarchar (25),
	stock_color nvarchar (15),
	stock_modified_date datetime,
	CONSTRAINT pk_department_id PRIMARY KEY (stock_id)
);

CREATE TABLE Purchasing.stock_photo(
	spho_id int IDENTITY (1,1),
	spho_thumbnail_filename nvarchar (50),
	spho_photo_filename nvarchar (50),
	spho_primary bit DEFAULT 0 CHECK (spho_primary IN (0,1)),
	spho_url nvarchar(355),
	spho_stock_id int,
	CONSTRAINT pk_spho_id PRIMARY KEY (spho_id),
	CONSTRAINT fk_spho_stock_id FOREIGN KEY (spho_stock_id) REFERENCES Purchasing.stocks(stock_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);

CREATE TABLE Purchasing.vendor(
	vendor_id int IDENTITY (1,1),
	vendor_name nvarchar(55) NOT NULL,
	vendor_active bit default 1 CHECK (vendor_active IN (0,1)),
	vendor_priority bit default 0 CHECK (vendor_priority IN (0,1)),
	vendor_register_date datetime NOT NULL,
	vendor_weburl nvarchar(1025),
	vendor_modifier_date datetime,
	CONSTRAINT pk_vendor_id PRIMARY KEY (vendor_id)
);

CREATE TABLE Purchasing.purchase_order_header(
    pohe_id int IDENTITY(1,1) NOT NULL,
    pohe_number nvarchar(20),
    pohe_status tinyint DEFAULT 1 CHECK (pohe_status IN(1, 2, 3, 4)),
    pohe_order_date datetime,
    pohe_subtotal money,
    pohe_tax money,
    pohe_total_amount money,
    pohe_refund money,
    pohe_arrival_date datetime,
    pohe_pay_type nchar(2) NOT NULL CHECK (pohe_pay_type IN('TR', 'CA')),
    pohe_emp_id int,
    pohe_vendor_id int,
    CONSTRAINT pk_pohe_id PRIMARY KEY(pohe_id),
    CONSTRAINT fk_pohe_emp_id FOREIGN KEY (pohe_emp_id) REFERENCES HR.employee(emp_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE,
    CONSTRAINT fk_pohe_vendor_id FOREIGN KEY (pohe_vendor_id) REFERENCES Purchasing.vendor(vendor_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE
);

CREATE TABLE Purchasing.stock_detail (
    stod_stock_id int,
    stod_id int IDENTITY,
    stod_barcode_number nvarchar (255),
    stod_status nchar(2) default 1,
    stod_notes nvarchar(1024),
    stod_faci_id int,
    stod_pohe_id int,
    CONSTRAINT pk_stod_id PRIMARY KEY (stod_id),
    CONSTRAINT fk_stod_stock_id FOREIGN KEY (stod_stock_id) REFERENCES Purchasing.stocks(stock_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE,
    CONSTRAINT fk_stod_pohe_id FOREIGN KEY (stod_pohe_id) REFERENCES Purchasing.purchase_order_header(pohe_id)
      ON DELETE CASCADE 
      ON UPDATE CASCADE,
    CONSTRAINT fk_stod_faci_id FOREIGN KEY (stod_faci_id) REFERENCES Hotel.facilities(faci_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE,
    CONSTRAINT uq_stod_barcode_number UNIQUE (stod_barcode_number)
);

CREATE TABLE Purchasing.purchase_order_detail(
    pode_pohe_id int,
    pode_id int IDENTITY (1,1),
    pode_order_qty smallint NOT NULL,
    pode_price money NOT NULL,
    pode_line_total money NOT NULL,
    pode_received_qty decimal(8,2),
    pode_rejected_qty decimal (8,2),
    pode_stocked_qty decimal (9,2),
    pode_modified_date datetime,
    pode_stock_id int,
    CONSTRAINT pk_pode_id PRIMARY KEY (pode_id),
    CONSTRAINT fk_pode_pohe_id FOREIGN KEY (pode_pohe_id) REFERENCES Purchasing.purchase_order_header(pohe_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE, 
    CONSTRAINT fk_pode_stock_id FOREIGN KEY (pode_stock_id) REFERENCES Purchasing.stocks(stock_id) 
      ON DELETE CASCADE 
      ON UPDATE CASCADE
);