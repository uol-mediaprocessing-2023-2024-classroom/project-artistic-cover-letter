import 'package:flutter/material.dart';

class ImageGallerySection extends StatelessWidget {
  final List<dynamic> currentGallery;
  final Function(dynamic) onImageTap;

  const ImageGallerySection({
    Key? key,
    required this.currentGallery,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.07),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: .6,
        ),
        itemCount: currentGallery.length,
        itemBuilder: (context, index) {
          var image = currentGallery[index];
          return InkWell(
            onTap: () => onImageTap(image),
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                image['url'],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
