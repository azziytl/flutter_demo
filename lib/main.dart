import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isNewUser = prefs.getBool('isNewUser') ?? true;

  runApp(MyApp(isNewUser: isNewUser));
}

class MyApp extends StatelessWidget {
  final bool isNewUser;
  const MyApp({Key? key, required this.isNewUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isNewUser
          ? OnboardingPage(isNewUser: isNewUser)
          : MyHomePage(
              title: "List of Attendance",
            ),
    );
  }
}
