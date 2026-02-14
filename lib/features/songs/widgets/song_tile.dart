import 'package:flutter/material.dart';
import '../../../data/models/song_model.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.title),
      subtitle: Text(
        song.lyrics,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(
          song.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: song.isFavorite ? Colors.red : null,
        ),
        onPressed: onFavoriteToggle,
      ),
      onTap: onTap,
    );
  }
}
