import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  static String url = "http://localhost:8000/api/";
  final Dio _dio = Dio();
  Future<bool> login(data) async {
    try {
      Response response =
          await _dio.post(url + 'sanctum/token', data: json.encode(data));
      return true;
    } catch (error) {
      return false;
    }
  }
}
