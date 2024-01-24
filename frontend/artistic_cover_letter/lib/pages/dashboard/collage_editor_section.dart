import 'package:artistic_cover_letter/services/collage_service.dart';
import 'package:artistic_cover_letter/widgets/image_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class CollageEditorSection extends StatefulWidget {
  const CollageEditorSection({
    super.key,
    required this.gradientEndColor,
    required this.editingController,
    required this.errorMessage,
    required this.selectedImages,
    required this.currentGallery,
    required this.onSelectionDone,
    required this.collageService,
    required this.getCollageResponse,
  });

  final List<dynamic> currentGallery;
  final Color gradientEndColor;
  final TextEditingController editingController;
  final String errorMessage;
  final List selectedImages;
  final Function(List<dynamic>) onSelectionDone;
  final CollageService collageService;
  final Function(Response) getCollageResponse;

  @override
  State<CollageEditorSection> createState() => _CollageEditorSectionState();
}

class _CollageEditorSectionState extends State<CollageEditorSection> {
  void _generateCollage() {
    {
      widget.collageService
          .getLetter(
        widget.editingController.text,
      )
          .then(
        (value) {
          setState(() {
            widget.getCollageResponse(value);
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.00, 0.1, 0.8, .99],
            colors: [
              Colors.transparent,
              widget.gradientEndColor.withOpacity(.35),
              widget.gradientEndColor.withOpacity(.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/logos/logo.png'),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Collage Editor",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              maxLines: 1,
              maxLength: 10,
              controller: widget.editingController,
              onChanged: (value) {},
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Enter your collage name here',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            widget.errorMessage.isNotEmpty
                ? Text(
                    widget.errorMessage,
                    style: const TextStyle(
                      color: Colors.orange,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 16.0),
            const Text(
              "Choose your images",
              style: TextStyle(fontSize: 16),
            ),
            ImageSelectionWidget(
              onSelectionDone: widget.onSelectionDone,
              allImages: widget.currentGallery,
            ),
            const Divider(thickness: 2),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${widget.selectedImages.length} selected images",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.generating_tokens_outlined,
                    ),
                    onPressed: widget.selectedImages.isNotEmpty &&
                            widget.editingController.text.isNotEmpty
                        ? _generateCollage
                        : null,
                    label: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Generate Collage'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
