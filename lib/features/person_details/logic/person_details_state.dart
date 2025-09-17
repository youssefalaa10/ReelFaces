import 'package:equatable/equatable.dart';
import '../../../../core/domain/entities/person_details.dart';

abstract class PersonDetailsState extends Equatable {
  const PersonDetailsState();

  @override
  List<Object?> get props => [];
}

class PersonDetailsInitial extends PersonDetailsState {
  const PersonDetailsInitial();
}

class PersonDetailsLoading extends PersonDetailsState {
  const PersonDetailsLoading();
}

class PersonDetailsLoaded extends PersonDetailsState {
  const PersonDetailsLoaded({required this.personDetails});
  final PersonDetails personDetails;

  @override
  List<Object?> get props => [personDetails];
}

class PersonDetailsError extends PersonDetailsState {
  const PersonDetailsError({required this.message, this.cachedPersonDetails});
  final String message;
  final PersonDetails? cachedPersonDetails;

  @override
  List<Object?> get props => [message, cachedPersonDetails];
}

class PersonDetailsRefreshing extends PersonDetailsState {
  const PersonDetailsRefreshing({this.currentPersonDetails});
  final PersonDetails? currentPersonDetails;

  @override
  List<Object?> get props => [currentPersonDetails];
}
