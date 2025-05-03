import {
  getUsers,
  getBuyers,
  getBuyer,
  getSellerShop,
  getSellerShops,
  getAddress,
  getBank,
  getSocial,
  getProductOrVariation,
  getShopProducts,
  getProductAttachments,
  getInfoVariation,
  getProductVariations,
  getVariationsFromCart,
  getAdmins,
  getAdmin,
  getShopVoucher,
  getVouchers,
  getComments,
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

app.get('/products/:product_id', async (req, res) => {
  const product_id = req.params.product_id;
  try {
    const results = await getProductOrVariation({ product_id });
    res.send({ success: true, data: results });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/variations/:variation_id', async (req, res) => {
  const variation_id = req.params.variation_id;
  try {
    const results = await getProductOrVariation({ variation_id });
    res.send({ success: true, data: results });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/sellers/products/:business_id', async (req, res) => {
  const business_id = req.params.business_id;
  try {
    const results = await getShopProducts({ business_id });
    res.send({ success: true, data: results });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/products/attachments/:product_id', async (req, res) => {
  const product_id = req.params.product_id;
  try {
    const ret = await getProductAttachments({ product_id });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/variations/info/:variation_id', async (req, res) => {
  const variation_id = req.params.variation_id;
  try {
    const ret = await getInfoVariation({ variation_id });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/products/variations/:product_id', async (req, res) => {
  const product_id = req.params.product_id;
  try {
    const ret = await getProductVariations({ product_id });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/buyers/cart/:buyer_username', async (req, res) => {
  const buyer_username = req.params.buyer_username;
  try {
    const ret = await getVariationsFromCart({
      buyer_username,
    });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.end({ success: false, message: err.message });
  }
});

app.get('/users/admins', async (req, res) => {
  try {
    res.send({ success: true, data: await getAdmins() });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.get('/users/admins/:username', async (req, res) => {
  const username = req.params.username;
  try {
    res.send({ success: true, data: await getAdmin({ username }) });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});


// Method for buyer to get voucher 

/*From a specific shop */
app.get('/voucher/:seller_usr', async (req, res) => {
  const seller_usr = req.params.seller_usr;
  try {
    res.send({success: true, data: await getShopVoucher({ seller_usr }) });
  } catch (err) {
    res.send({success: false, message: err.message});
  }
});

/*From main page or in Voucher site */
app.get('/voucher', async (req, res) => {
  const seller_usr = req.params.voucher;
  try {
    res.send({success: true, data: await getVouchers()});
  } catch(err) {
    res.send({success: true, message: err.message});
  }
});

app.get('/comment/:product_id', async (req, res) => {
  const product_id = req.params.product_id;
  try {
    res.send({success: true, data: await getComments({product_id}) });
  } catch (err) {
    res.send({success: false, message: err.message});
  }
});

export default app;