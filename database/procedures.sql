USE shopee;

DROP PROCEDURE IF EXISTS Proc_Insert_person;
DROP PROCEDURE IF EXISTS Proc_Insert_buyer;
DROP PROCEDURE IF EXISTS Proc_Insert_seller;
DROP PROCEDURE IF EXISTS Proc_Insert_admin;
DROP PROCEDURE IF EXISTS Proc_Sales_by_category;
DROP PROCEDURE IF EXISTS Proc_Best_sale_from_date;
DROP PROCEDURE IF EXISTS Proc_Unreviewed_product;
DROP PROCEDURE IF EXISTS Proc_update_cart_variation;
DROP PROCEDURE IF EXISTS Proc_get_variations_from_cart;
DROP PROCEDURE IF EXISTS Proc_tobe_reviewed_product;
DROP PROCEDURE IF EXISTS Proc_get_all_products;
DROP PROCEDURE IF EXISTS Proc_review_product;

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
    IF EXISTS (SELECT 1
               FROM Buyer
               WHERE in_username = username) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username exists';
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
    IF in_coin IS NULL THEN
        SET in_coin = 0;
    END IF;
    INSERT INTO Buyer (coin, username)
    VALUES (in_coin, in_username);
    INSERT INTO Cart(buyer_usr)
    VALUES (in_username);
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
    IN in_business_id INT,
    IN in_shop_name VARCHAR(20),
    IN in_addr VARCHAR(100),
    IN in_btype ENUM ('personal', 'business', 'family'),
    IN in_baddr VARCHAR(100),
    IN in_tax INT
)
BEGIN
    IF NOT Func_Valid_name(in_shop_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Shop name\'s is invalid';
    END IF;

    IF EXISTS (SELECT 1
               FROM Seller
               WHERE in_username = username) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username exists';
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

    INSERT INTO Shop (business_id ,name, address, business_type, business_address, tax_number)
    VALUES (
            in_business_id,
            in_shop_name,
            in_addr,
            in_btype,
            in_baddr,
            in_tax);

    INSERT INTO Seller (
        Seller.business_id,
        Seller.username)
    VALUES (
#             in_shop_name,
             in_business_id
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
    IF EXISTS (SELECT 1
               FROM Admin
               WHERE in_username = username) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username exists';
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

    INSERT INTO Admin (perm, username)
    VALUES (in_perm, in_username);
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
             JOIN Variation AS v ON ohv.variation_id = v.variation_id AND v.active = TRUE
             JOIN Product AS p ON p.category = ohv.product_id AND p.active = TRUE
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
             JOIN Product AS p ON p.product_id = ohv.product_id AND p.active = TRUE
             JOIN Variation AS v ON v.variation_id = ohv.variation_id AND v.active = TRUE
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

DELIMITER //
CREATE PROCEDURE Proc_tobe_reviewed_product()
BEGIN
    SELECT *
    FROM Product p
    WHERE admin_usr IS NULL
      AND EXISTS (
        SELECT *
        FROM Variation v
        WHERE v.product_id = p.product_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Proc_review_product(
    IN in_username VARCHAR(20),
    IN in_pid INT
)
BEGIN
    IF Exists_Admin(in_username) THEN
        UPDATE Product
        SET admin_usr = in_username
        WHERE product_id = in_pid;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'admin username doesn\'t exists';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Proc_update_cart_variation(
    IN in_buyer_usr VARCHAR(20),
    IN in_variation_id INT,
    IN in_amount INT
)
BEGIN
    DECLARE v_product_id INT;
    DECLARE v_active BOOL;
    DECLARE v_cart_id INT;

    SELECT p.product_id, p.active
    INTO v_product_id, v_active
    FROM Variation AS v
             JOIN Product AS p ON p.product_id = v.product_id
    WHERE variation_id = in_variation_id
      AND v.active = TRUE
    LIMIT 1;

    SELECT c.cart_id INTO v_cart_id
    FROM Cart c
    WHERE c.buyer_usr = in_buyer_usr
    LIMIT 1;

    IF v_product_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'variation_id not found or variation inactive';
    ELSEIF v_cart_id IS NULL THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'buyer_username not found';
    ELSEIF v_active = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Parent product is inactive';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Cart_has_variations
        WHERE cart_id = v_cart_id AND variation_id = in_variation_id
    )
    THEN
        UPDATE Cart_has_variations
        SET amount = in_amount
        WHERE cart_id = v_cart_id
          AND variation_id = in_variation_id
          AND product_id = v_product_id;
    ELSE
        INSERT INTO Cart_has_variations(cart_id, product_id, variation_id, amount)
        VALUES (v_cart_id, v_product_id, in_variation_id, in_amount);
    END IF;

    DELETE FROM Cart_has_variations
    WHERE amount <= 0;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Proc_get_variations_from_cart(
    IN username VARCHAR(20)
)
BEGIN
    SELECT
        v.product_id,
        v.variation_id,
        v.state,
        v.amount as variation_amount,
        v.price,
        v.attachment,
        cv.amount as cart_amount
    FROM Variation v
    JOIN Cart_has_variations cv ON cv.variation_id = v.variation_id
    WHERE cv.cart_id IN (
        SELECT c.cart_id FROM Cart c
                         WHERE buyer_usr = username
        );
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Proc_get_all_products()
BEGIN
    SELECT
        p.product_id,
        p.name,
        p.thumbnail,
        p.info,
        p.category,
        p.business_id,
        MIN(v.price) as min_price,
        MAX(v.price) as max_price
    FROM
        Product AS p
    JOIN Variation AS v ON v.product_id = p.product_id
    WHERE
        p.active = TRUE
      AND v.active = TRUE
      AND p.admin_usr IS NOT NULL
    GROUP BY
        p.product_id,
        p.name;
END //
DELIMITER ;