import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/songs.dart';

//this file for playlist
class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playList = [
    //list of songs (idk how to make it automatically match the song and img name)
    //index 0
    Song(
      songName: 'Calm',
      artistName: 'Cursedsnake',
      albumImage: 'assets/images/calm_img.png',
      audioPath: 'audio/Calm.mp3',
    ),
    //index 1
    Song(
      songName: 'Feel',
      artistName: '8bitPice',
      albumImage: 'assets/images/feel_img.png',
      audioPath: 'audio/Feel.mp3',
    ),
    Song(
      songName: 'Unity',
      artistName: 'TheFatRat',
      albumImage: 'assets/images/Unity_img.png',
      audioPath: 'audio/Unity.mp3',
    ),
    Song(
      songName: 'Invisible',
      artistName: 'Duran Duran',
      albumImage: 'assets/images/invisible.png',
      audioPath: 'audio/Invisible.mp3',
    ),
  ];
  /*AUDIOPLAYER 
  use $flutter pub add audioplayers*/

  //audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  //duration control
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructor
  PlaylistProvider() {
    listenToDuration();
  }

  //when not playing
  bool _isPlaying = false;

  //when playing
  void play() async {
    final String path = _playList[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  //pausing
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume
  void resume() async {
    await _audioPlayer.pause();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //find a specific timestamp
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playList.length - 1) {
        //go to next song if its not the last
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  //play previous song
  void playPreviousSong() {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = currentSongIndex! - 1;
      } else {
        currentSongIndex = _playList.length - 1;
      }
    }
  }

  //listen to duration
  void listenToDuration() {
    //listen to total
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    //listen to current
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen to end
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //dispose audio player

  int? _currentSongIndex;
  /*G E T T E R*/
  List<Song> get playList => _playList;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*S E T T E R*/
  set currentSongIndex(int? newIndex) {
    //update the index of current song ofc
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    //update the UI
    notifyListeners();
  }
}
