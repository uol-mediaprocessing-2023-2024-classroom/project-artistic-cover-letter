import 'dart:convert';
import 'package:artistic_cover_letter/repositories/client_repository.dart';
import 'package:artistic_cover_letter/repositories/images_repository.dart';
import 'package:artistic_cover_letter/services/loading_service.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CollageService {
  final LoadingService _loadingService = getIt<LoadingService>();
  final ImagesRepository _imagesRepository = getIt<ImagesRepository>();
  final ClientRepository _clientRepository = getIt<ClientRepository>();
  final String _baseUrl = "http://127.0.0.1:8000";

  Future<void> getCroppedImages(String imgId) async {
    String? cldId = _clientRepository.clientID;
    _loadingService.setLoading(true);
    var url = Uri.parse("$_baseUrl/get-crop/$cldId/$imgId");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<String> imageUrls = List<String>.from(json.decode(response.body));
        _imagesRepository.addNewCropImageLinks(newImageLinks: imageUrls);
        debugPrint('Cropped images loaded successfully!');
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
        throw Exception(
          'Failed to load cropped images: HTTP status ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      throw Exception('Failed to load cropped images: $e');
    } finally {
      _loadingService.setLoading(false);
    }
  }

  Future<void> createCollage({
    required String collageName,
    required String imagesNames,
  }) async {
    _loadingService.setLoading(true);
    var url = Uri.parse("$_baseUrl/create-collage/$collageName/$imagesNames");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        getIt<ImagesRepository>().setCollage(response);
      } else {
        throw Exception(
          'Failed to load collage: HTTP status ${response.statusCode}',
        );
      }
    } on Exception catch (e) {
      debugPrint('Error occurred: $e');
      throw Exception('Failed to load collage: $e');
    } finally {
      _loadingService.setLoading(false);
    }
  }
}
