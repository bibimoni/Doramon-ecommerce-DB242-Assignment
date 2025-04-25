import mysql from 'mysql2';
import 'dotenv/config'
import { checkExists } from './utils.js';

const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: process.env.username,
  password: process.env.password,
  database: 'shopee'
}).promise();

export async function getUsers() {
  const [rows] = await pool.query(`
    SELECT * 
    FROM 
      Person
    ORDER BY
      username
    `);
  return rows;
}

export async function getBuyers() {
  const [rows] = await pool.query(`
    SELECT * 
    FROM 
      Person p 
    JOIN Buyer b ON p.username = b.username
    ORDER BY
      p.username
    `);
  return rows;
}

export async function getBuyer({username}) {
  const [rows] = await pool.query(`
    SELECT * 
    FROM 
      Person p
    JOIN Buyer b ON p.username = b.username
    WHERE
      p.username = ?
    `, [username]);
  
  return checkExists(rows[0]);
}

export async function addBuyer({username, password, email}) {
  await pool.query(`
  CALL Proc_Insert_buyer(
    ?,
    ?,
    ?,
    null, null, false, null, null, null
  )`, [username, password, email]);
  try {
    return await getBuyer({username});
  } catch (err) {
    throw err;
  }
}

export async function getSellerShops() {
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
}

export async function getSellerShop({username}) {
  const [rows] = await pool.query(`
    SELECT *
    FROM 
      Person p
    JOIN Seller s ON s.username = p.username
    JOIN Shop sh ON sh.business_id = s.business_id
    WHERE p.username = ?
    `, [username]);
  return checkExists(rows[0]);
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
  try {
    return await getSellerShop({username});
  } catch (err) {
    throw err;
  }
}

export async function getAddress({username}) {
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

export async function getSocial({username}) {
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

export async function getBank({username}) {
  const [rows] = await pool.query(`
    SELECT bank_name, bank_number, bank_type FROM Banking_account WHERE username = ?
    `, [username]);
  return rows;
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