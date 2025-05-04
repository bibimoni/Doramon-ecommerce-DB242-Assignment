use shopee;

CALL Proc_Insert_person(
    'johnDoe123',
    'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',  -- password123 (SHA-256)
    'john@example.com',
    '1990-05-20',
    '0123456789',
    FALSE,
    'https://example.com/avatar/john.png',
    'm'
);

CALL Proc_Insert_person(
    'janeDoe',
    'bcb4efbddba33d2522fbb18aa50d050a0d7eb4193e3462bc6c3db551b96f61ef',  -- securepass
    'jane@example.com',
    '1995-07-15',
    '0987654321',
    FALSE,
    'https://example.com/avatar/jane.png',
    'f'
);

CALL Proc_Insert_person(
    'adminUser1',
    '65a8e27d8879283831b664bd8b7f0ad4e36aa6d44f41a5d47cbf7b7357dce8a4',  -- adminpass
    'admin@example.com',
    '1985-04-10',
    '0111222333',
    FALSE,
    'https://example.com/avatar/admin.png',
    'm'
);

CALL Proc_Insert_person(
    'user99',
    '32fcd1737b898b6a5be57ab2ee4bfe78d415ec7ef5a418053e3c4b8db3f297e7',  -- userpass
    'user99@example.com',
    '1992-03-12',
    '0909090909',
    FALSE,
    NULL,
    'm'
);

CALL Proc_Insert_person(
    'buyerX',
    '1c552d75a91c69d3ef8367d8f19641f8d3ae7b9b34e1b876dd38e1e9a9f4f2e2',  -- buyerpass
    'buyerx@example.com',
    '2000-12-01',
    NULL,
    FALSE,
    NULL,
    'f'
);


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
 'card', 'adminUser1', 3, 1002, NOW() - INTERVAL 2 DAY, 40000, 10000),

(NOW() - INTERVAL 1 DAY, '23 Pham Ngu Lao', '23 Xuan Thuy, Hanoi', 'cancelled', 'Buyer cancelled due to late delivery',
 'cash', 'user99', 4, NULL, NULL, 20000, 0),

(NOW() - INTERVAL 3 DAY, '81 Pasteur', '11 Ton Duc Thang, Hue', 'wait for delivery', 'Awaiting final delivery step',
 'card', 'buyerX', 5, 1003, NOW() + INTERVAL 5 HOUR, 35000, 2000);
