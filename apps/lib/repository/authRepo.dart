import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  String baseUrl = baseURL.url;
  String? _token; // Untuk menyimpan token autentikasi

  Future<bool> login(data) async {
    try {
      // Autentikasi pengguna dengan email dan password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );

      // Mendapatkan token ID pengguna yang telah login
      String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      if (idToken == null) {
        return false;
      }

      // Kirim token ke backend untuk verifikasi
      final response = await http.post(
        Uri.parse('$baseUrl/topups/verifyToken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        _token = idToken; // Simpan token di variabel
        await _saveToken(idToken); // Simpan token di SharedPreferences
        return true; // Login sukses
      } else {
        return false; // Login gagal
      }
    } catch (error) {
      print('Error during logout: $error');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/logout'));
      await FirebaseAuth.instance.signOut(); // Logout dari Firebase
      await _removeToken(); // Hapus token dari SharedPreferences
      return true;
    } catch (error) {
      print('Error during logout: $error');
      return false;
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  Future<void> _removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print('Error removing token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  Stream<String?> get authStateChange async* {
    yield _token; // Emit token (jika null, berarti tidak login)
  }
}

class baseURL {
  static String url = "https://famous-mastiff-sunny.ngrok-free.app";
}
