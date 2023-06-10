import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme_manager.dart';
import 'theme/theme_constants.dart';

void main() => runApp(MyApp());

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp({super.key});

  bool lightTheme = true;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static ThemeManager themeManager = ThemeManager();

  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    themeManager.addListener(themeListener);
    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarterIt',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      home: const SplashScreen(),
    );
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }
}
