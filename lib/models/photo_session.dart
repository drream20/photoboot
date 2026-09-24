import 'package:hive/hive.dart';

class PhotoSession {
  const PhotoSession({
    required this.id,
    required this.createdAt,
    required this.layoutId,
    required this.timerSeconds,
    required this.outputPath,
  });

  final String id;
  final DateTime createdAt;
  final String layoutId;
  final int timerSeconds;
  final String outputPath;
}

class PhotoSessionAdapter extends TypeAdapter<PhotoSession> {
  @override
  final int typeId = 0;

  @override
  PhotoSession read(BinaryReader reader) => PhotoSession(
    id: reader.readString(),
    createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    layoutId: reader.readString(),
    timerSeconds: reader.readInt(),
    outputPath: reader.readString(),
  );

  @override
  void write(BinaryWriter writer, PhotoSession value) {
    writer
      ..writeString(value.id)
      ..writeInt(value.createdAt.millisecondsSinceEpoch)
      ..writeString(value.layoutId)
      ..writeInt(value.timerSeconds)
      ..writeString(value.outputPath);
  }
}
