import 'package:billing_app/model/customer_details.dart';
import 'package:billing_app/screens/invoice_folder/invoice_form.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalInvoices = 0;
  double totalRevenue = 0.0;
  List<charts.Series<MonthlyData, String>> chartData = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    const boxName = 'democustomer';

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Invoice>(boxName);
    }

    final box = Hive.box<Invoice>(boxName);
    final invoices = box.values.toList();

    Map<String, double> revenueMap = {};
    Map<String, int> invoiceCountMap = {};

    totalRevenue = 0.0;
    totalInvoices = invoices.length;

    for (var invoice in invoices) {
      if (invoice.invoiceDate.isNotEmpty) {
        try {
          DateTime date = DateFormat('yyyy-MM-dd').parse(invoice.invoiceDate);
          String month = DateFormat('MMM').format(date);

          double revenue = invoice.grandTotal;
          totalRevenue += revenue;

          revenueMap.update(month, (val) => val + revenue, ifAbsent: () => revenue);
          invoiceCountMap.update(month, (val) => val + 1, ifAbsent: () => 1);
        } catch (e) {
          debugPrint("Date parse error: $e");
        }
      }
    }

    final months = revenueMap.keys.toList()..sort((a, b) =>
        DateFormat('MMM').parse(a).month.compareTo(DateFormat('MMM').parse(b).month));

    List<MonthlyData> data = months.map((month) {
      return MonthlyData(
        month: month,
        revenue: revenueMap[month] ?? 0.0,
        invoiceCount: invoiceCountMap[month] ?? 0,
      );
    }).toList();

    setState(() {
      chartData = [
        charts.Series<MonthlyData, String>(
          id: 'Revenue',
          domainFn: (MonthlyData data, _) => data.month,
          measureFn: (MonthlyData data, _) => data.revenue,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          data: data,
          labelAccessorFn: (MonthlyData data, _) =>
          '₹${data.revenue.toStringAsFixed(0)}',
        ),
        charts.Series<MonthlyData, String>(
          id: 'Invoices',
          domainFn: (MonthlyData data, _) => data.month,
          measureFn: (MonthlyData data, _) => data.invoiceCount,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          data: data,
          labelAccessorFn: (MonthlyData data, _) => '${data.invoiceCount}',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF00214d),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildStatCard("Total Invoices", totalInvoices.toString(), Icons.receipt),
                buildStatCard("Total Revenue", "₹${totalRevenue.toStringAsFixed(2)}", Icons.monetization_on),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Monthly Report", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: charts.BarChart(
                chartData,
                animate: true,
                barGroupingType: charts.BarGroupingType.grouped,
                behaviors: [charts.SeriesLegend()],
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
          ).then((_) => _loadDashboardData());
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
              Icon(icon, size: 36, color: const Color(0xFF00214d)),
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

class MonthlyData {
  final String month;
  final double revenue;
  final int invoiceCount;

  MonthlyData({required this.month, required this.revenue, required this.invoiceCount});
}
