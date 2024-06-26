
import 'package:melonandmelon/data/provider/auth_provider.dart';
import 'package:melonandmelon/data/provider/user_provider.dart';
import 'package:melonandmelon/data/service_locator.dart';
import 'package:melonandmelon/models/user_model.dart';
import 'package:melonandmelon/utilities/packages.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  final _authService = service<AuthProvider>();
  final _userService = service<UserProvider>();
  AuthCubit() : super(AuthenticationState());

  Future<void> signInWithGoogle() async {
    try {
      emit(state.copyWith(
        status: AuthStatus.loading,
        message: "Signing in with Google...",
      ));
      final response = await _authService.signInWithGoogle();
      if(!response){
        emit(state.copyWith(
          status: AuthStatus.error,
          message: "Failed to sign in with Google",
        ));
        return;
      }
      emit(state.copyWith(
        status: AuthStatus.success,
        message: "Signed in with Google",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        message: e.toString().toException(),
      ));
    }
  }

  Future<void> signOut() async {
    try {
      emit(state.copyWith(
          status: AuthStatus.loading, message: "Signing out..."));
      await _authService.signOutUser();
      emit(state.copyWith(status: AuthStatus.success, message: "Signed out"));
    } catch (error) {
      emit(state.copyWith(
          status: AuthStatus.error, message: error.toString().toException()));
    }
  }
}

enum AuthStatus { initial, loading, success, error }

class AuthenticationState {
  final UserModel? user;
  final AuthStatus status;
  final String message;
  AuthenticationState({
    this.user,
    this.status = AuthStatus.initial,
    this.message = "",
  });

  AuthenticationState copyWith({
    UserModel? user,
    AuthStatus status = AuthStatus.initial,
    String message = "",
  }) {
    return AuthenticationState(
      user: user ?? this.user,
      status: status,
      message: message,
    );
  }
}
