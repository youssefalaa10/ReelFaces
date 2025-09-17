import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/domain/entities/profile_image.dart';
import '../../../../core/network/network_config.dart';
import '../../../../core/services/permission_service.dart';
import 'image_save_state.dart';

class ImageSaveCubit extends Cubit<ImageSaveState> {
  ImageSaveCubit({Logger? logger})
    : _logger = logger ?? Logger(),
      _permissionService = PermissionService(logger: logger),
      super(const ImageSaveInitial());
  final Logger _logger;
  final PermissionService _permissionService;

  /// Save image to device storage
  Future<void> saveImage(ProfileImage image) async {
    emit(ImageSaving(image: image));

    try {
      // Check if permission is already granted
      final hasPermission = await _permissionService.hasStoragePermission();
      if (hasPermission) {
        await _performImageSave(image);
        return;
      }

      // Request permission
      final permissionResult = await _permissionService
          .requestStoragePermission();

      if (permissionResult == PermissionResult.granted) {
        await _performImageSave(image);
      } else {
        emit(
          ImageSaveError(
            message: _permissionService.getPermissionMessage(permissionResult),
            image: image,
            permissionResult: permissionResult,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error saving image: $e');
      String errorMessage = 'Failed to save image. Please try again.';

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          errorMessage =
              'Network timeout. Please check your connection and try again.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage =
              'No internet connection. Please check your network and try again.';
        }
      } else if (e is FileSystemException) {
        errorMessage =
            'Failed to save file. Please check storage space and try again.';
      }

      emit(ImageSaveError(message: errorMessage, image: image));
    }
  }

  /// Perform the actual image save operation
  Future<void> _performImageSave(ProfileImage image) async {
    // Get the directory for saving images
    Directory directory;
    if (Platform.isAndroid) {
      // For Android, try multiple locations in order of preference
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        // Extract the external storage root path
        final externalPath = externalDir.path;
        final parts = externalPath.split('/');
        // Find the index of 'Android' and go back to get the root
        final androidIndex = parts.indexOf('Android');
        if (androidIndex > 0) {
          final rootParts = parts.sublist(0, androidIndex);
          final rootPath = rootParts.join('/');

          // Try Pictures first, then Downloads as fallback
          final picturesDir = Directory('$rootPath/Pictures/ReelFaces');
          final downloadsDir = Directory('$rootPath/Download/ReelFaces');

          // Use Pictures if it exists or can be created, otherwise use Downloads
          try {
            if (!await picturesDir.exists()) {
              await picturesDir.create(recursive: true);
            }
            directory = picturesDir;
          } catch (e) {
            _logger.w(
              'Could not create Pictures directory, using Downloads: $e',
            );
            try {
              if (!await downloadsDir.exists()) {
                await downloadsDir.create(recursive: true);
              }
              directory = downloadsDir;
            } catch (e2) {
              _logger.w(
                'Could not create Downloads directory, using app documents: $e2',
              );
              directory = await getApplicationDocumentsDirectory();
              directory = Directory('${directory.path}/ReelFaces/Images');
            }
          }
        } else {
          // Fallback: try to construct path manually
          try {
            directory = Directory('/storage/emulated/0/Pictures/ReelFaces');
            if (!await directory.exists()) {
              await directory.create(recursive: true);
            }
          } catch (e) {
            _logger.w(
              'Could not create Pictures directory, using Downloads: $e',
            );
            directory = Directory('/storage/emulated/0/Download/ReelFaces');
            if (!await directory.exists()) {
              await directory.create(recursive: true);
            }
          }
        }
      } else {
        // Fallback to application documents directory
        directory = await getApplicationDocumentsDirectory();
        directory = Directory('${directory.path}/ReelFaces/Images');
      }
    } else if (Platform.isIOS) {
      // For iOS, use application documents directory
      directory = await getApplicationDocumentsDirectory();
      directory = Directory('${directory.path}/ReelFaces/Images');
    } else {
      // For other platforms, use application documents directory
      directory = await getApplicationDocumentsDirectory();
      directory = Directory('${directory.path}/ReelFaces/Images');
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Generate filename
    final fileName = _generateFileName(image);
    final filePath = '${directory.path}/$fileName';

    _logger.i('Saving image to directory: ${directory.path}');
    _logger.i('Full file path: $filePath');

    // Download and save the image
    await _downloadAndSaveImage(image, filePath);

    emit(ImageSaved(image: image, savedPath: filePath));

    _logger.i('Image saved successfully - path: $filePath');
  }

  /// Open app settings for permission management
  Future<void> openAppSettings() async {
    await _permissionService.openAppSettingsInternal();
  }

  /// Generate a unique filename for the image
  String _generateFileName(ProfileImage image) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final originalName = image.filePath.split('/').last;
    final nameWithoutExt = originalName.split('.').first;
    return '${nameWithoutExt}_$timestamp.jpg';
  }

  /// Download and save the image
  Future<void> _downloadAndSaveImage(
    ProfileImage image,
    String filePath,
  ) async {
    final dio = Dio();
    final imageUrl = NetworkConfig.getProfileImageUrl(image.filePath);

    // Set timeouts
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 60);

    _logger.d('Downloading image from: $imageUrl');

    // Download the image with progress tracking
    await dio.download(
      imageUrl,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = received / total;
          emit(ImageSaveProgress(image: image, progress: progress));
        }
      },
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        maxRedirects: 5,
      ),
    );

    // Verify the file was created and has content
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File was not created');
    }

    final fileSize = await file.length();
    if (fileSize == 0) {
      throw Exception('Downloaded file is empty');
    }

    _logger.i('Image downloaded successfully - size: $fileSize bytes');
  }

  /// Retry saving after error
  Future<void> retry() async {
    if (state is ImageSaveError) {
      final errorState = state as ImageSaveError;
      await saveImage(errorState.image);
    }
  }

  /// Clear current state
  void clear() {
    emit(const ImageSaveInitial());
  }
}
