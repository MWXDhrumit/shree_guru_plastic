import 'package:billing_app/hive/master_customer_controller.dart';
import 'package:billing_app/model/master_customer_model.dart';
import 'package:flutter/material.dart';

class MasterCustomerPage extends StatefulWidget {
  @override
  _MasterCustomerPageState createState() => _MasterCustomerPageState();
}

class _MasterCustomerPageState extends State<MasterCustomerPage> {
  List<MasterCustomer> customerList = [];

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    final customers = await MasterCustomerController.getAllCustomers();
    setState(() {
      customerList = customers;
    });
  }

  void showCustomerDialog({MasterCustomer? customer, int? index}) {
    final nameController = TextEditingController(text: customer?.master_customer_Name ?? '');
    final phoneController = TextEditingController(text: customer?.master_customer_phone ?? '');
    final addressController = TextEditingController(text: customer?.master_customer_address ?? '');
    final gstController = TextEditingController(text: customer?.master_customer_gst ?? '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                customer == null ? "Add Customer" : "Edit Customer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:  Color(0xFF00214d)),
              ),
              const SizedBox(height: 20),
              _buildTextField(controller: nameController, label: "Customer Name"),
              _buildTextField(controller: phoneController, label: "Phone Number", keyboardType: TextInputType.phone),
              _buildTextField(controller: addressController, label: "Address"),
              _buildTextField(controller: gstController, label: "GST Number"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFF00214d),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final newCustomer = MasterCustomer(
                        master_customer_Name: nameController.text.trim(),
                        master_customer_phone: phoneController.text.trim(),
                        master_customer_address: addressController.text.trim(),
                        master_customer_gst: gstController.text.trim(),
                      );

                      if (customer == null) {
                        await MasterCustomerController.saveCustomer(newCustomer);
                      } else if (index != null) {
                        await MasterCustomerController.updateCustomer(index, newCustomer);
                      }

                      Navigator.pop(context);
                      loadCustomers();
                    },
                    child: Text(customer == null ? "Add" : "Update",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Reusable text field builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              Text("Delete Customer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color:  Color(0xFF00214d))),
              SizedBox(height: 10),
              Text("Are you sure you want to delete this customer?"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel",style: TextStyle(color: Colors.grey[700]),)),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await MasterCustomerController.deleteCustomer(index);
                      Navigator.pop(context);
                      loadCustomers();
                    },
                    child: Text("Delete",style: TextStyle(color: Colors.white),),
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
      appBar: AppBar(title: Text("Master Customers",style: TextStyle(color: Colors.white),),backgroundColor:  Color(0xFF00214d),),
      body: customerList.isEmpty
          ? Center(child: Text("No customers found."))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return ListView.builder(
              itemCount: customerList.length,
              itemBuilder: (context, index) {
                final customer = customerList[index];
                final firstLetter = customer.master_customer_Name.isNotEmpty
                    ? customer.master_customer_Name[0].toUpperCase()
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
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.master_customer_Name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.phone, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(customer.master_customer_phone),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    customer.master_customer_address,
                                    style: TextStyle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.receipt_long, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text("GST: ${customer.master_customer_gst}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => showCustomerDialog(customer: customer, index: index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => confirmDelete(index),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () => showCustomerDialog(),
        child: Icon(Icons.add),
        tooltip: "Add Customer",
      ),
    );
  }
}
