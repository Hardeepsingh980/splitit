// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/provider/AuthProvider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<AuthProvider>(context, listen: false).setupInit();
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(context, '/home/', (route) => false);
      } else {
        Navigator.of(context).pushReplacementNamed("/onboarding/");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: orangeColor,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _size.width * 0.25),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
