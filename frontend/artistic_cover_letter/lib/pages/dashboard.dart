import 'package:artistic_cover_letter/pages/home_page.dart';
import 'package:artistic_cover_letter/services/auth_service.dart';
import 'package:artistic_cover_letter/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/responsive_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ImageService _imageService = ImageService();
  List<dynamic> _currentGallery = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    String? client = prefs.getString("cldId");
    debugPrint("client: ${client!}");
    try {
      var images =
          await _imageService.loadImages(client, _currentGallery.length);
      setState(() {
        _currentGallery = images;
      });
    } catch (e) {
      // Handle exceptions
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: const Placeholder(),
      tablet: const Placeholder(),
      desktop: desktopView(context),
    );
  }

  Widget desktopView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Use SafeArea to avoid any notches or status bar
        child: Column(
          // Column should be used to create vertical space for the Stack and ListView
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: const Color(0xAAf4f9ff),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Image(
                      image: AssetImage('assets/logos/logo&name.png'),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    child: const Text(
                      "AUSLOGEN",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      _logout(context).then((value) {
                        debugPrint(value.toString());
                        if (value) _navigateToHomePage(context);
                      });
                    },
                  )
                ],
              ),
            ),
            Expanded(
              // Expanded to fill the rest of the screen space
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: GridView.builder(
                      padding:
                          const EdgeInsets.all(8), // Add some padding if needed
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // Number of columns
                        crossAxisSpacing: 8, // Horizontal space between items
                        mainAxisSpacing: 8, // Vertical space between items
                        childAspectRatio: .5, // Aspect ratio of the children
                      ),
                      itemCount: _currentGallery.length,
                      itemBuilder: (context, index) {
                        return GridTile(
                          child: Image.network(
                            _currentGallery[index]['url'],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Stack(
                      children: [
                        const Image(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/images/home01.png'),
                        ),
                        Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.lime,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _logout(BuildContext context) async {
    AuthService authService = AuthService();
    bool isLogout = await authService.logout();
    return isLogout;
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
