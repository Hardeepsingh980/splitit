import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/models/userModel.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/utils/titleAndSubtitle.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class SelectFromContacts extends StatefulWidget {
  const SelectFromContacts({Key? key}) : super(key: key);

  @override
  State<SelectFromContacts> createState() => _SelectFromContactsState();
}

class _SelectFromContactsState extends State<SelectFromContacts> {
  List<UserModel>? contacts;
  List<UserModel> selectedContacts = [];

  @override
  void initState() {
    super.initState();

    _getContacts();
  }

  void _getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> userscontacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
      List<String> usersphones = [];

      userscontacts.forEach((contact) {
        if (contact.phones.isNotEmpty) {
          usersphones.add(contact.phones.first.number.replaceAll(' ', ''));
        }
      });

      contacts = await Provider.of<AuthProvider>(context, listen: false)
          .getUsersFromPhoneNumbers(usersphones);
    }
    setState(() {
      contacts = contacts ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pop(selectedContacts);
            },
            label: Text(
              'Done',
              textScaleFactor: 1.3,
            )),
        body: contacts == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleAndSubtitleWidget(
                                  title: 'Contacts',
                                  subtitle:
                                      'Selects your friends from your contacts who are using SplitIt'),
                              SizedBox(
                                height: 20,
                              ),
                              ...List.generate(
                                  contacts!.length,
                                  (index) => Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: index % 2 == 0
                                                ? orangeColor
                                                : Colors.redAccent,
                                            child: Center(
                                                child: Text(
                                              contacts![index]
                                                  .name[0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )),
                                          ),
                                          title:
                                              Text('${contacts![index].name}'),
                                          trailing: Checkbox(
                                            value: selectedContacts
                                                .contains(contacts![index]),
                                            onChanged: (value) {
                                              if (value!) {
                                                selectedContacts
                                                    .add(contacts![index]);
                                              } else {
                                                selectedContacts
                                                    .remove(contacts![index]);
                                              }
                                              setState(() {
                                                selectedContacts =
                                                    selectedContacts;
                                              });
                                            },
                                          ),
                                        ),
                                      ))
                            ])))));
  }
}
