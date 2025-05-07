import React, { useState, useEffect } from 'react';
import { getCart, updateCartAmount, removeCartItem } from '../../util/api';
import './Cart.css';

const Cart = () => {
  const [cartItems, setCartItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [finalPrice, setFinalPrice] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchCart = async () => {
      try {
        const res = await getCart();
        console.log(res.data);
        setCartItems(res.data.variations);
        setFinalPrice(res.data.final_price.final_price);
        setLoading(false);
      } catch (err) {
        setError('Không thể tải danh sách giỏ hàng.');
        setLoading(false);
      }
    };

    fetchCart();
  }, []);

  if (loading) return <div>Đang tải giỏ hàng...</div>;
  if (error) return <div>{error}</div>;

  const getTotalPrice = () => {
    return cartItems.reduce((total, item) => {
      return total + item.price * item.cart_amount;
    }, 0);
  };

  const handleDecreaseAmount = async (productId) => {
    const updatedItems = cartItems.map(item => {
      if (item.product_id === productId && item.cart_amount > 1) {
        item.cart_amount -= 1;
      }
      return item;
    });
    setCartItems(updatedItems);
    await updateCartAmount(productId, -1);
  };

  const handleIncreaseAmount = async (productId) => {
    const updatedItems = cartItems.map(item => {
      if (item.product_id === productId) {
        item.cart_amount += 1;
      }
      return item;
    });
    setCartItems(updatedItems);
    await updateCartAmount(productId, 1);
  };

  const handleRemoveItem = async (variation_id) => {
    try {
      // Gọi API để xóa mục trong giỏ hàng
      await removeCartItem(variation_id);

      // Cập nhật state để loại bỏ mục đã xóa
      setCartItems((prevItems) =>
        prevItems.filter((item) => item.variation_id !== variation_id)
      );
    } catch (error) {
      console.error("Xóa sản phẩm thất bại:", error);
      alert("Không thể xóa sản phẩm. Vui lòng thử lại.");
    }
  };
  const hasOutOfStockItem = cartItems.some(item => item.state === 'Out of stock');

  return (
    <div className="cart-page">
      <h2>Giỏ Hàng</h2>
      {cartItems.length === 0 ? (
        <p>Giỏ hàng của bạn hiện tại trống.</p>
      ) : (
        <div className="cart-items-container">
          {cartItems.map((item) => (
            <div key={`${item.product_id}-${item.variation_id}`} className="cart-item">
              <div className="cart-item-image-container">
                <img
                  src={item.attachment || 'https://via.placeholder.com/150'}
                  alt={`Sản phẩm ${item.product_id}`}
                  className="cart-item-image"
                />
              </div>
              <div className="cart-item-details">
                <h3>{item.name || `Sản phẩm ${item.product_id}`}</h3>
                <div className="cart-item-info">
                  {item.variationInfo && (
                    <div className="cart-item-variations">
                      {item.variationInfo.map((info) => (
                        <p key={info.variation_type}>
                          {info.variation_type}: {info.variation_value}
                        </p>
                      ))}
                    </div>
                  )}
                  <p>Giá: {item.price.toLocaleString('vi-VN')} VNĐ</p>
                  {item.state === 'Out of stock' ? (
                    <p className="out-of-stock">Hết hàng</p>
                  ) : (
                    <div className="cart-item-amount">
                      <button onClick={() => handleDecreaseAmount(item.product_id)}>-</button>
                      <span>{item.cart_amount}</span>
                      <button onClick={() => handleIncreaseAmount(item.product_id)}>+</button>
                    </div>
                  )}
                  <button
                    className="remove-button"
                    onClick={() => handleRemoveItem(item.variation_id)}
                  >
                    Xóa sản phẩm
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
      {cartItems.length > 0 && (
        <div className="cart-total">
          <h3>Tổng Tiền: {finalPrice.toLocaleString('vi-VN')} VNĐ</h3>
          <button className="checkout-button" disabled={hasOutOfStockItem}>
            Thanh toán
          </button>
          {hasOutOfStockItem && <p className="out-of-stock-warning">Vui lòng xóa sản phẩm hết hàng trước khi thanh toán.</p>}
        </div>
      )}
    </div>
  );
};

export default Cart;
