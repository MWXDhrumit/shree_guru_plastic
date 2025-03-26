import 'package:billing_app/screens/old_bill.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

import 'company_details_master.dart';
import 'dashboard.dart';
import 'invoice.dart';
import 'invoice_form.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Dashboard(),
    OldBillPage(),
    CompanyDetailsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice App'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.receipt_long),
            title: Text('Dashboard'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.article),
            title: Text('OldBill'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.history),
            title: Text('Master'),
          ),


        ],
      ),
    );
  }
}
