import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitit/const.dart';
import 'package:splitit/models/trip.dart';
import 'package:splitit/models/userModel.dart';
import 'package:splitit/provider/AuthProvider.dart';
import 'package:splitit/ui/home/popups/addTrip.dart';
import 'package:splitit/ui/home/popups/editProfile.dart';
import 'package:splitit/ui/home/tripDetails.dart';
import 'package:splitit/utils/titleAndSubtitle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel _user;

  late List<Trip> _trips = [];

  @override
  void initState() {
    super.initState();

    UserModel curUser =
        Provider.of<AuthProvider>(context, listen: false).curUser!;
    setState(() {
      _user = curUser;
    });

    Provider.of<AuthProvider>(context, listen: false)
        .firestoreInstance
        .collection('users')
        .doc(curUser.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        _user = UserModel.fromJson(event.data()!, event.id);
      });
    });

    Provider.of<AuthProvider>(context, listen: false)
        .firestoreInstance
        .collection('trips')
        .where('users_uid', arrayContains: curUser.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        _trips = event.docs.map((e) => Trip.fromJson(e.data())).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddTripDialog(context);
        },
        label: const Text(
          'Add Trip',
          textScaleFactor: 1.2,
        ),
        icon: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.redAccent,
                              size: 35,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'SPLIT IT!',
                              textScaleFactor: 2.5,
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showEditProfileDialog(context);
                          },
                          child: CircleAvatar(
                            radius: _size.width * 0.06,
                            backgroundColor: orangeColor,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Center(
                                child: Text(
                                  _user.name[0].toUpperCase(),
                                  textScaleFactor: 1.5,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: _size.height * 0.03,
                    ),
                    const TitleAndSubtitleWidget(
                        title: 'Stats',
                        subtitle: 'See how you are going so far.'),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: orangeColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Spent',
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: _size.height * 0.01,
                            ),
                            Text(
                              '₹${_user.totalSpend}',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pending Payments',
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: _size.height * 0.01,
                            ),
                            Text(
                              '₹${_user.pendingPayments}',
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
                      color: orangeColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Owed Money',
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: _size.height * 0.01,
                            ),
                            Text(
                              '₹${_user.owedMoney}',
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
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleAndSubtitleWidget(
                        title: 'Trips',
                        subtitle: 'List of trips, and their stats.'),
                    SizedBox(
                      height: _size.height * 0.02,
                    ),
                    ...List.generate(_trips.length, (index) {
                      Trip trip = _trips[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TripDetails(
                                          trip: trip,
                                        )));
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.white,
                              child: ListTile(
                                  title: Text(
                                    trip.tripName,
                                    textScaleFactor: 1.2,
                                  ),
                                  trailing: Text(
                                    '₹${trip.totalTripCost}',
                                    textScaleFactor: 1.2,
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 5),
                                    child: LimitedBox(
                                      maxHeight: 28,
                                      maxWidth: 50,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: trip.users.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index2) {
                                          return Align(
                                            widthFactor: 0.6,
                                            child: ClipOval(
                                              child: Container(
                                                color: index2 % 2 == 0
                                                    ? Colors.redAccent
                                                    : Colors.orangeAccent,
                                                child: Container(
                                                    height: 28,
                                                    width: 28,
                                                    child: Center(
                                                      child: Text(trip
                                                          .users[index2].name[0]
                                                          .toUpperCase()),
                                                    )),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ))),
                        ),
                      );
                    }),

                    _trips.length == 0
                        ? Center(
                            child: Text(
                              'No trips yet',
                              textScaleFactor: 1.5,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
