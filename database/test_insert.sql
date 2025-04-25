USE shopee;

CALL Proc_Insert_buyer(
     'distiled',
     '1f3f26a2438cf522c5db91708afad112ec94dabdafee02a36b2e37965b2d26ae',
     'proquadi66@gmail.com',
     null,
     null,
     false,
     null,
     null,
     null
     );

SELECT * FROM Person;

SELECT *
    FROM
      Person p
    JOIN Buyer b ON p.username = b.username
    WHERE
      p.username = 'distiled';

CALL Proc_Insert_Seller(
    'dangnguyenbaovn',
    'qwertyuioasdfghjkl', 'bao@company.com', null, null, false, null, null,
    'shopoffaith', 'Ho Chi Minh', 'personal', 'Nha Trang', 0012839712
  );

SELECT *
    FROM
      Person p
    JOIN Seller s ON s.username = p.username
    JOIN Shop sh ON sh.business_id = s.business_id
    WHERE p.username = 'dangnguyenbaovn'

SELECT *
    FROM
      Person p
    JOIN Seller s ON s.username = p.username
    JOIN Shop sh ON sh.business_id = s.business_id
    ORDER BY
      p.username
