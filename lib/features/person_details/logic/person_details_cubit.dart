import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/domain/entities/person_details.dart';
import '../../../../core/domain/repositories/people_repository.dart';
import '../../../../core/errors/exceptions.dart';
import 'person_details_state.dart';

class PersonDetailsCubit extends Cubit<PersonDetailsState> {
  PersonDetailsCubit({
    required PeopleRepository peopleRepository,
    Logger? logger,
  }) : _peopleRepository = peopleRepository,
       _logger = logger ?? Logger(),
       super(const PersonDetailsInitial());
  final PeopleRepository _peopleRepository;
  final Logger _logger;

  PersonDetails? _currentPersonDetails;

  /// Load person details by ID
  Future<void> loadPersonDetails(int personId, {bool refresh = false}) async {
    if (refresh) {
      emit(
        PersonDetailsRefreshing(currentPersonDetails: _currentPersonDetails),
      );
    } else {
      emit(const PersonDetailsLoading());
    }

    try {
      final personDetails = await _peopleRepository.getPersonDetails(personId);
      _currentPersonDetails = personDetails;

      emit(PersonDetailsLoaded(personDetails: personDetails));

      _logger.i(
        'Person details loaded successfully - id: $personId, name: ${personDetails.name}',
      );
    } on CacheException catch (e) {
      _logger.e('Cache error loading person details: ${e.message}');
      emit(
        PersonDetailsError(
          message: 'No data available. Please check your internet connection.',
          cachedPersonDetails: _currentPersonDetails,
        ),
      );
    } catch (e) {
      _logger.e('Error loading person details: $e');
      emit(
        PersonDetailsError(
          message: 'Failed to load person details. Please try again.',
          cachedPersonDetails: _currentPersonDetails,
        ),
      );
    }
  }

  /// Refresh person details
  Future<void> refresh() async {
    if (_currentPersonDetails != null) {
      await loadPersonDetails(_currentPersonDetails!.id, refresh: true);
    }
  }

  /// Retry loading after error
  Future<void> retry() async {
    if (state is PersonDetailsError && _currentPersonDetails != null) {
      await loadPersonDetails(_currentPersonDetails!.id);
    }
  }

  /// Get current person details
  PersonDetails? get currentPersonDetails => _currentPersonDetails;

  /// Clear current person details
  void clear() {
    _currentPersonDetails = null;
    emit(const PersonDetailsInitial());
  }
}
