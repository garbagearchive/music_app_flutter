import 'package:flutter/material.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/models/songs.dart';
import 'package:music_app/pages/setting_page.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlaylistProvider playListProvider;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    playListProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playListProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SongPage()),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0: // HOME
        return Consumer<PlaylistProvider>(
          builder: (context, value, child) {
            final List<Song> playList = value.playList;
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
        );
      case 1: // SEARCH
        return const Center(
          child: Text('Search Page', style: TextStyle(fontSize: 20)),
        );
      case 2: // SETTING
        return const SettingsPage();
      case 3: // ACCOUNT
        return const Center(
          child: Text('Account Page', style: TextStyle(fontSize: 20)),
        );
      default:
        return const Center(child: Text('Page Not Found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Center(child: const Text('M Y  M U S I C  A P P')),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'SEARCH'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'SETTING'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'ACCOUNT'),
        ],
      ),
    );
  }
}
