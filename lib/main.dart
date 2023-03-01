import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_conferencing/common/colors.dart';
import 'package:video_conferencing/screens/create_meeting.dart';
import 'package:video_conferencing/screens/forget_password_screen.dart';
import 'package:video_conferencing/screens/home_screen.dart';
import 'package:video_conferencing/screens/join_with_code.dart';
import 'package:video_conferencing/screens/login_screen.dart';
import 'package:video_conferencing/screens/meeting_screen.dart';
import 'package:video_conferencing/screens/sign_up_screen.dart';
import 'package:video_conferencing/screens/splash_screen.dart';
import 'package:video_conferencing/screens/verify_email_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final messengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: messengerKey,
      title: 'Meeting Minds',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/splash': (context) => const SplashScreen(),
        // '/meeting': (context) => const MeetingScreen(),
        '/createMeeting': (context) => const CreateMeeting(),
        '/joinMeeting': (context) => const JoinWithCode(),
        '/signUp': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgetPassword': (context) => const ForgetPasswordScreen(),
        '/verifyEmail': (context) => const VerifyEmailScreen(),
      },
    );
  }
}
