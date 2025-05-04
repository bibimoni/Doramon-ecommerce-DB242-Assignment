USE shopee;

DROP FUNCTION IF EXISTS Func_Valid_name;
DROP FUNCTION IF EXISTS Exists_Admin;
DROP FUNCTION IF EXISTS Calculate_Total_Discount;

##########################################################
################### Support functions ####################
##########################################################
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

##########################################################
### Function to calculate the average star of a product ##
##########################################################
DELIMITER //
CREATE FUNCTION Calculate_Avg_Star(p_id INT)
    RETURN DECIMAL(3, 2)
    DETERMINISTIC
BEGIN
    IF p_id IS NULL OR p_id <= 0 THEN
        RETURN 0.00
    END IF;

    DECLARE done INT DEFAULT 0;
    DECLARE star_value TYNYINT;
    DECLARE total INT DEFAULT 0;
    DECLARE count_rows INT DEFAULT 0;
    DECLARE avg_star DECIMAL(3, 2);

    DECLARE star_cursor CURSOR FOR
        SELECT star
        FROM Comment
        WHERE product_id = p_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN star_cursor;

    read_loop: LOOP
        FETCH star_cursor INTO star_value;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET total = total + star_value;
        SET count_rows = count_rows + 1;
    END LOOP;

    CLOSE star_cursor;

    IF count_rows = 0 THEN
        SET avg_star = 0.00;
    ELSE
        SET avg_star = total / count_rows;
    END IF;

    RETURN ROUND(avg_star, 2);
END //
DELIMITER ;