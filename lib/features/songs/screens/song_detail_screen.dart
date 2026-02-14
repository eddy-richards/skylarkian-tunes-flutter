import 'package:flutter/material.dart';
import '../../../data/models/song_model.dart';
import '../../../data/repositories/song_repository.dart';

class SongDetailScreen extends StatefulWidget {
  final SongModel song;

  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  late SongModel song;
  final repository = SongRepository();

  @override
  void initState() {
    super.initState();
    song = widget.song;
  }

  void toggleFavorite() {
    setState(() {
      song.isFavorite = !song.isFavorite; // update the Hive object
      song.save(); // persist to Hive
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
        actions: [
          IconButton(
            icon: Icon(
              song.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: song.isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            song.lyrics,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
