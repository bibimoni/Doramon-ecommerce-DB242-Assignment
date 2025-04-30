DROP TRIGGER IF EXISTS after_cart_update;

DELIMITER //
CREATE TRIGGER after_cart_update
BEFORE UPDATE ON Cart_has_variations
FOR EACH ROW
BEGIN
    DELETE FROM Cart_has_variations
    WHERE amount <= 0;
END //
DELIMITER ;