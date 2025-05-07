import express from 'express';
import cors from 'cors';
import getRoutes from './api/get.js';
import postRoutes from './api/post.js';

const app = express();
const port = 3000;

app.use(express.json());

app.use(cors({
  origin: "http://localhost:3001", // Port cua FE
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Sửa dấu ngoặc vuông thành dấu ngoặc đơn
  allowedHeaders: ['Content-Type', 'Authorization'], // Sửa dấu ngoặc vuông thành dấu ngoặc đơn
  credentials: true
}));

app.use('/', getRoutes);
app.use('/', postRoutes);

app.listen(port, () => {
  console.log(`Hello from ${port}`);
});
