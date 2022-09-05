import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/models/trip.dart';
import 'package:splitit/models/userModel.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/ui/home/paymentDetails.dart';
import 'package:splitit/ui/home/popups/addPayment.dart';
import 'package:splitit/utils/titleAndSubtitle.dart';

class TripDetails extends StatefulWidget {
  Trip trip;

  TripDetails({Key? key, required this.trip}) : super(key: key);

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: FloatingActionButton.extended(
            onPressed: () {
              showAddPaymentDialog(context, widget.trip);
            },
            label: const Text(
              'Add Payment',
              textScaleFactor: 1.2,
            ),
            icon: const Icon(Icons.add),
          ),
        ),
        bottomSheet: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            color: orangeColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Trip Cost',
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '₹${widget.trip.totalTripCost}',
                    textScaleFactor: 1.5,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TitleAndSubtitleWidget(
                title: widget.trip.tripName,
                subtitle: 'Your trip details, stats and all the payments'),
            SizedBox(height: _size.height * 0.03),
            Text(
              'Payments',
              textScaleFactor: 2,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: _size.height * 0.02,
            ),
            ...List.generate(widget.trip.payments.length, (index) {
              Payments payment = widget.trip.payments[index];

              List<Users> users = payment.records.map((e) {
                return widget.trip.users.firstWhere((element) {
                  return element.uid == e.user;
                });
              }).toList();

              Users paidBy = widget.trip.users.firstWhere((element) {
                return element.uid == payment.paidBy;
              });

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PaymentDetails(
                                  trip: widget.trip,
                                  paymentIndex: index,
                                )));
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text(
                                payment.name,
                                textScaleFactor: 1.2,
                              ),
                              trailing: Text(
                                '₹${payment.amount}',
                                textScaleFactor: 1.2,
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 5),
                                child: LimitedBox(
                                  maxHeight: 28,
                                  maxWidth: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: users.length,
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
                                                  child: Text(
                                                    users[index]
                                                        .name[0]
                                                        .toUpperCase(),
                                                    textScaleFactor: 1.2,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.grey,
                                ),
                                Text('✓ Paid by ${paidBy.name}',
                                    textScaleFactor: 1.1,
                                    style: const TextStyle(
                                        color: Colors.green, fontSize: 16)),
                                Divider(
                                  color: Colors.grey,
                                ),
                                Row(),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              );
            }),
            widget.trip.payments.length == 0
                ? Center(
                    child: Text(
                      'No payments yet',
                      textScaleFactor: 1.5,
                    ),
                  )
                : Container(),
          ]),
        ))));
  }
}
