import 'package:flutter/material.dart';
import 'package:music_app/components/neu_box.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});
  //convert secs => mins
  String formatTime(Duration duration) {
    String twoDigitSecs = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSecs";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        //get playlist
        final playList = value.playList;

        //get current song
        final currentSong = playList[value.currentSongIndex ?? 0];
        //
        //return song page UI
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                children: [
                  // App Bar Row at the top
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'NOW PLAYING',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance space
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Main content scrollable in case of small screen
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Album image and song info
                          NeuBox(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    currentSong.albumImage,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit
                                        .cover, // ensures it fills the box without stretching
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentSong.songName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(currentSong.artistName),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),

                          // Duration and slider
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatTime(value.currentDuration)),
                                    IconButton(
                                      icon: Icon(
                                        Icons.shuffle,
                                        color: value.isShuffle
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      onPressed: value.toggleShuffle,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        value.isRepeat
                                            ? Icons.repeat_one
                                            : Icons.repeat,
                                        color: value.isRepeat
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      onPressed: value.toggleRepeat,
                                    ),
                                    Text(formatTime(value.totalDuration)),
                                  ],
                                ),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 12,
                                  ),
                                  activeTrackColor: Colors.blueAccent,
                                  inactiveTrackColor: Colors.grey[300],
                                  thumbColor: Colors.blueAccent,
                                  trackHeight: 4,
                                ),
                                child: Slider(
                                  min: 0,
                                  max: value.totalDuration.inSeconds
                                      .toDouble()
                                      .clamp(1.0, double.infinity),
                                  value: value.currentDuration.inSeconds
                                      .clamp(0, value.totalDuration.inSeconds)
                                      .toDouble(),
                                  onChanged: (position) {
                                    value.seek(
                                      Duration(seconds: position.toInt()),
                                    );
                                  },
                                  onChangeEnd: (position) {
                                    value.seek(
                                      Duration(seconds: position.toInt()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Playback control
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: value.playPreviousSong,
                                  child: const NeuBox(
                                    child: Icon(Icons.skip_previous),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: value.pauseOrResume,
                                  child: NeuBox(
                                    child: Icon(
                                      value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: GestureDetector(
                                  onTap: value.playNextSong,
                                  child: const NeuBox(
                                    child: Icon(Icons.skip_next),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
