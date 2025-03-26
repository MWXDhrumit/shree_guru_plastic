import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OldBillPage extends StatelessWidget {
  final List<Map<String, String>> bills = [
    {'name': 'John Doe', 'billNo': 'INV001', 'amount': '\$250', 'date': '25 Mar 2025'},
    {'name': 'Jane Smith', 'billNo': 'INV002', 'amount': '\$180', 'date': '20 Mar 2025'},
    {'name': 'Michael Brown', 'billNo': 'INV003', 'amount': '\$320', 'date': '15 Mar 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Bills', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: bills.length,
          itemBuilder: (context, index) {
            final bill = bills[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bill['name']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Bill No: ${bill['billNo']}', style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 4),
                        Text('Amount: ${bill['amount']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                        SizedBox(height: 4),
                        Text('Date: ${bill['date']}', style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.download, color: Colors.blue),
                      onPressed: () {
                        // Add download logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloading ${bill['billNo']}...')),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
