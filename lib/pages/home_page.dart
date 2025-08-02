import 'package:flutter/material.dart';
import 'package:music_app/components/small_playing_widget.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/models/songs.dart';
import 'package:music_app/pages/search_page.dart';
import 'package:music_app/pages/setting_page.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:music_app/pages/account_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '🎵 Now Playing...',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6A1B9A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 10,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const SongPage()),
      );
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
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
      case 1:
        return const MusicSearchScreen();
      case 2:
        return const SettingsPage();
      case 3:
        return AccountPage(username: widget.username);
      default:
        return const Center(child: Text('Page Not Found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00FFFF),
                Color(0xFFFF00FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Center(
              child: Text(
                'M Y  M U S I C  A P P',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(child: _getBody()),
          Consumer<PlaylistProvider>(
            builder: (context, provider, child) {
              return provider.currentSongIndex != null
                  ? NowPlayingWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SongPage()),
                        );
                      },
                    )
                  : const SizedBox(); // Không hiển thị nếu chưa chọn bài
            },
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF00FFFF), Color(0xFFFF00FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(Icons.home, color: Colors.white),
            ),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF00FFFF), Color(0xFFFF00FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(Icons.search, color: Colors.white),
            ),
            label: 'SEARCH',
          ),
          BottomNavigationBarItem(
            icon: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF00FFFF), Color(0xFFFF00FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(Icons.settings, color: Colors.white),
            ),
            label: 'SETTING',
          ),
          BottomNavigationBarItem(
            icon: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF00FFFF), Color(0xFFFF00FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(Icons.contacts, color: Colors.white),
            ),
            label: 'ACCOUNT',
          ),
        ],
      ),
    );
  }
}
