import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/models/trip.dart';
import 'package:splitit/models/userModel.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/ui/home/selectFromContact.dart';
import 'package:splitit/utils/appTextField.dart';

showAddPaymentDialog(BuildContext context, Trip trip) {
  showDialog(
      context: context,
      builder: (_) => AddPaymentDialog(
            trip: trip,
          ));
}

class AddPaymentDialog extends StatefulWidget {
  Trip trip;
  AddPaymentDialog({Key? key, required this.trip}) : super(key: key);

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  List<UserModel> selectedContacts = [];

  TextEditingController _paymentNameController = TextEditingController();
  TextEditingController _paymentAmountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Payment',
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Name',
                  textScaleFactor: 1.2,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  hint: 'Enter Payment Name',
                  controller: _paymentNameController,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Add Payment Amount',
                  textScaleFactor: 1.2,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  hint: 'Enter Payment Amount',
                  inputType: TextInputType.number,
                  controller: _paymentAmountController,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Payment Members',
                  textScaleFactor: 1.2,
                ),
                const SizedBox(height: 10),
                ...List.generate(widget.trip.users.length, (index) {
                  if (widget.trip.users[index].uid ==
                      Provider.of<AuthProvider>(context, listen: false)
                          .curUser!
                          .uid) {
                    return Container();
                  }

                  return ListTile(
                    trailing: Checkbox(
                      value: selectedContacts
                          .map((e) => e.uid)
                          .contains(widget.trip.users[index].uid),
                      onChanged: (v) {
                        setState(() {
                          if (v!) {
                            selectedContacts.add(UserModel(
                                uid: widget.trip.users[index].uid,
                                name: widget.trip.users[index].name,
                                phoneNumber:
                                    widget.trip.users[index].phoneNumber,
                                upiAddress:
                                    widget.trip.users[index].upiAddress));
                          } else {
                            selectedContacts.removeWhere((element) =>
                                element.uid == widget.trip.users[index].uid);
                          }
                          setState(() {
                            selectedContacts = selectedContacts;
                          });
                        });
                      },
                    ),
                    title: Text(widget.trip.users[index].name,
                        textScaleFactor: 0.8),
                    leading: CircleAvatar(
                      backgroundColor:
                          index % 2 == 0 ? orangeColor : Colors.redAccent,
                      child: Center(
                          child: Text(
                        widget.trip.users[index].name[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedContacts.length > 0) {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .addPayment(
                                  widget.trip,
                                  _paymentNameController.text,
                                  double.parse(_paymentAmountController.text),
                                  selectedContacts);
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
                        'Add Payment',
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
