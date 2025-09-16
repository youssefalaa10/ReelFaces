import 'package:flutter/material.dart';
import '../../../core/utils/styles/app_text_style.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({required this.imageUrl, super.key, this.imageTitle});
  final String imageUrl;
  final String? imageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          imageTitle ?? 'Image Viewer',
          style: AppTextStyle.appBarTitle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 100, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'Image Viewer',
              style: AppTextStyle.headlineMedium.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'This screen will display the full-size image with zoom and pan capabilities.',
              style: AppTextStyle.bodyMedium.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
