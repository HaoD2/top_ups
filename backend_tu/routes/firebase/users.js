const express = require("express");
const router = express.Router();
const admin = require("firebase-admin");

// Signup user
router.post("/signup", async (req, res) => {
    try {
        const { email, password } = req.body;

        // Validasi input
        if (!email || !password) {
            return res.status(400).json({ message: "Email and password are required." });
        }

        // Membuat pengguna baru di Firebase Authentication
        const userResponse = await admin.auth().createUser({
            email: email,
            password: password,
            emailVerified: false,
            disabled: false,
        });

        return res.status(201).json({
            success: true,
            message: "User created successfully",
            userId: userResponse.uid,
        });
    } catch (error) {
        console.error("Error creating user:", error);

        // Handling error lebih spesifik
        let errorMessage = "Failed to create user";
        if (error.code === "auth/email-already-exists") {
            errorMessage = "Email is already in use";
        }

        return res.status(500).json({
            success: false,
            message: errorMessage,
            error: error.message,
        });
    }
});

// Verifikasi token Firebase
router.post("/verifyToken", async (req, res) => {
    try {
        const { idToken } = req.body;

        if (!idToken) {
            return res.status(400).json({ message: "ID Token is required." });
        }

        // Verifikasi ID Token dengan Firebase Admin SDK
        const decodedToken = await admin.auth().verifyIdToken(idToken);

        return res.status(200).json({
            success: true,
            message: "Token valid",
            uid: decodedToken.uid,
            email: decodedToken.email,
        });
    } catch (error) {
        console.error("Error verifying ID token:", error);
        return res.status(403).json({
            success: false,
            message: "Invalid ID Token.",
            error: error.message,
        });
    }
});

module.exports = router;
