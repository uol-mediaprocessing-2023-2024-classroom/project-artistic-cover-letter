import 'dart:math';

import 'package:flutter/material.dart';

class ImageSelectionWidget extends StatefulWidget {
  final Function(List<dynamic>) onSelectionDone;
  final List<dynamic> allImages;

  const ImageSelectionWidget({
    Key? key,
    required this.onSelectionDone,
    required this.allImages,
  }) : super(key: key);

  @override
  State<ImageSelectionWidget> createState() => _ImageSelectionWidgetState();
}

class _ImageSelectionWidgetState extends State<ImageSelectionWidget> {
  bool _isAutoSelectEnabled = false;
  final TextEditingController _numberController = TextEditingController();
  final Random _random = Random();

  void _handleAutoSelect() {
    if (_isAutoSelectEnabled) {
      int numberOfFiles = int.tryParse(_numberController.text) ?? 0;
      List<dynamic> selectedImages = [];

      // Assurez-vous que le nombre demandé n'est pas supérieur à la taille de la liste
      numberOfFiles = min(numberOfFiles, widget.allImages.length);

      while (selectedImages.length < numberOfFiles) {
        int randomIndex = _random.nextInt(widget.allImages.length);
        dynamic randomImage = widget.allImages[randomIndex];
        if (!selectedImages.contains(randomImage)) {
          selectedImages.add(randomImage);
        }
      }
      widget.onSelectionDone(selectedImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('select automatically'),
          value: _isAutoSelectEnabled,
          onChanged: (bool? value) {
            setState(() => _isAutoSelectEnabled = value ?? false);
          },
        ),
        _isAutoSelectEnabled
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  title: Expanded(
                    child: TextField(
                      controller: _numberController,
                      decoration: const InputDecoration(
                        labelText: 'Amount of images',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: _isAutoSelectEnabled,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: _isAutoSelectEnabled ? _handleAutoSelect : null,
                    child: const Text('Apply'),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
