DELIMITER //
CREATE PROCEDURE Test_function(
    IN in_oid INT
)
BEGIN
   DECLARE v_total_price INT;

   SELECT SUM(v.price)
   INTO v_total_price
    FROM `Order` o
    JOIN Order_has_variations ohv ON ohv.order_id = o.order_id
    JOIN Variation v ON v.variation_id = ohv.variation_id
    WHERE o.order_id = in_oid
    LIMIT 1;

   SELECT v_total_price;
   SELECT Calculate_Total_Discount(in_oid, v_total_price);

END //
DELIMITER ;

SELECT * FROM Voucher;

INSERT INTO Apply_voucher (voucher_id, order_id) VALUES
  -- Order 1 (johnDoe123)
  (1, 1),
  (3, 1),
  -- Order 2 (janeDoe)
  (5, 2),
  -- Order 3 (buyerX)
  (8, 3),
#   Order 4 (user99)
  (3, 4),
  -- Order 5 (buyerX)
  (6, 5);

SELECT o.order_id, o.discount, SUM(vv.price), v.decrease_type, v.decrease_value, v.max_decrease_value, v.min_buy_value
FROM `Order` o
    JOIN Order_has_variations ohv ON o.order_id = ohv.order_id
    JOIN Variation vv ON vv.variation_id = ohv.variation_id
    JOIN Apply_voucher av ON o.order_id = av.order_id
    JOIN Voucher v ON v.voucher_id = av.voucher_id
GROUP BY o.order_id, v.decrease_type, v.decrease_value, v.max_decrease_value, v.min_buy_value;

CALL Test_function(1);