import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';

class VisualizerSection extends StatelessWidget {
  const VisualizerSection({
    super.key,
    required this.collageResponse,
    required List selectedImages,
    required TextEditingController editingController,
  })  : _selectedImages = selectedImages,
        _editingController = editingController;

  final Response? collageResponse;
  final List _selectedImages;
  final TextEditingController _editingController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: SizedBox(
        child: Center(
          child: collageResponse != null
              ? Image.memory(
                  collageResponse!.bodyBytes,
                )
              : _selectedImages.isEmpty
                  ? const EditorStateAnimation(
                      text: "Please Select some images to start",
                      assetPath: 'assets/jsons/Camera.json',
                    )
                  : _editingController.text.isEmpty
                      ? const EditorStateAnimation(
                          text: "Please write your collage name",
                          assetPath: 'assets/jsons/Teaching.json',
                        )
                      : collageResponse == null
                          ? const EditorStateAnimation(
                              text: "'Ready to Start' 🚀",
                              assetPath: null,
                            )
                          : const EditorStateAnimation(
                              text: "Wait for it...",
                              assetPath: 'assets/jsons/Loading.json',
                            ),
        ),
      ),
    );
  }
}

class EditorStateAnimation extends StatelessWidget {
  final String? assetPath;
  final String text;
  const EditorStateAnimation({
    super.key,
    required this.assetPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        assetPath != null ? Lottie.asset(assetPath!) : const SizedBox(),
        Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(
              255,
              247,
              234,
              234,
            ),
          ),
        ),
      ],
    );
  }
}
