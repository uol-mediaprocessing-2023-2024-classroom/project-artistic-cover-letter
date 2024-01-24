import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../../services/collage_service.dart';
import '../../widgets/image_display_widget.dart';

class CropedImagesSection extends StatelessWidget {
  const CropedImagesSection({
    super.key,
    required this.selectedImages,
    required this.service,
    required this.client,
    required this.cropedImages,
  });

  final List selectedImages;
  final CollageService service;
  final String? client;
  final List<Uint8List> cropedImages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedImages.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 150,
            width: 100,
            padding: const EdgeInsets.all(5),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                InkWell(
                  onTap: () {
                    // Show the image alternative in a dialog
                  },
                  child: FutureBuilder<Response>(
                    future: service.getCroppedImage(
                        client!, selectedImages[index]['id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData &&
                            snapshot.data!.statusCode == 200) {
                          cropedImages.add(snapshot.data!.bodyBytes);
                          return ImageDisplayWidget(
                            imageData: snapshot.data!.bodyBytes,
                          );
                        } else {
                          return const Text(
                              'Erreur lors du chargement de l\'image');
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    selectedImages.removeAt(
                      index,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
