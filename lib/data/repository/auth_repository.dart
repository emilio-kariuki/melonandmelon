import 'package:melonandmelon/data/provider/user_provider.dart';
import 'package:melonandmelon/data/repository/notification_repository.dart';
import 'package:melonandmelon/data/service_locator.dart';
import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/models/user_model.dart';
import 'package:melonandmelon/utilities/packages.dart';

abstract class AuthTemplate {
  Future<bool> signInWithGoogle();
  Future<bool> signInWithApple();
  Future<void> signOutUser();
}

class AuthRepository extends AuthTemplate {
  static const webClientId =
      '705137587372-v201aremn8t7tl0q5ruq9d4nrju9ojsv.apps.googleusercontent.com';
  static const iosClientId =
      '705137587372-ovprtp6ggnm72lgihbutdr2h4phjkm1f.apps.googleusercontent.com';

  final GoogleSignIn googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    clientId: iosClientId,
    serverClientId: webClientId,
  );
  final _notificationService = service<NotificationRepository>();
  final _userService = service<UserProvider>();
  @override
  Future<bool> signInWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      AuthResponse response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      logger.d(response);
      final token = await _notificationService.getNotificationToken();
      final created = await _userService.createUser(
        user: UserModel(
          id: response.user!.id,
          name: response.user!.userMetadata?['full_name'],
          email: response.user!.email!,
          image: response.user!.userMetadata?['avatar_url'],
          token: token,
          username: "",
          bio: "",
          links: [],
          phone: "",
        ),
      );
      if (!created) {
        throw Exception('Failed to create user');
      }
      return true;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOutUser() async {
    try {
      await supabase.auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
