import 'package:flutter/material.dart';
import 'package:music_app/components/app_drawer.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/models/songs.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:provider/provider.dart';

//front page of the app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get playlist provider
  late final dynamic playListProvider;
  @override
  void initState() {
    super.initState();
    playListProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    //update the song index
    playListProvider.currentSongIndex = songIndex;
    //navigate to other song
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('P L A Y L I S T')),
      drawer:
          const AppDrawer(), //the drawer button (top left corner), add more function go to app_drawer.dart
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          //get playlist here
          final List<Song> playList = value.playList;

          //return listView UI
          return ListView.builder(
            itemCount: playList.length,
            itemBuilder: (context, index) {
              final Song song = playList[index];
              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumImage),
                onTap: () => goToSong(index),
              );
            },
          );
        },
      ),
    );
  }
}
