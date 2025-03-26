import 'package:flutter/material.dart';
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
            ElevatedButton(onPressed: () {}, child: Text("Generate Invoice")),
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
        TextField(controller: invoiceNumberController, decoration: InputDecoration(labelText: "Invoice Number", border: OutlineInputBorder())),
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
        TextField(controller: customerNameController, decoration: InputDecoration(labelText: "Customer Name", border: OutlineInputBorder())),
        SizedBox(height: 8),
        TextField(controller: customerAddressController, maxLines: 3, decoration: InputDecoration(labelText: "Customer Address", border: OutlineInputBorder())),
        SizedBox(height: 8),
        TextField(controller: customerPhoneController, decoration: InputDecoration(labelText: "Customer Phone Number", border: OutlineInputBorder())),
        SizedBox(height: 8),
        TextField(controller: customerGSTINController, decoration: InputDecoration(labelText: "Customer GSTIN (Optional)", border: OutlineInputBorder())),
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
        TextField(controller: cgstController, decoration: InputDecoration(labelText: "CGST %", border: OutlineInputBorder())),
        TextField(controller: sgstController, decoration: InputDecoration(labelText: "SGST %", border: OutlineInputBorder())),
        SizedBox(height: 8),
        Text("Grand Total: ₹${getGrandTotal().toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
