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

  bool isUpdating = false; // Controls button visibility

  @override
  void initState() {
    super.initState();
    _loadCompanyDetails();
  }

  // Load company details from Hive
  Future<void> _loadCompanyDetails() async {
    List<CompanyDetailsModel> companyList = await CompanyDetailsController.getData();

    if (companyList.isNotEmpty) {
      CompanyDetailsModel companyDetails = companyList.first;

      companyNameController.text = companyDetails.name;
      companyAddressController.text = companyDetails.address;
      companyPhoneController.text = companyDetails.mobileNumber;
      companyGSTController.text = companyDetails.gstNumber;
      bankNameController.text = companyDetails.bankName;
      accountNumberController.text = companyDetails.accountNo;
      ifscCodeController.text = companyDetails.ifsc;

      setState(() {
        isUpdating = true;
      });
    } else {
      setState(() {
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Company Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF00214d),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField("Company Name", companyNameController),
                buildTextField("Address", companyAddressController, maxLines: 2),
                buildTextField("Phone Number", companyPhoneController),
                buildTextField("GST Number", companyGSTController),
                buildTextField("Bank Name", bankNameController),
                buildTextField("Account Number", accountNumberController),
                buildTextField("IFSC Code", ifscCodeController),
                SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final model = CompanyDetailsModel(
                        name: companyNameController.text,
                        address: companyAddressController.text,
                        mobileNumber: companyPhoneController.text,
                        gstNumber: companyGSTController.text,
                        bankName: bankNameController.text,
                        ifsc: ifscCodeController.text,
                        accountNo: accountNumberController.text,
                      );

                      if (isUpdating) {
                        await CompanyDetailsController.updateData(model);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Company details updated successfully!')),
                        );
                      } else {
                        await CompanyDetailsController.saveData(model);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Company details saved successfully!')),
                        );
                      }
                      _loadCompanyDetails(); // Refresh UI
                    },
                    style: ElevatedButton.styleFrom(
                      primary: isUpdating ? Colors.green : Color(0xFF00214d),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isUpdating ? "Update Details" : "Save Details",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: icon != null ? Icon(icon, color: Color(0xFF00214d)) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xFF00214d),
              width: 2.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 1.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
