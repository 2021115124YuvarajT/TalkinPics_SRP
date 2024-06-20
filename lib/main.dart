import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/category_selection.dart';
import 'screens/xylophone.dart';
import 'screens/Settings.dart';
import 'screens/Language.dart';
import 'screens/about.dart';

void main() {
  runApp(BoardMakerApp());
}

class BoardMakerApp extends StatelessWidget {
  const BoardMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        CategorySelection.id: (context) => CategorySelection(),
        XylophonePage.id: (context) => XylophonePage(),
        SettingsScreen.id: (context) => SettingsScreen(),
        LanguagePage.id: (context) => LanguagePage(),
        AboutUs.id: (context) => AboutUs(),
        // Add SettingsScreen to routes
      },
    );
  }
}
