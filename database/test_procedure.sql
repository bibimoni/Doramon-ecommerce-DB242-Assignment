DROP PROCEDURE IF EXISTS Proc_Best_sale_from_date;
DROP PROCEDURE IF EXISTS Proc_get_variations_from_cart;
DELIMITER  //
CREATE PROCEDURE Proc_Best_sale_from_date(
    IN in_from DATETIME,
    IN in_bid INT
)
BEGIN
    SELECT p.product_id,
           p.name,
           SUM(ov.amount) as sales
    FROM Product p
             JOIN Variation v
                  ON v.product_id = p.product_id
             JOIN Order_has_variations ov
                  ON ov.product_id = v.product_id
                      AND ov.variation_id = v.variation_id
             JOIN `Order` o
                  ON o.order_id = ov.order_id
    WHERE p.business_id = 1
      AND o.state_type = 'finished'
      AND o.placed_date >= in_from
    GROUP BY p.product_id,
             p.name
    HAVING SUM(ov.amount) = (SELECT MAX(sales)
                             FROM (SELECT SUM(ov.amount) as sales
                                   FROM Product p
                                            JOIN Variation v
                                                 ON v.product_id = p.product_id
                                            JOIN Order_has_variations ov
                                                 ON ov.product_id = v.product_id
                                                     AND ov.variation_id = v.variation_id
                                            JOIN `Order` o
                                                 ON o.order_id = ov.order_id
                                   WHERE p.business_id = 1
                                     AND o.state_type = 'finished'
                                     AND o.placed_date >= in_from
                                   GROUP BY p.product_id,
                                            p.name) as sub)
    ORDER BY p.product_id;
END //
DELIMITER ;


CALL Proc_Best_sale_from_date('2025-05-01 09:00:00', 1);
CALL Proc_Best_sale_from_date('2025-04-20 10:15:00', 1);

SELECT * FROM `Order`;

SELECT p.product_id,
       p.name,
       SUM(ov.amount) as sales
FROM Product p
         JOIN Variation v
              ON v.product_id = p.product_id
         JOIN Order_has_variations ov
              ON ov.product_id = v.product_id
                  AND ov.variation_id = v.variation_id
         JOIN `Order` o
              ON o.order_id = ov.order_id
WHERE p.business_id = 1
  AND o.state_type = 'finished'
  AND o.placed_date >= '2025-04-20 10:15:00'
GROUP BY p.product_id,
         p.name;

-- ------------------------------------------

SELECT username FROM Buyer;
SELECT Variation.variation_id FROM Variation;

CALL Proc_get_variations_from_cart('BuyerX');

CALL Proc_update_cart_variation('BuyerX', 8, 2);

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

-- 1. Insert Products
INSERT INTO Product (name, thumbnail, info, category, business_id, admin_usr)
VALUES ('T-Shirt', 'tshirt.jpg', '100% cotton T‑shirt', 'Clothing', 1, 'adminUser1');
SET @prod1 := LAST_INSERT_ID();

INSERT INTO Product (name, thumbnail, info, category, business_id, admin_usr)
VALUES ('Sneakers', 'sneakers.jpg', 'Lightweight running shoes', 'Footwear', 1, 'adminJane');
SET @prod2 := LAST_INSERT_ID();

INSERT INTO Product (name, thumbnail, info, category, business_id, admin_usr)
VALUES     ('Backpack', 'backpack.jpg', 'Water‑resistant daypack, 20L', 'Accessories', 1, 'adminUser1');
SET @prod3 := LAST_INSERT_ID();


-- 2. Insert Variations for each Product
-- T-Shirt (product_id = 6)
INSERT INTO Variation (product_id, state, amount, price, attachment)
VALUES (@prod1, 'Available', 50, 200000, 'tshirt_blue.jpg');
SET @var1 := LAST_INSERT_ID();

INSERT INTO Variation (product_id, state, amount, price, attachment)
VALUES (@prod1, 'Available', 30, 200000, 'tshirt_red.jpg');
SET @var2 := LAST_INSERT_ID();

INSERT INTO Variation (product_id, state, amount, price, attachment)
VALUES (@prod1, 'Out of stock', 0, 200000, 'tshirt_green.jpg');
SET @var3 := LAST_INSERT_ID();

-- Sneakers (product_id = 7)
INSERT INTO Variation (product_id, state, amount, price, attachment)
VALUES (@prod2, 'Available', 20, 500000, 'sneakers_black.jpg');
SET @var4 := LAST_INSERT_ID();

INSERT INTO Variation (product_id, state, amount, price, attachment)
VALUES (@prod2, 'Available', 15, 500000, 'sneakers_white.jpg');
SET @var5 := LAST_INSERT_ID();

-- Backpack (product_id = 8)
INSERT INTO Variation (product_id, state, amount, price, attachment)
VALUES (@prod3, 'Available', 40, 350000, 'backpack_small.jpg');
SET @var6 := LAST_INSERT_ID();
INSERT INTO Variation (product_id, state, amount, price, attachment)
VALUES (@prod3, 'Available', 25, 400000, 'backpack_large.jpg');
SET @var7 := LAST_INSERT_ID();

SELECT *
FROM Variation;

-- 3. Insert Info_variation for each Variation
-- (Note: variation_id values will match auto‑generated IDs in the order inserted above)
INSERT INTO Info_variation (product_id, variation_id, variation_type, variation_value)
VALUES
    -- T-Shirt colors
    (@prod1, @var1, 'Color', 'Blue'),
    (@prod1, @var2, 'Color', 'Red'),
    (@prod1, @var3, 'Color', 'Green'),
    -- Sneakers colors
    (@prod2, @var4, 'Color', 'Black'),
    (@prod2, @var5, 'Color', 'White'),
    -- Backpack sizes
    (@prod3,@var6, 'Size', 'Small'),
    (@prod3,@var7,'Size', 'Large');

-- 4. Insert Product_attachments—at least one per product
INSERT INTO Product_attachments (product_id, link)
VALUES
    -- T-Shirt attachments
    (@prod1, 'https://cdn.example.com/products/tshirt/blue.jpg'),
    (@prod1, 'https://cdn.example.com/products/tshirt/red.jpg'),
    -- Sneakers attachments
    (@prod2, 'https://cdn.example.com/products/sneakers/black.jpg'),
    (@prod2, 'https://cdn.example.com/products/sneakers/white.jpg'),
    -- Backpack attachments
    (@prod3,'https://cdn.example.com/products/backpack/small.jpg'),
    (@prod3,'https://cdn.example.com/products/backpack/large.jpg');

INSERT INTO `Order`
(placed_date, shop_addr, delivery_addr, state_type, state_desc,
 payment_method, buyer_usr, delivery_id, carrier_id,
 estimate_time, transfer_fee, discount)
VALUES ('2025-04-20 10:15:00', '123 Nguyen Trai', '456 Le Loi, HCMC',
        'finished', 'Delivered successfully', 'cash', 'janeDoe',
        1, 201, '2025-04-22 15:00:00', 15000, 5000);
SET @ord1 := LAST_INSERT_ID();

-- 2. Insert Order for johnDoe123 and capture its order_id
INSERT INTO `Order`
(placed_date, shop_addr, delivery_addr, state_type, state_desc,
 payment_method, buyer_usr, delivery_id, carrier_id,
 estimate_time, transfer_fee, discount)
VALUES ('2025-04-25 14:30:00', '789 Tran Hung Dao', '10 Pasteur, HCMC',
        'finished', 'Delivered with no issues', 'card', 'johnDoe123',
        2, 202, '2025-04-27 18:00:00', 20000, 0);
SET @ord2 := LAST_INSERT_ID();

-- 3. Insert Order for user99 and capture its order_id
INSERT INTO `Order`
(placed_date, shop_addr, delivery_addr, state_type, state_desc,
 payment_method, buyer_usr, delivery_id, carrier_id,
 estimate_time, transfer_fee, discount)
VALUES ('2025-05-01 09:00:00', '55 Hai Ba Trung', '99 Nguyen Hue, HCMC',
        'finished', 'Customer received on time', 'cash', 'user99',
        3, 203, '2025-05-03 12:00:00', 18000, 2000);
SET @ord3 := LAST_INSERT_ID();

-- 4. Associate Variations to janeDoe’s Order (@order1)
INSERT INTO Order_has_variations (product_id, variation_id, order_id, amount)
VALUES (@prod1, @var3, @ord1, 2),
       (@prod1, @var1, @ord2, 1),
       (@prod1, @var2, @ord3, 3);

-- 5. Associate Variations to johnDoe123’s Order (@order2)
INSERT INTO Order_has_variations (product_id, variation_id, order_id, amount)
VALUES       (@prod2, @var4, @ord2, 1),
        (@prod2, @var4, @ord1, 1),
       (@prod2, @var5, @ord3, 1);

-- 6. Associate Variations to user99’s Order (@order3)
INSERT INTO Order_has_variations (product_id, variation_id, order_id, amount)
VALUES (@prod3,@var6, @ord1, 1),
       (@prod3,@var7,@ord1, 2),
       (@prod3,@var6, @ord3, 1),
       (@prod3,@var7,@ord3, 1);

