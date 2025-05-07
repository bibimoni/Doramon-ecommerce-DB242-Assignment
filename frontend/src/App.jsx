import React from 'react';
import { Outlet } from 'react-router-dom';
import Navbar from './components/Navbar/Navbar';
import './App.css'

const App = () => {

  return (
    <div className="app">
      <Navbar />
      <div className="main-content">
        <Outlet/>
      </div>
    </div>
  );
};

export default App;
