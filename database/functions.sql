USE shopee;

DROP FUNCTION IF EXISTS Func_Valid_name;
DROP FUNCTION IF EXISTS Exists_Admin;
DROP FUNCTION IF EXISTS Calculate_Total_Discount;

DELIMITER //
CREATE FUNCTION Func_Valid_name(s VARCHAR(255))
    RETURNS BOOLEAN
    DETERMINISTIC
BEGIN
    IF CHAR_LENGTH(s) <= 3 THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION Exists_Admin(in_admin_usr VARCHAR(20))
    RETURNS BOOLEAN
    DETERMINISTIC
BEGIN
    RETURN EXISTS (SELECT 1 FROM Admin WHERE username = in_admin_usr);
END //
DELIMITER ;


##########################################################
#### Function to calculate total discount of an order ####
##########################################################
DELIMITER //
CREATE FUNCTION Calculate_Total_Discount(orderID INT, orderTotal INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    IF orderID IS NULL OR orderID <= 0 THEN
        RETURN 0;
    END IF;

    IF orderTotal IS NULL OR orderTotal < 0 THEN
        RETURN 0;
    END IF;

    DECLARE totalDiscount INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE d_type ENUM('%', 'value');
    DECLARE d_value INT;
    DECLARE max_d_value INT;
    DECLARE done INT DEFAULT 0;

    DECLARE voucher_cursor CURSOR FOR
        SELECT v.voucher_id, v.decrease_type, v.decrease_value, v.max_decrease_value
        FROM Apply_voucher av
        JOIN voucher v ON av.voucher_id = v.voucher_id 
        WHERE av.order_id = orderID;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN voucher_cursor;
    read_loop: LOOP 
        FETCH voucher_cursor INTO v_id, d_type, d_value, max_d_value;
        IF done THEN 
            LEAVE read_loop;
        END IF;

        IF d_type = 'value' THEN
            SET totalDiscount = totalDiscount + LEAST(d_value, max_d_value);
        ELSEIF d_type = '%' THEN
            SET totalDiscount = totalDiscount + LEAST(ROUND(orderTotal * d_value / 100), max_d_value);
        END IF;
    END LOOP;

    CLOSE voucher_cursor;

    RETURN totalDiscount;
END //
DELIMITER ;