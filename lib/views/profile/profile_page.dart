import 'package:flutter/services.dart';
import 'package:melonandmelon/utilities/packages.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
        centerTitle: true,
        backgroundColor: white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
      backgroundColor: white,
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Welcome to the Profile Page',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'This is the profile page of the app',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}