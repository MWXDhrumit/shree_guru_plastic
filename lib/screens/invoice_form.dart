import 'package:billing_app/hive/customer_details_controller.dart';
import 'package:billing_app/model/customer_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class InvoiceFormScreen extends StatefulWidget {
  @override
  _InvoiceFormScreenState createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerAddressController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController customerGSTINController = TextEditingController();
  final TextEditingController cgstController = TextEditingController();
  final TextEditingController sgstController = TextEditingController();
  String selectedPaymentType = 'Cash';

  List<Map<String, dynamic>> products = [];


  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    cgstController.text = "9"; // Default 9% CGST
    sgstController.text = "9"; // Default 9% SGST

    // Listens to changes in CGST and SGST fields to update the total dynamically
    cgstController.addListener(() => setState(() {}));
    sgstController.addListener(() => setState(() {}));

  }

  void addProduct() {
    setState(() {
      products.add({
        'productName': TextEditingController(),
        'hsnCode': TextEditingController(),
        'quantity': TextEditingController(),
        'rate': TextEditingController(),
        'amount': 0.0,
      });
    });
  }
//hello haA BOL aa page kya khule che? kyu ?
  //aa
  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void calculateAmount(int index) {
    double qty = double.tryParse(products[index]['quantity'].text) ?? 0;
    double rate = double.tryParse(products[index]['rate'].text) ?? 0;
    double total = qty * rate;

    setState(() {
      products[index]['amount'] = total;
    });
  }

  double getSubTotal() {
    return products.fold(0, (sum, item) => sum + item['amount']);
  }

  double getCGSTAmount() {
    double cgstRate = double.tryParse(cgstController.text) ?? 0;
    return (getSubTotal() * cgstRate) / 100;
  }

  double getSGSTAmount() {
    double sgstRate = double.tryParse(sgstController.text) ?? 0;
    return (getSubTotal() * sgstRate) / 100;
  }

  double getGrandTotal() {
    return getSubTotal() + getCGSTAmount() + getSGSTAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invoice Form")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildInvoiceDetails(),
            SizedBox(height: 16),
            buildCustomerDetails(),
            SizedBox(height: 16),
            Text("Product Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(products.length, (index) => buildProductRow(index)),
            SizedBox(height: 10),
            ElevatedButton.icon(onPressed: addProduct, icon: Icon(Icons.add), label: Text("Add Product")),
            Divider(thickness: 1, height: 30),
            buildTotalCalculation(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Hive.openBox<Invoice>('democustomer');
                final modelCustomer = Invoice(
                  invoiceNumber: invoiceNumberController.text,
                  invoiceDate: dateController.text,
                  customerName: customerNameController.text,
                  customerAddress: customerAddressController.text,
                  customerPhone: customerPhoneController.text,
                  customerGSTIN: customerGSTINController.text,
                  paymentType: selectedPaymentType,
                  products: products.map((p) => Product(
                    productName: p['productName'].text,
                    hsnCode: p['hsnCode'].text,
                    quantity: double.tryParse(p['quantity'].text) ?? 0,
                    rate: double.tryParse(p['rate'].text) ?? 0,
                    amount: p['amount'],
                  )).toList(),
                  cgst: double.tryParse(cgstController.text) ?? 0,
                  sgst: double.tryParse(sgstController.text) ?? 0,
                  subTotal: getSubTotal(),
                  grandTotal: getGrandTotal(),
                );
                await CustomerDetailsController.saveData(modelCustomer);
                // Show a success message
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invoice ${modelCustomer.invoiceNumber} saved successfully!"))
                );

              },
              child: Text("Generate Invoice"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInvoiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Invoice Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        buildTextField("Bill Number", invoiceNumberController),
        SizedBox(height: 8),
        TextField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Invoice Date",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            }
          },
        ),
        SizedBox(height: 8),
        DropdownButtonFormField(
          value: selectedPaymentType,
          items: ['Cash', 'Credit', 'UPI'].map((String type) {
            return DropdownMenuItem(value: type, child: Text(type));
          }).toList(),
          onChanged: (value) => setState(() => selectedPaymentType = value as String),
          decoration: InputDecoration(labelText: "Payment Type", border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget buildCustomerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        buildTextField("Customer Name", customerNameController),
        SizedBox(height: 8),
        buildTextField("Customer Address", customerAddressController),
        SizedBox(height: 8),
        buildTextField("Customer Phoen number", customerPhoneController),
        SizedBox(height: 8),
        buildTextField("Customer GST", customerGSTINController),
      ],
    );
  }

  Widget buildProductRow(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(controller: products[index]['productName'], decoration: InputDecoration(labelText: "Product Name", border: OutlineInputBorder())),

            SizedBox(height: 8),
            TextField(controller: products[index]['hsnCode'], decoration: InputDecoration(labelText: "HSN Code", border: OutlineInputBorder())),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: products[index]['quantity'],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Qty", border: OutlineInputBorder()),
                    onChanged: (_) => calculateAmount(index),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: products[index]['rate'],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Rate per Piece", border: OutlineInputBorder()),
                    onChanged: (_) => calculateAmount(index),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text("Amount: ₹${products[index]['amount'].toStringAsFixed(2)}"),
            TextButton(onPressed: () => removeProduct(index), child: Text("Remove")),
          ],
        ),
      ),
    );
  }

  Widget buildTotalCalculation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Subtotal: ₹${getSubTotal().toStringAsFixed(2)}"),
        SizedBox(height: 8),
        Text("CGST: ₹${getCGSTAmount().toStringAsFixed(2)}"),
        Text("SGST: ₹${getSGSTAmount().toStringAsFixed(2)}"),
        SizedBox(height: 8),
        buildTextField("CGST", cgstController),
        buildTextField("SGST", sgstController),
        SizedBox(height: 8),
        Text("Grand Total: ₹${getGrandTotal().toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
  Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: icon != null
              ? Icon(icon, color: Color(0xFF00214d))
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xFF00214d),
              width: 2.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 1.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          isDense: true, // To make the TextField more compact
          filled: true, // Gives the background a light color
          fillColor: Colors.white,
        ),
      ),
    );
  }


}
