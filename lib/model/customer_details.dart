import 'package:hive/hive.dart';

part 'customer_details.g.dart';

@HiveType(typeId: 1)
class Invoice extends HiveObject {
  @HiveField(0)
  String invoiceNumber;

  @HiveField(1)
  String invoiceDate;

  @HiveField(2)
  String customerName;

  @HiveField(3)
  String customerAddress;

  @HiveField(4)
  String customerPhone;

  @HiveField(5)
  String customerGSTIN;

  @HiveField(6)
  String paymentType;

  @HiveField(7)
  List<Product> products;

  @HiveField(8)
  double cgst;

  @HiveField(9)
  double sgst;

  @HiveField(10)
  double subTotal;

  @HiveField(11)
  double grandTotal;

  Invoice({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.customerGSTIN,
    required this.paymentType,
    required this.products,
    required this.cgst,
    required this.sgst,
    required this.subTotal,
    required this.grandTotal,
  });
}

@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  String productName;

  @HiveField(1)
  String hsnCode;

  @HiveField(2)
  double quantity;

  @HiveField(3)
  double rate;

  @HiveField(4)
  double amount;

  Product({
    required this.productName,
    required this.hsnCode,
    required this.quantity,
    required this.rate,
    required this.amount,
  });
}