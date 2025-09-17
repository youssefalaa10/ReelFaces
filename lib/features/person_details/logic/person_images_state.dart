import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/profile_image.dart';

abstract class PersonImagesState extends Equatable {
  const PersonImagesState();

  @override
  List<Object?> get props => [];
}

class PersonImagesInitial extends PersonImagesState {
  const PersonImagesInitial();
}

class PersonImagesLoading extends PersonImagesState {
  const PersonImagesLoading();
}

class PersonImagesLoaded extends PersonImagesState {
  const PersonImagesLoaded({required this.images});
  final List<ProfileImage> images;

  @override
  List<Object?> get props => [images];
}

class PersonImagesError extends PersonImagesState {
  const PersonImagesError({required this.message, this.cachedImages});
  final String message;
  final List<ProfileImage>? cachedImages;

  @override
  List<Object?> get props => [message, cachedImages];
}

class PersonImagesRefreshing extends PersonImagesState {
  const PersonImagesRefreshing({this.currentImages});
  final List<ProfileImage>? currentImages;

  @override
  List<Object?> get props => [currentImages];
}
