import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ImagesRepository {
  ValueNotifier<List<dynamic>> albumContent = ValueNotifier([]);
  ValueNotifier<List<List<String>>> cropImageLinks = ValueNotifier([]);
  ValueNotifier<List<String>> cropImageAlternatives = ValueNotifier([]);
  ValueNotifier<Response?> collage = ValueNotifier(null);

  // set the album content
  void setAlbumContent(List<dynamic> details) {
    albumContent.value = details;
  }

  // add the image links to the list of links
  void addNewCropImageLinks({required List<String> newImageLinks}) {
    final updatedLinks = List<List<String>>.from(cropImageLinks.value)
      ..add(newImageLinks);
    cropImageLinks.value = updatedLinks;
    cropImageAlternatives.value = [];
  }

  // remove the image links at the given index
  void removeCropImageLinks({required int indexToRemove}) {
    // Ensure the index is valid
    if (indexToRemove < 0 || indexToRemove >= cropImageLinks.value.length) {
      debugPrint("Invalid index");
      return;
    }

    final updatedLinks = List<List<String>>.from(cropImageLinks.value)
      ..removeAt(indexToRemove);
    cropImageLinks.value = updatedLinks;

    if (updatedLinks.isNotEmpty) {
      cropImageAlternatives.value = updatedLinks[0];
    } else {
      cropImageAlternatives.value = [];
    }
  }

  // set the alternative images
  void setCropImageAlternative({required List<String> alternativeImages}) {
    cropImageAlternatives.value = alternativeImages;
  }

// Swap one crop image alternative to the first index and also update it in cropImageLinks
  void swapCropImageAlternatives({required int indexToSwap}) {
    // Ensure the index is valid
    if (indexToSwap < 0 || indexToSwap >= cropImageAlternatives.value.length) {
      debugPrint("Invalid index");
      return;
    }

    // Swap in cropImageAlternatives
    final updatedAlternatives = List<String>.from(cropImageAlternatives.value);
    final tempAlt = updatedAlternatives[0];
    updatedAlternatives[0] = updatedAlternatives[indexToSwap];
    updatedAlternatives[indexToSwap] = tempAlt;
    cropImageAlternatives.value = updatedAlternatives;

    // Find which sublist in cropImageLinks contains the cropImageAlternatives
    int sublistIndex = cropImageLinks.value.indexWhere((sublist) =>
        sublist.length == cropImageAlternatives.value.length &&
        sublist.every((item) => cropImageAlternatives.value.contains(item)));

    if (sublistIndex != -1) {
      // Swap in the found sublist in cropImageLinks
      final updatedLinks = List<List<String>>.from(cropImageLinks.value);
      final sublist = updatedLinks[sublistIndex];
      final tempLink = sublist[0];
      sublist[0] = sublist[indexToSwap];
      sublist[indexToSwap] = tempLink;
      updatedLinks[sublistIndex] = sublist;

      cropImageLinks.value = updatedLinks;
    }
  }

  void downloadImage(Uint8List imageBytes, String fileName) {
    // Convertir les octets de l'image en URL de données Base64
    final base64Data = base64Encode(imageBytes);
    final href = 'data:image/jpeg;base64,$base64Data';

    // Créer un élément HTML <a> pour le téléchargement
    AnchorElement(href: href)
      ..setAttribute('download', fileName)
      ..click();
  }

  // generate the collage
  void setCollage(Response response) {
    collage.value = response;
    clearImageLinks();
  }

  // clear the collage
  void clearCollage() {
    collage.value = null;
  }

  // clear the image links
  void clearImageLinks() {
    cropImageLinks.value = [];
  }

  // clear the album images
  void clearAlbumImages() {
    albumContent.value = [];
  }
}
