import axios from "./axios.customize";

const createBuyer = (username, email, password)=> {
    const URL_API = "/users/buyers";
    const data = {
        username, email, password
    }
    console.log(data)
    return axios.post(URL_API,data)
}

const createSeller = (username, email, password)=> {
    const URL_API = "/users/sellers";
    const data = {
        username, email, password
    }
    return axios.post(URL_API,data)
}

const loginBuyer = (username, password)=> {
    const URL_API = "/users/buyers";
    const data = {
         username, password
    }
    return axios.post(URL_API,data)
}

const loginSeller = (username, password)=> {
    const URL_API = "/users/sellers";
    const data = {
         username, password
    }
    return axios.post(URL_API,data)
}

const getAllProduct = () => {
    const URL_API = "/all/products/";
    return axios.get(URL_API)
}

const updateCartAmount = (variation_id, amount)=> {
    const URL_API = "/buyers/cart/update/bibimoni";
    const data = {
        variation_id, amount
    }
    return axios.post(URL_API,data)
}

const removeCartItem = (variation_id)=> {
    const URL_API = "/buyers/cart/update/bibimoni";
    const amount = 0
    const data = {
        variation_id, amount
    }
    return axios.post(URL_API,data)
}

const getProductById = (id) => {
    const URL_API = `/products/${id}`; // Chèn id vào URL
    return axios.get(URL_API)
}

const getCart = () => {
    const URL_API = "/buyers/cart/bibimoni";
    return axios.get(URL_API)
}

const getAllVariations = (id) => {
    const URL_API = `/products/variations/${id}`; // Chèn id vào URL
    return axios.get(URL_API)
}

const getVariationInfo = (id) => {
    const URL_API = `/variations/info/${id}`; // Chèn id vào URL
    return axios.get(URL_API)
}

const getBestSales = (id, date) => {
    const URL_API = `/shop/users/sellers/${id}`;
    const data = {
        date
    };
    return axios.post(URL_API, data);
}



export {
    createBuyer,
    createSeller,
    loginSeller,
    loginBuyer,
    getAllProduct,
    getProductById,
    getCart,
    removeCartItem,
    updateCartAmount,
    getAllVariations,
    getVariationInfo,
    getBestSales
}