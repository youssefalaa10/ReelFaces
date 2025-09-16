import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  // Display Styles
  static final TextStyle displayLarge = TextStyle(
    fontSize: 57.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static final TextStyle displayMedium = TextStyle(
    fontSize: 45.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  static final TextStyle displaySmall = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  // Headline Styles
  static final TextStyle headlineLarge = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  // Title Styles
  static final TextStyle titleLarge = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
  );

  static final TextStyle titleMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static final TextStyle titleSmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Body Styles
  static final TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static final TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label Styles
  static final TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static final TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static final TextStyle labelSmall = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // Custom App Styles
  static final TextStyle appBarTitle = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
  );

  static final TextStyle buttonText = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static final TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static final TextStyle overline = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.60,
  );

  // Light Text Theme
  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: displayLarge.copyWith(color: const Color(0xFF1C1B1F)),
    displayMedium: displayMedium.copyWith(color: const Color(0xFF1C1B1F)),
    displaySmall: displaySmall.copyWith(color: const Color(0xFF1C1B1F)),
    headlineLarge: headlineLarge.copyWith(color: const Color(0xFF1C1B1F)),
    headlineMedium: headlineMedium.copyWith(color: const Color(0xFF1C1B1F)),
    headlineSmall: headlineSmall.copyWith(color: const Color(0xFF1C1B1F)),
    titleLarge: titleLarge.copyWith(color: const Color(0xFF1C1B1F)),
    titleMedium: titleMedium.copyWith(color: const Color(0xFF1C1B1F)),
    titleSmall: titleSmall.copyWith(color: const Color(0xFF1C1B1F)),
    bodyLarge: bodyLarge.copyWith(color: const Color(0xFF1C1B1F)),
    bodyMedium: bodyMedium.copyWith(color: const Color(0xFF1C1B1F)),
    bodySmall: bodySmall.copyWith(color: const Color(0xFF1C1B1F)),
    labelLarge: labelLarge.copyWith(color: const Color(0xFF1C1B1F)),
    labelMedium: labelMedium.copyWith(color: const Color(0xFF1C1B1F)),
    labelSmall: labelSmall.copyWith(color: const Color(0xFF1C1B1F)),
  );

  // Dark Text Theme
  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: displayLarge.copyWith(color: const Color(0xFFE6E1E5)),
    displayMedium: displayMedium.copyWith(color: const Color(0xFFE6E1E5)),
    displaySmall: displaySmall.copyWith(color: const Color(0xFFE6E1E5)),
    headlineLarge: headlineLarge.copyWith(color: const Color(0xFFE6E1E5)),
    headlineMedium: headlineMedium.copyWith(color: const Color(0xFFE6E1E5)),
    headlineSmall: headlineSmall.copyWith(color: const Color(0xFFE6E1E5)),
    titleLarge: titleLarge.copyWith(color: const Color(0xFFE6E1E5)),
    titleMedium: titleMedium.copyWith(color: const Color(0xFFE6E1E5)),
    titleSmall: titleSmall.copyWith(color: const Color(0xFFE6E1E5)),
    bodyLarge: bodyLarge.copyWith(color: const Color(0xFFE6E1E5)),
    bodyMedium: bodyMedium.copyWith(color: const Color(0xFFE6E1E5)),
    bodySmall: bodySmall.copyWith(color: const Color(0xFFE6E1E5)),
    labelLarge: labelLarge.copyWith(color: const Color(0xFFE6E1E5)),
    labelMedium: labelMedium.copyWith(color: const Color(0xFFE6E1E5)),
    labelSmall: labelSmall.copyWith(color: const Color(0xFFE6E1E5)),
  );
}
