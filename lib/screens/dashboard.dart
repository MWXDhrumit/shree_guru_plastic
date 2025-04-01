import 'package:billing_app/screens/invoice.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'invoice_form.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalInvoices = 25; // Fetch from SQLite later
  double totalRevenue = 10500.75; // Fetch from SQLite

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
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
                buildStatCard("Total Revenue", "₹$totalRevenue", Icons.monetization_on),
              ],
            ),
            const SizedBox(height: 20),

            // Centered Generate Invoice Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Call the printPdf method to generate and print the invoice
                  PrintPdf().printPdf(context);
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Generate Invoice"),
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
          );
        },
        backgroundColor: Colors.blue,
        tooltip: "Create New Invoice",
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
