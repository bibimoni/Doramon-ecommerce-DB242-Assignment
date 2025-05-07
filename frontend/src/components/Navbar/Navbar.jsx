import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import './Navbar.css';
import { UserOutlined } from '@ant-design/icons'; // Import biểu tượng người dùng từ Ant Design
import DropDown from '../DropDown/DropDown';

const Navbar = () => {
  const [openProfile, setOpenProfile] = useState(false);
  
  return (
    <div className="navbar">
      {/* Logo */}
      <div className="navbar-logo">
          <Link to="/">
            Database_Doraemon
          </Link>
      </div>

      {/* Search Bar */}
      <div className="navbar-search">
        <input type="text" placeholder="Tìm kiếm..." />
      </div>

      {/* Right Section */}
      <div className="navbar-right">
        {/* Cart */}

        {/* Support */}
        <a href='/' className="navbar-support">
          Hỗ trợ
        </a>

        <div className="navbar-cart">
          <Link to="/cart">
            <span>🛒</span> Giỏ hàng
          </Link>
        </div>

        <div className="avt" onClick={() => setOpenProfile((prev) => !prev)}>
          <UserOutlined className="avt-icon" /> {/* Biểu tượng người dùng */}
        </div>


        {
          openProfile && <DropDown/>

        }
      </div>
    </div>
  );
};

export default Navbar;
