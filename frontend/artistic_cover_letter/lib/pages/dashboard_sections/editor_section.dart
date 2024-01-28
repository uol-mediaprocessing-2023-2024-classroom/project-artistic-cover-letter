import 'package:artistic_cover_letter/repositories/images_repository.dart';
import 'package:artistic_cover_letter/services/collage_service.dart';
import 'package:artistic_cover_letter/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:artistic_cover_letter/widgets/image_selection_widget.dart';
import 'package:flutter/services.dart';

class EditorSection extends StatelessWidget {
  final TextEditingController editingController;

  const EditorSection({
    Key? key,
    required this.editingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xAA0069FF),
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Collage Editor',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: editingController,
              style: const TextStyle(color: Colors.white),
              inputFormatters: [UpperCaseTextFormatter()],
              decoration: const InputDecoration(
                labelText: 'Enter your collage name here',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                errorStyle: TextStyle(color: Colors.red),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                helperStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
              maxLength: 10,
            ),
            ImageSelectionWidget(
              onSelectionDone: (List<dynamic> _) {},
              allImages: const [],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.maxFinite,
              child: Card(
                elevation: BorderSide.strokeAlignOutside,
                shadowColor: Colors.white,
                clipBehavior: Clip.hardEdge,
                color: const Color(0XAA002C9B),
                child: InkWell(
                  enableFeedback: true,
                  splashColor: Colors.white,
                  hoverColor: Colors.black,
                  onTap: () => generateCollage(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.generating_tokens,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Generate Collage",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateCollage(BuildContext context) async {
    final collageService = getIt<CollageService>();
    final imagesRepository = getIt<ImagesRepository>();
    if (editingController.text.isNotEmpty &&
        imagesRepository.cropImageLinks.value.isNotEmpty) {
      final collageName = editingController.text;
      final imagesNames = imagesRepository.cropImageLinks.value
          .map((e) => e.first.split('/').last.split('.').first)
          .join('-');
      debugPrint(imagesNames);
      await collageService.createCollage(
        collageName: collageName,
        imagesNames: imagesNames,
      );
    } else {
      if (imagesRepository.cropImageLinks.value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            elevation: 100.0,
            backgroundColor: Colors.red,
            content: Text(
              'Please select images to generate collage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            elevation: 100.0,
            backgroundColor: Colors.red,
            content: Text(
              'Please enter collage name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }
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
