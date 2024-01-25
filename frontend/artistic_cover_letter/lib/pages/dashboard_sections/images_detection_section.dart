import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../services/collage_service.dart';
import '../../widgets/image_display_widget.dart';

class ImagesDetectionSection extends StatefulWidget {
  final List<dynamic> selectedImages;
  final String? clientID;
  final Function(int index) onRemoveImage;
  final CollageService service;

  const ImagesDetectionSection({
    Key? key,
    required this.selectedImages,
    required this.clientID,
    required this.onRemoveImage,
    required this.service,
  }) : super(key: key);

  @override
  State<ImagesDetectionSection> createState() => _ImagesDetectionSectionState();
}

class _ImagesDetectionSectionState extends State<ImagesDetectionSection> {
  final Map<String, Future<Response>> _imageFutures = {};

  @override
  void initState() {
    super.initState();
    _updateImageFutures();
  }

  void _updateImageFutures() {
    for (var image in widget.selectedImages) {
      final imageId = image['id'];
      _imageFutures.putIfAbsent(imageId,
          () => widget.service.getCroppedImage(widget.clientID!, imageId));
    }
  }

  @override
  void didUpdateWidget(covariant ImagesDetectionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateImageFutures();
  }

  @override
  Widget build(BuildContext context) {
    return widget.selectedImages.isNotEmpty
        ? Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedImages.length,
              itemBuilder: (BuildContext context, int index) {
                final imageId = widget.selectedImages[index]['id'];
                return Container(
                  key: ValueKey(imageId),
                  height: 150,
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        InkWell(
                          onTap: () {
                            // Actions on tap, if necessary
                          },
                          child: Center(
                            child: ImageItem(
                              key: UniqueKey(), // Unique key for ImageItem
                              imageFuture: _imageFutures[imageId]!,
                            ),
                          ),
                        ),
                        IconButton.filled(
                          hoverColor: Colors.red,
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => widget.onRemoveImage(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : const SizedBox();
  }
}

class ImageItem extends StatelessWidget {
  final Future<Response> imageFuture;

  const ImageItem({
    Key? key,
    required this.imageFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
      future: imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.statusCode == 200) {
            return Column(
              children: [
                ImageDisplayWidget(
                  imageData: snapshot.data!.bodyBytes,
                ),
                const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          } else {
            return const Text('Error while loading image');
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
