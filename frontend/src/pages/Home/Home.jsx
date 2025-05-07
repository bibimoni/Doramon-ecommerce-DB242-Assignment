import React from 'react'
import './Home.css'
import ProductList from '../../components/ProductList/ProductList'

const Home = () => {
  return (
    <div className='home'>
      <div className="header">
        <div className="header-contents">
          <h2> Đặt hàng ở đây</h2>
          <p> 
              Database_Doraemon là một sàn thương mại điện tử hiện đại, cung cấp nền tảng để kết nối người mua và người bán một cách hiệu quả. Với giao diện trực quan và thân thiện, trang web hỗ trợ người dùng dễ dàng tìm kiếm, lựa chọn và đặt mua các sản phẩm đa dạng từ thời trang, điện tử, đến đồ gia dụng và nhiều danh mục khác. 
              Hệ thống được thiết kế để tối ưu hóa trải nghiệm mua sắm trực tuyến với các công cụ hỗ trợ thông minh như gợi ý sản phẩm phù hợp, so sánh giá cả, và đánh giá chất lượng từ cộng đồng người dùng.
          </p>
          <button>Xem sản phẩm</button>
        </div>

        <ProductList/>
      </div>

      
    </div>
  )
}

export default Home
