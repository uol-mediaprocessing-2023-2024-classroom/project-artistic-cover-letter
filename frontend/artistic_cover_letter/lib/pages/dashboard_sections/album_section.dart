import 'package:artistic_cover_letter/repositories/images_repository.dart';
import 'package:artistic_cover_letter/services/collage_service.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';

class AlbumSection extends StatelessWidget {
  final imageRepository = getIt.get<ImagesRepository>();

  AlbumSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.07),
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: ValueListenableBuilder<List<dynamic>>(
          valueListenable: imageRepository.albumContent,
          builder: (context, links, child) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: .6,
              ),
              itemCount: links.length,
              itemBuilder: (context, index) {
                var imageLink = links[index]['url'];
                return InkWell(
                  onTap: () {
                    // check if the image is already cropped
                    getIt<CollageService>().getCroppedImages(
                      links[index]['id'],
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      imageLink,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
