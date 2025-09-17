import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService({Logger? logger}) : _logger = logger ?? Logger();
  final Logger _logger;

  /// Check if storage permission is granted
  Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), use READ_MEDIA_IMAGES
      // For older versions, use storage permission
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.photos.status;
        _logger.d('Android photos permission status (API 33+): $status');
        return status.isGranted;
      } else {
        final status = await Permission.storage.status;
        _logger.d('Android storage permission status (API <33): $status');
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;
      _logger.d('iOS photos permission status: $status');
      return status.isGranted;
    }
    return true;
  }

  /// Request storage permission with proper handling
  Future<PermissionResult> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        return await _requestAndroidPermission();
      } else if (Platform.isIOS) {
        return await _requestIOSPermission();
      }
      return PermissionResult.granted;
    } catch (e) {
      _logger.e('Error requesting permission: $e');
      return PermissionResult.error;
    }
  }

  /// Request Android storage permission
  Future<PermissionResult> _requestAndroidPermission() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    // For Android 13+ (API 33+)
    if (androidInfo.version.sdkInt >= 33) {
      return await _requestAndroidPhotosPermission();
    } else {
      return await _requestAndroidStoragePermission();
    }
  }

  /// Request Android storage permission for API < 33
  Future<PermissionResult> _requestAndroidStoragePermission() async {
    // Check if permission is already granted
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return PermissionResult.granted;
    }

    // Check if permission is permanently denied
    if (status.isPermanentlyDenied) {
      _logger.w('Android storage permission permanently denied');
      return PermissionResult.permanentlyDenied;
    }

    // Request permission
    status = await Permission.storage.request();
    _logger.d('Android storage permission request result: $status');

    if (status.isGranted) {
      return PermissionResult.granted;
    } else if (status.isPermanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    } else {
      return PermissionResult.denied;
    }
  }

  /// Request Android photos permission for API 33+
  Future<PermissionResult> _requestAndroidPhotosPermission() async {
    // Check if permission is already granted
    var status = await Permission.photos.status;
    if (status.isGranted) {
      return PermissionResult.granted;
    }

    // Check if permission is permanently denied
    if (status.isPermanentlyDenied) {
      _logger.w('Android photos permission permanently denied');
      return PermissionResult.permanentlyDenied;
    }

    // Request permission
    status = await Permission.photos.request();
    _logger.d('Android photos permission request result: $status');

    if (status.isGranted) {
      return PermissionResult.granted;
    } else if (status.isPermanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    } else {
      return PermissionResult.denied;
    }
  }

  /// Request iOS photos permission
  Future<PermissionResult> _requestIOSPermission() async {
    // Check if permission is already granted
    var status = await Permission.photos.status;
    if (status.isGranted) {
      return PermissionResult.granted;
    }

    // Check if permission is permanently denied
    if (status.isPermanentlyDenied) {
      _logger.w('iOS photos permission permanently denied');
      return PermissionResult.permanentlyDenied;
    }

    // Request permission
    status = await Permission.photos.request();
    _logger.d('iOS photos permission request result: $status');

    if (status.isGranted) {
      return PermissionResult.granted;
    } else if (status.isPermanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    } else {
      return PermissionResult.denied;
    }
  }

  /// Open app settings for permission management
  Future<bool> openAppSettingsInternal() async {
    try {
      final result = await openAppSettings();
      _logger.d('Opened app settings: $result');
      return result;
    } catch (e) {
      _logger.e('Error opening app settings: $e');
      return false;
    }
  }

  /// Get user-friendly permission message
  String getPermissionMessage(PermissionResult result) {
    switch (result) {
      case PermissionResult.granted:
        return 'Permission granted!';
      case PermissionResult.denied:
        return 'Permission denied. Please allow storage access to save images.';
      case PermissionResult.permanentlyDenied:
        return 'Permission permanently denied. Please enable storage access in app settings.';
      case PermissionResult.error:
        return 'Error checking permissions. Please try again.';
    }
  }

  /// Get platform-specific permission instructions
  String getPermissionInstructions() {
    if (Platform.isAndroid) {
      return 'To save images, please allow photo access:\n\n1. Tap "Allow" when prompted\n2. Or go to Settings > Apps > ReelFaces > Permissions > Photos\n3. Enable "Allow access to media"';
    } else if (Platform.isIOS) {
      return 'To save images, please allow photo library access:\n\n1. Tap "Allow" when prompted\n2. Or go to Settings > Privacy & Security > Photos > ReelFaces';
    }
    return 'Please allow photo access to save images.';
  }
}

enum PermissionResult { granted, denied, permanentlyDenied, error }
