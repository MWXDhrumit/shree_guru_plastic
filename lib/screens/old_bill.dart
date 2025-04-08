import 'package:billing_app/screens/invoice.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../hive/customer_details_controller.dart';
import '../model/customer_details.dart';

class OldBillPage extends StatefulWidget {
  @override
  State<OldBillPage> createState() => _OldBillPageState();
}

class _OldBillPageState extends State<OldBillPage> {
  List<Invoice> invoiceData = [];
  List<Product> productData = [];
  bool isLoading = true;

  Future<void> getData() async {
    invoiceData = await CustomerDetailsController.getData();
    productData = invoiceData[0].products;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Bill', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF00214d),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Expanded(
                child: ListView.builder(
                  itemCount: invoiceData.length,
                  itemBuilder: (context, index) {
                    // final bill = bills[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(invoiceData[index].customerName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text(invoiceData[index].invoiceNumber,
                                    style: TextStyle(color: Colors.grey[700])),
                                SizedBox(height: 4),
                                Text(invoiceData[index].grandTotal.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                                SizedBox(height: 4),
                                Text(invoiceData[index].invoiceDate,
                                    style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                            IconButton(
                              icon: Icon(LucideIcons.download,
                                  color: Colors.blue),
                              onPressed: () {
                                // Add download logic here
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //       content: Text(
                                //           'Downloading ${invoiceData[index].invoiceNumber}...')),
                                // );
                                // print(invoiceData[index].invoiceDate);
                                // print(invoiceData[index].grandTotal);
                                PrintPdf().printInvoice(context, invoiceData[index]);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
