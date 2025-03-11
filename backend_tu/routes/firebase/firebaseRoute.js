const express = require("express");
const router = express.Router();
const bodyParser = require("body-parser");
const admin = require("firebase-admin");
const usersRoutes = require("./users");

// Middleware untuk parsing JSON
router.use(bodyParser.json());

// Pastikan Firebase hanya di-inisialisasi sekali
if (!admin.apps.length) {
    const credentials = require("../../serviceAccountKey.json");
    admin.initializeApp({
        credential: admin.credential.cert(credentials),
        databaseURL: "https://topupsapps-default-rtdb.firebaseio.com/",
    });
}

// Gunakan usersRoutes
router.use("/users", usersRoutes);

module.exports = router;
