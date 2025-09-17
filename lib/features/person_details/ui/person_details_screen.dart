import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/dependency_injection/dependency.dart';
import '../../../core/domain/entities/person_details.dart';
import '../../../core/domain/entities/profile_image.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/utils/colors_manager.dart';
import '../../../core/utils/styles/app_text_style.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/image_tile.dart';
import '../logic/person_details_cubit.dart';
import '../logic/person_details_state.dart';
import '../logic/person_images_cubit.dart';
import '../logic/person_images_state.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({
    required this.personId,
    required this.personName,
    super.key,
  });
  final int personId;
  final String personName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<PersonDetailsCubit>()..loadPersonDetails(personId),
        ),
        BlocProvider(
          create: (context) =>
              getIt<PersonImagesCubit>()..loadPersonImages(personId),
        ),
      ],
      child: const _PersonDetailsScreenView(),
    );
  }
}

class _PersonDetailsScreenView extends StatelessWidget {
  const _PersonDetailsScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.personDetails, style: AppTextStyle.appBarTitle),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
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
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: GradientBackground(
        child: BlocBuilder<PersonDetailsCubit, PersonDetailsState>(
          builder: (context, detailsState) {
            return BlocBuilder<PersonImagesCubit, PersonImagesState>(
              builder: (context, imagesState) {
                return _buildContent(context, detailsState, imagesState);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PersonDetailsState detailsState,
    PersonImagesState imagesState,
  ) {
    if (detailsState is PersonDetailsLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (detailsState is PersonDetailsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80.sp, color: AppColors.white70),
            SizedBox(height: 16.h),
            Text(
              AppStrings.error,
              style: AppTextStyle.headlineMedium.copyWith(
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              detailsState.message,
              style: AppTextStyle.bodyLarge.copyWith(color: AppColors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => context.read<PersonDetailsCubit>().retry(),
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    if (detailsState is PersonDetailsLoaded) {
      return _buildPersonDetails(
        context,
        detailsState.personDetails,
        imagesState,
      );
    }

    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildPersonDetails(
    BuildContext context,
    PersonDetails person,
    PersonImagesState imagesState,
  ) {
    return CustomScrollView(
      slivers: [
        // Person Header
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Hero(
                  tag: 'person_${person.id}',
                  child: Container(
                    width: 120.w,
                    height: 180.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.cardBackground,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black30,
                          blurRadius: 8.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: person.profilePath != null
                          ? Image.network(
                              person.profilePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholder();
                              },
                            )
                          : _buildPlaceholder(),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                // Person Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person.name,
                        style: AppTextStyle.headlineMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Popularity
                      if (person.popularity != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 20.sp,
                              color: AppColors.tmdbGreen,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${person.popularity!.toStringAsFixed(1)} ${AppStrings.popularity}',
                              style: AppTextStyle.bodyLarge.copyWith(
                                color: AppColors.tmdbGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 12.h),

                      // Birth Date
                      if (person.birthday != null)
                        _buildInfoRow(
                          Icons.cake,
                          AppStrings.birthDate,
                          person.birthday!,
                        ),

                      // Place of Birth
                      if (person.placeOfBirth != null)
                        _buildInfoRow(
                          Icons.location_on,
                          AppStrings.placeOfBirth,
                          person.placeOfBirth!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Biography Section
        if (person.biography != null && person.biography!.isNotEmpty)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.cardBackground.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.biography,
                    style: AppTextStyle.titleLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    person.biography!,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Known For Section
        if (person.alsoKnownAs.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.knownFor,
                    style: AppTextStyle.titleLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: person.alsoKnownAs.map((name) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Text(
                          name,
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

        // Images Grid
        _buildImagesGrid(context, imagesState),

        // Bottom Spacing
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }

  Widget _buildImagesGrid(BuildContext context, PersonImagesState imagesState) {
    if (imagesState is PersonImagesLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Loading images...',
                  style: AppTextStyle.bodyLarge.copyWith(
                    color: AppColors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (imagesState is PersonImagesError) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60.sp,
                  color: AppColors.white70,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Failed to load images',
                  style: AppTextStyle.bodyLarge.copyWith(
                    color: AppColors.white70,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () => context.read<PersonImagesCubit>().retry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text(AppStrings.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (imagesState is PersonImagesLoaded && imagesState.images.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Gallery',
            style: AppTextStyle.titleLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (imagesState is PersonImagesLoaded) {
      return SliverPadding(
        padding: EdgeInsets.all(16.w),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final image = imagesState.images[index];
            return ImageTile(
              image: image,
              heroTag: 'image_${image.filePath}',
              onTap: () => _navigateToImageViewer(context, image),
            );
          }, childCount: imagesState.images.length),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: AppColors.white70),
          SizedBox(width: 8.w),
          Text(
            '$label: ',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.bodyMedium.copyWith(color: AppColors.white),
            ),
          ),
        ],
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

  void _navigateToImageViewer(BuildContext context, ProfileImage image) {
    Navigator.pushNamed(
      context,
      Routes.imageViewerScreen,
      arguments: {'imageUrl': image.filePath, 'imageTitle': 'Profile Image'},
    );
  }
}
