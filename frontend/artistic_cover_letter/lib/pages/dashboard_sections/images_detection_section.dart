import 'package:artistic_cover_letter/repositories/images_repository.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';

class ImagesDetectionSection extends StatelessWidget {
  final imagesRepository = getIt<ImagesRepository>();

  ImagesDetectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ValueListenableBuilder<List<List<String>>>(
        valueListenable: imagesRepository.cropImageLinks,
        builder: (context, value, child) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: value.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                key: UniqueKey(),
                height: 150,
                width: 100,
                padding: const EdgeInsets.all(5),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            getIt<ImagesRepository>().clearCollage();
                            getIt<ImagesRepository>().setCropImageAlternative(
                              alternativeImages: value[index],
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  value[index].first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton.filled(
                        hoverColor: Colors.red,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            getIt<ImagesRepository>().removeCropImageLinks(
                          indexToRemove: index,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
