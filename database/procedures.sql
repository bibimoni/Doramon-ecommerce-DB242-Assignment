USE shopee;
DROP PROCEDURE IF EXISTS Proc_Insert_person;
DROP PROCEDURE IF EXISTS Proc_Insert_buyer;
DROP PROCEDURE IF EXISTS Proc_Insert_seller;
DROP PROCEDURE IF EXISTS Proc_Insert_admin;
DROP PROCEDURE IF EXISTS Proc_Insert_product;
DROP PROCEDURE IF EXISTS Proc_Sales_by_category;
DROP PROCEDURE IF EXISTS Proc_Best_sale_from_date;
DROP PROCEDURE IF EXISTS Proc_Unreviewed_product;

DELIMITER //
CREATE PROCEDURE Proc_Insert_person(
    IN in_username VARCHAR(20),
    IN in_hashed_password VARCHAR(64),
    IN in_email VARCHAR(20),
    IN in_birth_day DATE,
    IN in_phone_number VARCHAR(11),
    IN in_is_banned BOOL,
    IN in_avatar_link TEXT,
    IN in_gender ENUM ('m', 'f')
)
BEGIN
    IF in_username IS NULL OR LENGTH(in_username) < 3 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username cannot be NULL or has length smaller than 3';
    END IF;

    IF NOT in_username REGEXP '^[a-zA-Z0-9]+$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username has invalid format';
    END IF;

    IF EXISTS (SELECT 1
               FROM Person
               WHERE in_username = username) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username exists';
    END IF;

    IF NOT (in_hashed_password RLIKE '^[A-Fa-f0-9]{64}$') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid password hash format; must be 64 hex characters';
    END IF;

    iF in_is_banned IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'you must tell if the user is banned or not';
    END IF;

    IF in_email IS NOT NULL
        AND NOT (in_email RLIKE '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid email format';
    END IF;

    IF in_phone_number IS NOT NULL
        AND NOT (in_phone_number RLIKE '^[0-9]{10,11}$') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Phone must be 10 or 11 digits';
    END IF;

    INSERT INTO Person
    (username,
     email,
     phone_number,
     is_banned,
     avatar_link,
     gender,
     birth_day,
     hashed_password)
    VALUES (in_username,
            in_email,
            in_phone_number,
            in_is_banned,
            in_avatar_link,
            in_gender,
            in_birth_day,
            in_hashed_password);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Proc_Insert_buyer(
    IN in_username VARCHAR(20),
    IN hashed_password VARCHAR(64),
    IN email VARCHAR(20),
    IN birthday DATE,
    IN phone_number VARCHAR(11),
    IN is_banned BOOL,
    IN avatar_link TEXT,
    IN gender ENUM ('m', 'f'),
    IN in_coin INT
)
BEGIN
    CALL Proc_Insert_person(
            in_username,
            hashed_password,
            email,
            birthday,
            phone_number,
            is_banned,
            avatar_link,
            gender
         );
    IF in_coin IS NULL THEN
        SET in_coin = 0;
    END IF;
    INSERT INTO Buyer (coin, username)
    VALUES (in_coin, in_username);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Proc_Insert_seller(
    IN in_username VARCHAR(20),
    IN hashed_password VARCHAR(64),
    IN email VARCHAR(20),
    IN birthday DATE,
    IN phone_number VARCHAR(11),
    IN is_banned BOOL,
    IN avatar_link TEXT,
    IN gender ENUM ('m', 'f'),
    IN in_shop_name VARCHAR(20),
    IN in_addr VARCHAR(20),
    IN in_btype ENUM ('personal', 'business', 'family'),
    IN in_baddr VARCHAR(20),
    IN in_tax INT
)
BEGIN
    IF NOT Func_Valid_name(in_shop_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Shop name\'s is invalid';
    END IF;

    CALL Proc_Insert_person(
            in_username,
            hashed_password,
            email,
            birthday,
            phone_number,
            is_banned,
            avatar_link,
            gender
         );

    INSERT INTO Shop (name, address, business_type, business_address, tax_number)
    VALUES (in_shop_name,
            in_addr,
            in_btype,
            in_baddr,
            in_tax);

    INSERT INTO Seller (
#                         Seller.shop_name,
                        Seller.business_id,
                        Seller.username)
    VALUES (
#             in_shop_name,
            LAST_INSERT_ID()
               , in_username);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Proc_Insert_admin(
    IN in_username VARCHAR(20),
    IN hashed_password VARCHAR(64),
    IN email VARCHAR(20),
    IN birthday DATE,
    IN phone_number VARCHAR(11),
    IN is_banned BOOL,
    IN avatar_link TEXT,
    IN gender ENUM ('m', 'f'),
    IN in_perm INT
)
BEGIN
    CALL Proc_Insert_person(
            in_username,
            hashed_password,
            email,
            birthday,
            phone_number,
            is_banned,
            avatar_link,
            gender
         );

    INSERT INTO Admin (perm, username)
    VALUES (in_perm, in_username);
END //
DELIMITER ;

DELIMITER //
# insert product must have atleast 1 variation
CREATE PROCEDURE Proc_Insert_product(
    IN in_name VARCHAR(20),
    IN in_thumbnail TEXT,
    IN in_info TEXT,
    IN in_category VARCHAR(20),
    IN in_bid INT,
    IN in_admin VARCHAR(20)
)
BEGIN
    IF NOT Func_Valid_name(in_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid product name';
    END IF;

    INSERT INTO Product(name, thumbnail, info, category, business_id, admin_usr)
    VALUES (in_name,
            in_thumbnail,
            in_info,
            in_category,
            in_bid,
            in_admin);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Proc_Unreviewed_product()
BEGIN
    SELECT *
    FROM Product
    WHERE admin_usr IS NULL;
END //
DELIMITER ;

# Liet ke ra nhung don hang co chua sp
# thuoc 1 nganh hang va gia cua chung
# nhung chua tru di voucher va chiet khau
DELIMITER //
CREATE PROCEDURE Proc_Sales_by_category(
    IN in_category VARCHAR(20),
    IN in_year INT,
    IN in_bid INT
)
BEGIN
    SELECT ohv.order_id         AS order_id,
           per.username         AS buyer,
           p.name               AS product_name,
           ohv.amount * v.price AS total
    FROM Order_has_variations AS ohv
             JOIN Variation AS v ON ohv.variation_id = v.variation_id
             JOIN Product AS p ON p.category = ohv.product_id
             JOIN `Order` as o ON ohv.order_id = o.order_id
             JOIN Person as per ON o.buyer_usr = per.username
    WHERE p.product_id = in_category
      AND p.business_id = in_bid
      AND YEAR(placed_date) = in_year
      AND o.state_type = 'finished'
    ORDER BY ohv.order_id;
END //
DELIMITER ;

# tim san pham co doanh so cao nhat
# cua 1 shop tu 1 khoang thoi gian nao do
DELIMITER  //
CREATE PROCEDURE Proc_Best_sale_from_date(
    IN in_from DATETIME,
    IN in_bid INT
)
BEGIN
    SELECT p.product_id AS product_id,
           p.name       AS product_name
    FROM `Order` AS o
             JOIN Order_has_variations AS ohv ON o.order_id = ohv.order_id
             JOIN Product AS p ON p.product_id = ohv.product_id
             JOIN Variation AS v ON v.variation_id = ohv.variation_id
    WHERE p.product_id = in_bid
      AND o.placed_date >= in_from
      AND o.state_type = 'finished'
    HAVING SUM(ohv.amount) = (SELECT MAX(sales)
                              FROM (SELECT SUM(ohv.amount) as sales
                                    FROM `Order` AS o
                                             JOIN Order_has_variations AS ohv ON o.order_id = ohv.order_id
                                             JOIN Product AS p ON p.product_id = ohv.product_id
                                             JOIN Variation AS v ON v.variation_id = ohv.variation_id
                                    WHERE p.product_id = in_bid
                                      AND o.placed_date >= in_from
                                      AND o.state_type = 'finished') as sub);


END //
DELIMITER ;
