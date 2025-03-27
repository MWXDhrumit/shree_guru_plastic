import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

  late Box companyBox;

  @override
  void initState() {
    super.initState();
    companyBox = Hive.box('companyBox');
    loadCompanyDetails();
  }

  void loadCompanyDetails() {
    companyNameController.text = companyBox.get('name', defaultValue: '');
    companyAddressController.text = companyBox.get('address', defaultValue: '');
    companyPhoneController.text = companyBox.get('phone', defaultValue: '');
    companyGSTController.text = companyBox.get('gst', defaultValue: '');
    bankNameController.text = companyBox.get('bankName', defaultValue: '');
    accountNumberController.text = companyBox.get('accountNumber', defaultValue: '');
    ifscCodeController.text = companyBox.get('ifscCode', defaultValue: '');
  }

  void saveCompanyDetails() {
    companyBox.put('name', companyNameController.text);
    companyBox.put('address', companyAddressController.text);
    companyBox.put('phone', companyPhoneController.text);
    companyBox.put('gst', companyGSTController.text);
    companyBox.put('bankName', bankNameController.text);
    companyBox.put('accountNumber', accountNumberController.text);
    companyBox.put('ifscCode', ifscCodeController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Company details saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Company Details")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("Company Name", companyNameController),
            buildTextField("Address", companyAddressController, maxLines: 2),
            buildTextField("Phone Number", companyPhoneController),
            buildTextField("GST Number", companyGSTController),
            buildTextField("Bank Name", bankNameController),
            buildTextField("Account Number", accountNumberController),
            buildTextField("IFSC Code", ifscCodeController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveCompanyDetails,
              child: Text("Save Details"),
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
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }
}
