import express from 'express';
const app = express.Router();
import {
  addBuyer,
  addSeller, 
  updateAddress,
  updateBank,
  updateSocial
} from '../database.js';
import { sha256 } from 'js-sha256';

app.post('/users/buyers', async (req, res) => {
  let { username, password, email } = req.body;
  if (!username || !password) {
    res.send({ success: false, message: "Please provide username and password" });
  }
  email ??= null;
  password = sha256(password); // hash password
  try {
    const buyer = await addBuyer({
      username,
      password,
      email
    });
    res.send({ success: true, data: buyer, message: "create buyer successfully" });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/users/sellers', async(req, res) => {
  let {
    username,
    password,
    email,
    shopname,
    address,
    business_type,
    business_address,
    tax_number,
  } = req.body;
  password = sha256(password); // hash password
  try {
    const sellerShop = await addSeller({
      username,
      password,
      email,
      shopname,
      address,
      business_type,
      business_address,
      tax_number,
    });
    res.send({success: true, data: sellerShop});
  } catch (err) {
    res.send({success: false, message: err.message});
  }
});

app.post('/users/address/:username', async (req, res) => {
  const username = req.params.username;
  const { list_address } = req.body;
  try {
    const ret = await updateAddress({ username , list_address });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message});
  }
});

app.post('/users/bank/:username', async (req, res) => {
  const username = req.params.username;
  const { list_banks } = req.body;
  try {
    const ret = await updateBank({ username , list_banks });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message});
  }
});

app.post('/users/social/:username', async (req, res) => {
  const username = req.params.username;
  const { list_socials } = req.body;
  try {
    const ret = await updateSocial({ username , list_socials });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message});
  }
});

export default app;