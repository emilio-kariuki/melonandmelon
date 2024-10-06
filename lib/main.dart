import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/data/repository/socket_repository.dart';
import 'package:melonandmelon/data/service_locator.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:flutter/services.dart';
import 'package:melonandmelon/views/home/components/image_section.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://yuncjcovtdfuolflkbxz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl1bmNqY292dGRmdW9sZmxrYnh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgxNDY1OTUsImV4cCI6MjA0MzcyMjU5NX0.2VglkBD8cjKyHM2XAy25WVCZOBW2YOPfR1kwMeKYR28',
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
  runApp(MultiBlocProvider(
    providers: [
      ChangeNotifierProvider(lazy: false, create: (context) => PageProvider()),
    ],
    child: const MainApp(),
  ));
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
          create: (context) => PostCubit()..getPosts()..getUserPosts(),
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
