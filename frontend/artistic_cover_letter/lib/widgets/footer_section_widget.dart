import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 209, 217, 241).withOpacity(0.5),
            const Color(0xAA0069FF),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 16.0),
      child: const Column(
        children: [
          Text(
            'Artistic Cover Letter',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Make lasting memories with the collage you create.',
            style: TextStyle(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Text(
            'All rights reserved ©2024 Photo Collage',
            style: TextStyle(
              color: Colors.white54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
