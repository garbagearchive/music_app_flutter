import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:music_app/components/small_playing_widget.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/models/songs.dart';
import 'package:music_app/pages/playlistdetail_page.dart';
import 'package:music_app/pages/search_page.dart';
import 'package:music_app/pages/setting_page.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:music_app/pages/account_page.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _showAddPlaylistDialog(BuildContext context) async {
    final nameController = TextEditingController();
    Uint8List? imageData;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Playlist'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  Uint8List? picked;
                  if (kIsWeb) {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null) picked = result.files.first.bytes;
                  } else {
                    final picker = ImagePicker();
                    final file = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null) picked = await file.readAsBytes();
                  }
                  if (picked != null) {
                    setState(() => imageData = picked);
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: imageData != null
                      ? MemoryImage(imageData!)
                      : null,
                  child: imageData == null
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Playlist Name'),
              ),
            ],
          ),
        ),
        actions: [
          // Cancel button with border and black text
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              foregroundColor: Colors.black,
            ),
            child: const Text('Cancel'),
          ),

          // Create button with black text
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a playlist name.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              Provider.of<PlaylistProvider>(
                context,
                listen: false,
              ).addPlaylist(name, imageData);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200], // light background
              foregroundColor: Colors.black, // black text
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditPlaylistDialog(
    BuildContext context,
    int index,
    String currentName,
    Uint8List? currentImage,
  ) async {
    final nameController = TextEditingController(text: currentName);
    Uint8List? imageData = currentImage;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Playlist'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  Uint8List? picked;
                  if (kIsWeb) {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null) picked = result.files.first.bytes;
                  } else {
                    final picker = ImagePicker();
                    final file = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null) picked = await file.readAsBytes();
                  }
                  if (picked != null) {
                    setState(() => imageData = picked);
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: imageData != null
                      ? MemoryImage(imageData!)
                      : null,
                  child: imageData == null
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Playlist Name'),
              ),
            ],
          ),
        ),
        actions: [
          // Nút Cancel với viền rõ ràng
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black), // viền đen
              foregroundColor: Colors.black, // màu chữ đen
            ),
            child: const Text('Cancel'),
          ),

          // Nút Save với chữ đen
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Provider.of<PlaylistProvider>(
                  context,
                  listen: false,
                ).updatePlaylist(index, nameController.text, imageData);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200], // hoặc white
              foregroundColor: Colors.black, // chữ đen
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return Consumer<PlaylistProvider>(
          builder: (context, value, child) {
            final List<Song> playList = value.playList;
            final playlists = value.playlists;

            return ListView(
              children: [
                ListTile(
                  title: const Text(
                    'YOUR PLAYLISTS',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddPlaylistDialog(context),
                  ),
                ),
                ...List.generate(playlists.length, (index) {
                  final playlist = playlists[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: playlist.image != null
                          ? MemoryImage(playlist.image!)
                          : null,
                      child: playlist.image == null
                          ? const Icon(Icons.music_note)
                          : null,
                    ),
                    title: Text(playlist.name),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditPlaylistDialog(
                            context,
                            index,
                            playlist.name,
                            playlist.image,
                          );
                        } else if (value == 'delete') {
                          Provider.of<PlaylistProvider>(
                            context,
                            listen: false,
                          ).deletePlaylist(index);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PlaylistDetailPage(playlistIndex: index),
                        ),
                      );
                    },
                  );
                }),
                const Divider(),
                ListTile(
                  title: const Text(
                    'ALL SONGS',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ...List.generate(playList.length, (index) {
                  final song = playList[index];
                  return ListTile(
                    title: Text(song.songName),
                    subtitle: Text(song.artistName),
                    leading: Image.asset(song.albumImage),
                    onTap: () => goToSong(index),
                  );
                }),
              ],
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
              colors: [Color(0xFF00FFFF), Color(0xFFFF00FF)],
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
                          MaterialPageRoute(
                            builder: (context) => const SongPage(),
                          ),
                        );
                      },
                    )
                  : const SizedBox();
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
            label: 'SETTINGS',
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
