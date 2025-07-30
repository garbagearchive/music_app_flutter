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
        if (songIndex == null) return const SizedBox.shrink();

        final song = provider.playList[songIndex];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(), blurRadius: 6),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                song.albumImage,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        song.artistName,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: provider.playPreviousSong,
              ),
              IconButton(
                icon: Icon(provider.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: provider.pauseOrResume,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: provider.playNextSong,
              ),
            ],
          ),
        );
      },
    );
  }
}
