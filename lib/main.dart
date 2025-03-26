import 'package:billing_app/screens/company_details_master.dart';
import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/invoice_form.dart';
import 'package:get/get.dart';

import 'screens/old_bill.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}


