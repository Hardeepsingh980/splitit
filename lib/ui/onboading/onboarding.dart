import 'package:flutter/material.dart';
import 'package:splitit/const.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _size.height * 0.16,
            ),
            Image.asset('assets/onboarding.png'),
            SizedBox(
              height: _size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: _size.height * 0.3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        orangeColor.withOpacity(0.7),
                        orangeColor.withOpacity(0.8),
                        orangeColor,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Easy to share bills with your friends, and stop fighting over who needs to pay who.',
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.7,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: _size.height * 0.02),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signin/');
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Get Started',
                              textScaleFactor: 1.2,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
