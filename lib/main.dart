import 'package:flutter/material.dart';
import 'MainPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FTL:MV Save Manager',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      home: const MainPage(
        title: "FTL:MV Save Backup Manager",
        dev: true,
        hideDevButton: true,
        versionMain : "",
        versionDev : "230501"
      ),
    );
  }
}
