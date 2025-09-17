import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/domain/entities/profile_image.dart';
import 'image_save_state.dart';

class ImageSaveCubit extends Cubit<ImageSaveState> {
  ImageSaveCubit({Logger? logger})
    : _logger = logger ?? Logger(),
      super(const ImageSaveInitial());
  final Logger _logger;

  /// Save image to device storage
  Future<void> saveImage(ProfileImage image) async {
    emit(ImageSaving(image: image));

    try {
      // Simulate progress updates
      emit(ImageSaveProgress(image: image, progress: 0.2));
      await Future<void>.delayed(const Duration(milliseconds: 200));

      emit(ImageSaveProgress(image: image, progress: 0.5));
      await Future<void>.delayed(const Duration(milliseconds: 200));

      emit(ImageSaveProgress(image: image, progress: 0.8));
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Get the directory for saving images
      final directory = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${directory.path}/ReelFaces/Images');

      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      // Generate filename
      final fileName =
          '${image.filePath.split('/').last}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${imageDir.path}/$fileName';

      await _simulateImageDownload(image, filePath);

      emit(ImageSaved(image: image, savedPath: filePath));

      _logger.i('Image saved successfully - path: $filePath');
    } catch (e) {
      _logger.e('Error saving image: $e');
      emit(
        ImageSaveError(
          message: 'Failed to save image. Please try again.',
          image: image,
        ),
      );
    }
  }

  Future<void> _simulateImageDownload(
    ProfileImage image,
    String filePath,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Create a placeholder file to simulate successful save
    final file = File(filePath);
    await file.writeAsString('Simulated image data for: ${image.filePath}');
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
