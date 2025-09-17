import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/profile_image.dart';
import '../../../../core/services/permission_service.dart';

abstract class ImageSaveState extends Equatable {
  const ImageSaveState();

  @override
  List<Object?> get props => [];
}

class ImageSaveInitial extends ImageSaveState {
  const ImageSaveInitial();
}

class ImageSaving extends ImageSaveState {
  const ImageSaving({required this.image});
  final ProfileImage image;

  @override
  List<Object?> get props => [image];
}

class ImageSaved extends ImageSaveState {
  const ImageSaved({required this.image, this.savedPath});
  final ProfileImage image;
  final String? savedPath;

  @override
  List<Object?> get props => [image, savedPath];
}

class ImageSaveError extends ImageSaveState {
  const ImageSaveError({
    required this.message,
    required this.image,
    this.permissionResult,
  });
  final String message;
  final ProfileImage image;
  final PermissionResult? permissionResult;

  @override
  List<Object?> get props => [message, image, permissionResult];
}

class ImageSaveProgress extends ImageSaveState {
  const ImageSaveProgress({required this.image, required this.progress});
  final ProfileImage image;
  final double progress;

  @override
  List<Object?> get props => [image, progress];
}
