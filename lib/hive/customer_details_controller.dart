import 'package:billing_app/model/customer_details.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerDetailsController {

  /// **Save or Update Invoice**
  static Future<void> saveData(Invoice invoice) async {
    var box = await Hive.openBox<Invoice>("democustomer");

    // Check if an invoice with the same invoiceNumber exists
    var existingIndex = box.values.toList().indexWhere((inv) => inv.invoiceNumber == invoice.invoiceNumber);

    if (existingIndex != -1) {
      // If invoice exists, update it
      await box.putAt(existingIndex, invoice);
    } else {
      // Otherwise, add new invoice
      await box.add(invoice);
    }
  }

  /// **Get All Invoices**
  static getData() async {
    var box = await Hive.openBox<Invoice>("democustomer");
    return box.values.toList();
  }

  /// **Update Specific Invoice**
  static Future<void> updateData(Invoice updatedInvoice) async {
    var box = await Hive.openBox<Invoice>("democustomer");

    int index = box.values.toList().indexWhere((inv) => inv.invoiceNumber == updatedInvoice.invoiceNumber);

    if (index != -1) {
      await box.putAt(index, updatedInvoice);
    } else {
      print("Invoice not found for update.");
    }
  }

  static Future<void> deleteInvoice(String invoiceNumber) async {
    var box = await Hive.openBox<Invoice>("democustomer");

    int index = box.values.toList().indexWhere((inv) => inv.invoiceNumber == invoiceNumber);
    if (index != -1) {
      await box.deleteAt(index);
    }
  }

}
