import React, { useState } from 'react';
import './LoginSignup.css';
import { useNavigate } from 'react-router-dom';
import { createBuyer, createSeller } from '../../util/api';
import { notification } from 'antd';
import 'antd/dist/reset.css'; // Đảm bảo giao diện Ant Design hoạt động đúng

const SignUp = () => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [accountType, setAccountType] = useState('buyer'); // Mặc định là người mua
  const navigate = useNavigate(); // Hook để điều hướng

  const openNotification = (type, message, description) => {
    notification[type]({
      message,
      description,
    });
  };

  const handleSignup = async (e) => {
    e.preventDefault();
    if (password !== confirmPassword) {
      openNotification('error', 'Lỗi đăng ký', 'Mật khẩu xác nhận không khớp!');
      return;
    }

    try {
      if (accountType === 'buyer') {
        const res = await createBuyer(username, email, password);
        if (res.success) {
          openNotification('success', 'Đăng ký thành công', 'Tài khoản người mua đã được tạo!');
          console.log('Đăng ký người mua thành công:', res);
          navigate('/log_in'); // Điều hướng tới trang đăng nhập
        } else {
          openNotification('error', 'Đăng ký thất bại', res.message || 'Đã xảy ra lỗi. Vui lòng thử lại.');
          console.error('Lỗi từ API:', res);
        }
      } else {
        const res = await createSeller(username, email, password);
        if (res.success) {
          openNotification('success', 'Đăng ký thành công', 'Tài khoản người bán đã được tạo!');
          console.log('Đăng ký người bán thành công:', res);
          navigate('/log_in'); // Điều hướng tới trang đăng nhập
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
          <form className="auth-form" onSubmit={handleSignup}>
            <h2 className="auth-title">Đăng Ký</h2>

            <div className="form-group">
              <label htmlFor="username">Tên người dùng</label>
              <input
                type="text"
                id="username"
                placeholder="Nhập tên người dùng của bạn"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                required
              />
            </div>

            <div className="form-group">
              <label htmlFor="email">Email (tùy chọn)</label>
              <input
                type="email"
                id="email"
                placeholder="Nhập email của bạn"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>

            <div className="form-group">
              <label htmlFor="account-type">Loại tài khoản</label>
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
              <label htmlFor="confirm-password">Xác nhận mật khẩu</label>
              <input
                type="password"
                id="confirm-password"
                placeholder="Nhập lại mật khẩu của bạn"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
              />
            </div>

            <button type="submit" className="auth-button">
              Đăng Ký
            </button>
            <p className="auth-text">
              Đã có tài khoản? <a href="/log_in">Đăng nhập ngay</a>
            </p>
          </form>
        </div>
      </div>
    </div>
  );
};

export default SignUp;
