import 'package:artistic_cover_letter/pages/home_page.dart';
import 'package:artistic_cover_letter/services/auth_service.dart';
import 'package:artistic_cover_letter/services/crop_service.dart';
import 'package:artistic_cover_letter/services/image_service.dart';
import 'package:artistic_cover_letter/widgets/image_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/responsive_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ImageService _imageService = ImageService();
  CropServive _servive = CropServive();
  List<dynamic> _currentGallery = [];
  List<dynamic> _selectedImages = [];
  String? client;
  String? username;

  void _onSelectionDone(List<dynamic> selectedImages) {
    setState(() {
      _selectedImages = selectedImages.toSet().toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    client = prefs.getString("cldId");
    username = prefs.getString("userName");
    debugPrint("client: ${client!}");
    try {
      var images =
          await _imageService.loadImages(client!, _currentGallery.length);
      setState(() {
        _currentGallery = images;
      });
    } catch (e) {
      // Handle exceptions
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: const Placeholder(),
      tablet: const Placeholder(),
      desktop: desktopView(context),
    );
  }

  Widget desktopView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                color: const Color(0xAAf4f9ff),
                child: Row(
                  children: [
                    Text(
                      "Welcome ${username ?? ""} ",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      child: const Text(
                        "AUSLOGEN",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        _logout(context).then((value) {
                          debugPrint(value.toString());
                          if (value) _navigateToHomePage(context);
                        });
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.15),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        labelText:
                                            'Enter your collage name here',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Choose your images",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    ImageSelectionWidget(
                                      onSelectionDone: _onSelectionDone,
                                      allImages: _currentGallery,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: GridView.builder(
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: .5,
                                ),
                                itemCount: _currentGallery.length,
                                itemBuilder: (context, index) {
                                  return GridTile(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedImages.add(
                                            _currentGallery[index],
                                          );
                                          _selectedImages =
                                              _selectedImages.toSet().toList();
                                        });
                                      },
                                      child: Image.network(
                                        _currentGallery[index]['url'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                _selectedImages.isNotEmpty
                                    ? Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 5,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    _selectedImages.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    height: 150,
                                                    width: 100,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .topRight, // Aligner le bouton en haut à droite
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            _servive.getCroppedImage(
                                                                client!,
                                                                _selectedImages[
                                                                        index]
                                                                    ['id']);
                                                          },
                                                          child: Image.network(
                                                            _selectedImages[
                                                                index]['url'],
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _selectedImages
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Center(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${_selectedImages.length} selected images",
                                                      ),
                                                      TextButton(
                                                        child: const Text(
                                                          "Generate Collage",
                                                        ),
                                                        onPressed: () {},
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                _selectedImages.isNotEmpty
                                    ? Expanded(
                                        flex: 3,
                                        child: Container(
                                          color: Colors.lime,
                                        ),
                                      )
                                    : const SizedBox(),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _logout(BuildContext context) async {
    AuthService authService = AuthService();
    bool isLogout = await authService.logout();
    return isLogout;
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
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
