import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class CompanyDetailsScreen extends StatefulWidget {
  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController companyGSTController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCompanyDetails();
  }

  Future<void> _loadCompanyDetails() async {
    final db = await DatabaseHelper.getInstance();
    final data = await db.getCompanyDetails();

    if (data != null) {
      setState(() {
        companyNameController.text = data['name']!;
        companyAddressController.text = data['address']!;
        companyPhoneController.text = data['phone']!;
        companyGSTController.text = data['gst']!;
        bankNameController.text = data['bank_name']!;
        accountNumberController.text = data['account_number']!;
        ifscCodeController.text = data['ifsc_code']!;
      });
    }
  }

  Future<void> _saveCompanyDetails() async {
    final db = await DatabaseHelper.getInstance();
    await db.insertOrUpdateCompany({
      'name': companyNameController.text,
      'address': companyAddressController.text,
      'phone': companyPhoneController.text,
      'gst': companyGSTController.text,
      'bank_name': bankNameController.text,
      'account_number': accountNumberController.text,
      'ifsc_code': ifscCodeController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Company details saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Company Details", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionHeader("Company Information"),
            buildTextField("Company Name", companyNameController),
            buildTextField("Address", companyAddressController, maxLines: 2),
            buildTextField("Phone Number", companyPhoneController),
            buildTextField("GST Number", companyGSTController),
            Divider(thickness: 1, height: 30, color: Colors.grey.shade300),
            buildSectionHeader("Bank Details"),
            buildTextField("Bank Name", bankNameController),
            buildTextField("Account Number", accountNumberController),
            buildTextField("IFSC Code", ifscCodeController),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _saveCompanyDetails,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF007AFF)]),
                    boxShadow: [
                      BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Save Details",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 15, color: Colors.black87),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}
