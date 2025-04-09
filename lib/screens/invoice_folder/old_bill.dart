import 'package:billing_app/screens/invoice_folder/invoice.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../hive/customer_details_controller.dart';
import '../../model/customer_details.dart';

class OldBillPage extends StatefulWidget {
  @override
  State<OldBillPage> createState() => _OldBillPageState();
}

class _OldBillPageState extends State<OldBillPage> {
  List<Invoice> invoiceData = [];
  List<Invoice> filteredInvoiceData = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  Future<void> getData() async {
    invoiceData = await CustomerDetailsController.getData();
    filteredInvoiceData = List.from(invoiceData); // Initial copy
    setState(() {
      isLoading = false;
    });
  }

  void searchInvoices(String query) {
    if (query.isEmpty) {
      filteredInvoiceData = List.from(invoiceData);
    } else {
      filteredInvoiceData = invoiceData.where((invoice) {
        final nameMatch = invoice.customerName.toLowerCase().contains(query.toLowerCase());
        final billMatch = invoice.invoiceNumber.toLowerCase().contains(query.toLowerCase());
        return nameMatch || billMatch;
      }).toList();
    }
    setState(() {});
  }

  @override
  void initState() {
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by Name or Invoice No.",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: searchInvoices,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredInvoiceData.length,
                itemBuilder: (context, index) {
                  final invoice = filteredInvoiceData[index];

                  return Dismissible(
                    key: Key(invoice.invoiceNumber), // unique key
                    direction: DismissDirection.startToEnd, // swipe left to right
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Invoice'),
                          content: Text('Are you sure you want to delete this invoice?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel')),
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text('Delete', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) async {
                      // Delete from Hive
                      await CustomerDetailsController.deleteInvoice(invoice.invoiceNumber);

                      // Remove from both lists
                      invoiceData.removeWhere((inv) => inv.invoiceNumber == invoice.invoiceNumber);
                      filteredInvoiceData.removeAt(index);

                      setState(() {});
                    },
                    background: Container(
                      padding: EdgeInsets.only(left: 20,),
                      alignment: Alignment.centerLeft,
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(invoice.customerName,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text(invoice.invoiceNumber,
                                    style: TextStyle(color: Colors.grey[700])),
                                SizedBox(height: 4),
                                Text(invoice.grandTotal.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                                SizedBox(height: 4),
                                Text(invoice.invoiceDate,
                                    style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                            IconButton(
                              icon: Icon(LucideIcons.download, color: Colors.blue),
                              onPressed: () {
                                PrintPdf().printInvoice(context, invoice);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
