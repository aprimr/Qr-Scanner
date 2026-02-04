import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/provider/favourite_provider.dart';
import 'package:qr_code/provider/settings_provider.dart';
import 'package:qr_code/provider/theme_provider.dart';
import 'package:qr_code/screens/create_barcode_result.dart';
import 'package:qr_code/screens/create_result.dart';
import 'package:qr_code/screens/scan.dart';
import 'package:qr_code/screens/scan_result.dart';
import 'package:qr_code/screens/setting.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/utils/theme.dart';
import 'package:qr_code/widgets/bottom_nav.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
      ],
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
      routes: {
        AppRoutes.settingRoute: (context) => Setting(),
        AppRoutes.homeRoute: (context) => Scan(),
        AppRoutes.scanResultRoute: (context) => ScanResult(),
        AppRoutes.createResultRoute: (context) => CreateResult(),
        AppRoutes.createBarcodeResultRoute: (context) => CreateBarcodeResult(),
      },
    );
  }
}
