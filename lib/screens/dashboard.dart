import 'package:billing_app/model/customer_details.dart';
import 'package:billing_app/screens/invoice_form.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'invoice.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalInvoices = 0;
  double totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final box = Hive.box<Invoice>('invoices');
    final invoices = box.values.toList();

    setState(() {
      totalInvoices = invoices.length;
      totalRevenue = invoices.fold(0.0, (sum, item) => sum + (item.grandTotal ?? 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF00214d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatCard("Total Invoices", totalInvoices.toString(), Icons.receipt),
                buildStatCard("Total Revenue", "₹${totalRevenue.toStringAsFixed(2)}", Icons.monetization_on),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // PrintPdf().printPdf(context);
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Export PDF Preview"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InvoiceFormScreen()),
          ).then((_) => _loadDashboardData()); // Refresh stats after new invoice
        },
        backgroundColor: Colors.blue,
        tooltip: "Create New Invoice",
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, size: 36, color: Color(0xFF00214d)),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
