import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

import 'package:bash_test/data/service/service_locator.dart';
import 'package:bash_test/utilities/packages.dart';
import 'package:melonandmelon/utilities/packages.dart';

import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // add the git it locator
  //initLocator();
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
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return MaterialApp.router(
        routerConfig: AppRouter.appRouter,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        title: "melonandmelon",
      );
    });
  }
}

    