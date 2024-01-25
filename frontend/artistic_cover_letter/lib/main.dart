import 'package:artistic_cover_letter/pages/dashboard.dart';
import 'package:artistic_cover_letter/pages/home_page.dart';
import 'package:artistic_cover_letter/utils/constants.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  Future<void> checkState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  void initState() {
    checkState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artistic Cover Letter',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          onSurface: Colors.white,
          onPrimaryContainer: Colors.white,
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      home: isLoggedIn ? const DashboardPage() : const HomePage(),
    );
  }
}
