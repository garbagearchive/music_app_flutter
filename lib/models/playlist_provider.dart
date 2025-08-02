import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/songs.dart';

//this file for playlist
class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playList = [
    //index 0
    Song(
      songName: 'Calm',
      artistName: 'Cursedsnake',
      albumImage: 'assets/images/calm.png',
      audioPath: 'audio/Calm.mp3',
      genre: 'EDM', // Thể loại mới
    ),
    //index 1
    Song(
      songName: 'Feel',
      artistName: '8bitPice',
      albumImage: 'assets/images/feel.png',
      audioPath: 'audio/Feel.mp3',
      genre: 'EDM',
    ),
    //2
    Song(
      songName: 'Unity',
      artistName: 'TheFatRat',
      albumImage: 'assets/images/unity.png',
      audioPath: 'audio/Unity.mp3',
      genre: 'EDM',
    ),
    //3
    Song(
      songName: 'Invisible',
      artistName: 'Duran Duran',
      albumImage: 'assets/images/invisible.png',
      audioPath: 'audio/Invisible.mp3',
      genre: 'Pop',
    ),
    //4
    Song(
      songName: 'Blinding Lights',
      artistName: 'The Weeknd',
      albumImage: 'assets/images/blinding_lights.png',
      audioPath: 'audio/BlindingLights.mp3',
      genre: 'Synthwave',
    ),
    //5
    Song(
      songName: 'Bohemian Rhapsody',
      artistName: 'Queen',
      albumImage: 'assets/images/bohemian_rhapsody.png',
      audioPath: 'audio/BohemianRhapsody.mp3',
      genre: 'Rock',
    ),
    //6
    Song(
      songName: 'Stay',
      artistName: 'The Kid LAROI & Justin Bieber',
      albumImage: 'assets/images/stay.png',
      audioPath: 'audio/Stay.mp3',
      genre: 'Pop',
    ),
    //7
    Song(
      songName: 'Uptown Funk',
      artistName: 'Mark Ronson ft. Bruno Mars',
      albumImage: 'assets/images/uptown_funk.png',
      audioPath: 'audio/UptownFunk.mp3',
      genre: 'Funk/Pop',
    ),
    //8
    Song(
      songName: 'Cake by the ocean',
      artistName: 'DNCE',
      albumImage: 'assets/images/cake_by_the_ocean.png',
      audioPath: 'audio/CakeByTheOcean.mp3',
      genre: 'Pop',
    ),

    //9
    Song(
      songName: 'Blowin’ in the Wind',
      artistName: 'Bob Dylan',
      albumImage: 'assets/images/blowin_in_the_wind.png',
      audioPath: 'audio/BlowinInTheWind.mp3',
      genre: 'Folk',
    ),

    //10
    Song(
      songName: 'Can’t Stop the Feeling!',
      artistName: 'Justin Timberlake',
      albumImage: 'assets/images/cant_stop_the_feeling.png',
      audioPath: 'audio/CantStopTheFeeling.mp3',
      genre: 'Pop',
    ),

    //11
    Song(
      songName: 'Thunderstruck',
      artistName: 'AC/DC',
      albumImage: 'assets/images/thunderstruck.png',
      audioPath: 'audio/Thunderstruck.mp3',
      genre: 'Hard Rock',
    ),
    //12
    Song(
      songName: 'Counting Stars',
      artistName: 'OneRepublic',
      albumImage: 'assets/images/counting_stars.png',
      audioPath: 'audio/CountingStars.mp3',
      genre: 'Pop Rock',
    ),
    //13
    Song(
      songName: 'Lovely',
      artistName: 'Billie Eilish & Khalid',
      albumImage: 'assets/images/lovely.png',
      audioPath: 'audio/Lovely.mp3',
      genre: 'Indie Pop',
    ),
    //14
    Song(
      songName: 'Africa',
      artistName: 'Toto',
      albumImage: 'assets/images/africa.png',
      audioPath: 'audio/Africa.mp3',
      genre: 'Soft Rock',
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
  bool _isShuffle = false;
  bool _isRepeat = false;

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
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

//stop playing
  void stopPlaying() {
    _audioPlayer.stop();
    _isPlaying = false;
    _currentSongIndex = null;
    notifyListeners();
}

  //find a specific timestamp
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_isRepeat) {
      // Repeat current song
      seek(Duration.zero);
      play();
    } else if (_isShuffle) {
      // Play a random song (not the same as current)
      final random = Random();
      int nextIndex;
      do {
        nextIndex = random.nextInt(_playList.length);
      } while (nextIndex == _currentSongIndex);
      currentSongIndex = nextIndex;
    } else {
      // Play next song normally
      if (_currentSongIndex != null) {
        if (_currentSongIndex! < _playList.length - 1) {
          currentSongIndex = _currentSongIndex! + 1;
        } else {
          currentSongIndex = 0; // loop back to first song
        }
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

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
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
  bool get isRepeat => _isRepeat;
  bool get isShuffle => _isShuffle;
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
