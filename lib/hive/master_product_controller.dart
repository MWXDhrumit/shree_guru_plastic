import 'package:billing_app/model/master_product_model.dart';
import 'package:hive/hive.dart';

class MasterProductController {
  static Future<void> saveProduct(MasterProduct product) async {
    var box = await Hive.openBox<MasterProduct>('master_products');
    await box.add(product);
  }

  static Future<List<MasterProduct>> getAllProducts() async {
    var box = await Hive.openBox<MasterProduct>('master_products');
    return box.values.toList();
  }

  // Update existing product by index
  static Future<void> updateProduct(int index, MasterProduct updatedProduct) async {
    var box = await Hive.openBox<MasterProduct>('master_products');
    await box.putAt(index, updatedProduct);
  }

  // Delete product by index
  static Future<void> deleteProduct(int index) async {
    var box = await Hive.openBox<MasterProduct>('master_products');
    await box.deleteAt(index);
  }

}
