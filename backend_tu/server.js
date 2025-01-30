
const express = require('express');
const app = express();
const firebaseRoute = require("./routes/firebaseRoute");
const midtransRoute = require("./routes/midtransRoute");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/topups", firebaseRoute);
app.use("/api/payment/", midtransRoute);






const PORT = process.env.PORT || 8000;

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
});
