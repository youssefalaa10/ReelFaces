import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../domain/entities/person.dart';
import '../utils/colors_manager.dart';
import '../utils/styles/app_text_style.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({required this.person, super.key, this.onTap, this.heroTag});
  final Person person;
  final VoidCallback? onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: AppColors.black30,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Hero(
                tag: heroTag ?? 'person_${person.id}',
                child: Container(
                  width: double.infinity,
                  height: 200.h,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                  ),
                  child: person.profilePath != null
                      ? Image.network(
                          person.profilePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _buildShimmer();
                          },
                        )
                      : _buildPlaceholder(),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name
                    Flexible(
                      child: Text(
                        person.name,
                        style: AppTextStyle.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Known For (showing count of movies)
                    if (person.knownFor.isNotEmpty)
                      Flexible(
                        child: Text(
                          '${person.knownFor.length} movies',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    SizedBox(height: 8.h),

                    // Popularity
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16.sp,
                          color: AppColors.tmdbGreen,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            person.popularity?.toStringAsFixed(1) ?? 'N/A',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.tmdbGreen,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceVariant,
      child: Icon(Icons.person, size: 60.sp, color: AppColors.onSurfaceVariant),
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
