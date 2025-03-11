const express = require("express");
const midtransClient = require("midtrans-client"); // Pastikan sudah di-import

module.exports = (coreApi) => {
    const router = express.Router();

    router.post('/purchase', async (req, res) => {
        res.setHeader('Accept', 'application/json');
        res.setHeader('Content-Type', 'application/json');

        try {
            console.log("🔍 Incoming request:", req.body); // Log request body

            const data = req.body;
            if (!data || !data.transaction_detail || !data.customer_detail || !data.item_details) {
                console.error("❌ Invalid request format:", data);
                return res.status(400).json({ message: 'Invalid parameter' });
            }

            console.log("✅ Valid request data received");

            // Buat instance Snap Midtrans
            const snap = new midtransClient.Snap({
                isProduction: false, // Ubah ke true jika sudah live
                serverKey: process.env.MIDTRANSSERVERKEY,
                clientKey: process.env.MIDTRANSCLIENTKEY
            });

            // Pastikan item_details berbentuk array
            if (!Array.isArray(data.item_details)) {
                console.error("❌ item_details harus berupa array:", data.item_details);
                return res.status(400).json({ message: 'item_details harus berupa array' });
            }

            // Konfigurasi parameter transaksi
            const param = {
                transaction_details: {
                    order_id: data.transaction_detail.order_id,
                    gross_amount: data.transaction_detail.gross_amount,
                },
                item_details: data.item_details.map(item => ({
                    id: item.id,
                    name: item.item_game || "Unknown Item",
                    price: item.price,
                    quantity: 1
                })),
                customer_details: {
                    email: data.customer_detail.user,
                }
            };

            console.log("🛒 Transaction parameters:", JSON.stringify(param, null, 2));

            // Buat transaksi di Midtrans
            const transaction = await snap.createTransaction(param);
            const transaction_token = transaction.token;
            const transaction_redirect = transaction.redirect_url;

            console.log("✅ Transaction created:", transaction_token);
            console.log("🔗 Redirect URL:", transaction_redirect);

            return res.status(200).json({
                token: transaction_token,
                redirect: transaction_redirect
            });

        } catch (ex) {
            console.error("❌ Error saat membuat transaksi:", ex.message);
            return res.status(500).json({ message: ex.message });
        }
    });

    return router;
};
