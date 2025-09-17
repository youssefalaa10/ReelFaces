import '../../../../core/domain/entities/profile_image.dart';

abstract class ImageRepository {
  Future<List<ProfileImage>> getPersonImages(int personId);
}
