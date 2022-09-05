double roundToTwoDecimals(double value) {
  return (value * 100).round() / 100;
}

class Trip {
  Trip({
    required this.tripName,
    required this.totalTripCost,
    required this.payments,
    required this.users,
  });
  late final String tripName;
  late final double totalTripCost;
  late final List<Payments> payments;
  late final List<Users> users;

  Trip.fromJson(Map<String, dynamic> json) {
    tripName = json['trip_name'];
    totalTripCost = double.parse(json['total_trip_cost'].toString());
    payments =
        List.from(json['payments']).map((e) => Payments.fromJson(e)).toList();
    users = List.from(json['users']).map((e) => Users.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['trip_name'] = tripName;
    _data['total_trip_cost'] = roundToTwoDecimals(totalTripCost);
    _data['payments'] = payments.map((e) => e.toJson()).toList();
    _data['users'] = users.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Payments {
  Payments({
    required this.paidBy,
    required this.name,
    required this.amount,
    required this.records,
  });
  late final String paidBy;
  late final String name;
  late final double amount;
  late final List<Records> records;

  Payments.fromJson(Map<String, dynamic> json) {
    paidBy = json['paid_by'];
    name = json['name'];
    amount = roundToTwoDecimals(double.parse(json['amount'].toString()));
    records =
        List.from(json['records']).map((e) => Records.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['paid_by'] = paidBy;
    _data['name'] = name;
    _data['amount'] = amount;
    _data['records'] = records.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Records {
  Records({
    required this.user,
    required this.amount,
    required this.status,
  });
  late final String user;
  late final double amount;
  late String status;

  Records.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    amount = double.parse(json['amount'].toString());
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user;
    _data['amount'] = roundToTwoDecimals(amount);
    _data['status'] = status;
    return _data;
  }
}

class Users {
  Users({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.upiAddress,
  });
  late final String uid;
  late final String name;
  late final String phoneNumber;
  late final String upiAddress;

  Users.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    upiAddress = json['upi_address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['name'] = name;
    _data['phone_number'] = phoneNumber;
    _data['upi_address'] = upiAddress;
    return _data;
  }
}
