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
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added "${selectedSong.songName}"')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
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

          // 🎵 Danh sách bài hát trong playlist
          Expanded(
            child: playlist.songs.isEmpty
                ? const Center(child: Text('No songs in this playlist.'))
                : ListView.builder(
                    itemCount: playlist.songs.length,
                    itemBuilder: (context, index) {
                      final song = playlist.songs[index];
                      final isPlaying = playlistProvider.currentSong == song;

                      return Container(
                        color: isPlaying ? Colors.grey.shade200 : null,
                        child: ListTile(
                          leading: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                song.albumImage,
                                width: 50,
                                height: 50,
                              ),
                              if (isPlaying)
                                const Icon(
                                  Icons.music_note,
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                          title: Text(song.songName),
                          subtitle: Text(song.artistName),
                          onTap: () {
                            final messenger = ScaffoldMessenger.of(context);
                            final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
                            playlistProvider.setPlaylist(playlist.songs);
                            playlistProvider.playSong(song);

                            // Show SnackBar sau khi frame hiện xong
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    '🎵 Now Playing...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF6A1B9A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                  elevation: 10,
                                ),
                              );
                            });

                            // Delay trước khi chuyển trang để SnackBar kịp hiển thị
                            Future.delayed(
                              const Duration(milliseconds: 600),
                              () {
                                Navigator.push(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SongPage(),
                                  ),
                                );
                              },
                            );
                          },

                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              playlistProvider.removeSongFromPlaylist(
                                playlistIndex,
                                song,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Removed "${song.songName}"'),
                                ),
                              );
                            },
                          ),
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
