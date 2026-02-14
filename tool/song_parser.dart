import 'dart:io';
import 'dart:convert';

void main() async {
  final file = File('songs.txt'); // Put your txt file in project root
  final content = await file.readAsString();

  final lines = content.split('\n');

  final List<Map<String, dynamic>> songs = [];

  int? currentId;
  List<String> currentLyrics = [];

  final numberRegex = RegExp(r'^\s*(\d+)\.?\s*$');

  for (var line in lines) {
    final match = numberRegex.firstMatch(line.trim());

    if (match != null) {
      // Save previous song
      if (currentId != null && currentLyrics.isNotEmpty) {
        songs.add(_buildSong(currentId, currentLyrics));
      }

      currentId = int.parse(match.group(1)!);
      currentLyrics = [];
    } else {
      if (currentId != null) {
        if (line.trim().isNotEmpty) {
          currentLyrics.add(line.trim());
        }
      }
    }
  }

  // Add last song
  if (currentId != null && currentLyrics.isNotEmpty) {
    songs.add(_buildSong(currentId, currentLyrics));
  }

  final outputFile = File('songs.json');
  await outputFile.writeAsString(jsonEncode(songs));

  print('Done! Parsed ${songs.length} songs.');
}

Map<String, dynamic> _buildSong(int id, List<String> lyricsLines) {
  String firstLine = lyricsLines.first;

  String title;

  int bracketIndex = firstLine.indexOf('(');

  if (bracketIndex != -1) {
    title = firstLine.substring(0, bracketIndex).trim();
  } else {
    title = firstLine.trim();
  }

  return {
    "id": id,
    "title": title,
    "lyrics": lyricsLines.join('\n'),
    "category": "Worship",
    "language": "English",
    "audioUrl": null,
    "chords": null,
    "isFavorite": false,
  };
}

