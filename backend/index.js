import mysql from 'mysql2';
import express from 'express';
import 'dotenv/config'

const app = express();
const port = 3000;

app.listen(port, () => {
  console.log(`Hello from ${port}`);
});
console.log(process.env.username);
const pool = mysql.createPool({
  connectionLimit: 10,
  host: 'localhost',
  user: process.env.username,
  password: process.env.password,
  database: 'shopee'
}).promise();

app.get('/users', async (req, res) => {
  const [rows] = await pool.query('SELECT * FROM Person');
  res.send(rows);
});

