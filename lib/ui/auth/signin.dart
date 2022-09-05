import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/ui/auth/verifyotp.dart';
import 'package:splitit/utils/appTextField.dart';
import 'package:splitit/utils/titleAndSubtitle.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  TextEditingController _phoneNumberController =
      TextEditingController(text: '+91');

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: _size.height * 0.05,
                left: _size.width * 0.06,
                right: _size.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleAndSubtitleWidget(
                    title: 'Sign In Now',
                    subtitle: 'Please enter your phone number below.'),
                SizedBox(
                  height: _size.height * 0.04,
                ),
                AppTextField(
                  hint: '',
                  label: 'Phone Number',
                  controller: _phoneNumberController,
                  suffix: const Icon(Icons.phone),
                  maxLength: 13,
                  inputType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (value.length < 13) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: _size.height * 0.04,
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool res =
                        await Provider.of<AuthProvider>(context, listen: false)
                            .checkIfUserExists(_phoneNumberController.text);

                    if (res) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => VerifyOTPScreen(
                                  phoneNumber: _phoneNumberController.text))));
                    } else {
                      Fluttertoast.showToast(
                          msg: 'User does not exist! Please sign up.');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign In',
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                        Size(_size.width * 0.9, _size.height * 0.06)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _size.height * 0.035,
                ),
                // DividerWithText('or Login with'),
                // SizedBox(
                //   height: _size.height * 0.035,
                // ),
                // Align(
                //   alignment: Alignment.center,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       border: Border.all(color: Colors.grey.shade200),
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(15),
                //       child: SizedBox(
                //           width: _size.width * 0.1,
                //           child: Image.asset('assets/icons/google.png')),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: _size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup/');
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(
                                decoration: TextDecoration.underline)))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
