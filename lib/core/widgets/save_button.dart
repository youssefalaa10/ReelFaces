import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_string.dart';
import '../utils/colors_manager.dart';
import '../utils/styles/app_text_style.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isSaved = false,
    this.text,
  });
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSaved;
  final String? text;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              gradient: LinearGradient(
                colors: widget.isSaved
                    ? [AppColors.success, AppColors.tmdbGreenDark]
                    : [AppColors.primary, AppColors.modernPurpleDark],
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      (widget.isSaved ? AppColors.success : AppColors.primary)
                          .withValues(alpha: 0.3),
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : _handleTap,
                borderRadius: BorderRadius.circular(25.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isLoading)
                        SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                      else
                        Icon(
                          widget.isSaved ? Icons.check : Icons.download,
                          size: 18.sp,
                          color: AppColors.white,
                        ),

                      SizedBox(width: 8.w),

                      Text(
                        widget.text ??
                            (widget.isSaved
                                ? AppStrings.imageSaved
                                : AppStrings.saveImage),
                        style: AppTextStyle.buttonText.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onPressed?.call();
  }
}
