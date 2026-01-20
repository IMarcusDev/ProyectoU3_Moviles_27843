import 'package:flutter_riverpod/legacy.dart';
import 'package:turismo_app/core/domain/entities/user.dart';

class AuthState {
  final User? user;

  const AuthState({this.user});

  bool get isAuthenticated => user != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void setUser(User user) {
    state = AuthState(user: user);
  }

  Future<void> logout() async {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
