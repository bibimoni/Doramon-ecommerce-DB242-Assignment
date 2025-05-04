USE shopee;

DROP TRIGGER IF EXISTS Update_Final_Price_After_Add_Variation;
DROP TRIGGER IF EXISTS Update_Final_Price_After_Remove_Variation;
DROP TRIGGER IF EXISTS Update_Final_Price_After_Change_Quantity_Variation;
DROP TRIGGER IF EXISTS Create_Transaction;

##########################################################
#### Group triggers to update final_price of an order ####
##########################################################
DELIMITER //
CREATE TRIGGER Update_Final_Price_After_Add_Variation
AFTER INSERT ON Cart_has_variations
FOR EACH ROW
BEGIN
    DECLARE total_variation_price INT DEFAULT 0;

    SELECT IFNULL(SUM(v.price * cv.amount), 0)
    INTO total_variation_price
    FROM Cart_has_variations cv
    JOIN Variation v ON cv.variation_id = v.variation_id
    WHERE cv.cart_id = NEW.cart_id;

    UPDATE Cart
    SET final_price = total_variation_price
    WHERE cart_id = NEW.cart_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Update_Final_Price_After_Remove_Variation
AFTER DELETE ON Cart_has_variations
FOR EACH ROW
BEGIN
    DECLARE total_variation_price INT DEFAULT 0;

    SELECT IFNULL(SUM(v.price * cv.amount), 0)
    INTO total_variation_price
    FROM Cart_has_variations cv
    JOIN Variation v ON cv.variation_id = v.variation_id
    WHERE cv.cart_id = OLD.cart_id;

    UPDATE Cart
    SET final_price = total_variation_price
    WHERE cart_id = OLD.cart_id;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER Update_Final_Price_After_Change_Quantity_Variation
AFTER UPDATE ON Cart_has_variations
FOR EACH ROW
BEGIN
    DECLARE total_variation_price INT DEFAULT 0;

    SELECT IFNULL(SUM(v.price * cv.amount), 0)
    INTO total_variation_price
    FROM Cart_has_variations cv
    JOIN Variation v ON cv.variation_id = v.variation_id
    WHERE cv.cart_id = NEW.cart_id;

    UPDATE Cart
    SET final_price = total_variation_price
    WHERE cart_id = NEW.cart_id;
END //
DELIMITER ;

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