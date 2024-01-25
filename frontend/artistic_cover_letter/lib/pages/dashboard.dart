import 'package:artistic_cover_letter/pages/dashboard_sections/images_detection_section.dart';
import 'package:artistic_cover_letter/pages/home_page.dart';
import 'package:artistic_cover_letter/services/auth_service.dart';
import 'package:artistic_cover_letter/services/collage_service.dart';
import 'package:artistic_cover_letter/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/injection.dart';
import '../widgets/responsive_widget.dart';
import 'dashboard_sections/editor_section.dart';
import 'dashboard_sections/header_section.dart';
import 'dashboard_sections/image_gallery_section.dart';
import 'dashboard_sections/preview_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final CollageService _service = CollageService();
  final TextEditingController _editingController = TextEditingController();
  final List<dynamic> _currentGallery = [];
  List<dynamic> _selectedImages = [];
  Response? collageResponse;
  String? _clientID;
  String? _username;
  String errorMessage = "";
  int _startIndex = 0;
  static const int _limit = 60;
  bool _isLoading = false; // To track loading state
  bool _hasMore = true; // To determine if more images are available

  void _onSelectionDone(List<dynamic> selectedImages) {
    setState(() {
      _selectedImages = selectedImages.toSet().toList();
    });
  }

  @override
  void initState() {
    _loadPreferences().then((value) {
      _loadImages();
    });
    super.initState();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _clientID = prefs.getString("cldId");
      _username = prefs.getString("userName");
    });
  }

  Future<void> _loadImages() async {
    // Check for loading, more images, and client ID availability
    if (!_hasMore || _isLoading || _clientID == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageService = getIt.get<ImageService>();
      var newImages =
          await imageService.loadImages(_clientID!, _startIndex, _limit);

      setState(() {
        if (newImages.isNotEmpty) {
          _currentGallery.addAll(newImages);
          _startIndex += newImages.length;
        } else {
          _hasMore = false;
        }
      });
    } catch (e) {
      debugPrint('Error loading more images: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleImageTap(dynamic image) {
    setState(() {
      if (!_selectedImages.contains(image)) {
        _selectedImages = List.from(_selectedImages)..add(image);
      }
    });
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

  void _generateCollage() {
    {
      if (_editingController.text.isEmpty) {
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
      } else if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please select some images",
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
            debugPrint('Collage Done');
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
      tablet: _buildDesktopView(),
      desktop: _buildDesktopView(),
    );
  }

  Widget _buildDesktopView() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              HeaderSection(
                username: _username,
                onLogout: () {
                  _logout(context).then((value) {
                    if (value) _navigateToHomePage(context);
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: ImageGallerySection(
                          currentGallery: _currentGallery,
                          onImageTap: (image) => _handleImageTap(image),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: EditorSection(
                          editingController: _editingController,
                          allImages: _currentGallery,
                          onSelectionDone: _onSelectionDone,
                          generateCollage: _generateCollage,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: PreviewSection(
                                collageResponse: collageResponse,
                                selectedImages: _selectedImages,
                                editingController: _editingController,
                                isLoading: _isLoading,
                              ),
                            ),
                            ImagesDetectionSection(
                              selectedImages: _selectedImages,
                              clientID: _clientID,
                              onRemoveImage: (index) {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
                              service: _service,
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
}
