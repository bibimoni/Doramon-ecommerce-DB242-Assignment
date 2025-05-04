import express from 'express';
const app = express.Router();
import {
  addBuyer,
  addSeller,
  updateAddress,
  updateBank,
  updateSocial,
  addProduct,
  updateProduct,
  addVariation,
  updateVariation,
  updateCart,
  addAdmin,
  addVoucherBySeller,
  addVoucherByAdmin,
  addCommentToProd,
  responseComment,
  removeComment,
  addOrder,
  cancelOrder
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

app.post('/users/sellers', async (req, res) => {
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
    res.send({ success: true, data: sellerShop });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/users/address/:username', async (req, res) => {
  const username = req.params.username;
  const { list_address } = req.body;
  try {
    const ret = await updateAddress({ username, list_address });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/users/bank/:username', async (req, res) => {
  const username = req.params.username;
  const { list_banks } = req.body;
  try {
    const ret = await updateBank({ username, list_banks });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/users/social/:username', async (req, res) => {
  const username = req.params.username;
  const { list_socials } = req.body;
  try {
    const ret = await updateSocial({ username, list_socials });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/sellers/products/add/:business_id', async (req, res) => {
  const business_id = req.params.business_id;
  const {
    name,
    thumbnail, // optional
    info, // optional,
    category,
    list_attachments = [] // optional 
  } = req.body;
  try {
    const ret = await addProduct({
      name,
      thumbnail,
      info,
      category,
      business_id,
      list_attachments
    });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/products/update/:product_id', async (req, res) => {
  const product_id = req.params.product_id;
  const {
    name,
    thumbnail, // optional
    info, // optional
    category,
    list_attachments = [] // optional
  } = req.body;

  try {
    const ret = await updateProduct({
      product_id,
      name,
      thumbnail,
      info,
      category,
      list_attachments
    });
    res.send({ data: ret, success: true });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

// xóa một sản phẩm khỏi danh mục sản phẩm của sàn tmdt 
app.post('/products/remove/:product_id', async (req, res) => {
  const product_id = req.params.product_id;
  try {
    const ret = await updateProduct({
      product_id,
      active: false,
    });
    res.send({ data: ret, success: true });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/products/variations/add/:product_id', async (req, res) => {
  const product_id = req.params.product_id;
  const {
    state,
    amount,
    price,
    attachment, /* optional */
    list_info = [] /* optional */
  } = req.body;
  try {
    const ret = await addVariation({
      product_id,
      state,
      amount,
      price,
      attachment,
      list_info /* type, value */
    });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/variations/update/:variation_id', async (req, res) => {
  const variation_id = req.params.variation_id;
  const {
    state,
    amount,
    price,
    attachment, /* optional */
    list_info = [] /* optional */
  } = req.body;
  try {
    const ret = await updateVariation({
      variation_id,
      state,
      amount,
      price,
      attachment,
      list_info /* type, value */
    });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/variations/remove/:variation_id', async (req, res) => {
  const variation_id = req.params.variation_id;
  try {
    const ret = await updateVariation({
      variation_id,
      active: false,
    });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/buyers/cart/update/:buyer_username', async (req, res) => {
  const buyer_username = req.params.buyer_username;
  const {
    variation_id,
    amount
  } = req.body;
  try {
    const ret = await updateCart({ buyer_username, variation_id, amount });
    res.send({ success: true, data: ret });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/users/admins', async (req, res) => {
  let {
    username,
    password,
    email, /* optional */
    perm // either 1, 2, 3
  } = req.body;
  email ??= null;
  password = sha256(password); // hash password
  try {
    res.send({ success: true, data: await addAdmin({ username, password, email, perm }) })
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});


app.post('/voucher/sellers', async (req, res) => {
  const { voucher_list } = req.body;

  if (!Array.isArray(voucher_list) || voucher_list.length === 0) {
    return res.send({ success: false, message: 'Invalid voucher list datatype' });
  }

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

    // Kiểm tra các tham số cần thiết
    if (!name || !expired_date || !seller_usr || !max_usage ||
      decrease_type == null || decrease_value == null || min_buy_value == null || max_decrease_value == null
    ) {
      results.push({
        success: false,
        message: 'Thiếu thông tin trong voucher'
      });
      continue; // chuyển sang voucher tiếp theo
    }

    try {
      // Gọi hàm addVoucher và truyền voucher vào dưới dạng mảng
      const result = await addVoucherBySeller({
        voucher_list: [{
          name,
          expired_date,
          seller_usr,
          max_usage,
          decrease_type,
          decrease_value,
          min_buy_value,
          max_decrease_value
        }]
      });
      results.push({ success: true, data: result });
    } catch (err) {
      res.send({ success: false, message: err.message });
    }
  }
  res.send({ success: true, data: results });
});

app.post('/voucher/admins', async (req, res) => {
  const { voucher_list } = req.body;

  if (!Array.isArray(voucher_list) || voucher_list.length === 0) {
    return res.send({ success: false, message: 'Invalid voucher list datatype' });
  }

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

    // Kiểm tra các tham số cần thiết
    if (!name || !expired_date || !max_usage ||
      decrease_type == null || decrease_value == null || min_buy_value == null || max_decrease_value == null
    ) {
      results.push({
        success: false,
        message: 'Thiếu thông tin trong voucher'
      });
      continue; // chuyển sang voucher tiếp theo
    }

    try {
      // Gọi hàm addVoucher và truyền voucher vào dưới dạng mảng
      const result = await addVoucherByAdmin({
        voucher_list: [{
          name,
          expired_date,
          max_usage,
          decrease_type,
          decrease_value,
          min_buy_value,
          max_decrease_value
        }]
      });
      results.push({ success: true, data: result });
    } catch (err) {
      res.send({ success: false, message: err.message });
    }
  }
  res.send({ success: true, data: results });

});

app.post('/comment/:product_id', async (req, res) => {
  const { product_id } = req.params;
  const { buyer_usr, seller_usr, comment, star, attachment } = req.body;

  const result = await addCommentToProd({
    product_id,
    buyer_usr,
    seller_usr,
    comment,
    star,
    attachment
  });

  try {
    res.send({ success: true, data: result });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/comment/:product_id/:comment_id/response', async (req, res) => {
  const { comment_id } = req.params;
  const { seller_usr, response } = req.body;
  try {
    res.send({ success: true, data: await responseComment({ comment_id, seller_usr, response }) });
  }
  catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/comment/:product_id/:comment_id/remove', async (req, res) => {
  const { buyer_usr } = req.body;
  const { product_id, comment_id } = req.params;
  try {
    res.send({ success: true, data: await removeComment({ buyer_usr, product_id, comment_id }) });
  } catch (err) {
    res.send({ success: false, message: err.message });
  }
});

app.post('/orders', async (req, res) => {
  const { buyer_usr,
    shop_addr,
    delivery_addr,
    state_type,
    state_desc,
    payment_method,
    transfer_fee,
    discount,
    estimate_time } = req.body;
  try {
    const ret = await addOrder({
      buyer_usr,
      shop_addr,
      delivery_addr,
      state_type,
      state_desc,
      payment_method,
      transfer_fee,
      discount,
      estimate_time
    });
    const orderData = { buyer_usr,
      shop_addr,
      delivery_addr,
      state_type,
      state_desc,
      payment_method,
      transfer_fee,
      discount,
      estimate_time };

    //res.send({success: true, data: ret});
    res.json({
      success: true,
      data: {
        orderData,
        order_id: ret.insertId
      }
    });
  } catch (err) {
    res.send({success: false, message: err.message});
  }
});

app.post('/buyers/orders/cancel', async (req, res) => {
  const { buyer_usr, order_id} = req.body;
  try {
    res.send({success: true, data: await cancelOrder({buyer_usr, order_id}) });
  } catch (err) {
    res.send({success: false, message: err.message});
  }
})

export default app;

