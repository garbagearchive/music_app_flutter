// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:music_app/models/playlist_provider.dart'; // Import your provider
import 'package:music_app/pages/musicsearching_page.dart'; // Import your screen

void main() {
  // Không cần WidgetsFlutterBinding.ensureInitialized() ở đây nữa nếu audioplayers tự xử lý
  // hoặc bạn có thể giữ nó nếu có các plugin khác cần
  runApp(
    ChangeNotifierProvider(
      create: (context) => PlaylistProvider(), // Tạo một instance của PlaylistProvider
      child: const MyApp(),
    ),
  );
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
      home: const MusicSearchScreen(),
    );
  }
}