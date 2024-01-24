import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CollageService {
  Future<http.Response> getCroppedImage(String cldId, String imgId) async {
    var url = Uri.parse("http://127.0.0.1:8000/get-crop/$cldId/$imgId");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load cropped image');
    }
  }

  Future<http.Response> getLetter(String name) async {
    var url = Uri.parse("http://127.0.0.1:8000/get-letter/$name");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load cropped image');
    }
  }

  Future<http.Response> createCollage(
      List<Uint8List> images, String collageText) async {
    var uri = Uri.parse("http://127.0.0.1:8000/create-collage");

    // Créer une requête multipart
    var request = http.MultipartRequest('POST', uri);

    // Ajouter le texte au corps de la requête
    request.fields['text'] = collageText;

    // Ajouter chaque image en tant que partie de la requête multipart
    for (int i = 0; i < images.length; i++) {
      var image = images[i];
      request.files.add(http.MultipartFile.fromBytes(
        'images', // Nom du champ pour les images
        image,
        filename: 'image$i.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    // Envoyer la requête
    var streamedResponse = await request.send();

    // Recevoir la réponse
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to create collage');
    }
  }
}
