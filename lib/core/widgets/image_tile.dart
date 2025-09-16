import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/image_model.dart';
import '../utils/colors_manager.dart';
import '../utils/styles/app_text_style.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({
    required this.image,
    super.key,
    this.onTap,
    this.heroTag,
    this.width,
    this.height,
  });
  final ImageModel image;
  final VoidCallback? onTap;
  final String? heroTag;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: AppColors.black20,
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Hero(
            tag: heroTag ?? 'image_${image.id}',
            child: Stack(
              children: [
                // Image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.surfaceVariant,
                  child: Image.network(
                    image.url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildShimmer();
                    },
                  ),
                ),

                // Overlay
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
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (image.title != null)
                          Text(
                            image.title!,
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (image.aspectRatio != null)
                          Text(
                            image.aspectRatio!,
                            style: AppTextStyle.caption.copyWith(
                              color: AppColors.white70,
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
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceVariant,
      child: Icon(Icons.image, size: 40.sp, color: AppColors.onSurfaceVariant),
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.shimmerBase,
            AppColors.shimmerHighlight,
            AppColors.shimmerBase,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
