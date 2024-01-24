import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/image_selection_widget.dart';

class ImageSelectionArea extends StatelessWidget {
  final List<dynamic> currentGallery;
  final ValueChanged<List<dynamic>> onSelectionDone;

  const ImageSelectionArea({
    Key? key,
    required this.currentGallery,
    required this.onSelectionDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Collage Editor",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    maxLines: 1,
                    maxLength: 10,
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                      FilteringTextInputFormatter.deny(
                        RegExp('[\\s]'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Enter your collage name here',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Choose your images",
                    style: TextStyle(fontSize: 16),
                  ),
                  ImageSelectionWidget(
                    onSelectionDone: onSelectionDone,
                    allImages: currentGallery,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: .5,
              ),
              itemCount: currentGallery.length,
              itemBuilder: (context, index) {
                return GridTile(
                  child: InkWell(
                    onTap: () {},
                    child: Image.network(
                      currentGallery[index]['url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
