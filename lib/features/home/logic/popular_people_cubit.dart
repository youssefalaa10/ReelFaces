import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/domain/entities/paginated.dart';
import '../../../../core/domain/entities/person.dart';
import '../../../../core/domain/repositories/people_repository.dart';
import '../../../../core/errors/exceptions.dart';
import 'popular_people_state.dart';

class PopularPeopleCubit extends Cubit<PopularPeopleState> {
  PopularPeopleCubit({
    required PeopleRepository peopleRepository,
    Logger? logger,
  }) : _peopleRepository = peopleRepository,
       _logger = logger ?? Logger(),
       super(const PopularPeopleInitial());

  final PeopleRepository _peopleRepository;
  final Logger _logger;

  List<Person> _allPeople = [];
  int _currentPage = 1;
  bool _hasReachedMax = false;

  /// Load initial popular people
  Future<void> loadPopularPeople({bool refresh = false}) async {
    if (refresh) {
      _allPeople.clear();
      _currentPage = 1;
      _hasReachedMax = false;
      emit(PopularPeopleRefreshing(currentPeople: _allPeople));
    } else {
      emit(const PopularPeopleLoading());
    }

    try {
      final paginatedPeople = await _peopleRepository.getPopularPeople(
        _currentPage,
      );
      _allPeople = List.from(paginatedPeople.results);
      _hasReachedMax = _currentPage >= paginatedPeople.totalPages;

      emit(
        PopularPeopleLoaded(
          paginatedPeople: paginatedPeople,
          allPeople: _allPeople,
          hasReachedMax: _hasReachedMax,
        ),
      );

      _logger.i(
        'Popular people loaded successfully - page: $_currentPage, count: ${_allPeople.length}',
      );
    } on CacheException catch (e) {
      _logger.e('Cache error loading popular people: ${e.message}');

      // If we have cached people, show them with a warning
      if (_allPeople.isNotEmpty) {
        emit(
          PopularPeopleLoaded(
            paginatedPeople: Paginated<Person>(
              page: _currentPage,
              results: _allPeople,
              totalPages:
                  _currentPage, // Assume we've reached max if cache failed
              totalResults: _allPeople.length,
            ),
            allPeople: _allPeople,
            hasReachedMax: true,
          ),
        );
        _logger.w('Showing cached data due to cache error');
      } else {
        // No cached data available, show error
        emit(
          const PopularPeopleError(
            message:
                'Unable to load data. Please check your internet connection and try again.',
          ),
        );
      }
    } catch (e) {
      _logger.e('Error loading popular people: $e');

      // If we have cached people, show them with a warning
      if (_allPeople.isNotEmpty) {
        emit(
          PopularPeopleLoaded(
            paginatedPeople: Paginated<Person>(
              page: _currentPage,
              results: _allPeople,
              totalPages:
                  _currentPage, // Assume we've reached max if error occurred
              totalResults: _allPeople.length,
            ),
            allPeople: _allPeople,
            hasReachedMax: true,
          ),
        );
        _logger.w('Showing cached data due to error');
      } else {
        emit(
          const PopularPeopleError(
            message: 'Something went wrong. Please try again.',
          ),
        );
      }
    }
  }

  /// Load more popular people for infinite scroll
  Future<void> loadMorePeople() async {
    if (_hasReachedMax) return;

    emit(PopularPeopleLoadingMore(currentPeople: _allPeople));

    try {
      _currentPage++;
      final paginatedPeople = await _peopleRepository.getPopularPeople(
        _currentPage,
      );

      _allPeople.addAll(paginatedPeople.results);
      _hasReachedMax = _currentPage >= paginatedPeople.totalPages;

      emit(
        PopularPeopleLoaded(
          paginatedPeople: paginatedPeople,
          allPeople: _allPeople,
          hasReachedMax: _hasReachedMax,
        ),
      );

      _logger.i(
        'More people loaded - page: $_currentPage, total count: ${_allPeople.length}',
      );
    } on CacheException catch (e) {
      _logger.e('Cache error loading more people: ${e.message}');
      // Revert page increment since we failed to load
      _currentPage--;
      emit(
        PopularPeopleError(
          message:
              'Unable to load more people. Please check your internet connection.',
          cachedPeople: _allPeople,
        ),
      );
    } catch (e) {
      _logger.e('Error loading more people: $e');
      // Revert page increment since we failed to load
      _currentPage--;
      emit(
        PopularPeopleError(
          message:
              'Something went wrong while loading more people. Please try again.',
          cachedPeople: _allPeople,
        ),
      );
    }
  }

  /// Refresh popular people
  Future<void> refresh() async {
    await loadPopularPeople(refresh: true);
  }

  /// Retry loading after error
  Future<void> retry() async {
    if (state is PopularPeopleError) {
      await loadPopularPeople();
    }
  }

  /// Get current people list
  List<Person> get currentPeople => _allPeople;

  /// Check if can load more
  bool get canLoadMore => !_hasReachedMax;

  /// Clear current state
  void clear() {
    _allPeople.clear();
    _currentPage = 1;
    _hasReachedMax = false;
    emit(const PopularPeopleInitial());
  }
}
