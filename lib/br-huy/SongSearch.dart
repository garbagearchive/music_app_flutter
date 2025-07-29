import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 1. Define a Hive-compatible model for Song
@HiveType(typeId: 0) // Unique typeId for your model
class Song extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String artist;

  @HiveField(2)
  late String imageUrl;

  @HiveField(3)
  late String genre;

  @HiveField(4)
  late DateTime releaseDate;

  Song({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.genre,
    required this.releaseDate,
  });
}

// 2. Create a TypeAdapter for the Song model (manual for this example)
class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 0; // Must match the typeId in @HiveType

  @override
  Song read(BinaryReader reader) {
    return Song(
      title: reader.readString(),
      artist: reader.readString(),
      imageUrl: reader.readString(),
      genre: reader.readString(),
      releaseDate: DateTime.parse(reader.readString()), // Read as string, parse to DateTime
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.artist);
    writer.writeString(obj.imageUrl);
    writer.writeString(obj.genre);
    writer.writeString(obj.releaseDate.toIso8601String()); // Write as string
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongAdapter()); // Register the adapter

  // Open the box for songs
  await Hive.openBox<Song>('songsBox');

  // Add some initial dummy data if the box is empty
  var songBox = Hive.box<Song>('songsBox');
  if (songBox.isEmpty) {
    // Clear the box for fresh data in case it had old data from previous runs
    await songBox.clear();

    // Dân ca
    songBox.add(Song(
      title: 'Tát Nước Đầu Đình',
      artist: 'Quan Họ Bắc Ninh',
      imageUrl: 'https://via.placeholder.com/150/A0522D/FFFFFF?text=TatNuoc',
      genre: 'Dân ca',
      releaseDate: DateTime(1960, 1, 1), // Old song
    ));
    songBox.add(Song(
      title: 'Đi Cấy',
      artist: 'Dân ca Quan Họ',
      imageUrl: 'https://via.placeholder.com/150/D2B48C/000000?text=DiCay',
      genre: 'Dân ca',
      releaseDate: DateTime(1965, 3, 10),
    ));
    songBox.add(Song(
      title: 'Khúc Hát Ân Tình (Ví Giặm)',
      artist: 'Dân ca Ví Giặm Nghệ Tĩnh',
      imageUrl: 'https://via.placeholder.com/150/8B4513/FFFFFF?text=ViGiam',
      genre: 'Dân ca',
      releaseDate: DateTime(1970, 7, 20),
    ));

    // Cách mạng
    songBox.add(Song(
      title: 'Đất Nước Trọn Niềm Vui',
      artist: 'Tạ Minh Tâm',
      imageUrl: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=DatNuoc',
      genre: 'Cách mạng',
      releaseDate: DateTime(1975, 4, 30),
    ));
    songBox.add(Song(
      title: 'Cảm xúc tháng mười',
      artist: 'Quang Thọ',
      imageUrl: 'https://via.placeholder.com/150/DC143C/FFFFFF?text=TienQuan',
      genre: 'Cách mạng',
      releaseDate: DateTime(1944, 8, 17),
    ));
    songBox.add(Song(
      title: 'Giải phóng Điện Biên',
      artist: 'Trọng Tấn-Đăng Dương-Việt Hoàng',
      imageUrl: 'https://via.placeholder.com/150/B22222/FFFFFF?text=HonSiTu',
      genre: 'Cách mạng',
      releaseDate: DateTime(1970, 1, 1),
    ));

    // Pop
    songBox.add(Song(
      title: 'Vợ Người Ta',
      artist: 'Phan Mạnh Quỳnh',
      imageUrl: 'https://via.placeholder.com/150/3357FF/FFFFFF?text=VoNguoiTa',
      genre: 'Pop',
      releaseDate: DateTime(2015, 8, 15),
    ));
    songBox.add(Song(
      title: 'Lạc Trôi',
      artist: 'Sơn Tùng M-TP',
      imageUrl: 'https://via.placeholder.com/150/FF33CC/FFFFFF?text=LacTroi',
      genre: 'Pop',
      releaseDate: DateTime(2017, 1, 1),
    ));
    songBox.add(Song(
      title: 'Em Gái Mưa',
      artist: 'Hương Tràm',
      imageUrl: 'https://via.placeholder.com/150/FFFF33/000000?text=EmGaiMua',
      genre: 'Pop',
      releaseDate: DateTime(2017, 9, 20),
    ));

    // Nhạc Trữ Tình
    songBox.add(Song(
      title: 'Duyên Phận',
      artist: 'Như Quỳnh',
      imageUrl: 'https://via.placeholder.com/150/6A5ACD/FFFFFF?text=DuyenPhan',
      genre: 'Nhạc Trữ Tình',
      releaseDate: DateTime(2018, 5, 10),
    ));
    songBox.add(Song(
      title: 'Chuyến Tàu Hoàng Hôn',
      artist: 'Đan Nguyên',
      imageUrl: 'https://via.placeholder.com/150/4682B4/FFFFFF?text=ChuyenTau',
      genre: 'Nhạc Trữ Tình',
      releaseDate: DateTime(2010, 11, 5),
    ));
    songBox.add(Song(
      title: 'Đồi Thông Hai Mộ',
      artist: 'Quang Lê',
      imageUrl: 'https://via.placeholder.com/150/20B2AA/FFFFFF?text=DoiThong',
      genre: 'Nhạc Trữ Tình',
      releaseDate: DateTime(2012, 3, 25),
    ));
    
    // Add a very recent song for testing recommendations
    songBox.add(Song(
      title: 'Ngày Đầu Tiên',
      artist: 'Đức Phúc',
      imageUrl: 'https://via.placeholder.com/150/FFD700/000000?text=NgayDauTien',
      genre: 'Pop',
      releaseDate: DateTime(2022, 2, 10),
    ));
    songBox.add(Song(
      title: 'À Lôi',
      artist: 'Double2T',
      imageUrl: 'https://via.placeholder.com/150/DAA520/000000?text=ALoi',
      genre: 'Pop',
      releaseDate: DateTime(2023, 7, 1),
    ));
    songBox.add(Song(
      title: 'Nâng Chén Tiêu Sầu',
      artist: 'Bích Phương',
      imageUrl: 'https://via.placeholder.com/150/8B008B/FFFFFF?text=NangChen',
      genre: 'Pop',
      releaseDate: DateTime(2024, 1, 15),
    ));


  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: Colors.white, // Make AppBar background white
          elevation: 0, // Remove shadow
          iconTheme: IconThemeData(color: Colors.black), // Black icons
          toolbarTextStyle: TextStyle(color: Colors.black), // Black text
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: MusicSearchScreen(),
    );
  }
}

class MusicSearchScreen extends StatefulWidget {
  const MusicSearchScreen({super.key});

  @override
  State<MusicSearchScreen> createState() => _MusicSearchScreenState();
}

class _MusicSearchScreenState extends State<MusicSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedGenre; // Null means "Tất cả" (All genres)
  List<Song> _filteredSongs = [];
  List<Song> _recommendedSongs = [];

  late Box<Song> _songBox;

  @override
  void initState() {
    super.initState();
    _songBox = Hive.box<Song>('songsBox');
    _searchController.addListener(_onSearchChanged);
    _updateRecommendations();
    // No initial filter applied, so _filteredSongs starts empty
    _filterSongs();
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
    setState(() {
      final query = _searchController.text.toLowerCase();
      final allSongs = _songBox.values.toList();

      if (query.isEmpty && _selectedGenre == null) {
        // Nếu ô tìm kiếm trống và không chọn thể loại, không hiển thị bài nào
        _filteredSongs = [];
      } else if (_selectedGenre != null) {
        // Nếu thể loại được chọn, lọc theo thể loại đó
        List<Song> genreFiltered = allSongs.where((song) => song.genre == _selectedGenre).toList();
        if (query.isNotEmpty) {
          // Nếu có cả query, lọc tiếp trong số bài hát của thể loại đó
          _filteredSongs = genreFiltered.where(
            (song) => song.title.toLowerCase().contains(query) || song.artist.toLowerCase().contains(query)
          ).toList();
        } else {
          // Nếu chỉ có thể loại được chọn, hiển thị tất cả bài của thể loại đó
          _filteredSongs = genreFiltered;
        }
      } else if (query.isNotEmpty) {
        // Nếu chỉ có query (không chọn thể loại), lọc trên tất cả bài hát
        _filteredSongs = allSongs.where(
          (song) => song.title.toLowerCase().contains(query) || song.artist.toLowerCase().contains(query)
        ).toList();
      }
      // Implicitly, if query is empty AND _selectedGenre is null, _filteredSongs remains empty.
    });
  }


  void _updateRecommendations() {
    // Get all songs, sort by release date in descending order, and take the top 3
    final allSongs = _songBox.values.toList();
    allSongs.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    _recommendedSongs = allSongs.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm bài hát'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm bài hát, nghệ sĩ...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
                onChanged: (value) {
                  _filterSongs(); // Filter as user types
                },
              ),
              const SizedBox(height: 16),

              // Filter Options
              Row(
                children: [
                  // Genre Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGenre,
                        hint: const Text('Thể loại'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGenre = newValue;
                          });
                          _filterSongs(); // Filter when genre changes
                        },
                        items: <String?>[
                          null, // Represents "Tất cả" (All)
                          'Cách mạng',
                          'Pop',
                          'Dân ca',
                          'Nhạc Trữ Tình',
                          'Rock',
                          'Jazz',
                          'EDM',
                          'Classical',
                        ].map<DropdownMenuItem<String>>(
                          (String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value ?? 'Tất cả'), // Display "Tất cả" for null
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // "Mới phát hành" Chip (If you still want it, otherwise remove)
                  // I'm keeping it for now, but its function isn't tied to main search results
                  // as per the new requirements, but rather recommendations handle "newest".
                  ActionChip(
                    label: const Text('Mới phát hành'),
                    onPressed: () {
                      // This chip just serves as an indicator/button.
                      // The 'Đề xuất cho bạn' section already handles the "newest releases".
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Xem mục "Đề xuất cho bạn" để tìm bài hát mới nhất.')),
                      );
                    },
                    backgroundColor: Colors.blue[100],
                    labelStyle: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Results Section
              const Text(
                'Kết quả tìm kiếm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _filteredSongs.isEmpty
                  ? Center(
                      child: Text(
                        (_searchController.text.isEmpty && _selectedGenre == null)
                            ? 'Bắt đầu tìm kiếm hoặc chọn thể loại.'
                            : 'Không tìm thấy bài hát nào.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // 4 columns as per the image
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 0.8, // Adjust as needed
                      ),
                      itemCount: _filteredSongs.length,
                      itemBuilder: (context, index) {
                        final song = _filteredSongs[index];
                        return _buildSongCard(song.imageUrl, song.title, song.artist);
                      },
                    ),

              const SizedBox(height: 24),

              // Recommendations Section
              const Text(
                'Đề xuất cho bạn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200, // Height for the horizontal scroll view
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recommendedSongs.length,
                  itemBuilder: (context, index) {
                    final song = _recommendedSongs[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _buildSongCard(song.imageUrl, song.title, song.artist),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build a song card
  Widget _buildSongCard(String imageUrl, String title, String artist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            width: 150, // Adjust width as needed
            height: 120, // Adjust height as needed
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 150,
                height: 120,
                color: Colors.grey[300],
                child: const Icon(Icons.music_note, size: 50, color: Colors.grey),
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
    );
  }
}