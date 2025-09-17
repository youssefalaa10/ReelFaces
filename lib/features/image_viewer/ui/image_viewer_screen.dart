import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/dependency_injection/dependency.dart';
import '../../../core/domain/entities/profile_image.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/utils/colors_manager.dart';
import '../../../core/utils/styles/app_text_style.dart';
import '../../../core/widgets/save_button.dart';
import '../logic/image_save_cubit.dart';
import '../logic/image_save_state.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({required this.imageUrl, super.key, this.imageTitle});
  final String imageUrl;
  final String? imageTitle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ImageSaveCubit>(),
      child: _ImageViewerScreenView(imageUrl: imageUrl, imageTitle: imageTitle),
    );
  }
}

class _ImageViewerScreenView extends StatelessWidget {
  const _ImageViewerScreenView({required this.imageUrl, this.imageTitle});
  final String imageUrl;
  final String? imageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          imageTitle ?? AppStrings.imageViewer,
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
      body: BlocBuilder<ImageSaveCubit, ImageSaveState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Fullscreen Image
              Center(
                child: Hero(
                  tag: 'image_$imageUrl',
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildErrorWidget(context);
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
                      if (imageTitle != null)
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
                            imageTitle!,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(height: 16.h),

                      // Save Button with progress
                      _buildSaveButton(context, state),

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
          );
        },
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, ImageSaveState state) {
    if (state is ImageSaveProgress) {
      return Column(
        children: [
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: AppColors.white30,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Saving... ${(state.progress * 100).toInt()}%',
            style: AppTextStyle.bodySmall.copyWith(color: AppColors.white70),
          ),
        ],
      );
    }

    if (state is ImageSaved) {
      return Column(
        children: [
          SaveButton(
            onPressed: () {
              // Already saved, show success
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppStrings.imageSaved),
                  backgroundColor: AppColors.success,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            isSaved: true,
          ),
          SizedBox(height: 8.h),
          Text(
            'Saved to gallery',
            style: AppTextStyle.bodySmall.copyWith(color: AppColors.success),
          ),
        ],
      );
    }

    if (state is ImageSaveError) {
      return Column(
        children: [
          SaveButton(onPressed: () => _handleSaveImage(context)),
          SizedBox(height: 8.h),
          Text(
            state.message,
            style: AppTextStyle.bodySmall.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Default state (ImageSaveInitial or ImageSaving)
    return SaveButton(
      onPressed: () => _handleSaveImage(context),
      isLoading: state is ImageSaving,
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
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
              // Refresh the image
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(
                Routes.imageViewerScreen,
                arguments: {'imageUrl': imageUrl, 'imageTitle': imageTitle},
              );
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

  void _handleSaveImage(BuildContext context) {
    // Create a ProfileImage from the current image URL
    final profileImage = ProfileImage(
      aspectRatio: 1.0, // Default aspect ratio
      height: 1000, // Default height
      filePath: imageUrl,
      voteAverage: 0.0, // Default vote average
      voteCount: 0, // Default vote count
      width: 1000, // Default width
    );

    context.read<ImageSaveCubit>().saveImage(profileImage);
  }
}
