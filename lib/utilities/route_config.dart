import 'package:melonandmelon/utilities/packages.dart';
import 'package:melonandmelon/views/authentication/welcome.dart';
import 'package:melonandmelon/views/home.dart';
import 'package:melonandmelon/views/home/home_page.dart';
import 'package:melonandmelon/views/profile/profile_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouter =
    GoRouter( initialLocation: '/home', routes: [
  GoRoute(
    path: '/welcome',
    name: Routes.welcome,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: WelcomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
    redirect: (context, state) {
      final user = supabase.auth.currentUser;
      if (user != null) {
        return '/home';
      }
      return null;
    },
  ),
  ShellRoute(
    navigatorKey: navigatorKey,
    builder: (context, state, child) => Home(child: child),
    routes: [
      GoRoute(
        path: '/home',
        name: Routes.home,
        pageBuilder: (context, state) =>MaterialPage(child: HomePage()),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/profile',
        name: Routes.profile,
        pageBuilder: (context, state) =>MaterialPage(child: ProfilePage()),
        
      ),
    ],
  ),
]);

class Routes {
//* Authentication
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String profile = '/profile';
}
