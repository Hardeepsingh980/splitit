// ignore_for_file: file_names

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/provider/AuthProvider.dart';

class VerifyOTPScreen extends StatelessWidget {
  String phoneNumber;
  String? firstName;
  String? lastName;
  String? upiAddress;
  bool isLogin;
  VerifyOTPScreen(
      {Key? key,
      required this.phoneNumber,
      this.isLogin = true,
      this.firstName,
      this.lastName,
      this.upiAddress})
      : super(key: key);

  TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return FirebasePhoneAuthProvider(
      child: Scaffold(
          backgroundColor: scaffoldBackground,
          body: SafeArea(
              child: SingleChildScrollView(
                  child: FirebasePhoneAuthHandler(
            phoneNumber: phoneNumber,
            signOutOnSuccessfulVerification: false,
            linkWithExistingUser: false,
            autoRetrievalTimeOutDuration: const Duration(seconds: 60),
            otpExpirationDuration: const Duration(seconds: 60),
            onLoginSuccess: (userCredential, autoVerified) async {
              if (!isLogin) {
                await Provider.of<AuthProvider>(context, listen: false)
                    .registerUser(
                        userCredential, firstName!, lastName!, upiAddress!);
              }
              Navigator.pushNamedAndRemoveUntil(
                  context, '/splash/', (route) => false);
            },
            onLoginFailed: (authException, stackTrace) {
              print(stackTrace);
              switch (authException.code) {
                case 'invalid-phone-number':
                  return Fluttertoast.showToast(msg: 'Invalid phone number!');
                case 'invalid-verification-code':
                  return Fluttertoast.showToast(
                      msg: 'The entered OTP is invalid!');
                default:
                  Fluttertoast.showToast(msg: 'Something went wrong!');
              }
            },
            builder: (context, controller) {
              return Padding(
                  padding: EdgeInsets.only(
                      top: _size.height * 0.05,
                      left: _size.width * 0.06,
                      right: _size.width * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _size.height * 0.04),
                        child: const Text(
                          "Verify your phone number",
                          textScaleFactor: 2.3,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Type the verification code we've sent you at $phoneNumber",
                        textScaleFactor: 1.2,
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: _size.height * 0.03,
                      ),
                      OtpTextField(
                        numberOfFields: 6,
                        borderColor: Colors.grey.shade200,
                        fillColor: orangeColor,
                        cursorColor: orangeColor,
                        focusedBorderColor: orangeColor,
                        autoFocus: true,
                        borderRadius: BorderRadius.circular(8),
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                        showFieldAsBox: true,
                        onCodeChanged: (code) {
                          _otpController.text += code;
                        },
                      ),
                      SizedBox(
                        height: _size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't receive code?",
                          ),
                          TextButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, '/signin/');
                              },
                              child: const Text('Resend New Code',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline)))
                        ],
                      ),
                      SizedBox(
                        height: _size.height * 0.02,
                      ),
                      ElevatedButton(
                        onPressed: () {
                            print(_otpController.text);
                            controller.verifyOtp(_otpController.text);
                            _otpController.clear();
                          // Navigator.pushNamed(context, '/home/');
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Verify OTP',
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
                    ],
                  ));
            },
          )))),
    );
  }
}
