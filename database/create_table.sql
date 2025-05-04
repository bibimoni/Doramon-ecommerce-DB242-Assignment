USE SHOPEE;

DROP TABLE IF EXISTS Order_has_variations;
DROP TABLE IF EXISTS Apply_voucher;
DROP TABLE IF EXISTS Cart_has_variations;
DROP TABLE IF EXISTS Ban_seller;
DROP TABLE IF EXISTS Ban_buyer;
DROP TABLE IF EXISTS Report;
DROP TABLE IF EXISTS Use_voucher;
DROP TABLE IF EXISTS Voucher_category;
DROP TABLE IF EXISTS Create_voucher;
DROP TABLE IF EXISTS Cart;
DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Delivery;
DROP TABLE IF EXISTS Info_variation;
DROP TABLE IF EXISTS Variation;
DROP TABLE IF EXISTS Product_attachments;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Voucher;
DROP TABLE IF EXISTS Buyer;
DROP TABLE IF EXISTS Seller;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Sending_message;
DROP TABLE IF EXISTS Shop;
DROP TABLE IF EXISTS Social;
DROP TABLE IF EXISTS Banking_account;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Person;

# Tham chieu den khoa ngoai thi truong khoa ngoai trong bang do
# se khong co rang buoc NOT NULL (quy uoc vay thoi chu khong
# biet co nen lam vay khong :>>>)

# Co 1 so truong em tu dinh nghia no co the null hoac khong
# Neu mn co y kien thi sua lai nha!

# VARCHAR(20) voi TEXT duoc su dung trong day voi y nghia
# VARCHAR : dung cho cac truong do do dai thuong bi gioi han
# TEXT    : dung co cac truong do dai lon 2^16 bit... do dai
# Mn co the sua lai tuy thich, cai nay khong quan trong lam
# Neu de hon thi spam TEXT cho nhanh

CREATE TABLE Person (
	username 			VARCHAR(20) NOT NULL PRIMARY KEY,
    hashed_password     VARCHAR(100) NOT NULL,
    email				VARCHAR(100),
    birth_day			DATE,
    phone_number		VARCHAR(11),
    is_banned           BOOL NOT NULL,
    avatar_link         TEXT,
    gender				ENUM('m', 'f') # male, female, LGBT ?, lesbian ??
);

CREATE TABLE Address (
	address 			VARCHAR(100) NOT NULL,
    username            VARCHAR(20),
    PRIMARY KEY (username, address)
);

CREATE TABLE Banking_account (
	bank_name			VARCHAR(20) NOT NULL,
    bank_number 		VARCHAR(20) UNIQUE NOT NULL, # 1 tai khoan 1 bank thoi
    bank_type			ENUM('credit', 'debit') DEFAULT 'debit',
    username            VARCHAR(20),
    PRIMARY KEY (username, bank_number) # !!!! khac voi trong mapping
);

CREATE TABLE Social (
	link				VARCHAR(20) UNIQUE NOT NULL, # cac tk dung cac account khac nhau
    username            VARCHAR(200),
    PRIMARY KEY (username, link)
);


CREATE TABLE Sending_message (
	msg_id				INT UNIQUE NOT NULL,
    timestamp			INT NOT NULL, # Timestamp la time since epoch, con date la DD/MM/YYY...
    content				TEXT NOT NULL,
    snd_username        VARCHAR(20),
    recv_username       VARCHAR(20),
    PRIMARY KEY (msg_id, snd_username, recv_username)
);

CREATE TABLE Buyer (
	coin				INT NOT NULL,
    username            VARCHAR(20) PRIMARY KEY
);

CREATE TABLE Seller (
	business_id 	    INT NOT NULL UNIQUE,
    username            VARCHAR(20) PRIMARY KEY
);

CREATE TABLE Admin (
    perm                TINYINT NOT NULL CHECK (perm IN (1, 2, 3)), # 3 muc do perm
    username            VARCHAR(20) PRIMARY KEY
);

CREATE TABLE Shop (
    business_id         INT UNIQUE PRIMARY KEY,
    name                VARCHAR(20) NOT NULL,
    address             VARCHAR(100) NOT NULL,
    join_time           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    business_type       ENUM('personal', 'business', 'family') NOT NULL,
    business_address    VARCHAR(100) NOT NULL,
    tax_number          INT NOT NULL # khac nhau tuy theo loai hinh kinh doanh (business_type)
);

CREATE TABLE Voucher (
    voucher_id          INT AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(20) NOT NULL,
    expired_date        DATETIME NOT NULL,
    max_usage           INT NOT NULL, # co ve se khong dung den dau
    decrease_type       ENUM('%', 'value'), # giam theo % hoac theo gia tri
    decrease_value      INT NOT NULL,
    min_buy_value       INT NOT NULL, # gia mua toi thieu
    max_decrease_value  INT NOT NULL, # giam toi da
    seller_usr          VARCHAR(20) # null neu la shopee tao
);

CREATE TABLE Comment (
    product_id          INT,
    seller_usr          VARCHAR(20),
    buyer_usr           VARCHAR(20),
    comment_id          INT AUTO_INCREMENT UNIQUE, # moi comment nen chi co 1 id duy nhat
    comment             TEXT,
    star                TINYINT NOT NULL CHECK (star IN (1, 2, 3, 4, 5)), # 1 den 5 sao
    attachment          TEXT,
    response            TEXT,
    PRIMARY KEY (product_id, comment_id)
);

CREATE TABLE Product (
    product_id          INT AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(20) NOT NULL,
    thumbnail           TEXT,
    info                TEXT,
    category            VARCHAR(20) NOT NULL,
    business_id         INT,
    admin_usr           VARCHAR(20),
    active              BOOL DEFAULT TRUE NOT NULL
);

CREATE TABLE Product_attachments (
    product_id          INT,
    link                VARCHAR(128), # vi khong de text dc
    PRIMARY KEY (product_id, link)
);

CREATE TABLE Variation (
    product_id          INT,
    variation_id        INT AUTO_INCREMENT UNIQUE, # moi bien the thi variation_id cua no cung unique
    state               Enum('Available', 'Out of stock') NOT NULL, # Con / het
    amount              INT NOT NULL,
    price               INT NOT NULL,
    attachment          TEXT,
    active              BOOL DEFAULT TRUE NOT NULL,
    PRIMARY KEY (product_id, variation_id)
);

CREATE TABLE Info_variation (
    product_id          INT,
    variation_id        INT UNIQUE,
    variation_type      VARCHAR(20),
    variation_value     VARCHAR(20),
    PRIMARY KEY (product_id, variation_id, variation_type, variation_value)
);

CREATE TABLE `Order` (
    order_id            INT AUTO_INCREMENT PRIMARY KEY,
    placed_date         DATETIME NOT NULL,
    shop_addr           VARCHAR(20), # dia chi lay hang
    delivery_addr       VARCHAR(100) NOT NULL,
    state_type          ENUM('waiting', 'accepted', 'transport', 'wait for delivery', 'finished', 'cancelled') NOT NULL,
    state_desc          TEXT,
    payment_method      ENUM('card', 'cash') NOT NULL, # hoac co the de la VARCHAR(20)
    buyer_usr           VARCHAR(20),
    delivery_id         INT,
    carrier_id          INT, # ma van don co the la null, chi khi dang van chuyen moi co
    estimate_time       DATETIME, # co the khong estimate duoc ?
    transfer_fee        INT NOT NULL,
    discount            INT NOT NULL # chiet khau cua san
);

CREATE TABLE Delivery (
    delivery_id         INT AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(20) NOT NULL,
    method              ENUM('normal', 'express') NOT NULL
);

CREATE TABLE Transaction (
    buyer_usr           VARCHAR(20),
    seller_usr          VARCHAR(20),
    order_id            INT,
    trans_id            INT AUTO_INCREMENT UNIQUE,
    reference_id        INT NOT NULL, # ma tham chieu giao dich
    timestamp           INT NOT NULL,
    PRIMARY KEY (buyer_usr, seller_usr, order_id, trans_id)
);

CREATE TABLE Cart (
    cart_id             INT AUTO_INCREMENT PRIMARY KEY,
    buyer_usr           VARCHAR(20),
    final_price         INT DEFAULT 0
);

CREATE TABLE Create_voucher (
    admin_usr           VARCHAR(20),
    voucher_id          INT,
    PRIMARY KEY (admin_usr, voucher_id)
);

CREATE TABLE Voucher_category (
    category            VARCHAR(20) NOT NULL,
    voucher_id          INT,
    PRIMARY KEY (category, voucher_id)
);

CREATE TABLE Use_voucher (
    amount              INT NOT NULL,
    seller_usr          VARCHAR(20),
    voucher_id          INT,
    PRIMARY KEY (seller_usr, voucher_id)
);

CREATE TABLE Report (
    seller_usr          VARCHAR(20),
    business_id         INT,
    timestamp           INT NOT NULL,
    verdict             Enum('Banned', 'Nothing', 'Pending') NOT NULL, # xu li, chan/khong lam gi/dang cho xu li
    `desc`                TEXT NOT NULL, # cai nay co the bo 'NOT NULL'
    PRIMARY KEY (seller_usr, business_id)
);

CREATE TABLE Ban_buyer (
    ban_id              INT UNIQUE, # this have to be unique right ?
    buyer_usr           VARCHAR(20),
    admin_usr           VARCHAR(20),
    reason              TEXT NOT NULL, # cai any co the bo 'NOT NULL' nhung ma chac la nen de do
    timestamp           INT NOT NULL,
    is_banned_verdict   BOOL NOT NULL,
    PRIMARY KEY (ban_id, buyer_usr, admin_usr)
);

CREATE TABLE Ban_seller (
    ban_id              INT UNIQUE, # this have to be unique right ?
    seller_usr          VARCHAR(20),
    admin_usr           VARCHAR(20),
    reason              TEXT NOT NULL, # cai any co the bo 'NOT NULL' nhung ma chac la nen de do
    timestamp           INT NOT NULL,
    is_banned_verdict   BOOL NOT NULL,
    PRIMARY KEY (ban_id, seller_usr, admin_usr)
);

CREATE TABLE Cart_has_variations (
    cart_id             INT,
    product_id          INT,
    variation_id        INT,
    amount              INT,
    PRIMARY KEY (cart_id, product_id, variation_id)
);

CREATE TABLE Apply_voucher (
    voucher_id          INT,
    order_id            INT,
    PRIMARY KEY (voucher_id, order_id)
);

CREATE TABLE Order_has_variations (
    product_id          INT,
    variation_id        INT,
    order_id            INT,
    amount              INT,
    PRIMARY KEY (product_id, variation_id, order_id)
);
