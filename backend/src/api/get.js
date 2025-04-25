import {
  getUsers,
  getBuyers,
  getBuyer,
  getSellerShop,
  getSellerShops,
  getAddress,
  getBank,
  getSocial,
} from '../database.js';
import express from 'express';
const app = express.Router();

app.get('/users', async (req, res) => {
  try {
    const users = await getUsers();
    res.send({ success: true, data: users });
  } catch (err) {
    res.send({ success: false });
  }
});

app.get('/users/buyers', async (req, res) => {
  try {
    const buyers = await getBuyers();
    res.send({ success: true, data: buyers });
  } catch (err) {
    res.send({ success: false });
  }
});

app.get('/users/buyers/:username', async (req, res) => {
  const username = req.params.username;
  if (!username) {
    res.send({ success: false, message: "Please provide username" });
  }
  try {
    const buyer = await getBuyer({ username: username });
    res.send({ success: true, data: buyer });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/users/sellers', async (req, res) => {
  try {
    const sellers = await getSellerShops();
    res.send({ success: true, data: sellers });
  } catch (err) {
    res.send({ success: false });
  }
});

app.get('/users/sellers/:username', async (req, res) => {
  const username = req.params.username;
  try {
    const seller = await getSellerShop({ username });
    res.send({ success: true, data: seller });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/users/address/:username', async (req, res) => {
  const username = req.params.username;
  try {
    const results = await getAddress({ username });
    res.send({ success: true, data: results });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/users/bank/:username', async (req, res) => {
  const username = req.params.username;
  try {
    const results = await getBank({ username });
    res.send({ success: true, data: results });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/users/social/:username', async (req, res) => {
  const username = req.params.username;
  try {
    const results = await getSocial({ username });
    res.send({ success: true, data: results });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

export default app;