import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageService {
  static const String _baseUrl = "https://cmp.photoprintit.com/api/photos";
  static const String _clientVersion = "0.0.1-medienVerDemo";

  Future<List<dynamic>> loadImages(String cldId, int loadedAmount) async {
    const limit = 60;
    List<dynamic> gallery = [];
    final response = await http.get(
      Uri.parse(
          "$_baseUrl/all?orderDirection=asc&showHidden=false&showShared=false&includeMetadata=false"),
      headers: {'cldId': cldId, 'clientVersion': _clientVersion},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Transform data and return
      // return data['photos'];
      for (var photo in data['photos']) {
        if (loadedAmount >= limit) break;
        loadedAmount++;
        var url =
            '$_baseUrl/${photo['id']}.jpg?size=300&errorImage=false&cldId=$cldId&clientVersion=$_clientVersion';
        gallery.add({
          'id': photo['id'],
          'name': photo['name'],
          'avgColor': photo['avgHexColor'],
          'timestamp': photo['timestamp'],
          'type': photo['mimeType'],
          'url': url
        });
      }
      return gallery;
    } else {
      // Handle error
      throw Exception('Failed to load images');
    }
  }
  // Additional methods for other requests...
}
