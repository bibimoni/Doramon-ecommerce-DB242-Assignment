USE shopee;

# CALL Proc_Insert_buyer(
#         'alice123',
#         '0b30c75f8ccc8abbc47af5194c50bd612773cc14b7f8991799ca9d26bb8a5344', -- MD5 for 'password'
#         'alice@example.com',
#         '1995-06-15',
#         '09123456789',
#         FALSE,
#         'https://example.com/avatars/alice.jpg',
#         'f',
#         null -- vi du ve viec no auto bang 0
#      );
# CALL Proc_Insert_buyer(
#         'bobhebuyer',
#         '201ebe6f0dffda47fc610ba53693f22b5ce0ba7a0187372fb40a2d9d92830fca', -- MD5 for 'abc123'
#         'bob@example.net',
#         '1988-03-22',
#         '09876543210',
#         TRUE,
#         'https://example.com/avatars/bob.png',
#         'm',
#         250
#      );
# CALL Proc_Insert_buyer(
#         'charlie789',
#         '05431781f1f9404d2ee81a9111a0bc6aaa54bb303c97fe85fc9dfa743c98da18', -- MD5 for 'qwerty'
#         'charlie@shop.org',
#         '2000-11-30',
#         '09012345678',
#         FALSE,
#         'https://example.com/avatars/charlie.gif',
#         'm',
#         500
#      );

-- Xem buyer
SELECT *
FROM Person p
         JOIN buyer b ON p.username = b.username
         JOIN Cart c ON c.buyer_usr = b.username
ORDER BY p.username;

# CALL Proc_Insert_seller(
#         'jane',
#         '0097728063561277a24daa61dba6bbc17ba2120b5696666d71a7c8fcc536a2de', -- hashed 'password'
#         'jane@market.com',
#         '1992-07-21',
#         '09012345678',
#         FALSE,
#         'https://example.com/avatars/jane.png',
#         'f',
#         101,
#         'JaneStore',
#         '123 Main St',
#         'personal',
#         '456 Market Rd',
#         123456789
#      );
#
# CALL Proc_Insert_seller(
#         'bob',
#         '66ff6f42c50fb134447d7c409454779055ddc69b5bdf82aa8a38c00d54e6b153', -- hashed 'test'
#         'bob@techhub.com',
#         '1985-02-11',
#         '09123456789',
#         FALSE,
#         'https://example.com/avatars/bob.jpg',
#         'm',
#         102,
#         'TechBob',
#         '789 Tech Park',
#         'business',
#         '101 Silicon Ave',
#         987654321
#      );
#
# CALL Proc_Insert_seller(
#         'sara',
#         '456128ce56d37ba0ade3834c4738f5cd6b2d5ea9be38d5306cc11470256e6a0f', -- hashed 'family123'
#         'sara@familyshop.com',
#         '1990-12-05',
#         '09345678901',
#         FALSE,
#         'https://example.com/avatars/sara.jpeg',
#         'f',
#         103,
#         'FamilyMart',
#         '12 Cozy Ln',
#         'family',
#         '34 Community Rd',
#         456789012
#      );

SELECT *
FROM Person p
         JOIN Seller s ON s.username = p.username
         JOIN Shop sh ON sh.business_id = s.business_id
ORDER BY p.username;

# CALL Proc_Insert_person(
#         'johnDoe123',
#         'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', -- SHA-256 of "password123"
#         'john@example.com',
#         '1990-05-20',
#         '0123456789',
#         FALSE,
#         'https://example.com/avatar/john.png',
#         'm'
#      );

SELECT *
FROM Person p
WHERE username = 'johnDoe123';
#
# CALL Proc_Insert_admin(
#         'adminUser1',
#         'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', -- password123
#         'admin1@example.com',
#         '1985-04-10',
#         '0987654321',
#         FALSE,
#         'https://example.com/avatar/admin1.png',
#         'm',
#         1 -- permission level
#      );
#
# CALL Proc_Insert_admin(
#         'adminJane',
#         'bcb4efbddba33d2522fbb18aa50d050a0d7eb4193e3462bc6c3db551b96f61ef', -- securepass
#         NULL,
#         '1992-03-21',
#         NULL,
#         FALSE,
#         NULL,
#         'f',
#         2
#      );

SELECT *
FROM Person p
         JOIN Admin ad ON ad.username = p.username
WHERE p.username = 'adminJane'



SELECT * FROM Person;
SELECT * FROM Buyer;
SELECT * FROM Seller;
SELECT * FROM Admin;

SELECT * FROM Cart;
SELECT * FROM Cart_has_variations;

SELECT * FROM Shop;
SELECT * FROM Product;
SELECT * FROM Variation;

SELECT * FROM Banking_account;
SELECT * FROM Social;
SELECT * FROM Address;

SELECT * FROM `Order`;
SELECT * FROM Order_has_variations;

SELECT * FROM Product_attachments;
SELECT * FROM Info_variation;

SELECT * FROM Delivery;

SELECT * FROM Transaction;

SELECT * FROM Voucher;
SELECT * FROM Voucher_category;
SELECT * FROM Apply_voucher;
#
# INSERT INTO Address (username, address) VALUES
#   ('johnDoe123', '101 Nguyen Trai, Hanoi'),
#   ('johnDoe123', '12 Tran Phu, Hanoi'),
#
#   ('janeDoe',     '200 Hai Ba Trung, HCMC'),
#   ('janeDoe',     '45 Le Loi, HCMC'),
#
#   ('user99',      '23 Xuan Thuy, Hanoi'),
#
#   ('buyerX',      '11 Ton Duc Thang, Hue');
#
# -- Banking accounts
# INSERT INTO Banking_account (username, bank_name, bank_number, bank_type) VALUES
#   ('johnDoe123', 'Vietcombank',   '9704361234567890', 'debit'),
#   ('janeDoe',    'Techcombank',   '9704129876543210', 'credit'),
#   ('user99',     'MB Bank',       '9704012345678901', 'debit'),
#   ('buyerX',     'ACB',           '9704234567890123', 'debit');
#
# -- Social links
# INSERT INTO Social (username, link) VALUES
#   ('johnDoe123', 'https://facebook.com/john.doe123'),
#   ('janeDoe',    'https://instagram.com/jane.doe'),
#   ('user99',     'https://twitter.com/user99'),
#   ('buyerX',     'https://tiktok.com/@buyerX');
#
# INSERT INTO Voucher
#   (name, expired_date, max_usage, decrease_type, decrease_value, min_buy_value, max_decrease_value, seller_usr, admin_usr)
# VALUES
#   ('PLAT10OFF',   '2025-12-31 23:59:59', 10000, '%',   10, 200000, 50000, NULL,      'adminJane'),
#   ('PLAT20OFF',   '2025-10-31 23:59:59',  5000, '%',   20, 300000, 80000, NULL,      'adminUser1'),
#   ('PLAT50K',     '2025-11-30 23:59:59',  8000, 'value',50000,100000, 50000, NULL,   'adminUser1');
#
# INSERT INTO Voucher
#   (name, expired_date, max_usage, decrease_type, decrease_value, min_buy_value, max_decrease_value, seller_usr)
# VALUES
#   ('TECH100K',    '2025-11-30 23:59:59',  1000, 'value',100000,500000,100000,'seller1'),
#   ('FASHION50',   '2025-09-30 23:59:59',  1500, 'value',50000, 200000, 50000, 'seller2'),
#   ('HOME5PCT',    '2025-10-15 23:59:59',  1200, '%',    5,   100000, 30000, 'seller3'),
#   ('BOOK25PCT',   '2025-12-31 23:59:59',  2000, '%',   25,   150000, 60000, 'seller4'),
#   ('PET30OFF',    '2025-08-31 23:59:59',  500,  'value',30000,100000,30000, 'seller5');
#
# INSERT INTO Voucher_category (category, voucher_id) VALUES
#   ('platform',  '1'),
#   ('platform',  '2'),
#   ('platform',  '3'),
#   ('electronics','4'),
#   ('fashion',   '5'),
#   ('home',      '6'),
#   ('books',     '7'),
#   ('pets',      '8');
#
# INSERT INTO Apply_voucher (voucher_id, order_id) VALUES
#   -- Order 1 (johnDoe123)
#   (1, 1),
#   -- Order 2 (janeDoe)
#   (5, 2),
#   -- Order 3 (buyerX)
#   (8, 3),
#   -- Order 4 (user99)
#   (3, 4),
#   -- Order 5 (buyerX)
#   (6, 5);