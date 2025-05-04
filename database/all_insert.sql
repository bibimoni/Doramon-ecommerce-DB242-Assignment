CALL Proc_Insert_buyer(
    'johnDoe123',
    'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',  -- password123 (SHA-256)
    'john@example.com',
    '1990-05-20',
    '0123456789',
    FALSE,
    'https://example.com/avatar/john.png',
    'm',
     0
);

CALL Proc_Insert_buyer(
    'janeDoe',
    'bcb4efbddba33d2522fbb18aa50d050a0d7eb4193e3462bc6c3db551b96f61ef',  -- securepass
    'jane@example.com',
    '1995-07-15',
    '0987654321',
    FALSE,
    'https://example.com/avatar/jane.png',
    'f',
     0
);

CALL Proc_Insert_buyer(
    'user99',
    '32fcd1737b898b6a5be57ab2ee4bfe78d415ec7ef5a418053e3c4b8db3f297e7',  -- userpass
    'user99@example.com',
    '1992-03-12',
    '0909090909',
    FALSE,
    NULL,
    'm',
     0
);

CALL Proc_Insert_buyer(
    'buyerX',
    '1c552d75a91c69d3ef8367d8f19641f8d3ae7b9b34e1b876dd38e1e9a9f4f2e2',  -- buyerpass
    'buyerx@example.com',
    '2000-12-01',
    NULL,
    FALSE,
    NULL,
    'f',
     0
);

-- Seller 1: Tech Gadgets shop
CALL Proc_Insert_seller(
    'seller1',
    '3c7a1e4f8d8d8d2607e290a809dabbb72a4c550cdce4a9f7f7c6b16f6b153e64',  -- sha256("seller1pass")
    'seller1@techgadgets.com',
    '1988-02-14',
    '0912345678',
    FALSE,
    'https://example.com/avatar/seller1.png',
    'm',
    1,                            -- business_id
    'Tech Gadgets',               -- shop_name
    '12 Tran Phu, Hanoi',         -- shop address
    'business',                   -- business_type
    '12 Tran Phu, Hanoi',         -- business_address
    123456789                     -- tax_number
);

-- Seller 2: Fashion World shop
CALL Proc_Insert_seller(
    'seller2',
    '5b8a2f3c7f1d4e3a6b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a',  -- sha256("seller2pass")
    'seller2@fashionworld.vn',
    '1990-06-21',
    '0987654321',
    FALSE,
    'https://example.com/avatar/seller2.png',
    'f',
    2,
    'Fashion World',
    '45 Le Loi, HCMC',
    'personal',
    '45 Le Loi, HCMC',
    987654321
);

-- Seller 3: Home Needs shop
CALL Proc_Insert_seller(
    'seller3',
    '8f1c2d3e4a5b6c7d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d',  -- sha256("seller3pass")
    'seller3@homeneeds.com',
    '1985-11-05',
    '0901122334',
    FALSE,
    NULL,
    'm',
    3,
    'Home Needs',
    '7 Nguyen Hue, Da Nang',
    'family',
    '7 Nguyen Hue, Da Nang',
    192837465
);

-- Seller 4: Book Hub shop
CALL Proc_Insert_seller(
    'seller4',
    '1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b',  -- sha256("seller4pass")
    'seller4@bookhub.vn',
    '1992-09-17',
    '0911223344',
    FALSE,
    'https://example.com/avatar/seller4.png',
    'f',
    4,
    'Book Hub',
    '23 Pham Ngu Lao, Hanoi',
    'business',
    '23 Pham Ngu Lao, Hanoi',
    564738291
);

-- Seller 5: Pet Store shop
CALL Proc_Insert_seller(
    'seller5',
    '2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c',  -- sha256("seller5pass")
    'seller5@petstore.vn',
    '1993-03-03',
    '0933445566',
    FALSE,
    NULL,
    'm',
    5,
    'Pet Store',
    '81 Pasteur, Hue',
    'business',
    '81 Pasteur, Hue',
    102938475
);

CALL Proc_Insert_admin(
    'adminUser1',
    'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',  -- password123
    'admin1@example.com',
    '1985-04-10',
    '0987654321',
    FALSE,
    'https://example.com/avatar/admin1.png',
    'm',
    1  -- permission level
);

CALL Proc_Insert_admin(
    'adminJane',
    'bcb4efbddba33d2522fbb18aa50d050a0d7eb4193e3462bc6c3db551b96f61ef',  -- securepass
    NULL,
    '1992-03-21',
    NULL,
    FALSE,
    NULL,
    'f',
    2
);

INSERT INTO Product (name, thumbnail, info, category, business_id, admin_usr) VALUES
  ('Bluetooth Speaker',     'https://example.com/img/speaker.jpg',      'Portable, 10W output',      'Electronics', 1, 'adminUser1'),
  ('Summer Dress',          'https://example.com/img/dress.jpg',        'Light cotton, size M',      'Clothing',    2, 'adminUser1'),
  ('Rice Cooker 1.8L',      'https://example.com/img/ricecooker.jpg',   'Non‑stick inner pot',       'Home',        3, 'adminUser1'),
  ('Lined Notebook',        'https://example.com/img/notebook.jpg',     '200 pages, A5 size',        'Stationery',  4, 'adminUser1'),
  ('Dog Leash 1.5m',        'https://example.com/img/leash.jpg',        'Nylon, reflective stitching','Pets',        5, 'adminUser1');

INSERT INTO Variation (product_id, state, amount, price, attachment) VALUES
  (1, 'Available',     25,  450000, 'https://example.com/img/speaker-side.jpg'),
  (2, 'Available',     10,  299000, 'https://example.com/img/dress-detail.jpg'),
  (3, 'Out of stock',   0,  790000, NULL),
  (4, 'Available',    150,   18000, 'https://example.com/img/notebook-open.jpg'),
  (5, 'Available',     75,  115000, 'https://example.com/img/leash-detail.jpg');

INSERT INTO Info_variation (product_id, variation_id, variation_type, variation_value) VALUES
  (1, 1, 'Color',        'Black'),
  (2, 2, 'Size',         'M'),
  (3, 3, 'Capacity',     '1.8L'),
  (4, 4, 'Page Type',    'Lined'),
  (5, 5, 'Length',       '1.5m');

INSERT INTO Product_attachments (product_id, link) VALUES
  (1, 'https://example.com/img/speaker-front.jpg'),
  (1, 'https://example.com/img/speaker-back.jpg'),
  (2, 'https://example.com/img/dress-back.jpg'),
  (3, 'https://example.com/img/ricecooker-inside.jpg'),
  (4, 'https://example.com/img/notebook-cover.jpg'),
  (5, 'https://example.com/img/leash-clip.jpg');

INSERT INTO Delivery (name, method) VALUES
('GiaoHangNhanh', 'normal'),    -- delivery_id = 1
('J&T Express', 'express'),     -- delivery_id = 2
('VNPost', 'normal'),           -- delivery_id = 3
('GHN', 'express'),             -- delivery_id = 4
('Shopee Xpress', 'express');   -- delivery_id = 5

INSERT INTO `Order` (
    placed_date, shop_addr, delivery_addr, state_type, state_desc,
    payment_method, buyer_usr, delivery_id, carrier_id,
    estimate_time, transfer_fee, discount
) VALUES
(NOW(), '12 Tran Phu', '101 Nguyen Trai, Hanoi', 'waiting', 'Order placed, pending approval',
 'cash', 'johnDoe123', 1, NULL, NULL, 30000, 0),

(NOW() - INTERVAL 2 DAY, '45 Le Loi', '200 Hai Ba Trung, HCMC', 'transport', 'In transit to destination',
 'card', 'janeDoe', 2, 1001, NOW() + INTERVAL 1 DAY, 25000, 5000),

(NOW() - INTERVAL 5 DAY, '7 Nguyen Hue', '789 Dinh Tien Hoang, Da Nang', 'finished', 'Delivered and confirmed by customer',
 'card', 'buyerX', 3, 1002, NOW() - INTERVAL 2 DAY, 40000, 10000),

(NOW() - INTERVAL 1 DAY, '23 Pham Ngu Lao', '23 Xuan Thuy, Hanoi', 'cancelled', 'Buyer cancelled due to late delivery',
 'cash', 'user99', 4, NULL, NULL, 20000, 0),

(NOW() - INTERVAL 3 DAY, '81 Pasteur', '11 Ton Duc Thang, Hue', 'wait for delivery', 'Awaiting final delivery step',
 'card', 'buyerX', 5, 1003, NOW() + INTERVAL 5 HOUR, 35000, 2000);

SELECT * FROM `Order`;

INSERT INTO Order_has_variations (product_id, variation_id, order_id, amount) VALUES
  (1, 1, 1, 1),  -- johnDoe123 ordered 1 Bluetooth Speaker
  (2, 2, 2, 2),  -- janeDoe ordered 2 Summer Dresses
  (3, 3, 3, 1),  -- buyerX ordered 1 Rice Cooker
  (4, 4, 4, 5),  -- user99 ordered 5 Notebooks
  (5, 5, 5, 1);  -- buyerX ordered 1 Dog Leash

INSERT INTO Cart_has_variations (cart_id, product_id, variation_id, amount) VALUES
  -- Cart #1 johnDoe123
  (1, 1, 1, 2), -- 450000
  (1, 2, 2, 1), -- 299000

  -- Cart #3 user99
  (3, 3, 3, 3), -- 790000
  (3, 4, 4, 2), -- 18000
  (3, 5, 5, 1), -- 115000

  -- Cart #4 buyerX
  (4, 5, 5, 100); -- 115000


INSERT INTO Address (username, address) VALUES
  ('johnDoe123', '101 Nguyen Trai, Hanoi'),
  ('johnDoe123', '12 Tran Phu, Hanoi'),

  ('janeDoe',     '200 Hai Ba Trung, HCMC'),
  ('janeDoe',     '45 Le Loi, HCMC'),

  ('user99',      '23 Xuan Thuy, Hanoi'),

  ('buyerX',      '11 Ton Duc Thang, Hue');

-- Banking accounts
INSERT INTO Banking_account (username, bank_name, bank_number, bank_type) VALUES
  ('johnDoe123', 'Vietcombank',   '9704361234567890', 'debit'),
  ('janeDoe',    'Techcombank',   '9704129876543210', 'credit'),
  ('user99',     'MB Bank',       '9704012345678901', 'debit'),
  ('buyerX',     'ACB',           '9704234567890123', 'debit');

-- Social links
INSERT INTO Social (username, link) VALUES
  ('johnDoe123', 'https://facebook.com/john.doe123'),
  ('janeDoe',    'https://instagram.com/jane.doe'),
  ('user99',     'https://twitter.com/user99'),
  ('buyerX',     'https://tiktok.com/@buyerX');

INSERT INTO Voucher
  (name, expired_date, max_usage, decrease_type, decrease_value, min_buy_value, max_decrease_value, seller_usr, admin_usr)
VALUES
  ('PLAT10OFF',   '2025-12-31 23:59:59', 10000, '%',   10, 200000, 50000, NULL,      'adminJane'),
  ('PLAT20OFF',   '2025-10-31 23:59:59',  5000, '%',   20, 300000, 80000, NULL,      'adminUser1'),
  ('PLAT50K',     '2025-11-30 23:59:59',  8000, 'value',50000,100000, 50000, NULL,   'adminUser1');

INSERT INTO Voucher
  (name, expired_date, max_usage, decrease_type, decrease_value, min_buy_value, max_decrease_value, seller_usr)
VALUES
  ('TECH100K',    '2025-11-30 23:59:59',  1000, 'value',100000,500000,100000,'seller1'),
  ('FASHION50',   '2025-09-30 23:59:59',  1500, 'value',50000, 200000, 50000, 'seller2'),
  ('HOME5PCT',    '2025-10-15 23:59:59',  1200, '%',    5,   100000, 30000, 'seller3'),
  ('BOOK25PCT',   '2025-12-31 23:59:59',  2000, '%',   25,   150000, 60000, 'seller4'),
  ('PET30OFF',    '2025-08-31 23:59:59',  500,  'value',30000,100000,30000, 'seller5');

INSERT INTO Voucher_category (category, voucher_id) VALUES
  ('platform',  '1'),
  ('platform',  '2'),
  ('platform',  '3'),
  ('electronics','4'),
  ('fashion',   '5'),
  ('home',      '6'),
  ('books',     '7'),
  ('pets',      '8');

INSERT INTO Apply_voucher (voucher_id, order_id) VALUES
  -- Order 1 (johnDoe123)
  (1, 1),
    (3, 1),

  -- Order 2 (janeDoe)
  (5, 2),
  -- Order 3 (buyerX)
  (8, 3),
  -- Order 4 (user99)
  (3, 4),
  -- Order 5 (buyerX)
  (6, 5);