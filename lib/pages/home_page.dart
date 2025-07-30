import 'package:flutter/material.dart';
import 'package:music_app/components/small_playing_widget.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/models/songs.dart';
import 'package:music_app/pages/search_page.dart';
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
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'favorite':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${song.songName} added to favorites',
                              ),
                            ),
                          );
                          break;

                        case 'remove':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${song.songName} removed from playlist',
                              ),
                            ),
                          );
                          break;

                        default:
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'favorite',
                        child: Text('Add to Favorites'),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove from playlist'),
                      ),
                    ],
                  ),
                  onTap: () => goToSong(index),
                );
              },
            );
          },
        );
      case 1: // SEARCH
        return const MusicSearchScreen();
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
        title: const Center(child: Text('M Y  M U S I C  A P P')),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _getBody()),
          NowPlayingWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SongPage()),
              );
            },
          ),
        ],
      ),
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
