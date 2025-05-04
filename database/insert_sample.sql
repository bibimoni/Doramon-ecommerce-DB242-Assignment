USE shopee;

CALL Proc_Insert_buyer(
        'alice123',
        '0b30c75f8ccc8abbc47af5194c50bd612773cc14b7f8991799ca9d26bb8a5344', -- MD5 for 'password'
        'alice@example.com',
        '1995-06-15',
        '09123456789',
        FALSE,
        'https://example.com/avatars/alice.jpg',
        'f',
        null -- vi du ve viec no auto bang 0
     );
CALL Proc_Insert_buyer(
        'bobhebuyer',
        '201ebe6f0dffda47fc610ba53693f22b5ce0ba7a0187372fb40a2d9d92830fca', -- MD5 for 'abc123'
        'bob@example.net',
        '1988-03-22',
        '09876543210',
        TRUE,
        'https://example.com/avatars/bob.png',
        'm',
        250
     );
CALL Proc_Insert_buyer(
        'charlie789',
        '05431781f1f9404d2ee81a9111a0bc6aaa54bb303c97fe85fc9dfa743c98da18', -- MD5 for 'qwerty'
        'charlie@shop.org',
        '2000-11-30',
        '09012345678',
        FALSE,
        'https://example.com/avatars/charlie.gif',
        'm',
        500
     );

-- Xem buyer
SELECT *
FROM Person p
         JOIN buyer b ON p.username = b.username
         JOIN Cart c ON c.buyer_usr = b.username
ORDER BY p.username;

CALL Proc_Insert_seller(
        'jane',
        '0097728063561277a24daa61dba6bbc17ba2120b5696666d71a7c8fcc536a2de', -- hashed 'password'
        'jane@market.com',
        '1992-07-21',
        '09012345678',
        FALSE,
        'https://example.com/avatars/jane.png',
        'f',
        101,
        'JaneStore',
        '123 Main St',
        'personal',
        '456 Market Rd',
        123456789
     );

CALL Proc_Insert_seller(
        'bob',
        '66ff6f42c50fb134447d7c409454779055ddc69b5bdf82aa8a38c00d54e6b153', -- hashed 'test'
        'bob@techhub.com',
        '1985-02-11',
        '09123456789',
        FALSE,
        'https://example.com/avatars/bob.jpg',
        'm',
        102,
        'TechBob',
        '789 Tech Park',
        'business',
        '101 Silicon Ave',
        987654321
     );

CALL Proc_Insert_seller(
        'sara',
        '456128ce56d37ba0ade3834c4738f5cd6b2d5ea9be38d5306cc11470256e6a0f', -- hashed 'family123'
        'sara@familyshop.com',
        '1990-12-05',
        '09345678901',
        FALSE,
        'https://example.com/avatars/sara.jpeg',
        'f',
        103,
        'FamilyMart',
        '12 Cozy Ln',
        'family',
        '34 Community Rd',
        456789012
     );

SELECT *
FROM Person p
         JOIN Seller s ON s.username = p.username
         JOIN Shop sh ON sh.business_id = s.business_id
ORDER BY p.username