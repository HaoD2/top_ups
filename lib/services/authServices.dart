import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

final authserviceprovider = Provider<AuthServices>((ref) => AuthServices());

class AuthServices {
  bool isLoggedIn = false;

  Future<bool> login({required String email, required String password}) async {
    // Simulate login logic here
    await Future.delayed(Duration(seconds: 2), () {
      isLoggedIn = true;
    });
    return isLoggedIn;
  }
}
