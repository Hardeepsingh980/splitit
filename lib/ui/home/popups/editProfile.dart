import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/utils/appTextField.dart';

showEditProfileDialog(BuildContext context) {
  showDialog(context: context, builder: (_) => EditProfileDialog());
}

class EditProfileDialog extends StatefulWidget {
  EditProfileDialog({Key? key}) : super(key: key);

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _upiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _nameController.text =
          Provider.of<AuthProvider>(context, listen: false).curUser!.name;
      _upiController.text =
          Provider.of<AuthProvider>(context, listen: false).curUser!.upiAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              const Text(
                'Full Name',
                textScaleFactor: 1.2,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: 'Enter your name',
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              const Text(
                'UPI Address',
                textScaleFactor: 1.2,
              ),
              const SizedBox(height: 10),
              AppTextField(
                hint: 'Your UPI address',
                controller: _upiController,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false)
                        .updateUserDetails(
                            _nameController.text, _upiController.text);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Save',
                      textScaleFactor: 1.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: orangeColor,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signOutCurUser();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/splash/', (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Logout',
                      textScaleFactor: 1.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
