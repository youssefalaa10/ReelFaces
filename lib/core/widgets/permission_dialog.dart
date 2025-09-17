import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/permission_service.dart';
import '../utils/colors_manager.dart';
import '../utils/styles/app_text_style.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    required this.permissionResult,
    super.key,
    this.onRetry,
    this.onOpenSettings,
  });

  final PermissionResult permissionResult;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Icon(_getIcon(), color: _getIconColor(), size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              _getTitle(),
              style: AppTextStyle.titleMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getMessage(),
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (permissionResult == PermissionResult.permanentlyDenied) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to enable:',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    PermissionService().getPermissionInstructions(),
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (permissionResult == PermissionResult.denied) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ] else if (permissionResult == PermissionResult.permanentlyDenied) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onOpenSettings?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Open Settings'),
          ),
        ] else ...[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ],
    );
  }

  IconData _getIcon() {
    switch (permissionResult) {
      case PermissionResult.granted:
        return Icons.check_circle;
      case PermissionResult.denied:
        return Icons.warning;
      case PermissionResult.permanentlyDenied:
        return Icons.block;
      case PermissionResult.error:
        return Icons.error;
    }
  }

  Color _getIconColor() {
    switch (permissionResult) {
      case PermissionResult.granted:
        return AppColors.success;
      case PermissionResult.denied:
        return AppColors.warning;
      case PermissionResult.permanentlyDenied:
        return AppColors.error;
      case PermissionResult.error:
        return AppColors.error;
    }
  }

  String _getTitle() {
    switch (permissionResult) {
      case PermissionResult.granted:
        return 'Permission Granted';
      case PermissionResult.denied:
        return 'Permission Required';
      case PermissionResult.permanentlyDenied:
        return 'Permission Denied';
      case PermissionResult.error:
        return 'Permission Error';
    }
  }

  String _getMessage() {
    switch (permissionResult) {
      case PermissionResult.granted:
        return 'You can now save images to your device.';
      case PermissionResult.denied:
        return 'Storage permission is required to save images. Please allow access when prompted.';
      case PermissionResult.permanentlyDenied:
        return 'Storage permission has been permanently denied. You need to enable it manually in app settings.';
      case PermissionResult.error:
        return 'There was an error checking permissions. Please try again.';
    }
  }
}

