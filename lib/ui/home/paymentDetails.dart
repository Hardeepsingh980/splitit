import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/models/trip.dart';
import 'package:splitit/models/userModel.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/utils/titleAndSubtitle.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetails extends StatefulWidget {
  Trip trip;
  int paymentIndex;

  PaymentDetails({Key? key, required this.trip, required this.paymentIndex})
      : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  Payments get payment => widget.trip.payments[widget.paymentIndex];

  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    UserModel curUser =
        Provider.of<AuthProvider>(context, listen: false).curUser!;
    Provider.of<AuthProvider>(context, listen: false)
        .firestoreInstance
        .collection('trips')
        .doc(widget.trip.tripName)
        .snapshots()
        .listen((event) {
      setState(() {
        widget.trip = Trip.fromJson(event.data()!);
        payment.records.forEach((element) {
          if (element.status == 'paid' && element.user == curUser.uid) {
            setState(() {
              isPaid = true;
            });
          }
        });
      });
    });
  }

  double roundToTwoDecimals(double value) {
    return (value * 100).round() / 100;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        bottomSheet: !isPaid
            ? ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  // color: orangeColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Elevate button to pay
                        ElevatedButton(
                          onPressed: () async {
                            UserModel? paidBy = await Provider.of<AuthProvider>(
                                    context,
                                    listen: false)
                                .getUserFromUid(payment.paidBy);

                            if (!await launchUrl(Uri.parse(
                                'upi://pay?pa=${paidBy!.upiAddress}&tn=Payment for ${paidBy.name} while on ${widget.trip.tripName}&am=${payment.amount / payment.records.length}&cu=INR'))) {
                              throw 'Could not launch';
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Pay Now',
                              textScaleFactor: 1.5,
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

                        // mark as paid button
                        ElevatedButton(
                          onPressed: () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .markPaymentAsPaid(
                                    widget.trip,
                                    widget.paymentIndex,
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .curUser!
                                        .uid);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Mark as Paid',
                              textScaleFactor: 1.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: orangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleAndSubtitleWidget(
                              title: payment.name,
                              subtitle:
                                  'Your payment details, stats and who paid and who owes'),
                          SizedBox(height: _size.height * 0.03),
                          Row(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: orangeColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total Cost',
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: _size.height * 0.01,
                                      ),
                                      Text(
                                        '₹${roundToTwoDecimals(payment.amount)}',
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.redAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Your Part',
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: _size.height * 0.01,
                                      ),
                                      Text(
                                        '₹${roundToTwoDecimals(payment.amount / payment.records.length)}',
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.grey,
                                ),
                                Text(
                                    isPaid
                                        ? '✓ You have paid already'
                                        : "X You have to pay yet",
                                    textScaleFactor: 1.1,
                                    style: TextStyle(
                                        color: isPaid
                                            ? Colors.green
                                            : Colors.redAccent,
                                        fontSize: 16)),
                                Divider(
                                  color: Colors.grey,
                                ),
                                Row(),
                              ],
                            ),
                          ),
                          SizedBox(height: _size.height * 0.02),
                          Text(
                            'Payments Record',
                            textScaleFactor: 2,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...List.generate(payment.records.length, (index) {
                            Records record = payment.records[index];

                            Users user = widget.trip.users.firstWhere(
                                (element) => element.uid == record.user);

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: index % 2 == 0
                                                ? orangeColor
                                                : Colors.redAccent,
                                            child: Center(
                                                child: Text(
                                              user.name[0].toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )),
                                          ),
                                          title: Text(
                                            user.name,
                                            textScaleFactor: 1.2,
                                          ),
                                          trailing: Text(
                                            '₹${roundToTwoDecimals(record.amount)}',
                                            textScaleFactor: 1.2,
                                          ),
                                          subtitle: record.status == 'paid'
                                              ? Text(
                                                  'Paid',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )
                                              : Text(
                                                  'Not Paid',
                                                  style: TextStyle(
                                                      color: Colors.redAccent),
                                                )),
                                      record.status != 'paid' &&
                                              Provider.of<AuthProvider>(context,
                                                          listen: false)
                                                      .curUser!
                                                      .uid ==
                                                  payment.paidBy
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20),
                                              child: Column(
                                                children: [
                                                  Divider(
                                                    color: Colors.grey,
                                                  ),
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      orangeColor,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  )),
                                                          onPressed: () async {
                                                            await Provider.of<
                                                                        AuthProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .markPaymentAsPaid(
                                                                    widget.trip,
                                                                    widget
                                                                        .paymentIndex,
                                                                    user.uid);
                                                          },
                                                          child: Text(
                                                            'Mark as Paid',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                      SizedBox(width: 10),
                                                      ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .redAccent,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  )),
                                                          onPressed: () async {
                                                            if (!await launchUrl(
                                                                Uri.parse(
                                                                    'https://wa.me/+919803588671?text=Hey ${user.name}, \n Your payment of ₹${record.amount} is pending for ${payment.name} on ${widget.trip.tripName} trip. Paisa de mera'),
                                                                mode: LaunchMode
                                                                    .externalApplication)) {
                                                              throw 'Could not launch';
                                                            }
                                                          },
                                                          child: Text(
                                                            'Ask To Pay',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  )),
                            );
                          }),
                        ])))));
  }
}
