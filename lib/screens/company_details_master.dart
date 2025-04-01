import 'package:billing_app/model/company_details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../hive/company_details_controller.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Company Details")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
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
                onPressed: ()async{
                  final model = CompanyDetailsModel(
                      name: companyNameController.text,
                      address: companyAddressController.text,
                      mobileNumber: companyPhoneController.text,
                      gstNumber: companyGSTController.text,
                      bankName: bankNameController.text,
                      ifsc: ifscCodeController.text,
                      accountNo: accountNumberController.text);
                  await CompanyDetailsController.saveData(model);
                  await CompanyDetailsController.getData();
                },
                child: Text("Save Details"),
              ),
            ],
          ),
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
