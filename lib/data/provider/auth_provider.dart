import 'package:melonandmelon/data/repository/auth_repository.dart';

class AuthProvider extends AuthTemplate {
  final AuthRepository _authRepository;
  AuthProvider({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<bool> signInWithApple() {
    return _authRepository.signInWithApple();
  }

  @override
  Future<bool> signInWithGoogle() {
    return _authRepository.signInWithGoogle();
  }

  @override
  Future<void> signOutUser() {
    return _authRepository.signOutUser();
  }
}
