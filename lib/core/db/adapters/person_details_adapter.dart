import 'package:hive/hive.dart';
import '../../domain/entities/person_details.dart';

class PersonDetailsAdapter extends TypeAdapter<PersonDetails> {
  @override
  final int typeId = 1;

  @override
  PersonDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonDetails(
      id: fields[0] as int,
      name: fields[1] as String,
      adult: fields[2] as bool,
      alsoKnownAs: (fields[3] as List).cast<String>(),
      biography: fields[4] as String?,
      birthday: fields[5] as String?,
      deathday: fields[6] as String?,
      placeOfBirth: fields[7] as String?,
      profilePath: fields[8] as String?,
      popularity: fields[9] as double?,
      knownForDepartment: fields[10] as String?,
      homepage: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonDetails obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.adult)
      ..writeByte(3)
      ..write(obj.alsoKnownAs)
      ..writeByte(4)
      ..write(obj.biography)
      ..writeByte(5)
      ..write(obj.birthday)
      ..writeByte(6)
      ..write(obj.deathday)
      ..writeByte(7)
      ..write(obj.placeOfBirth)
      ..writeByte(8)
      ..write(obj.profilePath)
      ..writeByte(9)
      ..write(obj.popularity)
      ..writeByte(10)
      ..write(obj.knownForDepartment)
      ..writeByte(11)
      ..write(obj.homepage);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
