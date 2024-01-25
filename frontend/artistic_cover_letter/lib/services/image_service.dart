import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'image_cache_service.dart';

class ImageService {
  static const String _baseUrl = "https://cmp.photoprintit.com/api/photos";
  static const String _clientVersion = "0.0.1-medienVerDemo";
  final ImageCacheService _cacheService;

  ImageService() : _cacheService = GetIt.instance.get<ImageCacheService>();

  Future<List<dynamic>> loadImages(
      String cldId, int startIndex, int limit) async {
    List<dynamic> gallery = [];
    final response = await http.get(
      Uri.parse(
          "$_baseUrl/all?start=$startIndex&limit=$limit&orderDirection=asc&showHidden=false&showShared=false&includeMetadata=false"),
      headers: {'cldId': cldId, 'clientVersion': _clientVersion},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (var photo in data['photos']) {
        var url =
            '$_baseUrl/${photo['id']}.jpg?size=300&errorImage=false&cldId=$cldId&clientVersion=$_clientVersion';

        if (!_cacheService.containsImage(photo['id'])) {
          gallery.add({
            'id': photo['id'],
            'name': photo['name'],
            'avgColor': photo['avgHexColor'],
            'timestamp': photo['timestamp'],
            'type': photo['mimeType'],
            'url': url
          });
          _cacheService.cacheImage(photo['id'], url);
        } else {
          var cachedUrl = _cacheService.getImage(photo['id']);
          gallery.add({'id': photo['id'], 'url': cachedUrl});
        }
      }
      return gallery;
    } else {
      throw Exception('Failed to load images');
    }
  }

  // Additional methods...
}
