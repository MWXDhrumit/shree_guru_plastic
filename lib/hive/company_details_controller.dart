import 'package:hive_flutter/adapters.dart';
import '../model/company_details.dart';

class CompanyDetailsController {

  static Future<void> saveData(CompanyDetailsModel companyDetailsModel) async {
    var box = await Hive.openBox<CompanyDetailsModel>("democompany");
    if (box.isNotEmpty) {
      await updateData(companyDetailsModel);
    } else {
      await box.add(companyDetailsModel);
    }
  }

  static Future<List<CompanyDetailsModel>> getData() async {
    var box = await Hive.openBox<CompanyDetailsModel>("democompany");
    return box.values.toList();
  }

  static Future<void> updateData(CompanyDetailsModel updatedCompanyDetails) async {
    var box = await Hive.openBox<CompanyDetailsModel>("democompany");

    if (box.isNotEmpty) {
      await box.putAt(0, updatedCompanyDetails);
    } else {
      print("No company details found to update.");
    }
  }
}
