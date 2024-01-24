import 'package:artistic_cover_letter/pages/dashboard/header.dart';
import 'package:artistic_cover_letter/pages/home_page.dart';
import 'package:artistic_cover_letter/services/auth_service.dart';
import 'package:artistic_cover_letter/services/collage_service.dart';
import 'package:artistic_cover_letter/services/image_service.dart';
import 'package:artistic_cover_letter/widgets/image_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/image_display_widget.dart';
import '../widgets/responsive_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ImageService _imageService = ImageService();
  final CollageService _service = CollageService();
  final List<Uint8List> _cropedImages = [];
  final TextEditingController _editingController = TextEditingController();
  List<dynamic> _currentGallery = [];
  List<dynamic> _selectedImages = [];
  Response? collageResponse;
  String? client;
  String? username;
  String errorMessage = "";

  final gradientStartColor = const Color.fromARGB(255, 238, 153, 153);
  final gradientMiddleColor = const Color.fromARGB(255, 149, 51, 44);
  final gradientEndColor = const Color.fromARGB(255, 35, 34, 34);

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
      debugPrint(e.toString());
    }
  }

  void _generateCollage() {
    {
      if (_editingController.text.isEmpty || _selectedImages.isEmpty) {
        setState(() {
          errorMessage = "Please enter collage name";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please enter collage name",
            ),
          ),
        );
        return;
      }
      _service
          .getLetter(
        _editingController.text,
      )
          .then(
        (value) {
          setState(() {
            collageResponse = value;
          });
        },
      );
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
              HeaderWidget(
                username: username,
                onLogout: () {
                  _logout(context).then((value) {
                    if (value) _navigateToHomePage(context);
                  });
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        gradientEndColor,
                        gradientMiddleColor,
                        gradientEndColor
                      ],
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.07),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: .6,
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
                      ),
                      Flexible(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.00, 0.1, 0.8, .99],
                                colors: [
                                  Colors.transparent,
                                  gradientEndColor.withOpacity(.35),
                                  gradientEndColor.withOpacity(.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
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
                                    controller: _editingController,
                                    onChanged: (value) {
                                      setState(() {
                                        errorMessage = "";
                                      });
                                    },
                                    inputFormatters: [
                                      UpperCaseTextFormatter(),
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: 'Enter your collage name here',
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorMessage.isNotEmpty
                                      ? Text(
                                          errorMessage,
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
                                    onSelectionDone: _onSelectionDone,
                                    allImages: _currentGallery,
                                  ),
                                  const Divider(thickness: 2),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${_selectedImages.length} selected images",
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.generating_tokens_outlined,
                                          ),
                                          onPressed:
                                              _selectedImages.isNotEmpty &&
                                                      _editingController
                                                          .text.isNotEmpty
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
                          ),
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
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _selectedImages.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              height: 150,
                                              width: 100,
                                              padding: const EdgeInsets.all(5),
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      // Show the image alternative in a dialog
                                                    },
                                                    child:
                                                        FutureBuilder<Response>(
                                                      future: _service
                                                          .getCroppedImage(
                                                              client!,
                                                              _selectedImages[
                                                                  index]['id']),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot
                                                                  .hasData &&
                                                              snapshot.data!
                                                                      .statusCode ==
                                                                  200) {
                                                            _cropedImages.add(
                                                                snapshot.data!
                                                                    .bodyBytes);
                                                            return ImageDisplayWidget(
                                                              imageData: snapshot
                                                                  .data!
                                                                  .bodyBytes,
                                                            );
                                                          } else {
                                                            return const Text(
                                                                'Erreur lors du chargement de l\'image');
                                                          }
                                                        } else {
                                                          return const CircularProgressIndicator();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          _selectedImages
                                                              .removeAt(
                                                            index,
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const SizedBox(),
                                VisualizerWidget(
                                    collageResponse: collageResponse,
                                    selectedImages: _selectedImages,
                                    editingController: _editingController),
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

class VisualizerWidget extends StatelessWidget {
  const VisualizerWidget({
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
