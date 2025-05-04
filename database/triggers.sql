USE shopee

SOURCE functions.sql;

DROP TRIGGER IF EXISTS Update_Final_Price;
DROP TRIGGER IF EXISTS Create_Transaction;

##########################################################
#### Group triggers to update final_price of an order ####
##########################################################
DELIMITER //
CREATE TRIGGER Update_Final_Price_After_Add_Variation
AFTER INSERT ON Order_has_variations
FOR EACH ROW
BEGIN
    DECLARE total_variation_price INT DEFAULT 0;
    DECLARE total_discount INT DEFAULT 0;

    SELECT IFNULL(SUM(v.price * ov.amount), 0)
    INTO total_variation_price
    FROM Order_has_variations ov
    JOIN Variation v ON ov.variation_id = v.variation_id
    WHERE ov.order_id = NEW.order_id;

    SET total_discount = Calculate_Total_Discount(NEW.order_id, total_variation_price);

    UPDATE `Order`
    SET final_price = total_variation_price - total_discountdiscount
    WHERE order_id = NEW.order_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Update_Final_Price_After_Remove_Variation
AFTER DELETE ON Order_has_variations
FOR EACH ROW
BEGIN
    DECLARE total_variation_price INT DEFAULT 0;
    DECLARE total_discount INT DEFAULT 0;

    SELECT IFNULL(SUM(v.price * ov.amount), 0)
    INTO total_variation_price
    FROM Order_has_variations ov
    JOIN Variation v ON ov.variation_id = v.variation_id
    WHERE ov.order_id = OLD.order_id;

    SET total_discount = Calculate_Total_Discount(OLD.order_id, total_variation_price);

    UPDATE `Order`
    SET final_price = total_variation_price - total_discount
    WHERE order_id = OLD.order_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Update_Final_Price_After_Apply_Voucher
AFTER INSERT ON Apply_voucher
FOR EACH ROW
BEGIN 
    DECLARE total_variation_price INT DEFAULT 0;
    DECLARE total_discount INT DEFAULT 0;

    SELECT IFNULL(SUM(v.price * ov.amount), 0)
    INTO total_variation_price
    FROM Order_has_variations ov
    JOIN Variation v ON ov.variation_id = v.variation_id
    WHERE ov.order_id = NEW.order_id;

    SET total_discount = Calculate_Total_Discount(NEW.order_id, total_variation_price);

    UPDATE `Order`
    SET discount = total_discount,
        final_price = total_variation_price - total_discount
    WHERE order_id = NEW.order_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Update_Final_Price_After_Remove_Voucher
AFTER DELETE ON Apply_voucher
FOR EACH ROW
BEGIN 
    DECLARE total_variation_price INT DEFAULT 0;
    DECLARE total_discount INT DEFAULT 0;

    SELECT IFNULL(SUM(v.price * ov.amount), 0)
    INTO total_variation_price
    FROM Order_has_variations ov
    JOIN Variation v ON ov.variation_id = v.variation_id
    WHERE ov.order_id = OLD.order_id;

    SET total_discount = Calculate_Total_Discount(OLD.order_id, total_variation_price);

    PDATE `Order`
    SET discount = total_discount,
        final_price = total_variation_price - total_discount
    WHERE order_id = OLD.order_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Update_Final_Price_After_Change_Quantity_Variation
AFTER UPDATE ON Order_has_variations
FOR EACH ROW
BEGIN 
    IF OLD.amount != NEW.amount THEN
        DECLARE total_variation_price INT DEFAULT 0;
        DECLARE total_discount INT DEFAULT 0;

        SELECT IFNULL(SUM(v.price * ov.amount), 0)
        INTO total_variation_price
        FROM Order_has_variations ov
        JOIN Variation v ON ov.variation_id = v.variation_id
        WHERE ov.order_id = NEW.order_id;

        SET total_discount = Calculate_Total_Discount(NEW.order_id, total_variation_price);

        UPDATE `Order`
        SET discount = total_discount,
            final_price = total_variation_price - total_discount
        WHERE order_id = NEW.order_id;
    END IF;
END //

##########################################################
##### Trigger to automatically create a transaction ######
##########################################################
DELIMITER //
CREATE TRIGGER Create_Transaction
AFTER UPDATE ON `Order`
FOR EACH ROW
BEGIN 
    IF NEW.state_type = 'accepted' AND OLD.state_type = 'waiting' THEN
        INSERT INTO Transaction (
            buyer_usr,
            seller_usr,
            order_id,
            reference_id,
            timestamp
        )
        VALUES (
            NEW.buyer_usr,
            (
                SELECT s.username FROM Product p
                JOIN Variation v ON p.product_id = v.product_id
                JOIN Order_has_variations ohv ON v.variation_id = ohv.variation_id
                JOIN Seller s ON p.business_id = s.business_id
                WHERE ohv.order_id = NEW.order_id LIMIT 1
            ),
            NEW.order_id,
            FLOOR(RAND() * 1000000),  -- simple random reference ID
            UNIX_TIMESTAMP()
        );
    END IF;
END //
DELIMITER ;