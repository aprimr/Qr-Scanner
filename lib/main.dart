import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/provider/theme_provider.dart';
import 'package:qr_code/screens/scan.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/utils/theme.dart';
import 'package:qr_code/widgets/bottom_nav.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = "QR Scanner";
    final themeData = context.watch<ThemeProvider>();
    return MaterialApp(
      title: title,
      home: BottomNav(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeData.themeMode == ThemeMode.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: {AppRoutes.homeRoute: (context) => Scan()},
    );
  }
}
