import express from 'express';
import colors from 'colors';
import cors from 'cors';

import dotenv from 'dotenv';
import connectDB from './config/db.js';
import bookRoutes from './routes/bookRoutes.js'

dotenv.config()
connectDB()

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5001;

// Health endpoint for ALB
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.use('/api/books/', bookRoutes)

app.listen(PORT, () => {
    console.log(`Server running in ${process.env.NODE_ENV} and listening on PORT ${PORT}`.blue)
  })

app.get('/', (req, res) => {
    res.send('API is running...')
})

