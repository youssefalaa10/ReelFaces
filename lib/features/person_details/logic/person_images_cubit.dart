import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/domain/entities/profile_image.dart';
import '../../../../core/domain/repositories/people_repository.dart';
import '../../../../core/errors/exceptions.dart';
import 'person_images_state.dart';

class PersonImagesCubit extends Cubit<PersonImagesState> {
  PersonImagesCubit({
    required PeopleRepository peopleRepository,
    Logger? logger,
  }) : _peopleRepository = peopleRepository,
       _logger = logger ?? Logger(),
       super(const PersonImagesInitial());
  final PeopleRepository _peopleRepository;
  final Logger _logger;

  List<ProfileImage> _currentImages = [];
  int? _currentPersonId;

  /// Load person images by person ID
  Future<void> loadPersonImages(int personId, {bool refresh = false}) async {
    _currentPersonId = personId;

    if (refresh) {
      emit(
        PersonImagesRefreshing(
          currentImages: _currentImages.isNotEmpty ? _currentImages : null,
        ),
      );
    } else {
      emit(const PersonImagesLoading());
    }

    try {
      final images = await _peopleRepository.getPersonImages(personId);
      _currentImages = images;

      emit(PersonImagesLoaded(images: images));

      _logger.i(
        'Person images loaded successfully - personId: $personId, count: ${images.length}',
      );
    } on CacheException catch (e) {
      _logger.e('Cache error loading person images: ${e.message}');

      // If we have cached images, show them with a warning
      if (_currentImages.isNotEmpty) {
        emit(PersonImagesLoaded(images: _currentImages));
        _logger.w('Showing cached person images due to cache error');
      } else {
        emit(
          const PersonImagesError(
            message:
                'No images available. Please check your internet connection.',
          ),
        );
      }
    } catch (e) {
      _logger.e('Error loading person images: $e');

      // If we have cached images, show them with a warning
      if (_currentImages.isNotEmpty) {
        emit(PersonImagesLoaded(images: _currentImages));
        _logger.w('Showing cached person images due to error');
      } else {
        emit(
          const PersonImagesError(
            message: 'Failed to load images. Please try again.',
          ),
        );
      }
    }
  }

  /// Refresh person images
  Future<void> refresh() async {
    if (_currentPersonId != null) {
      await loadPersonImages(_currentPersonId!, refresh: true);
    }
  }

  /// Retry loading after error
  Future<void> retry() async {
    if (state is PersonImagesError && _currentPersonId != null) {
      await loadPersonImages(_currentPersonId!);
    }
  }

  /// Get current images
  List<ProfileImage> get currentImages => _currentImages;

  /// Get current person ID
  int? get currentPersonId => _currentPersonId;

  /// Clear current images
  void clear() {
    _currentImages.clear();
    _currentPersonId = null;
    emit(const PersonImagesInitial());
  }
}
