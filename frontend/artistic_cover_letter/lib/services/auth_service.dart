import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.post(
          Uri.parse('https://cmp.photoprintit.com/api/account/session/'),
          headers: {
            'Content-Type': 'application/json',
            'clientVersion': "0.0.1-medienVerDemo",
            'apiAccessKey': "6003d11a080ae5edf4b4f45481b89ce7",
          },
          body: jsonEncode({
            'login': email,
            'password': password,
            'deviceName': "Medienverarbeitung CEWE API Demo",
          }));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Save session data to SharedPreferences
        await prefs.setString('cldId', data['session']['cldId']);
        await prefs.setString('userName', data['user']['firstname']);
        await prefs.setBool('isLoggedIn', true);
        return true;
        // Handle successful login
      } else {
        // Handle error
        return false;
      }
    } catch (e) {
      // Handle exception
    }
    return false;
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.delete(
        Uri.parse(
            "https://cmp.photoprintit.com/api/account/session/?invalidateRefreshToken=true"),
        headers: {
          'cldId': prefs.getString('cldId') ?? '',
          'clientVersion': "0.0.1-medienVerDemo",
        },
      );
      if (response.statusCode == 204 || response.statusCode == 200) {
        await prefs.clear();
        return true;
      } else {
        // Handle error
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    // Construct logout request
    // ...
    return false;
  }
}
