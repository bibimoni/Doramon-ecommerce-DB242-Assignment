USE shopee

SOURCE functions.sql;

DROP TRIGGER IF EXISTS Update_Final_Price;

DELIMITER //
CREATE TRIGGER Update_Final_Price
AFTER INSERT ON Order_has_variations
FOR EACH ROW
BEGIN
    DECLARE total_variation_price INT;
    DECLARE total_discount INT;

    SELECT SUM(v.price * ov.amount)
    INTO total_variation_price
    FROM Order_has_variations ov
    JOIN Variation v ON ov.variation_id = v.variation_id
    WHERE ov.order_id = NEW.order_id

    SET total_discount = Calculate_Total_Discount(NEW.order_id, total_variation_price)

    UPDATE `Order`
    SET final_price = total_variation_price - discount
    WHERE order_id = NEW.order_id;
END //
DELIMITER;