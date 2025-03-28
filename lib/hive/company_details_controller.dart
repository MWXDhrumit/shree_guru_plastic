import 'package:hive_flutter/adapters.dart';

import '../model/company_details.dart';

class CompanyDetailsController {


  static saveData(CompanyDetailsModel companyDetailsModel) async{
    var box = await Hive.openBox<CompanyDetailsModel>("democompany");
    box.add(companyDetailsModel);
  }

  static getData() async{
    var box = await Hive.openBox<CompanyDetailsModel>("democompany");
    List<CompanyDetailsModel> list = await box.values.toList();
    print(list[0].name);
  }

}