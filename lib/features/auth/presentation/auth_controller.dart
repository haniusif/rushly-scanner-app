import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/providers.dart';
import '../data/auth_repository.dart';

class AuthState {
  const AuthState({this.userEmail, this.isLoading = false, this.error});
  final String? userEmail;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => userEmail != null;

  AuthState copyWith({String? userEmail, bool? isLoading, String? error}) =>
      AuthState(
        userEmail: userEmail ?? this.userEmail,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AuthController extends Notifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  AuthState build() => const AuthState();

  Future<bool> restore() async {
    final token = await ref.read(tokenStorageProvider).readToken();
    if (token == null || token.isEmpty) return false;
    try {
      await _repo.profile();
      state = const AuthState(userEmail: 'unknown');
      return true;
    } catch (_) {
      await ref.read(tokenStorageProvider).clear();
      state = const AuthState();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.login(email: email, password: password);
      state = AuthState(userEmail: email);
      return true;
    } catch (e) {
      state = AuthState(error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
