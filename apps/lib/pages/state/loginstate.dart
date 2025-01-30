import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_ups/repository/authRepo.dart';


final navigatorProvider = Provider<NavigatorState>((ref) {
  // Mengambil context dari aplikasi dan mengembalikan navigatorState
  return Navigator.of(ref.read(navigatorKeyProvider).currentContext!);
});

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

// LoginState sesuai yang kamu buat
class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginStateInitial extends LoginState {
  const LoginStateInitial();

  @override
  List<Object> get props => [];
}

class LoginStateLoading extends LoginState {
  const LoginStateLoading();

  @override
  List<Object> get props => [];
}

class LoginStateSuccess extends LoginState {
  const LoginStateSuccess();

  @override
  List<Object> get props => [];
}

class LoginStateError extends LoginState {
  final String error;

  const LoginStateError(this.error);

  @override
  List<Object> get props => [error];
}

// LoginNotifier untuk mengelola LoginState
class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  LoginNotifier(this._authRepository,this._ref) : super(const LoginStateInitial());

  // Fungsi login
  Future<void> login(Map<String, dynamic> data) async {
    state = const LoginStateLoading();
    try {
      final success = await _authRepository.login(data);
      if (success) {
        state = const LoginStateSuccess();
        _ref.read(navigatorProvider).pushReplacementNamed('/home');
      } else {
        state = const LoginStateError('Login failed');
      }
    } catch (e) {
      state = LoginStateError(e.toString());
    }
  }

  // Fungsi logout
  Future<void> logout() async {
    state = const LoginStateLoading();
    try {
      final success = await _authRepository.logout();
      if (success) {
        state = const LoginStateInitial();
      } else {
        state = const LoginStateError('Logout failed');
      }
    } catch (e) {
      state = LoginStateError(e.toString());
    }
  }
}
