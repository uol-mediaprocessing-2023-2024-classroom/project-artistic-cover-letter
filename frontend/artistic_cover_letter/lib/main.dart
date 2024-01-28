import 'package:artistic_cover_letter/pages/dashboard.dart';
import 'package:artistic_cover_letter/pages/home_page.dart';
import 'package:artistic_cover_letter/repositories/app_repository.dart';
import 'package:artistic_cover_letter/repositories/client_repository.dart';
import 'package:artistic_cover_letter/services/album_service.dart';
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
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      String clientID = prefs.getString('cldId') ?? "";
      String firstname = prefs.getString('firstName') ?? "";
      getIt.get<AlbumService>().loadImages(
            cldId: clientID,
            startIndex: 0,
            limit: 80,
          );
      getIt.get<ClientRepository>().updateCredentials(
            clientID: clientID,
            firstName: firstname,
          );
      debugPrint(getIt<ClientRepository>().clientID);
    }
    setState(() {});
  }

  @override
  void initState() {
    checkState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appRepository = getIt<AppRepository>();
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
      home: ValueListenableBuilder<bool>(
        valueListenable: appRepository.isLogout,
        builder: (context, isLoggedOut, child) {
          return isLoggedIn && !isLoggedOut
              ? const DashboardPage()
              : const HomePage();
        },
      ),
    );
  }
}
