import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:splitit/const.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/ui/auth/signin.dart';
import 'package:splitit/ui/auth/signup.dart';
import 'package:splitit/ui/auth/verifyotp.dart';
import 'package:splitit/ui/home/home.dart';
import 'package:splitit/ui/onboading/onboarding.dart';
import 'package:splitit/ui/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configLoading();
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.doubleBounce
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'YBit',
        theme: ThemeData(
            fontFamily: GoogleFonts.secularOne().fontFamily,
            colorScheme: ColorScheme.fromSwatch(
                accentColor: Colors.red, primarySwatch: orangeSwatch),
            primaryColor: orangeColor),
        initialRoute: '/splash/',
        routes: {
          '/onboarding/': (context) => const OnboardingScreen(),
          '/signin/': (context) => SignInScreen(),
          '/signup/': (context) => SignUpScreen(),
          '/home/': (context) => const HomeScreen(),
          '/splash/': (context) => const SplashScreen(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
