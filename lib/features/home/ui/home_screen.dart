import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/data/mock_data_service.dart';
import '../../../core/models/person_model.dart';
import '../../../core/routing/routes.dart';
import '../../../core/utils/app_string.dart';
import '../../../core/utils/colors_manager.dart';
import '../../../core/utils/styles/app_text_style.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/person_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final people = MockDataService.getAllPeople();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GradientBackground(
          child: CustomScrollView(
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
        
              // People Grid
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final person = people[index];
                    return PersonCard(
                      person: person,
                      heroTag: 'person_${person.id}',
                      onTap: () => _navigateToPersonDetails(context, person),
                    );
                  }, childCount: people.length),
                ),
              ),
        
              // Bottom Spacing
              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPersonDetails(BuildContext context, PersonModel person) {
    Navigator.pushNamed(
      context,
      Routes.personDetailsScreen,
      arguments: {'personId': person.id, 'personName': person.name},
    );
  }
}
