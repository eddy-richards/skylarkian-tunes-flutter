import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/song_model.dart';
import 'features/songs/screens/song_list_screen.dart';
import 'data/repositories/song_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(SongModelAdapter());
  await Hive.openBox<SongModel>('songs');

  final repository = SongRepository();
  await repository.loadSongsFromJsonIfNeeded();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SongListScreen(),
    );
  }
}
