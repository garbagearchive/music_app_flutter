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
    final colorScheme = Theme.of(context).colorScheme;

    if (playlistIndex < 0 ||
        playlistIndex >= playlistProvider.playlists.length) {
      return Scaffold(
        body: Center(
          child: Text(
            'Playlist does not exist.',
            style: TextStyle(color: colorScheme.inversePrimary),
          ),
        ),
      );
    }

    final playlist = playlistProvider.playlists[playlistIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          playlist.name,
          style: TextStyle(color: colorScheme.inversePrimary),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colorScheme.inversePrimary),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.inversePrimary,
                ),
              ),
            ),
          ),

          // 🎵 Song List
          Expanded(
            child: playlist.songs.isEmpty
                ? Center(
                    child: Text(
                      'No songs in this playlist.',
                      style: TextStyle(color: colorScheme.inversePrimary),
                    ),
                  )
                : ListView.builder(
                    itemCount: playlist.songs.length,
                    itemBuilder: (context, index) {
                      final song = playlist.songs[index];
                      final isPlaying = playlistProvider.currentSong == song;

                      return Container(
                        color: isPlaying ? colorScheme.primary : null,
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
                                Icon(
                                  Icons.music_note,
                                  color: colorScheme.secondary,
                                ),
                            ],
                          ),
                          title: Text(
                            song.songName,
                            style: TextStyle(color: colorScheme.inversePrimary),
                          ),
                          subtitle: Text(
                            song.artistName,
                            style: TextStyle(color: colorScheme.secondary),
                          ),
                          onTap: () {
                            final messenger = ScaffoldMessenger.of(context);
                            final playlistProvider =
                                Provider.of<PlaylistProvider>(
                                  context,
                                  listen: false,
                                );
                            playlistProvider.setPlaylist(playlist.songs);
                            playlistProvider.playSong(song);

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '🎵 Now Playing...',
                                    style: TextStyle(
                                      color: colorScheme.surface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: colorScheme.inversePrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                  elevation: 10,
                                ),
                              );
                            });

                            Future.delayed(
                              const Duration(milliseconds: 600),
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SongPage(),
                                  ),
                                );
                              },
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: colorScheme.inversePrimary,
                            ),
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
