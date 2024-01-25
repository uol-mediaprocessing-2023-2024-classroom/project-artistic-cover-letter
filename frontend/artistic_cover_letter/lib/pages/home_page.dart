import 'package:artistic_cover_letter/pages/login_page.dart';
import 'package:artistic_cover_letter/utils/constants.dart';
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
          const Positioned(
            bottom: 0,
            top: 150,
            right: 0,
            left: 0,
            child: Image(
              fit: BoxFit.fitWidth,
              image: AssetImage('assets/images/home.png'),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: kBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.17,
                      ),
                      const Text(
                        "Memories made easy 🚀",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Effortlessly Create \nArtistic Collages!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 90,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () => _navigateToLoginPage(context),
                        child: const Card(
                          color: Color(0XAA002C9B),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 150.0,
                              vertical: 25,
                            ),
                            child: Text(
                              "Start Collage now",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                  ),
                  const FooterSection(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 10.0,
              ),
              color: const Color.fromARGB(255, 249, 250, 254),
              child: Row(
                children: [
                  const Image(
                    image: AssetImage('assets/logos/logo&name.png'),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
                      iconColor: MaterialStatePropertyAll(Colors.white),
                      overlayColor: MaterialStatePropertyAll(
                        Color.fromARGB(170, 1, 50, 120),
                      ),
                      backgroundColor: MaterialStatePropertyAll(
                        Color(0xAA0069FF),
                      ),
                    ),
                    icon: const Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _navigateToLoginPage(context),
                  ),
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
