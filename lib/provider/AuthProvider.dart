import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:splitit/models/trip.dart';
import 'package:splitit/models/userModel.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  UserModel? curUser;

  get isLoggedIn => curUser != null;

  Future<void> setupInit() async {
    User? user = auth.currentUser;
    if (user != null) {
      print("uid: ${user.uid}");
      await firestoreInstance
          .collection("users")
          .doc(user.uid)
          .get()
          .then((value) {
        Map<String, dynamic>? res = value.data();
        print("res: $res");
        if (res != null) {
          curUser = UserModel.fromJson(res, user.uid);
        }
      });
    }
    notifyListeners();
  }

  Future<bool> checkIfUserExists(String phone) async {
    return firestoreInstance
        .collection("users")
        .where("phone_number", isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        return false;
      }
      return true;
    });
  }

  Future<UserModel?> getUserFromUid(String uid) async {
    return firestoreInstance.collection("users").doc(uid).get().then((value) {
      Map<String, dynamic>? res = value.data();
      if (res != null) {
        return UserModel.fromJson(res, uid);
      }
      return null;
    });
  }

  Future<List<UserModel>> getUsersFromPhoneNumbers(
      List<String> phoneNumbers) async {
    List<UserModel> users = [];

    await firestoreInstance.collection("users").get().then((value) {
      value.docs.forEach((doc) {
        Map<String, dynamic>? res = doc.data();
        if (res != null) {
          UserModel user = UserModel.fromJson(res, doc.id);
          if (phoneNumbers.contains(user.phoneNumber) &&
              user.uid != curUser?.uid) {
            users.add(user);
          }
        }
      });
    });

    return users;
  }

  Future<bool> registerUser(
    UserCredential userCredential,
    String first_name,
    String last_name,
    String upiAddress,
  ) async {
    User? user = userCredential.user;
    user!.updateDisplayName(first_name + " " + last_name);
    EasyLoading.show();
    firestoreInstance.collection("users").doc(user.uid).set({
      "name": first_name + " " + last_name,
      "phone_number": user.phoneNumber,
      "upi_address": upiAddress
    });
    setupInit();
    EasyLoading.dismiss();
    return true;
  }

  Future<void> signOutCurUser() async {
    EasyLoading.show();
    await auth.signOut();
    curUser = null;
    EasyLoading.dismiss();
    notifyListeners();
  }

  void updateUserDetails(String fullName, String upiAddress) async {
    EasyLoading.show();
    firestoreInstance
        .collection("users")
        .doc(curUser!.uid)
        .update({"full_name": fullName, "upi_address": upiAddress});
    curUser!.name = fullName;
    curUser!.upiAddress = upiAddress;
    notifyListeners();
    EasyLoading.dismiss();
  }

  // add trip
  Future<void> addTrip(String tripName, List<UserModel> users) async {
    users += [curUser!];
    EasyLoading.show();
    await firestoreInstance.collection("trips").doc(tripName).set({
      "trip_name": tripName,
      "users": users.map((user) => user.toJson()).toList(),
      "users_uid": users.map((user) => user.uid).toList(),
      "total_trip_cost": 0,
      "payments": [],
    });
    EasyLoading.dismiss();
  }

  // add payment
  Future<void> addPayment(Trip trip, String paymentName, double paymentAmount,
      List<UserModel> users) async {
    double paymentPerUser = paymentAmount / (users.length + 1);

    List<Records> paymentRecords = [];

    users.forEach((user) {
      paymentRecords.add(
          Records(user: user.uid, amount: paymentPerUser, status: 'unpaid'));
    });

    paymentRecords.add(
        Records(user: curUser!.uid, amount: paymentPerUser, status: 'paid'));

    Payments payment = Payments(
      amount: paymentAmount,
      name: paymentName,
      records: paymentRecords,
      paidBy: curUser!.uid,
    );

    EasyLoading.show();
    await firestoreInstance.collection("trips").doc(trip.tripName).update({
      "payments": FieldValue.arrayUnion([
        payment.toJson(),
      ]),
      "total_trip_cost": FieldValue.increment(paymentAmount),
    });

    await firestoreInstance.collection("users").doc(curUser!.uid).update({
      "total_spend": FieldValue.increment(paymentPerUser),
      "owed_money": FieldValue.increment(paymentPerUser * users.length),
    });

    users.forEach((user) async {
      if (user.uid != curUser!.uid) {
        await firestoreInstance.collection("users").doc(user.uid).update({
          "total_spend": FieldValue.increment(paymentPerUser),
          "pending_payments": FieldValue.increment(paymentPerUser),
        });
      }
    });

    EasyLoading.dismiss();
  }

  // mark payment as paid
  Future<void> markPaymentAsPaid(Trip trip, int paymentIndex, String paidNowUserUid) async {
    EasyLoading.show();
    trip.payments[paymentIndex].records.forEach((element) {
      if (element.user == paidNowUserUid) {
        element.status = 'paid';
      }
    });
    firestoreInstance
        .collection('trips')
        .doc(trip.tripName)
        .update(trip.toJson());

    await firestoreInstance.collection("users").doc(paidNowUserUid).update({
      "pending_payments":
          FieldValue.increment(-trip.payments[paymentIndex].amount),
    });

    await firestoreInstance
        .collection("users")
        .doc(trip.payments[paymentIndex].paidBy)
        .update({
      "owed_money": FieldValue.increment(-trip.payments[paymentIndex].amount),
    });

    EasyLoading.dismiss();
  }
}
