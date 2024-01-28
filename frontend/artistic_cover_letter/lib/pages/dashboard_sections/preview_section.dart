import 'package:artistic_cover_letter/repositories/images_repository.dart';
import 'package:artistic_cover_letter/services/loading_service.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PreviewSection extends StatelessWidget {
  final loadingService = getIt<LoadingService>();
  final imagesRepository = getIt<ImagesRepository>();
  final TextEditingController editingController;
  PreviewSection({
    Key? key,
    required this.editingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Center(
          child: ValueListenableBuilder<bool>(
        valueListenable: loadingService.isLoading,
        builder: (context, isLoading, child) {
          return isLoading
              ? Column(
                  children: [
                    Lottie.asset(
                      'assets/jsons/Loading.json',
                      fit: BoxFit.scaleDown,
                    ),
                    const Text(
                      "Wait for it...",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : ValueListenableBuilder<List<String>>(
                  valueListenable: imagesRepository.cropImageAlternatives,
                  builder: (context, value, child) {
                    final collageResponse = imagesRepository.collage.value;
                    return collageResponse != null
                        ? InkWell(
                            onTap: () {
                              imagesRepository.downloadImage(
                                collageResponse.bodyBytes.buffer.asUint8List(),
                                editingController.text,
                              );
                            },
                            onHover: (value) {
                              if (value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    "Click to download",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ));
                              }
                            },
                            child: Image.memory(
                              collageResponse.bodyBytes.buffer.asUint8List(),
                            ),
                          )
                        : value.isNotEmpty
                            ? _buildCropSelector(context, value)
                            : _buildPlaceholder(context);
                  },
                );
        },
      )),
    );
  }

  Widget _buildCropSelector(BuildContext context, List<String> cropLinks) {
    // Crop selector based on the state of selected images
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
        itemCount: cropLinks.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => getIt<ImagesRepository>()
                .swapCropImageAlternatives(indexToSwap: index),
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                cropLinks[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildPlaceholder(
  BuildContext context,
) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: const Text(
              "1",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: const Text(
            "Enter your cover letter \n(Collage Name)",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: const Text(
              "2",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: const Text(
            "Select images from the album \n(manually or randomly)",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: const Text(
              "3",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: const Text(
            "Click on images to edit them",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: const Text(
              "4",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: const Text(
            "Click on Generate Collage",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: const Text(
              "5",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: const Text(
            "Click on the Collage to download it",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}
