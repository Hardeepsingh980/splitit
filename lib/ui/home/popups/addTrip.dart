import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/models/userModel.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/ui/home/selectFromContact.dart';
import 'package:splitit/utils/appTextField.dart';

showAddTripDialog(BuildContext context) {
  showDialog(context: context, builder: (_) => AddTripDialog());
}

class AddTripDialog extends StatefulWidget {
  AddTripDialog({Key? key}) : super(key: key);

  @override
  State<AddTripDialog> createState() => _AddTripDialogState();
}

class _AddTripDialogState extends State<AddTripDialog> {
  TextEditingController _nameController = TextEditingController();

  List<UserModel> selectedContacts = [];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Form(
        key: _formKey,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Trip',
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Trip Name',
                  textScaleFactor: 1.2,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  hint: 'Enter Trip Name',
                  controller: _nameController,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Trip Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Trip Members',
                  textScaleFactor: 1.2,
                ),
                TextButton(
                    onPressed: () async {
                      selectedContacts = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectFromContacts()));
                      setState(() {
                        selectedContacts = selectedContacts;
                      });
                    },
                    child: Text('Select From Contacts')),
                LimitedBox(
                  maxHeight: 28,
                  maxWidth: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedContacts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Align(
                        widthFactor: 0.6,
                        child: ClipOval(
                          child: Container(
                            color: index % 2 == 0
                                ? Colors.redAccent
                                : Colors.orangeAccent,
                            child: Container(
                                height: 28,
                                width: 28,
                                child: Center(
                                  child: Text(selectedContacts[index]
                                      .name[0]
                                      .toUpperCase()),
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedContacts.length > 0) {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .addTrip(_nameController.text, selectedContacts);
                          Navigator.pop(context);
                        } else {
                          EasyLoading.showError(
                              'Please select atleast one member');
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Add Trip',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
