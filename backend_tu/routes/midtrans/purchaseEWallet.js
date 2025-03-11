const express = require("express");

module.exports = (coreApi) => {
    const router = express.Router();

    router.post('/OVO', async (req, res) => {
        try {
            console.log("Received request body:", req.body);
        } catch (e) {

        }
    });

    router.post('/Shoopepay', async (req, res) => {
        try {
            console.log("Received request body:", req.body);
        } catch (e) {

        }
    });


    return router;
};