import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CropServive {
  Future<void> getCroppedImage(String cldId, String imgId) async {
    var url = Uri.parse("http://127.0.0.1:8000/get-crop/$cldId/$imgId");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint(data);
    } else {
      // Gérez les erreurs ici
      throw Exception('Failed to load cropped image');
    }
  }
}
