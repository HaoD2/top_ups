import 'dart:convert';
import 'package:http/http.dart' as http;
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
        print(response.body);
        return true; // Login sukses
      } else {
        print(response.body);
        return false; // Login gagal
      }
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/logout'));
      return response.statusCode == 200;
    } catch (error) {
      print('Error during logout: $error');
      return false;
    }
  }

  Stream<String?> get authStateChange async* {
    yield _token; // Emit token (jika null, berarti tidak login)
  }
}

class baseURL {
  static String url = "http://192.168.1.9:8000"; // Emulator Android
}
