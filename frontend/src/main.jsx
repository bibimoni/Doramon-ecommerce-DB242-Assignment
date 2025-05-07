import React from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";

import Home from './pages/Home/Home.jsx';
import SignUp from './pages/Auth/SignUp.jsx';
import Login from './pages/Auth/Login.jsx';
import Seller from './pages/Seller/Seller.jsx';
import ProductDetail from './pages/ProductDetail/ProductDetail.jsx';
import Cart from './pages/Cart/Cart.jsx';

const router = createBrowserRouter([
  {
    path: "/",
    element: <App/>,
    children: [
      {
        index: true,
        element: <Home/>
      },
      {
        path: "product/:id",
        element: <ProductDetail/>
      },
      {
        path: "cart",
        element: <Cart/>
      },
    ]
  },
  {
    path: "/sign_up",
    element: <SignUp></SignUp>
  },
  {
    path: "/log_in",
    element: <Login></Login>
  },
  {
    path: "/seller",
    element: <Seller></Seller>
  },
]);


createRoot(document.getElementById('root')).render(
  <React.StrictMode>
      <RouterProvider router={router} /> 
  </React.StrictMode>
)
