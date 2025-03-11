require('dotenv').config(); // Pastikan .env dibaca pertama kali
const express = require('express');
const cors = require('cors'); // Tambahkan CORS untuk akses frontend
const app = express();

// Import routes
const firebaseRoute = require("./routes/firebase/firebaseRoute");
const midtransRoute = require("./routes/midtrans/midtransRoute");

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// routes
app.use("/topups", firebaseRoute);
app.use("/api/payment", midtransRoute);

// Tentukan port, gunakan default jika tidak ada di .env
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`✅ Server is running on port ${PORT}`);
});