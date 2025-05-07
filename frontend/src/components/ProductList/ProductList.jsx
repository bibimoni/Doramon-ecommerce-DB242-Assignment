import React, { useState, useEffect } from 'react';
import { getAllProduct } from '../../util/api';
import { useNavigate } from 'react-router-dom';
import './ProductList.css';

const ProductList = () => {
  const [products, setProducts] = useState([]); // Danh sách sản phẩm
  const [loading, setLoading] = useState(true); // Trạng thái tải
  const [error, setError] = useState(null); // Trạng thái lỗi

  const navigate = useNavigate(); // Hook để điều hướng

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const res = await getAllProduct();
        setProducts(res.data);
        setLoading(false);
      } catch (err) {
        setError('Không thể tải danh sách sản phẩm.');
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  const handleThumbnailClick = (productId) => {
    navigate(`/product/${productId}`); // Điều hướng đến trang chi tiết sản phẩm
  };

  if (loading) return <div>Đang tải sản phẩm...</div>;
  if (error) return <div>{error}</div>;

  return (
    <div className="product-list">
      {products.map((product) => (
        <div key={product.product_id} className="product-card">
          <img
            src={product.thumbnail || 'https://via.placeholder.com/150'}
            alt={product.name}
            className="product-image"
            onClick={() => handleThumbnailClick(product.product_id)} // Thêm sự kiện onClick
          />
          <h3 className="product-name">{product.name}</h3>
          <p className="product-category">Loại: {product.category}</p>
          <p className="product-price">
            Giá: {product.min_price.toLocaleString('vi-VN')} VNĐ -{' '}
            {product.max_price.toLocaleString('vi-VN')} VNĐ
          </p>
          
        </div>
      ))}
    </div>
  );
};

export default ProductList;
