import '../../../../core/domain/entities/paginated.dart';
import '../entities/person.dart';
import '../entities/person_details.dart';
import '../entities/profile_image.dart';

abstract class PeopleRepository {
  Future<Paginated<Person>> getPopularPeople(int page);

  Future<PersonDetails> getPersonDetails(int id);

  Future<List<ProfileImage>> getPersonImages(int id);
}
