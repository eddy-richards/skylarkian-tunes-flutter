import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/song_model.dart';
import '../../../data/repositories/song_repository.dart';
import '../widgets/song_tile.dart';
import 'song_detail_screen.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  final repository = SongRepository();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  List<SongModel> _filterSongs(List<SongModel> allSongs) {
    if (_searchQuery.isEmpty) return allSongs;

    return allSongs.where((song) {
      return song.title.toLowerCase().contains(_searchQuery) ||
          song.lyrics.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Skylarkian Tunes 🎵")),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search songs...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Song list
          Expanded(
            child: ValueListenableBuilder<Box<SongModel>>(
              valueListenable: repository.listenToSongs(),
              builder: (context, box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text("No songs available"));
                }

                final allSongs = box.values.toList();
                final filteredSongs = _filterSongs(allSongs);

                if (filteredSongs.isEmpty) {
                  return const Center(child: Text("No matching songs found"));
                }

                return ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = filteredSongs[index];

                    return SongTile(
                      song: song,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SongDetailScreen(song: song),
                          ),
                        );
                      },
                      onFavoriteToggle: () {
                        repository.toggleFavorite(song);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
