import 'dart:math';

import 'package:artistic_cover_letter/repositories/images_repository.dart';
import 'package:artistic_cover_letter/services/collage_service.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final imageRespository = getIt<ImagesRepository>();
  final collageService = getIt<CollageService>();
  final Random _random = Random();

  void _handleAutoSelect() {
    if (_isAutoSelectEnabled) {
      int numberOfFiles = int.tryParse(_numberController.text) ?? 0;
      imageRespository.clearImageLinks();
      for (int i = 0; i < numberOfFiles; i++) {
        int randomIndex =
            _random.nextInt(imageRespository.albumContent.value.length);
        dynamic randomImage = imageRespository.albumContent.value[randomIndex];
        collageService.getCroppedImages(randomImage['id']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('randomly select images'),
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
                  title: Expanded(
                    child: TextField(
                      controller: _numberController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Amount of images',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: _isAutoSelectEnabled,
                      maxLength: 2,
                    ),
                  ),
                  trailing: Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 100,
                      height: 50,
                      child: Card(
                        color: Colors.black,
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () => _numberController.text.isEmpty
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    elevation: 100.0,
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Please enter a number of images',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : _handleAutoSelect(),
                          hoverColor: const Color(0XAA002C9B),
                          child: const Center(
                            child: Text(
                              "Apply",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
