import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String? username;
  final VoidCallback onLogout;

  const HeaderWidget({
    Key? key,
    required this.username,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            "Welcome ${username ?? ""} ",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            clipBehavior: Clip.none,
            onPressed: onLogout,
            icon: const Icon(Icons.logout, size: 24.0),
            label: const Text('Logout', textAlign: TextAlign.left),
          )
        ],
      ),
    );
  }
}
