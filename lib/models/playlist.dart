import 'dart:typed_data';
import 'songs.dart';

class Playlist {
  String name;
  Uint8List? image;
  List<Song> songs;

  Playlist({required this.name, this.image, required this.songs});
}
