import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song_model.dart';

class SongRepository {
  final Box<SongModel> _box = Hive.box<SongModel>('songs');

  /// Listen to box changes
  ValueListenable<Box<SongModel>> listenToSongs() {
    return _box.listenable();
  }

  /// Get all songs
  List<SongModel> getAllSongs() {
    return _box.values.toList();
  }

  /// Add single song
  void addSong(SongModel song) {
    _box.put(song.id, song);
  }

  /// Toggle favorite
  void toggleFavorite(SongModel song) {
    song.isFavorite = !song.isFavorite;
    song.save(); // HiveObject method
  }

  /// Load JSON songs only once
  Future<void> loadSongsFromJsonIfNeeded() async {
    if (_box.isNotEmpty) return; // Prevent duplicate loading

    final String response = await rootBundle.loadString('assets/songs.json');

    final List<dynamic> data = jsonDecode(response);

    for (var json in data) {
      final song = SongModel(
        id: json['id'],
        title: json['title'],
        lyrics: json['lyrics'],
        category: json['category'] ?? "Worship",
        language: json['language'] ?? "English",
        audioUrl: json['audioUrl'],
        chords: json['chords'],
        isFavorite: false,
      );

      _box.put(song.id, song);
    }
  }
}
