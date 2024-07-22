import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/data/repository/socket_repository.dart';
import 'package:melonandmelon/data/service_locator.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://rqasbzdofzhwbqnhtxot.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJxYXNiemRvZnpod2Jxbmh0eG90Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYwMzQ3NjAsImV4cCI6MjAzMTYxMDc2MH0.yI4LQd0l7Atuhb9EDcxhTqH4zBmjZFG_WUIs91HvRJ8',
    debug: false,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initLocator();
  await SocketRepository().connect();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => UserCubit()..getUser(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => PostCubit()..getPosts(),
        ),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        SizeConfig().init(constraints);
        return MaterialApp.router(
          routerDelegate: appRouter.routerDelegate,
          routeInformationParser: appRouter.routeInformationParser,
          routeInformationProvider: appRouter.routeInformationProvider,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          title: "melonandmelon",
        );
      }),
    );
  }
}
