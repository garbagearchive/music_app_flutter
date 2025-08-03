import 'package:flutter/material.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class NowPlayingWidget extends StatelessWidget {
  final VoidCallback onTap;

  const NowPlayingWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, provider, child) {
        final songIndex = provider.currentSongIndex;
        final currentPlaylist = provider.currentPlaylist;

        if (songIndex == null ||
            currentPlaylist.isEmpty ||
            songIndex >= currentPlaylist.length) {
          return const SizedBox.shrink();
        }

        final song = currentPlaylist[songIndex];

        return Dismissible(
          key: const ValueKey('now-playing-widget'),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            provider.stopPlaying(); // Dừng phát khi vuốt
          },
          background: Container(
            color: Colors.redAccent,
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.close, color: Colors.white),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Ảnh bài hát
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    song.albumImage,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // Tên bài hát và ca sĩ
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.songName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          song.artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Nút điều khiển
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: provider.playPreviousSong,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: IconButton(
                    key: ValueKey<bool>(provider.isPlaying),
                    icon: Icon(
                      provider.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: provider.pauseOrResume,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: provider.playNextSong,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
