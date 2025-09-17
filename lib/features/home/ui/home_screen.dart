import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/dependency_injection/dependency.dart';
import '../../../core/domain/entities/person.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/utils/colors_manager.dart';
import '../../../core/utils/styles/app_text_style.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/person_card.dart';
import '../logic/popular_people_cubit.dart';
import '../logic/popular_people_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PopularPeopleCubit>()..loadPopularPeople(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GradientBackground(
          child: BlocBuilder<PopularPeopleCubit, PopularPeopleState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  // Header Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.welcomeMessage,
                            style: AppTextStyle.headlineLarge.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            AppStrings.appDescription,
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColors.white70,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            AppStrings.popularPeople,
                            style: AppTextStyle.titleLarge.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content based on state
                  _buildContent(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PopularPeopleState state) {
    if (state is PopularPeopleLoading) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              SizedBox(height: 16.h),
              Text(
                AppStrings.loading,
                style: AppTextStyle.bodyLarge.copyWith(
                  color: AppColors.white70,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is PopularPeopleError) {
      // If we have cached people, show them with an error banner
      if (state.cachedPeople != null && state.cachedPeople!.isNotEmpty) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Error banner
              Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Showing cached data. ${state.message}',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.read<PopularPeopleCubit>().retry(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              // Cached people grid
              ..._buildPeopleGrid(state.cachedPeople!),
            ]),
          ),
        );
      }

      // No cached data, show full error screen
      return SliverFillRemaining(
        child: Center(
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
                state.message,
                style: AppTextStyle.bodyLarge.copyWith(
                  color: AppColors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: () => context.read<PopularPeopleCubit>().retry(),
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (state is PopularPeopleLoaded ||
        state is PopularPeopleRefreshing ||
        state is PopularPeopleLoadingMore) {
      final people = state is PopularPeopleLoaded
          ? state.allPeople
          : state is PopularPeopleRefreshing
          ? state.currentPeople
          : (state as PopularPeopleLoadingMore).currentPeople;

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < people.length) {
                final person = people[index];
                return PersonCard(
                  person: person,
                  heroTag: 'person_${person.id}',
                  onTap: () => _navigateToPersonDetails(context, person),
                );
              } else if (state is PopularPeopleLoaded && !state.hasReachedMax) {
                // Load more when reaching the end
                context.read<PopularPeopleCubit>().loadMorePeople();
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                );
              }
              return null;
            },
            childCount:
                people.length +
                (state is PopularPeopleLoaded && !state.hasReachedMax ? 1 : 0),
          ),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  void _navigateToPersonDetails(BuildContext context, Person person) {
    Navigator.pushNamed(
      context,
      Routes.personDetailsScreen,
      arguments: {'personId': person.id, 'personName': person.name},
    );
  }

  List<Widget> _buildPeopleGrid(List<Person> people) {
    return [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
        ),
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          return PersonCard(
            person: person,
            heroTag: 'person_${person.id}',
            onTap: () => _navigateToPersonDetails(context, person),
          );
        },
      ),
    ];
  }
}
