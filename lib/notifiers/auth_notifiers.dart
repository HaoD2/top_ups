import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_ups/pages/home.dart';
import 'package:top_ups/services/authServices.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>(
    (ref) => AuthNotifier(ref.watch(authserviceprovider)));

class AuthNotifier extends StateNotifier<bool> {
  final AuthServices _authServices;
  AuthNotifier(this._authServices) : super(false);

  login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      state = true; // Set state to loading
      final value = await _authServices.login(email: email, password: password);

      // Navigate to the home menu after successful login
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const homeMenu()),
      );
    } catch (e) {
      // Handle the error (optional: log the error or show a message)
      print('Login failed: $e');
    }
  }
}
