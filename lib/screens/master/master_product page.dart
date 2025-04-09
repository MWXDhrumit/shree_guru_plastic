import 'package:billing_app/hive/master_product_controller.dart';
import 'package:billing_app/model/master_product_model.dart';
import 'package:flutter/material.dart';

class MasterProductPage extends StatefulWidget {
  @override
  _MasterProductPageState createState() => _MasterProductPageState();
}

class _MasterProductPageState extends State<MasterProductPage> {
  List<MasterProduct> productList = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await MasterProductController.getAllProducts();
    setState(() {
      productList = products;
    });
  }

  void showProductDialog({MasterProduct? product, int? index}) {
    final nameController = TextEditingController(text: product?.master_product_Name ?? '');
    final hsnController = TextEditingController(text: product?.master_product_hsnCode ?? '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product == null ? "Add New Product" : "Edit Product",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00214d)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Product Name",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: hsnController,
                decoration: InputDecoration(
                  labelText: "HSN Code",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00214d),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final newProduct = MasterProduct(
                        master_product_Name: nameController.text.trim(),
                        master_product_hsnCode: hsnController.text.trim(),
                      );

                      if (product == null) {
                        await MasterProductController.saveProduct(newProduct);
                      } else if (index != null) {
                        await MasterProductController.updateProduct(index, newProduct);
                      }

                      Navigator.pop(context);
                      loadProducts();
                    },
                    child: Text(product == null ? "Add" : "Update",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, color: Colors.red, size: 40),
              SizedBox(height: 10),
              Text("Delete Product", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF00214d))),
              SizedBox(height: 10),
              Text("Are you sure you want to delete this product?"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await MasterProductController.deleteProduct(index);
                      Navigator.pop(context);
                      loadProducts();
                    },
                    child: Text("Delete",style: TextStyle(fontWeight: FontWeight.bold,  color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Master Products",style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF00214d),
      ),
      body: productList.isEmpty
          ? Center(child: Text("No products found."))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: ListView.builder(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            final product = productList[index];
            final firstLetter = product.master_product_Name.isNotEmpty
                ? product.master_product_Name[0].toUpperCase()
                : '?';

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFF00214d).withOpacity(0.1),
                    child: Text(
                      firstLetter,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00214d),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.master_product_Name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00214d),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.receipt, size: 16, color: Colors.grey.shade600),
                            SizedBox(width: 4),
                            Text(
                              "HSN Code: ${product.master_product_hsnCode}",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF00214d)),
                        onPressed: () => showProductDialog(product: product, index: index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => confirmDelete(index),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProductDialog(),
        child: Icon(Icons.add,color:  Color(0xFF00214d)),
        tooltip: "Add Product",
      ),
    );
  }
}
