import 'package:billing_app/model/master_customer_model.dart';
import 'package:billing_app/model/master_product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/company_details.dart';
import 'model/customer_details.dart';
import 'screens/home.dart';
import 'screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open Hive box
  // await Hive.openBox('companyBox');
  Hive.registerAdapter(CompanyDetailsModelAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(MasterCustomerAdapter());
  Hive.registerAdapter(MasterProductAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}


