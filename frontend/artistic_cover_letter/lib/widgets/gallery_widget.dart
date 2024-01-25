import 'package:artistic_cover_letter/services/image_service.dart';
import 'package:flutter/material.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({super.key});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  final ImageService _imageService = ImageService();
  List<dynamic> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      var images = await _imageService.loadImages('your_cldId', 0, 80);
      setState(() {
        _images = images;
      });
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return Image.network(_images[index]['url']);
      },
    );
  }
}
