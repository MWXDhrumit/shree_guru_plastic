import 'package:billing_app/model/master_customer_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class MasterCustomerController {
  static Future<void> saveCustomer(MasterCustomer customer) async {
    var box = await Hive.openBox<MasterCustomer>('master_customers');
    await box.add(customer);
    await Get.snackbar("Succes", "Customer added");
  }

  static Future<List<MasterCustomer>> getAllCustomers() async {
    var box = await Hive.openBox<MasterCustomer>('master_customers');
    return box.values.toList();
  }

  static Future<void> updateCustomer(int index, MasterCustomer customer) async {
    var box = await Hive.openBox<MasterCustomer>('master_customers');
    await box.putAt(index, customer);
    Get.snackbar("Success", "Customer updated");
  }

  static Future<void> deleteCustomer(int index) async {
    var box = await Hive.openBox<MasterCustomer>('master_customers');
    await box.deleteAt(index);
    Get.snackbar("Deleted", "Customer removed");
  }

}
