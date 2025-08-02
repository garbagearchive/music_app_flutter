import 'package:flutter/material.dart';
import 'package:music_app/components/small_playing_widget.dart';
import 'package:music_app/models/songs.dart';
import 'package:music_app/pages/song_selector_page.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:provider/provider.dart';
import '../models/playlist_provider.dart';

class PlaylistDetailPage extends StatelessWidget {
  final int playlistIndex;

  const PlaylistDetailPage({super.key, required this.playlistIndex});

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    if (playlistIndex < 0 ||
        playlistIndex >= playlistProvider.playlists.length) {
      return const Scaffold(
        body: Center(child: Text('Playlist does not exist.')),
      );
    }

    final playlist = playlistProvider.playlists[playlistIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final selectedSong = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongSelectorPage(
                    playlistSongs: playlist.songs,
                    onSongSelected: (song) {},
                  ),
                ),
              );

              if (selectedSong != null && selectedSong is Song) {
                playlistProvider.addSongToPlaylist(playlistIndex, selectedSong);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 👇 Hiển thị số lượng bài hát
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${playlist.songs.length} songs',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // 🔀 Nút Shuffle Play
          // ...
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      playlistProvider.setPlaylist(playlist.songs);
                      playlistProvider.shufflePlaylist();
                      playlistProvider.playCurrentSong();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SongPage()),
                      );
                    },
                    icon: const Icon(Icons.shuffle),
                    label: const Text("Shuffle Play"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🎵 Danh sách bài hát trong playlist
          Expanded(
            child: (playlist.songs.isEmpty)
                ? const Center(child: Text('No songs in this playlist.'))
                : ListView.builder(
                    itemCount: playlist.songs.length,
                    itemBuilder: (context, index) {
                      final song = playlist.songs[index];
                      return ListTile(
                        leading: Image.asset(
                          song.albumImage,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(song.songName),
                        subtitle: Text(song.artistName),
                        onTap: () {
                          playlistProvider.setPlaylist(playlist.songs);
                          playlistProvider.playSong(song);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SongPage()),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            playlistProvider.removeSongFromPlaylist(
                              playlistIndex,
                              song,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),

          // 🔊 Mini Player
          NowPlayingWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SongPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
