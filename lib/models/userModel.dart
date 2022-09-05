class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.upiAddress,
     this.totalSpend,
     this.pendingPayments,
     this.owedMoney,
  });
  late final String uid;
  late final String phoneNumber;
  late  String name;
  late  String upiAddress;
  late  double? totalSpend;
  late  double? pendingPayments;
  late  double? owedMoney;
  
  UserModel.fromJson(Map<String, dynamic> json, String uid){
    this.uid = uid;
    name = json['name'];
    phoneNumber = json['phone_number'];
    upiAddress = json['upi_address'];
    totalSpend = double.tryParse(json['total_spend'].toString()) ?? 0;
    pendingPayments = double.tryParse(json['pending_payments'].toString()) ?? 0;
    owedMoney = double.tryParse(json['owed_money'].toString()) ?? 0;

    totalSpend = double.parse(totalSpend!.toStringAsFixed(2));
    pendingPayments = double.parse(pendingPayments!.toStringAsFixed(2));
    owedMoney = double.parse(owedMoney!.toStringAsFixed(2));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['name'] = name;
    _data['phone_number'] = phoneNumber;
    _data['upi_address'] = upiAddress;
    _data['total_spend'] = totalSpend;
    _data['pending_payments'] = pendingPayments;
    _data['owed_money'] = owedMoney;
    return _data;
  }
}