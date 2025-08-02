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

        if (songIndex == null || provider.playList.isEmpty) {
          return const SizedBox.shrink();
        }

        final song = provider.playList[songIndex];

        return Dismissible(
          key: const ValueKey('now-playing-widget'),
          direction: DismissDirection.startToEnd, // Vuốt từ trái sang phải
          onDismissed: (direction) {
            provider.stopPlaying(); // Ngừng nhạc và xóa widget
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
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.songName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          song.artistName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
