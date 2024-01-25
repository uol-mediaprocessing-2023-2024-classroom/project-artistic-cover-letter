import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageDisplayWidget extends StatelessWidget {
  final Uint8List imageData;

  const ImageDisplayWidget({Key? key, required this.imageData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      imageData,
      fit: BoxFit.fill,
    );
  }
}
