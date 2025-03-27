import 'package:hive/hive.dart';

part 'invoice_model.g.dart';

@HiveType(typeId: 0)
class InvoiceModel extends HiveObject {
  @HiveField(0)
  String invoiceNumber;

  @HiveField(1)
  String date;

  @HiveField(2)
  String customerName;

  @HiveField(3)
  String customerAddress;

  @HiveField(4)
  String customerPhone;

  @HiveField(5)
  String customerGSTIN;

  @HiveField(6)
  List<Map<String, dynamic>> products;

  @HiveField(7)
  double totalAmount;

  InvoiceModel({
    required this.invoiceNumber,
    required this.date,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.customerGSTIN,
    required this.products,
    required this.totalAmount,
  });
}
