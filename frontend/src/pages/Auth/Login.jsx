import React, { useState } from 'react';
import './LoginSignup.css';
import { loginSeller,loginBuyer } from '../../util/api';
import { useNavigate } from 'react-router-dom';
import { notification } from 'antd';
import 'antd/dist/reset.css'; // Đảm bảo giao diện Ant Design hoạt động đúng

const Login = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [accountType, setAccountType] = useState('buyer'); // Mặc định là người mua
  const navigate = useNavigate(); // Hook để điều hướng

  const openNotification = (type, message, description) => {
    if (type === 'success') {
      notification.success({
        message,
        description,
      });
    } else if (type === 'error') {
      notification.error({
        message,
        description,
      });
    }
  };

  const handleLogin = async (e) => {
    e.preventDefault(); // Ngăn hành vi mặc định của form

    try {
      if (accountType === 'buyer') {
        const res = await loginBuyer(username, password);
        if (!res.success) {
          openNotification('Đăng nhập thành công!');
          console.log('Đăng nhap người mua thành công/ chac vay:', res);
          navigate('/'); // Điều hướng tới trang đăng nhập
        } else {
          openNotification('error', 'Đăng ký thất bại', res.message || 'Đã xảy ra lỗi. Vui lòng thử lại.');
          console.error('Lỗi từ API:', res);
        }
      } else {
        const res = await loginSeller(username, password);
        if (!res.success) {
          openNotification('Đăng nhập thành công');
          console.log('Đăng nhap người bán thành công/ chac vay:', res);
          navigate('/seller'); // Điều hướng tới trang đăng nhập
        } else {
          openNotification('error', 'Đăng ký thất bại', res.message || 'Đã xảy ra lỗi. Vui lòng thử lại.');
          console.error('Lỗi từ API:', res);
        }
      }
    } catch (error) {
      console.error('Lỗi kết nối hoặc không xử lý được yêu cầu:', error);
      openNotification('error', 'Đăng ký thất bại', 'Đã xảy ra lỗi kết nối. Vui lòng thử lại.');
    }
  };

  return (
    <div className="auth-page">
      <div className="auth-background"></div>
      <div className="auth-wrapper">
        <div className="auth-container">
          <form className="auth-form" onSubmit={handleLogin}>
            <h2 className="auth-title">Đăng Nhập</h2>
            <div className="form-group">
              <label htmlFor="username">Tên đăng nhập</label>
              <input
                type="text"
                id="username"
                placeholder="Nhập tên đăng nhập của bạn"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                required
              />
            </div>
            <div className="form-group">
              <label htmlFor="password">Mật khẩu</label>
              <input
                type="password"
                id="password"
                placeholder="Nhập mật khẩu của bạn"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </div>
            <div className="form-group">
              <label>Loại tài khoản:</label>
              <div className="userType-sellect">
                <label>
                  <input
                    type="radio"
                    name="accountType"
                    value="buyer"
                    checked={accountType === 'buyer'}
                    onChange={(e) => setAccountType(e.target.value)}
                  />
                  Người mua
                </label>
                <label>
                  <input
                    type="radio"
                    name="accountType"
                    value="seller"
                    checked={accountType === 'seller'}
                    onChange={(e) => setAccountType(e.target.value)}
                  />
                  Người bán
                </label>
              </div>
            </div>
            <button type="submit" className="auth-button">
              Đăng Nhập
            </button>
            <p className="auth-text">
              Chưa có tài khoản? <a href="/sign_up">Đăng ký ngay</a>
            </p>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Login;
