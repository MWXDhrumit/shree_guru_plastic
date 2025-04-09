import 'package:hive/hive.dart';

part 'master_product_model.g.dart';

@HiveType(typeId: 4)
class MasterProduct extends HiveObject {
  @HiveField(0)
  String master_product_Name;

  @HiveField(1)
  String master_product_hsnCode;

  MasterProduct({
    required this.master_product_Name,
    required this.master_product_hsnCode,
  });
}
