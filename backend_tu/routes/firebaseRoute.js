const { response } = require("express");
const express = require("express");
const router = express.Router();

const bodyParser = require('body-parser');
router.use(bodyParser.json());
const admin = require('firebase-admin');
const credentials = require("../serviceAccountKey.json");

admin.initializeApp({
    credential: admin.credential.cert(credentials),
    databaseURL: 'https://topupsapps-default-rtdb.firebaseio.com/'
});



router.post('/signup', async (req, res) => {
    try {
        // Validasi input
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required.' });
        }

        // Membuat pengguna baru
        const userResponse = await admin.auth().createUser({
            email: email,
            password: password,
            emailVerified: false,
            disabled: false,
        });

        // Berikan respons sukses
        return res.status(201).json({
            message: 'User created successfully',
            userId: userResponse.uid,
        });
    } catch (error) {
        console.error('Error creating user:', error);
        return res.status(500).json({
            message: 'Failed to create user',
            error: error.message,
        });
    }
});



module.exports = router;