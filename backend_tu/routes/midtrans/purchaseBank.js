const express = require("express");

// Fungsi untuk menerima `coreApi`
module.exports = (coreApi) => {
    const router = express.Router();

    router.post('/BCA', async (req, res) => {
        try {
            console.log("request body:", req.body);

            let { order_id, gross_amount, customer_details, item_details, bank_transfer } = req.body;

            // ✅ Pastikan semua data yang diperlukan ada
            if (!order_id || !customer_details || !item_details || !bank_transfer?.bank) {
                return res.status(400).json({ success: false, message: "Data tidak lengkap atau format bank_transfer salah" });
            }

            // ✅ Hitung ulang total harga dari item_details
            let calculatedGrossAmount = item_details.reduce((total, item) => total + (item.price * item.quantity), 0);

            // ✅ Validasi total harga
            if (calculatedGrossAmount !== gross_amount) {
                return res.status(400).json({
                    success: false,
                    message: `Invalid gross_amount. Expected: ${calculatedGrossAmount}, received: ${gross_amount}`
                });
            }

            let parameter = {
                payment_type: "bank_transfer",
                transaction_details: {
                    gross_amount: calculatedGrossAmount, // Gunakan total yang sudah dihitung
                    order_id: order_id
                },
                customer_details: customer_details,
                item_details: item_details,
                bank_transfer: {
                    bank: bank_transfer.bank // ✅ Hanya kirim bank, VA Number dibuat otomatis oleh Midtrans
                }
            };

            // ✅ Kirim request ke Midtrans
            const midtransResponse = await coreApi.charge(parameter);

            return res.status(200).json({
                success: true,
                message: "Transaksi berhasil dibuat",
                data: midtransResponse
            });

        } catch (error) {
            console.error("Error processing transaction:", error);

            return res.status(500).json({
                success: false,
                message: "Terjadi kesalahan saat memproses transaksi",
                error: error.message
            });
        }
    });



    // Bank BRI VA
    router.post("/pBRI", async (req, res) => {
        try {
            const { order_id, gross_amount, customer, items } = req.body;

            let parameter = {
                payment_type: "bank_transfer",
                transaction_details: { gross_amount, order_id },
                customer_details: customer,
                item_details: items,
                bank_transfer: { bank: "bri" }
            };

            let transaction = await coreApi.charge(parameter);
            res.json({ success: true, transaction });
        } catch (error) {
            res.status(500).json({ success: false, error: error.message });
        }
    });

    // Bank BNI VA
    router.post("/BNI", async (req, res) => {
        try {
            const { order_id, gross_amount, customer, items } = req.body;

            let parameter = {
                payment_type: "bank_transfer",
                transaction_details: { gross_amount, order_id },
                customer_details: customer,
                item_details: items,
                bank_transfer: { bank: "bni" }
            };

            let transaction = await coreApi.charge(parameter);
            res.json({ success: true, transaction });
        } catch (error) {
            res.status(500).json({ success: false, error: error.message });
        }
    });

    // Bank Mandiri VA
    router.post("/Mandiri", async (req, res) => {
        try {
            const { order_id, gross_amount, customer, items } = req.body;

            let parameter = {
                payment_type: "echannel",
                transaction_details: { gross_amount, order_id },
                customer_details: customer,
                item_details: items,
                echannel: { bill_info1: "Payment For:", bill_info2: "HoKTopUp" }
            };

            let transaction = await coreApi.charge(parameter);
            res.json({ success: true, transaction });
        } catch (error) {
            res.status(500).json({ success: false, error: error.message });
        }
    });

    // Status update (untuk webhook Midtrans)
    router.put("/status", (req, res) => {
        res.json({ success: true, message: "Status updated" });
    });

    // Get item details
    router.get("/details/:id", (req, res) => {
        res.json({ success: true, message: `Details for item ${req.params.id}` });
    });

    return router;
};

