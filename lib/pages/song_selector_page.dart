import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist_provider.dart';
import '../models/songs.dart';

class SongSelectorPage extends StatelessWidget {
  final List<Song> playlistSongs; // các bài hiện có trong playlist

  // ignore: non_constant_identifier_names
  const SongSelectorPage({
    super.key,
    required this.playlistSongs,
    required Null Function(dynamic Song) onSongSelected,
  });

  @override
  Widget build(BuildContext context) {
    final allSongs = context.read<PlaylistProvider>().allSongs;

    // Lọc ra những bài chưa có trong playlist
    final availableSongs = allSongs
        .where(
          (song) => !playlistSongs.any(
            (s) =>
                s.songName == song.songName && s.artistName == song.artistName,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Select a song")),
      body: ListView.builder(
        itemCount: availableSongs.length,
        itemBuilder: (context, index) {
          final song = availableSongs[index];
          return ListTile(
            leading: Image.asset(
              song.albumImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(song.songName),
            subtitle: Text(song.artistName),
            onTap: () => Navigator.pop(context, song),
          );
        },
      ),
    );
  }
}
