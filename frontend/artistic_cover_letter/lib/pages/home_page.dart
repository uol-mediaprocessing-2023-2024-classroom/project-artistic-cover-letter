import 'package:artistic_cover_letter/pages/login_page.dart';
import 'package:artistic_cover_letter/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/footer_section_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: const Placeholder(),
      tablet: const Placeholder(),
      desktop: desktopView(),
    );
  }

  Widget desktopView() {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 50,
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Image(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/images/home01.png'),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Image(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/images/home02.png'),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Memories made easy",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            "Build your artistic \nCollage now",
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _navigateToLoginPage(context),
                            child: const Card(
                              color: Color.fromARGB(255, 236, 138, 131),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 60.0,
                                  vertical: 16,
                                ),
                                child: Text(
                                  "Start Collage now",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Image(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/home03.png'),
                ),
                const FooterSection(),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.white.withOpacity(0.3), // Color(0xAAf4f9ff),
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
                      "Home",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    child: const Text(
                      "Solution",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  TextButton(
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => _navigateToLoginPage(context),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
