import 'dart:math';
import 'dart:typed_data' show Uint8List;
// ignore: prefer_typing_uninitialized_variables, strict_top_level_inference, non_constant_identifie'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'songs.dart';
import 'playlist.dart';

class PlaylistProvider extends ChangeNotifier {
  // ============ PLAYLIST DO NGƯỜI DÙNG TẠO ============
  final List<Playlist> _playlists = [];

  List<Playlist> get playlists => _playlists;

  void addPlaylist(String name, Uint8List? image) {
    _playlists.add(
      Playlist(name: name, image: image, songs: []),
    ); // ok nếu constructor đã an toàn
    notifyListeners();
  }

  void updatePlaylist(int index, String name, Uint8List? image) {
    _playlists[index].name = name;
    _playlists[index].image = image;
    notifyListeners();
  }

  void deletePlaylist(int index) {
    _playlists.removeAt(index);
    notifyListeners();
  }

  void addSongToPlaylist(int index, Song song) {
    _playlists[index].songs.add(song);
    notifyListeners();
  }

  void removeSongFromPlaylist(int index, Song song) {
    _playlists[index].songs.remove(song);
    notifyListeners();
  }

  // ============ DANH SÁCH BÀI HÁT + PHÁT NHẠC ============
  final List<Song> _playList = [
    Song(
      songName: 'Calm',
      artistName: 'Cursedsnake',
      albumImage: 'assets/images/calm.png',
      audioPath: 'audio/Calm.mp3',
      genre: 'EDM',
    ),
    Song(
      songName: 'Feel',
      artistName: '8bitPice',
      albumImage: 'assets/images/feel.png',
      audioPath: 'audio/Feel.mp3',
      genre: 'EDM',
    ),
    Song(
      songName: 'Unity',
      artistName: 'TheFatRat',
      albumImage: 'assets/images/unity.png',
      audioPath: 'audio/Unity.mp3',
      genre: 'EDM',
    ),
    Song(
      songName: 'Invisible',
      artistName: 'Duran Duran',
      albumImage: 'assets/images/invisible.png',
      audioPath: 'audio/Invisible.mp3',
      genre: 'Pop',
    ),
    Song(
      songName: 'Blinding Lights',
      artistName: 'The Weeknd',
      albumImage: 'assets/images/blinding_lights.png',
      audioPath: 'audio/BlindingLights.mp3',
      genre: 'Synthwave',
    ),
    Song(
      songName: 'Bohemian Rhapsody',
      artistName: 'Queen',
      albumImage: 'assets/images/bohemian_rhapsody.png',
      audioPath: 'audio/BohemianRhapsody.mp3',
      genre: 'Rock',
    ),
    Song(
      songName: 'Stay',
      artistName: 'The Kid LAROI & Justin Bieber',
      albumImage: 'assets/images/stay.png',
      audioPath: 'audio/Stay.mp3',
      genre: 'Pop',
    ),
    Song(
      songName: 'Uptown Funk',
      artistName: 'Mark Ronson ft. Bruno Mars',
      albumImage: 'assets/images/uptown_funk.png',
      audioPath: 'audio/UptownFunk.mp3',
      genre: 'Funk/Pop',
    ),
    Song(
      songName: 'Cake by the ocean',
      artistName: 'DNCE',
      albumImage: 'assets/images/cake_by_the_ocean.png',
      audioPath: 'audio/CakeByTheOcean.mp3',
      genre: 'Pop',
    ),
    Song(
      songName: 'Blowin’ in the Wind',
      artistName: 'Bob Dylan',
      albumImage: 'assets/images/blowin_in_the_wind.png',
      audioPath: 'audio/BlowinInTheWind.mp3',
      genre: 'Folk',
    ),
    Song(
      songName: 'Can’t Stop the Feeling!',
      artistName: 'Justin Timberlake',
      albumImage: 'assets/images/cant_stop_the_feeling.png',
      audioPath: 'audio/CantStopTheFeeling.mp3',
      genre: 'Pop',
    ),
    Song(
      songName: 'Thunderstruck',
      artistName: 'AC/DC',
      albumImage: 'assets/images/thunderstruck.png',
      audioPath: 'audio/Thunderstruck.mp3',
      genre: 'Hard Rock',
    ),
    Song(
      songName: 'Counting Stars',
      artistName: 'OneRepublic',
      albumImage: 'assets/images/counting_stars.png',
      audioPath: 'audio/CountingStars.mp3',
      genre: 'Pop Rock',
    ),
    Song(
      songName: 'Lovely',
      artistName: 'Billie Eilish & Khalid',
      albumImage: 'assets/images/lovely.png',
      audioPath: 'audio/Lovely.mp3',
      genre: 'Indie Pop',
    ),
    Song(
      songName: 'Africa',
      artistName: 'Toto',
      albumImage: 'assets/images/africa.png',
      audioPath: 'audio/Africa.mp3',
      genre: 'Soft Rock',
    ),
  ];
  List<Song> get allSongs => _playList; // tất cả bài hát có sẵn

  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeat = false;
  int? _currentSongIndex;

  PlaylistProvider() {
    listenToDuration();
  }

  // Audio Controls
  void play() async {
    if (_currentSongIndex == null) return;
    await _audioPlayer.stop();
    await _audioPlayer.play(
      AssetSource(_playList[_currentSongIndex!].audioPath),
    );
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() {
    _isPlaying ? pause() : resume();
  }

  void stopPlaying() {
    _audioPlayer.stop();
    _isPlaying = false;
    _currentSongIndex = null;
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentPlaylist.isEmpty) return;

    if (_isRepeat) {
      if (_currentSongIndex != null &&
          _currentSongIndex! >= 0 &&
          _currentSongIndex! < _currentPlaylist.length) {
        playSong(_currentPlaylist[_currentSongIndex!]); // ✅ Lặp lại bài đúng
      }
    } else if (_isShuffle) {
      final random = Random();
      int nextIndex;
      do {
        nextIndex = random.nextInt(_currentPlaylist.length);
      } while (nextIndex == _currentSongIndex && _currentPlaylist.length > 1);
      currentSongIndex = nextIndex;
    } else {
      if (_currentSongIndex != null) {
        final nextIndex = (_currentSongIndex! + 1) % _currentPlaylist.length;
        currentSongIndex = nextIndex;
      }
    }
  }

  void playPreviousSong() {
    if (_currentPlaylist.isEmpty) return;

    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex == null || _currentSongIndex == 0) {
        currentSongIndex = _currentPlaylist.length - 1;
      } else {
        currentSongIndex = _currentSongIndex! - 1;
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

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // Getters
  List<Song> get playList => _playList;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isRepeat => _isRepeat;
  bool get isShuffle => _isShuffle;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // Setter
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null && _currentPlaylist.isNotEmpty) {
      playSong(_currentPlaylist[newIndex]);
    }
    notifyListeners();
  }

  // ====================== PHÁT NHẠC TỪ PLAYLIST TÙY CHỌN ======================

  List<Song> _currentPlaylist = [];
  Song? _currentSong;

  List<Song> get currentPlaylist => _currentPlaylist;
  Song? get currentSong => _currentSong;

  void setPlaylist(List<Song> songs) {
    _currentPlaylist = List.from(songs);
    // ❌ Không set _currentSongIndex ở đây
    notifyListeners();
  }

  void playSong(Song song) async {
    _currentPlaylist = _currentPlaylist; // giữ nguyên nếu đã set rồi trước đó
    _currentSong = song;
    _currentSongIndex = _currentPlaylist.indexOf(song); // ✅ đặt đúng vị trí bài hát

    if (_currentSongIndex == -1) {
      // Nếu bài hát không có trong danh sách, thêm vào đầu
      _currentPlaylist.insert(0, song);
      _currentSongIndex = 0;
    }

    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(song.audioPath));

    _isPlaying = true;
    notifyListeners(); // 🔁 BẮT BUỘC để cập nhật UI
  }

  void playCurrentSong() {
    if (_currentPlaylist.isNotEmpty) {
      playSong(_currentPlaylist[_currentSongIndex ?? 0]);
    }
  }
}
