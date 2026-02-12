# 🎵 Skylarkian tunes

An offline-first Flutter application for managing and viewing songs with lyrics, chords, and audio support.

## 🚀 Features

- 📜 View song list with lyrics preview
- ❤️ Mark songs as favorites
- 💾 Local storage using Hive (No internet required)
- 🎼 Chord support with transpose functionality (planned)
- 🔊 Audio support (scalable to cloud in future)

## 🛠 Tech Stack

- Flutter
- Hive (Local NoSQL Database)
- Dart

## 🏗 Architecture

The project follows a simple clean separation approach:

lib/
- data/
  - models/
  - services/
- presentation/
  - screens/
  - widgets/

## 📦 Installation

```bash
git clone https://github.com/eddy-richards/skylarkian-tunes-flutter.git
cd song-book-app
flutter pub get
flutter run
