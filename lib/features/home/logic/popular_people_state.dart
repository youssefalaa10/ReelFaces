import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/paginated.dart';
import '../../../../core/domain/entities/person.dart';

abstract class PopularPeopleState extends Equatable {
  const PopularPeopleState();

  @override
  List<Object?> get props => [];
}

class PopularPeopleInitial extends PopularPeopleState {
  const PopularPeopleInitial();
}

class PopularPeopleLoading extends PopularPeopleState {
  const PopularPeopleLoading();
}

class PopularPeopleLoaded extends PopularPeopleState {
  const PopularPeopleLoaded({
    required this.paginatedPeople,
    required this.allPeople,
    this.hasReachedMax = false,
  });
  final Paginated<Person> paginatedPeople;
  final List<Person> allPeople;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [paginatedPeople, allPeople, hasReachedMax];

  PopularPeopleLoaded copyWith({
    Paginated<Person>? paginatedPeople,
    List<Person>? allPeople,
    bool? hasReachedMax,
  }) {
    return PopularPeopleLoaded(
      paginatedPeople: paginatedPeople ?? this.paginatedPeople,
      allPeople: allPeople ?? this.allPeople,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class PopularPeopleError extends PopularPeopleState {
  const PopularPeopleError({required this.message, this.cachedPeople});
  final String message;
  final List<Person>? cachedPeople;

  @override
  List<Object?> get props => [message, cachedPeople];
}

class PopularPeopleRefreshing extends PopularPeopleState {
  const PopularPeopleRefreshing({required this.currentPeople});
  final List<Person> currentPeople;

  @override
  List<Object?> get props => [currentPeople];
}

class PopularPeopleLoadingMore extends PopularPeopleState {
  const PopularPeopleLoadingMore({required this.currentPeople});
  final List<Person> currentPeople;

  @override
  List<Object?> get props => [currentPeople];
}
