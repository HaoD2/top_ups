const express = require("express");
const router = express.Router();
const midtransClient = require("midtrans-client");

// Konfigurasi Midtrans
const coreApi = new midtransClient.CoreApi({
    isProduction: false,
    serverKey: process.env.MIDTRANSSERVERKEY,
    clientKey: process.env.MIDTRANSCLIENTKEY
});

// Import routes serta akses `coreApi` untuk Purchase
const purchaseBankRoutes = require("./purchaseBank")(coreApi);
router.use("/purchaseBank", purchaseBankRoutes);

const purchaseEwalletRoutes = require("./purchaseEWallet")(coreApi);
router.use("/purchaseEwallet", purchaseEwalletRoutes);

const snapRoutes = require("./snapMidtrans")(coreApi);
router.use("/Snap", snapRoutes);

// Ekspor router
module.exports = router;