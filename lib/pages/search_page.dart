// lib/screens/search_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:music_app/models/songs.dart';
import 'package:music_app/models/playlist_provider.dart';

class MusicSearchScreen extends StatefulWidget {
  const MusicSearchScreen({super.key});

  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedGenre;
  List<Song> _filteredSongs = [];
  List<Song> _recommendedSongs = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filterSongs(); // Gọi _filterSongs khi màn hình được khởi tạo
      _updateRecommendations();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterSongs();
  }

  void _filterSongs() {
    final allSongs = Provider.of<PlaylistProvider>(
      context,
      listen: false,
    ).playList;

    setState(() {
      final query = _searchController.text.toLowerCase();
      List<Song> results = allSongs; // Bắt đầu với TẤT CẢ bài hát

      // Lọc theo thể loại nếu một thể loại cụ thể được chọn (_selectedGenre không phải null)
      if (_selectedGenre != null) {
        results = results
            .where((song) => song.genre == _selectedGenre)
            .toList();
      }

      // Lọc theo từ khóa tìm kiếm nếu có từ khóa (query không rỗng)
      if (query.isNotEmpty) {
        results = results
            .where(
              (song) =>
                  song.songName.toLowerCase().contains(query) ||
                  song.artistName.toLowerCase().contains(query),
            )
            .toList();
      }

      // Gán kết quả cuối cùng vào _filteredSongs
      _filteredSongs = results;
    });
  }

  void _updateRecommendations() {
    final allSongs = Provider.of<PlaylistProvider>(
      context,
      listen: false,
    ).playList;
    List<Song> sortedSongs = List.from(allSongs);
    sortedSongs.sort((a, b) => a.songName.compareTo(b.songName));
    _recommendedSongs = sortedSongs.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    final List<String> availableGenres =
        playlistProvider.playList.map((song) => song.genre).toSet().toList()
          ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('SEARCH')),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.inversePrimary, // chữ trong chế độ tối
                ),
                decoration: InputDecoration(
                  hintText: 'Search for songs, artists...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                ),
                onChanged: (value) {
                  _filterSongs();
                },
              ),
              const SizedBox(height: 16),

              // Filter Options
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGenre,
                        hint: const Text('Genre'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGenre = newValue;
                          });
                          _filterSongs();
                        },
                        items: <String?>[null, ...availableGenres]
                            .map<DropdownMenuItem<String>>((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Builder(
                                  builder: (context) => Text(
                                    value ?? 'All',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                                    ),
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  ActionChip(
                    label: const Text('Now Playing'),
                    onPressed: () {
                      if (playlistProvider.isPlaying &&
                          playlistProvider.currentSongIndex != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Now playing: ${playlistProvider.playList[playlistProvider.currentSongIndex!].songName}',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No song is playing currently.'),
                          ),
                        );
                      }
                    },
                    backgroundColor: playlistProvider.isPlaying
                        ? Colors.green[100]
                        : Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: playlistProvider.isPlaying
                          ? Colors.green
                          : Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Results Section
              const Text(
                'Result',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _filteredSongs.isEmpty
                  ? Center(
                      child: Text(
                        // Sửa lại thông báo cho phù hợp
                        (_searchController.text.isEmpty &&
                                _selectedGenre == null)
                            ? 'Select gerne and keywords'
                            : 'Nothing found.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: _filteredSongs.length,
                      itemBuilder: (context, index) {
                        final song = _filteredSongs[index];
                        final originalIndex = playlistProvider.playList.indexOf(
                          song,
                        );
                        return _buildSongCard(
                          song.albumImage,
                          song.songName,
                          song.artistName,
                          originalIndex,
                        );
                      },
                    ),

              const SizedBox(height: 24),

              // Recommendations Section
              const Text(
                'Recommendation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recommendedSongs.length,
                  itemBuilder: (context, index) {
                    final song = _recommendedSongs[index];
                    final originalIndex = playlistProvider.playList.indexOf(
                      song,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _buildSongCard(
                        song.albumImage,
                        song.songName,
                        song.artistName,
                        originalIndex,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongCard(
    String imageUrl,
    String title,
    String artist,
    int songIndex,
  ) {
    final playlistProvider = Provider.of<PlaylistProvider>(
      context,
      listen: false,
    );
    return GestureDetector(
      onTap: () {
        playlistProvider.currentSongIndex = songIndex;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Now playing: $title - $artist')),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imageUrl,
              width: 150,
              height: 150, // Đảm bảo tỷ lệ 1:1
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.music_note,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            artist,
            style: TextStyle(color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
