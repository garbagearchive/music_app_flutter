//song format ( might add more stuff soon)
class Song {
  final String songName;
  final String artistName;
  final String albumImage;
  final String audioPath;
  final String genre;

  // ignore: prefer_typing_uninitialized_variables, strict_top_level_inference
  static var songs; // <--- THÊM TRƯỜNG NÀY
  //final String songAlbum;
  //final String songLyrics; (?)

  Song({
    required this.songName,
    required this.artistName,
    required this.albumImage,
    required this.audioPath,
    required this.genre, // <--- THÊM VÀO CONSTRUCTOR
    //required this.songAlbum,
    //required this.songLyrics;
  });
}



//maybe an Artist class here
