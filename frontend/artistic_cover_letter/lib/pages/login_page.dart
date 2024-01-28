import 'package:artistic_cover_letter/pages/dashboard.dart';
import 'package:artistic_cover_letter/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

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
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 7),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.all(100.0),
                child: Card(
                  elevation: 3.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40.0,
                      horizontal: 32.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          "Log in to your account",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(color: Colors.red),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            helperStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            errorText:
                                errorMessage.isNotEmpty ? errorMessage : null,
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(),
                            errorStyle: const TextStyle(color: Colors.red),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            helperStyle: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 40),
                        _awaitingLoginResponse
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                                child: InkWell(
                                  onTap: () {
                                    _handleLogin().then(
                                      (value) {
                                        if (value) {
                                          _navigateToDashboardPage(context);
                                        } else {
                                          setState(() {
                                            errorMessage =
                                                "Invalid Credentials please try again";
                                          });
                                        }
                                      },
                                    );
                                  },
                                  child: const SizedBox(
                                    width: double.maxFinite,
                                    child: Card(
                                      color: Color(0XAA002C9B),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 25),
                                        child: Text(
                                          "Login",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        ),
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
            ),
            const Expanded(
              flex: 3, // Take the other half of the screen space
              child: Image(
                color: Colors.black12,
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/home04.png'),
              ),
            ),
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
