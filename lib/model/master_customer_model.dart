// model/master_customer.dart
import 'package:hive/hive.dart';

part 'master_customer_model.g.dart';

@HiveType(typeId: 3)
class MasterCustomer extends HiveObject {
  @HiveField(0)
  String master_customer_Name;

  @HiveField(1)
  String master_customer_address;

  @HiveField(2)
  String  master_customer_phone;

  @HiveField(3)
  String  master_customer_gst;

  MasterCustomer({
    required this.master_customer_Name,
    required this.master_customer_address,
    required this.master_customer_phone,
    required this.master_customer_gst,
  });
}