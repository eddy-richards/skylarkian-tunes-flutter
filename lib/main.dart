import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/song_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(SongModelAdapter());
  await Hive.openBox<SongModel>('songs');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SongListScreen(),
    );
  }
}

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late Box<SongModel> songBox;

  @override
  void initState() {
    super.initState();
    songBox = Hive.box<SongModel>('songs');

    // Insert sample songs only if empty
    if (songBox.isEmpty) {
      addSampleSongs();
    }
  }

  void addSampleSongs() {
    songBox.add(
      SongModel(
        id: 1,
        title: "Amazing Grace",
        lyrics: "Amazing grace how sweet the sound...",
        isFavorite: false,
      ),
    );

    songBox.add(
      SongModel(
        id: 2,
        title: "Blessed Assurance",
        lyrics: "Blessed assurance Jesus is mine...",
        isFavorite: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Song Book 🎵"),
      ),
      body: ValueListenableBuilder(
        valueListenable: songBox.listenable(),
        builder: (context, Box<SongModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No songs available"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final song = box.getAt(index);

              return ListTile(
                title: Text(song!.title),
                subtitle: Text(
                  song.lyrics,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(
                  song.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: song.isFavorite ? Colors.red : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

