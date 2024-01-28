import 'dart:convert';
import 'package:artistic_cover_letter/repositories/app_repository.dart';
import 'package:artistic_cover_letter/services/album_service.dart';
import 'package:artistic_cover_letter/repositories/client_repository.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _albumService = getIt.get<AlbumService>();
  final _clientService = getIt.get<ClientRepository>();
  final _appRepository = getIt.get<AppRepository>();

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
        _albumService.loadImages(
          cldId: data['session']['cldId'],
          startIndex: 0,
          limit: 100,
        );

        // Save session data to SharedPreferences
        _clientService.updateCredentials(
          clientID: data['session']['cldId'],
          firstName: data['user']['firstname'],
        );
        await prefs.setString('cldId', data['session']['cldId']);
        await prefs.setString('firstName', data['user']['firstname']);
        await prefs.setBool('isLoggedIn', true);
        return true;
        // Handle successful login
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
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
        _appRepository.setLogout(true);
      } else {
        // Handle error
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
