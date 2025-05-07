import React, {useState, useEffect} from "react";
import "./Seller.css";
import { Avatar, Dropdown, Menu } from "antd";
import { UserOutlined } from "@ant-design/icons";
import { getBestSales } from "../../util/api";



const Seller = () => {
  const [saleItems, setSaleItems] = useState([]);
  const id = 1;
  const date = "2025-05-01 09:00:00";
  const menu = (
    <Menu>
      <Menu.Item key="1">Profile</Menu.Item>
      <Menu.Item key="2">Manage Account</Menu.Item>
      <Menu.Item key="3">Logout</Menu.Item>
    </Menu>
  );
  useEffect(() => {
    const fetchSales = async () => {
      try {
        const res = await getBestSales(id, "2025-05-01 09:00:00" );
        console.log(res.data)
        setSaleItems(res.data);
      } catch (err) { }
    };

    fetchSales();
  }, []);
  return (
    <div className="seller-dashboard">
      {/* Navbar */}
      <nav className="seller-navbar">
        <div className="logo">Database_Doraemon Kênh người bán</div>
        <div className="seller-navbar-right">
          <a href="/seller" className="navbar-link">Hỗ Trợ</a>
          <Dropdown overlay={menu} placement="bottomRight">
            <Avatar
              icon={<UserOutlined />}
              className="navbar-avatar"
            />
          </Dropdown>
        </div>
      </nav>

      {/* Main Content */}
      <div className="main-content">
        {/* Sidebar */}
        <aside className="sidebar">
          <ul className="sidebar-menu">
            <li>Quản lí đơn hàng</li>
            <li>Quản lí sản phẩm</li>
            <li>Quản lí Voucher</li>
          </ul>
        </aside>
        
        {/* Home Content */}
        {/* <div className="home-content"> */}
          {/* <h2>Phân tích bán hàng</h2> */}
          {/* <div className="analytics-card"> */}
            {/* <p>Doanh thu tháng: 50,000,000 VND</p> */}
            {/* <p>Đơn hàng: 200</p> */}
            {/* <p>Khách hàng: 150</p> */}
          {/* </div> */}
        {/* </div> */}
        {saleItems.length === 0 ? (
          <p>Không có dữ liệu bán hàng.</p>
        ) : (
          <div className="sales-list">
            {saleItems.map((item) => (
              <div key={item.id} className="sale-item">
                <h3>{item.name}</h3>
                <p>Số lượng đã bán: {item.sales}</p>
                <p>Thời gian: {date}</p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default Seller;
