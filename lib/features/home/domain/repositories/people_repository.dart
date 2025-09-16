import '../../../../core/domain/entities/paginated.dart';
import '../entities/person.dart';

abstract class PeopleRepository {
  Future<Paginated<Person>> getPopularPeople(int page);
}
