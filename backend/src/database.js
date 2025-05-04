import mysql from 'mysql2';
import 'dotenv/config'
import { checkExists } from './utils.js';

const pool = mysql.createPool({
  connectionLimit: 10,
  host: '127.0.0.1',
  user: process.env.username,
  password: process.env.password,
  database: 'shopee'
}).promise();

export async function getUsers() {
  try {
    const [rows] = await pool.query(`
    SELECT * 
    FROM 
    Person
    ORDER BY
        username
      `);
    return rows;
  } catch (err) {
    throw err;
  }
}

export async function getBuyers() {
  try {
    const [rows] = await pool.query(`
      SELECT * 
      FROM 
        Person p 
      JOIN buyer b ON p.username = b.username
      JOIN Cart c ON c.buyer_usr = b.username
      ORDER BY
        p.username
      `);
    return rows;
  } catch (err) {
    throw err;
  }
}

export async function getBuyer({ username }) {
  try {
    const [rows] = await pool.query(`
      SELECT * 
      FROM 
        Person p
      JOIN Buyer b ON p.username = b.username
      JOIN Cart c ON c.buyer_usr = b.username
      WHERE
        p.username = ?
      `, [username]);
    return checkExists(rows[0]);
  } catch (err) {
    throw err;
  }
}

export async function addBuyer({ username, password, email }) {
  try {
    await pool.query(`
      CALL Proc_Insert_buyer(
        ?,
        ?,
        ?,
        null, null, false, null, null, null
      )`, [username, password, email]);

    await pool.query(`
      INSERT INTO Cart(buyer_usr) 
      VALUES (?)  
      `, [username]);

    return await getBuyer({ username });
  } catch (err) {
    throw err;
  }
}

export async function getAdmins() {
  try {
    const [rows] = await pool.query(`
      SELECT * FROM Person p
      JOIN Admin ad ON ad.username = p.username
      `);
    
      return rows;
  } catch (err) {
    throw err;
  }
}

export async function getAdmin({ username }) {
  try {
    const [rows] = await pool.query(`
      SELECT * FROM Person p
      JOIN Admin ad ON ad.username = p.username
      WHERE 
        p.username = ?
      `, [username])
    return checkExists(rows[0]);
  } catch (err) {
    throw err;
  }
}

export async function addAdmin({
  username,
  password,
  email,
  perm
}) {
  try {
    await pool.query(`
      CALL Proc_Insert_admin(
        ?, ?, ?, null, null, false, null, null, ?
      )
      `, [username, password, email, perm]);
    
    return await getAdmin({ username });
  } catch (err) {
    throw err;
  }
}

export async function getSellerShops() {
  try {
    const [rows] = await pool.query(`
      SELECT *
      FROM 
        Person p
      JOIN Seller s ON s.username = p.username
      JOIN Shop sh ON sh.business_id = s.business_id
      ORDER BY
        p.username
      `);
    return rows;
  } catch (err) {
    throw err;
  }
}

export async function getSellerShop({ username }) {
  try {
    const [rows] = await pool.query(`
      SELECT *
      FROM 
        Person p
      JOIN Seller s ON s.username = p.username
      JOIN Shop sh ON sh.business_id = s.business_id
      WHERE p.username = ?
      `, [username]);
    return checkExists(rows[0]);
  } catch (err) {
    throw err;
  }
}

export async function addSeller({
  username,
  password,
  email,
  shopname,
  address,
  business_type,
  business_address,
  tax_number,
}) {
  try {
    await pool.query(`
    CALL Proc_Insert_Seller(
      ?, ?, ?, null, null, false, null, null, 
      ?, ?, ?, ?, ?
    )`, [
      username,
      password,
      email,
      shopname,
      address,
      business_type,
      business_address,
      tax_number
    ]);
    return await getSellerShop({ username });
  } catch (err) {
    throw err;
  }
}

export async function getAddress({ username }) {
  const [rows] = await pool.query(`
    SELECT address FROM Address WHERE username = ?
    `, [username]);
  return rows;
}

export async function updateAddress({
  username,
  list_address = []
}) {
  try {
    await pool.query(`
      DELETE FROM Address WHERE username = ?
      `, [username]);
  } catch (err) {
    throw err;
  }
  for (const address of list_address) {
    try {
      await pool.query(`
        INSERT INTO Address(username, address)
        VALUES (?, ?)
        `, [username, address]);
    } catch (err) {
      throw err;
    }
  }
  try {
    return await getAddress({ username });
  } catch (err) {
    throw err;
  }
}

export async function getSocial({ username }) {
  const [rows] = await pool.query(`
    SELECT link FROM Social WHERE username = ?
    `, [username]);
  return rows;
}

export async function updateSocial({
  username,
  list_socials = []
}) {
  try {
    await pool.query(`
      DELETE FROM Social WHERE username = ?
      `, [username]);
  } catch (err) {
    throw err;
  }
  for (const link of list_socials) {
    try {
      await pool.query(`
        INSERT INTO Social(username, link)
        VALUES (?, ?)
        `, [username, link]);
    } catch (err) {
      throw err;
    }
  }
  try {
    return await getSocial({ username });
  } catch (err) {
    throw err;
  }
}

export async function getBank({ username }) {
  try {
    const [rows] = await pool.query(`
    SELECT bank_name, bank_number, bank_type FROM Banking_account WHERE username = ?
    `, [username]);
    return rows;
  } catch (err) { throw err; }
}

export async function updateBank({
  username,
  list_banks = []
}) {
  try {
    await pool.query(`
      DELETE FROM Banking_account WHERE username = ?
      `, [username]);
  } catch (err) {
    throw err;
  }
  for (const bank of list_banks) {
    try {
      await pool.query(`
        INSERT INTO Banking_account(username, bank_name, bank_number, bank_type)
        VALUES (?, ?, ?, ?)
        `, [username, bank.name, bank.number, bank.type]);
    } catch (err) {
      throw err;
    }
  }
  try {
    return await getBank({ username });
  } catch (err) {
    throw err;
  }
}

export async function getShopProducts({ business_id }) {
  try {
    const [rows] = await pool.query(`
      SELECT * 
      FROM Product p 
      WHERE p.business_id = ?
      `, [business_id]);
    return rows;
  } catch (err) {
    throw err;
  }
}


export async function getProductVariations({ product_id }) {
  try {
    const [rows] = await pool.query(`
      SELECT *
      FROM Variation 
      WHERE product_id = ?
      `, [product_id]);
    return rows;
  } catch (err) {
    throw err;
  }
}

export async function getProductOrVariation({ product_id = null, variation_id = null }) {
  try {
    if (product_id !== null) {
      const [rows] = await pool.query(`
        SELECT * FROM Product p 
        WHERE p.product_id = ?
        `, [product_id]);

      return rows[0];
    } else if (variation_id !== null) {
      const [rows] = await pool.query(`
        SELECT * FROM Variation v
        WHERE v.variation_id = ?
        `, [variation_id]);

      return rows[0];
    }

    throw Error("Please provide either product_id or variation_id")
  } catch (err) {
    throw err;
  }
}

export async function getProductAttachments({ product_id }) {
  try {
    const [rows] = await pool.query(`
      SELECT * FROM Product_attachments
      WHERE product_id = ?
      `, [product_id]);
    return rows;
  } catch (err) {
    throw err;
  }
}

export async function addProduct({
  name,
  thumbnail,
  info,
  category,
  business_id,
  list_attachments = []
}) {
  try {
    const [result] = await pool.query(`
      INSERT INTO Product(name, thumbnail, info, category, business_id)
      VALUES (?, ?, ?, ?, ?)
      `, [name, thumbnail, info, category, business_id]);
    for (const link of list_attachments) {
      await pool.query(`
        INSERT INTO Product_attachments(product_id, link)
        VALUES (?, ?)
        `, [result.insertId, link]);
    }
    return await getProductOrVariation({ product_id: result.insertId });
  } catch (err) {
    throw err;
  }
}

export async function updateProduct({
  product_id,
  name,
  thumbnail,
  info,
  category,
  list_attachments = [],
  active = null,
}) {
  try {
    if (active === null) {
      await pool.query(`
        UPDATE Product 
        SET name = ?,
          thumbnail = ?,
          info = ?,
          category = ?
        WHERE product_id = ?
        `, [name, thumbnail, info, category, product_id]);
      await pool.query(`
        DELETE FROM Product_attachments
        WHERE product_id = ?
        `, [product_id]);

      for (const link of list_attachments) {
        await pool.query(`
          INSERT INTO 
          Product_attachments(product_id, link)
          VALUES (?, ?)
          `, [product_id, link]);
      }
    } else {
      await pool.query(`
        UPDATE Product 
        SET active = ?
        WHERE product_id = ?
        `, [active, product_id]);
    }
    return await getProductOrVariation({ product_id });
  } catch (err) {
    throw err;
  }
}

export async function addVariation({
  product_id,
  state,
  amount,
  price,
  attachment, /* optional */
  list_info = [],
}) {
  try {
    const [result] = await pool.query(`
      INSERT INTO Variation(product_id, state, amount, price, attachment)
      VALUES (?, ?, ?, ?, ?)
      `, [product_id, state, amount, price, attachment]);

    for (const info of list_info) {
      await pool.query(`
        INSERT INTO Info_variation(product_id, variation_id, variation_type, variation_value)
        VALUES (?, ?, ?, ?)
        `, [product_id, result.insertId, info.type, info.value]);
    }

    return await getProductOrVariation({
      variation_id: result.insertId
    });
  } catch (err) {
    throw err;
  }
}

export async function updateVariation({
  variation_id,
  state,
  amount,
  price,
  attachment, /* optional */
  list_info = [],
  active = null
}) {
  try {
    if (active === null) {
      await pool.query(`
        UPDATE Variation 
        SET state = ?,
          amount = ?,
          price = ?,
          attachment = ?
        WHERE variation_id = ?
        `, [state, amount, price, attachment, variation_id]);

      const [rows] = await pool.query(`
        SELECT product_id FROM Variation
        WHERE Variation.variation_id = ?
        `, [variation_id]);

      const product_id = rows[0].product_id;

      await pool.query(`
        DELETE FROM Info_variation WHERE variation_id = ?
        `, [variation_id]);

      for (const info of list_info) {
        await pool.query(`
          INSERT INTO Info_variation(product_id, variation_id, variation_type, variation_value)
          VALUES (?, ?, ?, ?)
          `, [product_id, variation_id, info.type, info.value]);
      }
    } else {
      await pool.query(`
        UPDATE Variation
        SET active = ?
        WHERE variation_id = ?
      `, [active, variation_id]);
    }
    return await getProductOrVariation({ variation_id });
  } catch (err) {
    throw err;
  }
}

export async function getInfoVariation({ variation_id }) {
  try {
    const [rows] = await pool.query(`
      SELECT * FROM Info_variation
      WHERE variation_id = ?
      `, [variation_id]);

    return rows;
  } catch (err) {
    throw err;
  }
}

export async function updateCart({ buyer_username, variation_id, amount }) {
  try {
    await pool.query(`
      CALL Proc_update_cart_variation(?, ?, ?)
      `, [buyer_username, variation_id, amount]);
    return await getVariationsFromCart({ buyer_username });
  } catch (err) {
    throw err;
  }
}

export async function getVariationsFromCart({ buyer_username }) {
  try {
    const [[rows]] = await pool.query(`
      CALL Proc_get_variations_from_cart(?)
      `, [buyer_username]);
    return rows;
  } catch (err) {
    throw err;
  }
}

export async function addVoucherBySeller({voucher_list = []}) {
  const results = [];
  for (const voucher of voucher_list) {
    const {
      name,
      expired_date,
      seller_usr,
      max_usage,
      decrease_type,     
      decrease_value,    
      min_buy_value,     
      max_decrease_value
    } = voucher;

    try {
      const sql = `
        INSERT INTO Voucher (name, expired_date, seller_usr, max_usage, decrease_type, decrease_value, min_buy_value, max_decrease_value)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `;
      const [result] = await pool.execute(sql, [
        name,
        expired_date,
        seller_usr,
        max_usage,
        decrease_type,
        decrease_value,
        min_buy_value,
        max_decrease_value
      ]);

      results.push({
        name,
        expired_date,
        seller_usr,
        max_usage,
        decrease_type,
        decrease_value,
        min_buy_value,
        max_decrease_value
      });

    } catch (err) {
      throw new Error(`Error when add voucher ${name}: ${err.message}`);
    }
  }

  return results;
}

export async function getShopVoucher({seller_usr}) {
  try {
    const [results] = await pool.query(`
      SELECT *
      FROM 
      Voucher v 
      WHERE v.seller_usr = ?
      `, [seller_usr]);
      return checkExists(results);
  }
  catch (err) {
    throw err;
  }
}

export async function addVoucherByAdmin({voucher_list = []}) {
  const results = [];
  for (const voucher of voucher_list) {
    const {
      name,
      expired_date,
      max_usage,
      decrease_type,     
      decrease_value,    
      min_buy_value,     
      max_decrease_value
    } = voucher;

    if (!name || !expired_date || !max_usage || 
      decrease_type == null || decrease_value == null || min_buy_value == null || max_decrease_value == null
    ) {
      throw new Error(`Not enough information for voucher: ${JSON.stringify(voucher)}`);
    }

    try {
      const sql = `
        INSERT INTO Voucher (name, expired_date, max_usage, decrease_type, decrease_value, min_buy_value, max_decrease_value)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      `;
      const [result] = await pool.execute(sql, [
        name,
        expired_date,
        max_usage,
        decrease_type,
        decrease_value,
        min_buy_value,
        max_decrease_value
      ]);

      results.push({
        name,
        expired_date,
        max_usage,
        decrease_type,
        decrease_value,
        min_buy_value,
        max_decrease_value
      });

    } catch (err) {
      throw new Error(`Error when add voucher ${name}: ${err.message}`);
    }
  }

  
  return results;
}

export async function getVouchers(){
  try {
    const [rows] = await pool.query(`
      SELECT *
      FROM 
      Voucher
      `);
      return rows;
  } catch (err) {
    throw err;
  }
}

export async function addCommentToProd({
  product_id,
  buyer_usr,
  seller_usr,
  comment,
  star,
  attachment = null
}) {
  try {
    const [results] = await pool.execute(
      `INSERT INTO Comment (product_id, seller_usr, buyer_usr, comment, star, attachment)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [product_id, seller_usr, buyer_usr, comment, star, attachment]
    );

    return results;
  }
  catch (err) {
    throw err;
  }
}

export async function removeComment({buyer_usr, product_id, comment_id}) {
  try {
    // Kiểm tra xem comment có tồn tại và người mua
    // có đúng là người đã đăng comment này hay không 
    const [rows] = await pool.query(`
      SELECT buyer_usr, comment_id, comment
      FROM Comment c
      WHERE c.product_id = ?
      AND c.comment_id = ?
      `, [product_id, comment_id]);
      if (rows.length === 0) throw new Error('Comment not found');
    
    const commentBuyer = rows[0].buyer_usr;
    if (commentBuyer !== buyer_usr) {
      throw new Error('You are not authorized to delete this comment');
    }

    await pool.query(`
      DELETE FROM Comment
      WHERE product_id = ?
      AND comment_id = ?
      `, [product_id, comment_id]);

      return checkExists(rows);
  } catch (err) {
    throw err;
  }
};

export async function getComments({product_id}) {
  try {
    const [rows] = await pool.query(`
      SELECT * 
      FROM Comment c
      WHERE c.product_id = ?
      `, [product_id]);
      return checkExists(rows);
  } catch (err) {
    throw err;
  }
}

export async function responseComment({comment_id, seller_usr, response}) {
  try {
    const [rows] = await pool.query(`
      SELECT seller_usr, comment_id, response
      FROM Comment c
      WHERE c.comment_id = ?
      `, [comment_id]);

      if (rows.lenght == 0) throw new Error('Comment not exist');

      const commentSeller = rows[0].seller_usr;
      if (commentSeller != seller_usr)
      {
        throw new Error('Not allowed to response this comment');
      }

      const [result] = await pool.query(`
        UPDATE Comment 
        SET response = ? 
        WHERE comment_id = ?
      `, [response, comment_id]);
      return checkExists(rows);
  } catch (err) {
    throw err;
  }
};

export async function addOrder({
  buyer_usr,          
  shop_addr,        
  delivery_addr,     
  state_type,        
  state_desc,       
  payment_method,    
  transfer_fee,       
  discount,         
  estimate_time,
  delivery_id = null,   // Có thể truyền null nếu chưa có
  carrier_id = null     // Có thể truyền null nếu chưa có
}) {
  try {
    const [rows] = await pool.query(`
      INSERT INTO \`Order\` (
        placed_date,
        shop_addr,
        delivery_addr,
        state_type,
        state_desc,
        payment_method,
        buyer_usr,
        delivery_id,
        carrier_id,
        transfer_fee,
        discount,
        estimate_time
      )
      VALUES (NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      shop_addr,
      delivery_addr,
      state_type,
      state_desc,
      payment_method,
      buyer_usr,
      delivery_id,
      carrier_id,
      transfer_fee,
      discount,
      estimate_time
    ]);

    return checkExists(rows);
  } catch (err) {
    throw err;
  }
}

export async function getOrders({buyer_usr}) {
  try {
    const [rows] = await pool.query(`
      SELECT * 
      FROM \`Order\` o
      WHERE o.buyer_usr = ?
      `, [buyer_usr]);
      return checkExists(rows);
  } catch (err) {
    throw err;
  }
};

export async function cancelOrder({buyer_usr, order_id}) {
  try {
    const [rows] = await pool.query(`
      SELECT state_type, buyer_usr
      FROM \`Order\`o
      WHERE o.buyer_usr = ?
      AND o.order_id = ?
      `, [buyer_usr, order_id]);

      if (rows.length == 0) {
        throw new Error('Order not found');
      }

      const order = rows[0];
      if (buyer_usr != order.buyer_usr) {
        throw new Error('No authentication to cancel this order');
      }

      if (order.state_type != 'accepted' || order.state_type != 'waiting') {
        throw new Error('TO Front end: do not display this button');
      }

      await pool.query(`
        UPDATE \`Order\`
        SET state_type = 'cancelled', state_desc = 'Backend: Cancelled by buyer'
        WHERE order_id = ?
        `, [order_id]);
        const [rows_after_cancel] = await pool.query(`
          SELECT order_id, buyer_usr, state_type 
          FROM \`Order\`o
          WHERE o.buyer_usr = ?
          AND o.order_id = ?
          `, [buyer_usr, order_id]);

      return checkExists(rows_after_cancel);
  } catch (err) {
    throw err;
  }
}

//export async function addDelivery({})
