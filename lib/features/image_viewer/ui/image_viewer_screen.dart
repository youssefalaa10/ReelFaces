import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_string.dart';
import '../../../core/utils/colors_manager.dart';
import '../../../core/utils/styles/app_text_style.dart';
import '../../../core/widgets/save_button.dart';

class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen({required this.imageUrl, super.key, this.imageTitle});
  final String imageUrl;
  final String? imageTitle;

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  bool _isSaved = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          widget.imageTitle ?? AppStrings.imageViewer,
          style: AppTextStyle.appBarTitle.copyWith(color: AppColors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        backgroundColor: AppColors.black70,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Share functionality will be implemented later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality coming soon!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            icon: const Icon(Icons.share, color: AppColors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fullscreen Image
          Center(
            child: Hero(
              tag: 'image_${widget.imageUrl}',
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildLoadingWidget();
                    },
                  ),
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.transparent, AppColors.black70],
                ),
              ),
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image Info
                  if (widget.imageTitle != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black50,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        widget.imageTitle!,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  SizedBox(height: 16.h),

                  // Save Button
                  SaveButton(
                    onPressed: _handleSaveImage,
                    isLoading: _isLoading,
                    isSaved: _isSaved,
                  ),

                  SizedBox(height: 16.h),

                  // Instructions
                  Text(
                    'Pinch to zoom • Drag to pan',
                    style: AppTextStyle.caption.copyWith(
                      color: AppColors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Gradient Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.black60, AppColors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80.sp, color: AppColors.white70),
          SizedBox(height: 16.h),
          Text(
            AppStrings.error,
            style: AppTextStyle.headlineMedium.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            'Failed to load image',
            style: AppTextStyle.bodyLarge.copyWith(color: AppColors.white70),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
            label: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            strokeWidth: 3,
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.loading,
            style: AppTextStyle.bodyLarge.copyWith(color: AppColors.white70),
          ),
        ],
      ),
    );
  }

  void _handleSaveImage() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate save operation
    await Future<void>.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isSaved = true;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.imageSaved),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }

    // Reset saved state after 3 seconds
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSaved = false;
        });
      }
    });
  }
}
