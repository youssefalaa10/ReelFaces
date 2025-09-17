import 'package:hive/hive.dart';
import '../../../core/domain/entities/person.dart';

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 0;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      id: fields[0] as int,
      name: fields[1] as String,
      adult: fields[2] as bool,
      knownFor: (fields[3] as List).cast<int>(),
      profilePath: fields[4] as String?,
      popularity: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.adult)
      ..writeByte(3)
      ..write(obj.knownFor)
      ..writeByte(4)
      ..write(obj.profilePath)
      ..writeByte(5)
      ..write(obj.popularity);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
