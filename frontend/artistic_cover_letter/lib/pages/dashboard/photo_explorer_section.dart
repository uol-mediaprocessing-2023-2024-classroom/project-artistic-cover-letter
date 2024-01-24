import 'package:flutter/material.dart';

class PhotoExplorerSection extends StatelessWidget {
  const PhotoExplorerSection({
    super.key,
    required this.currentGallery,
  });

  final List currentGallery;

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
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: .6,
        ),
        itemCount: currentGallery.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: InkWell(
              onTap: () {
                /*                   setState(() {
                  _selectedImages.add(
                    _currentGallery[index],
                  );
                  _selectedImages =
                      _selectedImages.toSet().toList();
                }); 
             */
              },
              child: Image.network(
                currentGallery[index]['url'],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
