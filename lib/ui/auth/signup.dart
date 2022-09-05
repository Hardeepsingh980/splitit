import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/ui/auth/verifyotp.dart';
import 'package:splitit/utils/appTextField.dart';
import 'package:splitit/utils/titleAndSubtitle.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController(
    text: '+91',
  );
  TextEditingController _upiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleAndSubtitleWidget(
                      title: 'Sign Up Now',
                      subtitle: 'Please enter details below to join us.'),
                  SizedBox(
                    height: _size.height * 0.05,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: AppTextField(
                          hint: '',
                          label: 'First Name',
                          controller: _firstNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: _size.width * 0.05,
                      ),
                      Flexible(
                        child: AppTextField(
                          hint: '',
                          label: 'Last Name',
                          controller: _lastNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _size.height * 0.03,
                  ),
                  AppTextField(
                    hint: '',
                    label: 'Phone Number',
                    suffix: const Icon(Icons.phone),
                    controller: _phoneNumberController,
                    maxLength: 13,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length < 13) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    inputType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: _size.height * 0.02,
                  ),
                  AppTextField(
                    hint: '',
                    label: 'UPI Address',
                    suffix: const Icon(Icons.account_balance_wallet),
                    controller: _upiController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter upi id';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid upi address';
                      }
                      return null;
                    },
                    inputType: TextInputType.text,
                  ),
                  SizedBox(
                    height: _size.height * 0.02,
                  ),
                  SizedBox(
                    height: _size.height * 0.04,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyOTPScreen(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      phoneNumber: _phoneNumberController.text,
                                      upiAddress: _upiController.text,
                                      isLogin: false,
                                    )));
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Sign Up',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signin/');
                          },
                          child: const Text('Sign In',
                              style: TextStyle(
                                  decoration: TextDecoration.underline)))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
