import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';

class PreviewSection extends StatelessWidget {
  final Response? collageResponse;
  final List<dynamic> selectedImages;
  final TextEditingController editingController;
  final bool isLoading;

  const PreviewSection({
    Key? key,
    required this.collageResponse,
    required this.selectedImages,
    required this.editingController,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.07),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Center(
        child: isLoading
            ? Lottie.asset('assets/jsons/Loading.json', fit: BoxFit.scaleDown)
            : collageResponse != null
                ? Image.memory(collageResponse!.bodyBytes)
                : _buildPlaceholder(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    // Placeholder content based on the state of selected images and collage name
    if (selectedImages.isEmpty) {
      return const Text(
        "Please select some images to start",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    } else if (editingController.text.isEmpty) {
      return const Text(
        "Please enter a name for your collage",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    } else {
      return Column(
        children: [
          Lottie.asset('assets/jsons/Loading.json', fit: BoxFit.scaleDown),
          const Text(
            "Wait for it...",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
  }
}
