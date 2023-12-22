import 'package:artistic_cover_letter/pages/dashboard.dart';
import 'package:artistic_cover_letter/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/footer_section_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _awaitingLoginResponse = false;
  String errorMessage = "";

  Future<bool> _handleLogin() async {
    setState(() {
      _awaitingLoginResponse = true;
    });
    bool value = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _awaitingLoginResponse = false;
    });

    return value;
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 50,
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        flex: 2,
                        child: Image(
                          fit: BoxFit.fitHeight,
                          image: AssetImage('assets/images/home01.png'),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Card(
                          elevation: 1.0,
                          color: Colors.white,
                          margin: const EdgeInsets.all(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Image(
                                  fit: BoxFit.contain,
                                  image: AssetImage('assets/logos/logo.png'),
                                ),
                                const Text(
                                  "Welcome",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'Enter your email',
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 40),
                                errorMessage.isNotEmpty
                                    ? Text(
                                        errorMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 40),
                                _awaitingLoginResponse
                                    ? const CircularProgressIndicator()
                                    : InkWell(
                                        onTap: () {
                                          _handleLogin().then((value) {
                                            if (value) {
                                              _navigateToDashboardPage(context);
                                            } else {
                                              setState(() {
                                                errorMessage =
                                                    "Invalid Credentials please try again";
                                              });
                                            }
                                          });
                                        },
                                        child: const Card(
                                          color: Colors.blue,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 60.0,
                                              vertical: 16,
                                            ),
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  void _navigateToDashboardPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }
}
