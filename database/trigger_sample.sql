use shopee;

UPDATE `Order` SET state_type = 'waiting';
SELECT * FROM `Order` WHERE state_type = 'waiting';
SELECT * FROM Transaction;
UPDATE `Order` SET state_type = 'accepted' WHERE order_id = 1;
SELECT * FROM Transaction;

-- lay gio hang
SELECT b.username, v.variation_id, cv.amount, v.price
FROM Buyer b
    JOIN Cart c ON c.buyer_usr = b.username
    JOIN Cart_has_variations cv ON cv.cart_id = c.cart_id
    JOIN Variation v ON v.variation_id = cv.variation_id
WHERE username = 'buyerX';

-- lay final price
SELECT Cart.final_price FROM Cart JOIN Buyer b ON Cart.buyer_usr = b.username WHERE b.username = 'buyerX';

-- add
CALL Proc_update_cart_variation('buyerX', 10, 100);

-- update
CALL Proc_update_cart_variation('buyerX', 10, 1);

-- delete
DELETE FROM Cart_has_variations WHERE cart_id = 4 AND variation_id = 8;

