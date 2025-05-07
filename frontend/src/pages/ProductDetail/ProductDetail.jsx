import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { getProductById, getAllVariations, getVariationInfo, updateCartAmount } from '../../util/api';
import './ProductDetail.css';
import { notification } from 'antd';

const ProductDetail = () => {
  const { id } = useParams(); // Lấy product_id từ URL
  const [product, setProduct] = useState(null); // Lưu trữ thông tin sản phẩm
  const [variations, setVariations] = useState([]); // Lưu trữ danh sách biến thể
  const [selectedVariation, setSelectedVariation] = useState(null); // Lưu trữ variation đã chọn
  const [quantity, setQuantity] = useState(1); // Số lượng mặc định là 1
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchProductDetails = async () => {
      try {
        // Lấy thông tin sản phẩm
        const productRes = await getProductById(id);
        if (productRes?.data) {
          setProduct(productRes.data);
        } else {
          setError('Không tìm thấy sản phẩm');
        }

        // Lấy danh sách biến thể
        const variationsRes = await getAllVariations(id);

        if (variationsRes?.data) {
          // Lọc các biến thể active
          const activeVariations = variationsRes.data.filter(
            (variation) => variation.active === 1
          );

          // Lấy thông tin chi tiết cho từng biến thể
          const variationsWithInfo = await Promise.all(
            activeVariations.map(async (variation) => {
              const variationInfo = await getVariationInfo(variation.variation_id);
              return { ...variation, variationInfo: variationInfo.data };
            })
          );
          setVariations(variationsWithInfo);
        }

        setLoading(false);
      } catch (err) {
        setError('Không thể tải thông tin sản phẩm.');
        setLoading(false);
      }
    };

    fetchProductDetails();
  }, [id]);

  if (loading) return <div>Đang tải thông tin sản phẩm...</div>;
  if (error) return <div>{error}</div>;

  // Hàm xử lý thêm sản phẩm vào giỏ
  const handleAddToCart = async () => {
    if (!selectedVariation) {
      notification.error({
        message: 'Chưa chọn biến thể',
        description: 'Vui lòng chọn một biến thể để thêm vào giỏ hàng.',
      });
      return;
    }
    try {
      const res = await updateCartAmount(selectedVariation, quantity);
      if (res.success) {
        console.log(res)
        notification.success({
          message: 'Thêm vào giỏ thành công',
          description: 'Biến thể đã được thêm vào giỏ.',
        });
      } else {
        notification.error({
          message: 'Thêm vào giỏ thất bại 1',
          description: 'Vui lòng thử lại.',
        });
      }
    } catch (error) {
      notification.error({
        message: 'Thêm vào giỏ thất bại 2',
        description: 'Đã xảy ra lỗi. Vui lòng thử lại.',
      });
    }
  };

  // Hàm chọn biến thể
  const handleVariationChange = (variationId) => {
    setSelectedVariation(variationId);
  };

  // Hàm tăng giảm số lượng
  const handleIncreaseQuantity = () => {
    setQuantity(quantity + 1);
  };

  const handleDecreaseQuantity = () => {
    if (quantity > 1) {
      setQuantity(quantity - 1);
    }
  };

  return (
    <div className="product-detail">
      <div className="product-image-container">
        <img
          src={product.thumbnail ? `/${product.thumbnail}` : 'https://via.placeholder.com/150'}
          alt={product.name}
          className="product-detail-image"
        />
      </div>
      <div className="product-info-container">
        <h2 className="product-detail-name">{product.name}</h2>
        <p className="product-detail-category">Loại: {product.category}</p>
        <p className="product-detail-info">{product.info || 'Không có thông tin thêm.'}</p>

        <h3>Các biến thể:</h3>
        <div className="variation-selector">
          {variations.length > 0 ? (
            variations.map((variation) => (
              <div key={variation.variation_id} className="variation-item">
                <input
                  type="radio"
                  id={`variation-${variation.variation_id}`}
                  name="variation"
                  value={variation.variation_id}
                  checked={selectedVariation === variation.variation_id}
                  onChange={() => handleVariationChange(variation.variation_id)}
                />
                <label htmlFor={`variation-${variation.variation_id}`}>
                  Biến thể {variation.variation_id} - Giá: {variation.price.toLocaleString('vi-VN')} VNĐ
                </label>
                {variation.variationInfo && (
                  <div className="variation-info">
                    {variation.variationInfo.map((info) => (
                      <p key={info.variation_type}>
                        {info.variation_type}: {info.variation_value} : {info.state}
                      </p>
                    ))}
                  </div>
                )}
              </div>
            ))
          ) : (
            <p>Không có biến thể nào khả dụng.</p>
          )}
        </div>

        {selectedVariation && (
          <div className="quantity-selector">
            <label htmlFor="quantity">Số lượng:</label>
            <div className="quantity-controls">
              <button onClick={handleDecreaseQuantity} className="quantity-btn">-</button>
              <input
                type="number"
                id="quantity"
                value={quantity}
                min="1"
                readOnly
              />
              <button onClick={handleIncreaseQuantity} className="quantity-btn">+</button>
            </div>
          </div>
        )}

        {selectedVariation && quantity > 0 && (
          <button onClick={handleAddToCart} className="add-to-cart-btn">Thêm vào giỏ</button>
        )}
      </div>
    </div>
  );
};

export default ProductDetail;
