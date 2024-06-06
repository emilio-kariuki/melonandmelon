
import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/utilities/packages.dart';

class AppRouter {
    static final appRouter = GoRouter(initialLocation: '/welcome', routes: [
        GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child:  Container(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity:animation, child: child),
                ),
        ),
    ]);
}

class AppRoute {
//* Authentication
static const String welcome = '/auth/welcome';
}
