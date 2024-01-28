import 'dart:convert';
import 'package:artistic_cover_letter/repositories/images_repository.dart';
import 'package:artistic_cover_letter/services/loading_service.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

class AlbumService {
  static const String _baseUrl = "https://cmp.photoprintit.com/api/photos";
  static const String _clientVersion = "0.0.1-medienVerDemo";
  final ImagesRepository _imageLinksService =
      GetIt.instance.get<ImagesRepository>();
  final LoadingService _loadingService = getIt.get<LoadingService>();

  Future<void> loadImages({
    required String cldId,
    required int startIndex,
    required int limit,
  }) async {
    List<dynamic> album = [];
    _loadingService.setLoading(true);
    try {
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
          album.add({
            'id': photo['id'],
            'name': photo['name'],
            'avgColor': photo['avgHexColor'],
            'timestamp': photo['timestamp'],
            'type': photo['mimeType'],
            'url': url
          });
        }
        _imageLinksService.setAlbumContent(album);
      } else {
        throw Exception('Failed to load images');
      }
    } finally {
      _loadingService.setLoading(false);
    }
  }

  // Additional methods...
}
