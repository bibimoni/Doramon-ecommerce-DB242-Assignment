import React from 'react'
import './DropDown.css'

const DropDown = () => {
  return (
    <div className='flex flex-col dropDown'>
      <ul className="list-none bg-white shadow-lg rounded-md p-4 w-60">
        {/* Profile */}
        <li className="font-bold text-gray-800 mb-2 text-2xl text-red-500">
            Doraemon nè
        </li>
        {/* Quản lý tài khoản */}
        <li>
            <a
                href="/"
                className="text-black hover:text-black hover:underline transition duration-200"
            >
                Quản lý tài khoản
            </a>
        </li>

        {/* Đăng xuất */}
        <li className="mt-4">
            {/* <button
            // onClick={handleLogout}
            className="w-full bg-red-500 text-white py-2 px-4 rounded-md hover:bg-red-600 transition"
            >
              
            Đăng xuất
            </button> */}
            <a href="/log_in">Đăng xuất</a>
        </li>
        </ul>
    </div>
  )
}

export default DropDown
