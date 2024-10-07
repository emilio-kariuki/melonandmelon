import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:melonandmelon/views/authentication/welcome.dart';
import 'package:melonandmelon/views/home.dart';
import 'package:melonandmelon/views/home/home_page.dart';
import 'package:melonandmelon/views/post/post_page.dart';
import 'package:melonandmelon/views/profile/profile_page.dart';
import 'package:melonandmelon/views/search/search_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(initialLocation: '/home', routes: [
  GoRoute(
    path: '/welcome',
    name: Routes.welcome,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: const WelcomePage(),
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
  GoRoute(
    path: '/profile',
    name: Routes.profile,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child:  ProfilePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
    redirect: (context, state) {
      final user = supabase.auth.currentUser;
      if (user != null) {
        return '/profile';
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
        pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
        redirect: (context, state) {
          final user = supabase.auth.currentUser;
          logger.e("user$user");
          if (user == null) {
            return '/welcome';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/search',
        name: Routes.search,
        pageBuilder: (context, state) => const MaterialPage(child: SearchPage()),
      ),
      GoRoute(
        path: '/add',
        name: Routes.add,
        pageBuilder: (context, state) => const MaterialPage(child: AddPostPage()),
      ),
    ],
  ),
]);

class Routes {
//* Authentication
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String add = '/add';
}
