import 'package:firebase_auth/firebase_auth.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_ups/pages/state/loginstate.dart';
import 'package:top_ups/repository/authRepo.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// StreamProvider untuk memantau perubahan autentikasi
final authStateProvider = StreamProvider<String?>((ref) {
  return ref.read(authRepositoryProvider).authStateChange;
});

// Provider untuk LoginNotifier
final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return LoginNotifier(authRepository);
  },
);
