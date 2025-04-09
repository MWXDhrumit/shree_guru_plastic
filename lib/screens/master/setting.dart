import 'package:billing_app/screens/master/master_customer_page.dart';
import 'package:flutter/material.dart';

import 'company_details_master.dart';
import 'master_product page.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00214d);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _settingsTile(
            title: 'Add Master Customer',
            icon: Icons.person_add_alt_1,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MasterCustomerPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          _settingsTile(
            title: 'Add Master Product',
            icon: Icons.inventory_2_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  MasterProductPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          _settingsTile(
            title: 'Add Company Details',
            icon: Icons.inventory_2_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  CompanyDetailsScreen()),
              );
            },
          ),

        ],
      ),
    );
  }

  Widget _settingsTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF00214d);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withOpacity(0.1)),
      ),
      tileColor: Colors.grey[50],
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: primaryColor, size: 16),
    );
  }
}
