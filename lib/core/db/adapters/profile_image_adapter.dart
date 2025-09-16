import 'package:hive/hive.dart';
import '../../../features/person_details/domain/entities/profile_image.dart';

class ProfileImageAdapter extends TypeAdapter<ProfileImage> {
  @override
  final int typeId = 2;

  @override
  ProfileImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileImage(
      aspectRatio: fields[0] as double,
      height: fields[1] as int,
      filePath: fields[2] as String,
      voteAverage: fields[3] as double,
      voteCount: fields[4] as int,
      width: fields[5] as int,
      iso6391: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileImage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.aspectRatio)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.voteAverage)
      ..writeByte(4)
      ..write(obj.voteCount)
      ..writeByte(5)
      ..write(obj.width)
      ..writeByte(6)
      ..write(obj.iso6391);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
