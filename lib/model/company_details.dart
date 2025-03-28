import 'package:hive_flutter/adapters.dart';

part 'company_details.g.dart';

@HiveType(typeId: 0)
class CompanyDetailsModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String address;

  @HiveField(2)
  String mobileNumber;

  @HiveField(3)
  String gstNumber;

  @HiveField(4)
  String bankName;

  @HiveField(5)
  String ifsc;

  @HiveField(6)
  String accountNo;

  CompanyDetailsModel({
    required this.name,
    required this.address,
    required this.mobileNumber,
    required this.gstNumber,
    required this.bankName,
    required this.ifsc,
    required this.accountNo,
  });
}
