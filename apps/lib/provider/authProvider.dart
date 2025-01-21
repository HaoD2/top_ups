import 'package:firebase_auth/firebase_auth.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_ups/repository/authRepo.dart';

class Auth {
  final bool isLogin;
  Auth(this.isLogin);
}

class AuthNotifier extends StateNotifier<Auth> {
  AuthNotifier() : super(Auth(false));
  void isLogin(bool data) {
    state = new Auth(data);
  }
}

final authProvider = StateNotifierProvider((ref) => new AuthNotifier());
