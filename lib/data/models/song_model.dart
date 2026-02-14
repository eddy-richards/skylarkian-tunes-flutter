import 'package:hive/hive.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0)
class SongModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String lyrics;

  @HiveField(3)
  bool isFavorite;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String language;

  @HiveField(6)
  final String? audioUrl;

  @HiveField(7)
  final String? chords;

  SongModel({
    required this.id,
    required this.title,
    required this.lyrics,
    this.isFavorite = false,
    this.category = "Worship",
    this.language = "English",
    this.audioUrl,
    this.chords,
  });
}
