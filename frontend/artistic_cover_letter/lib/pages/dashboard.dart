import 'package:artistic_cover_letter/pages/dashboard_sections/images_detection_section.dart';
import 'package:artistic_cover_letter/services/album_service.dart';
import 'package:artistic_cover_letter/services/loading_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../utils/injection.dart';
import '../widgets/responsive_widget.dart';
import 'dashboard_sections/editor_section.dart';
import 'dashboard_sections/header_section.dart';
import 'dashboard_sections/album_section.dart';
import 'dashboard_sections/preview_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final LoadingService loadingService = getIt<LoadingService>();
  final imageService = getIt.get<AlbumService>();
  final TextEditingController _editingController = TextEditingController();
  Response? collageResponse;
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
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
              HeaderSection(),
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
                      AlbumSection(),
                      Flexible(
                        flex: 2,
                        child: EditorSection(
                          editingController: _editingController,
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: PreviewSection(
                                editingController: _editingController,
                              ),
                            ),
                            ImagesDetectionSection(),
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
