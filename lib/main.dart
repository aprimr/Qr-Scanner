import 'package:flutter/material.dart';
import 'package:qr_code/screens/scan.dart';
import 'package:qr_code/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = "QR Scanner";
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      routes: {AppRoutes.homeRoute: (context) => Scan()},
    );
  }
}
