import express from 'express';
const app = express();
const port = 3000;
import getRoutes from './api/get.js';
import postRoutes from './api/post.js';

app.use(express.json());

app.use('/', getRoutes);
app.use('/', postRoutes);

app.listen(port, () => {
  console.log(`Hello from ${port}`);
});

export { app };
