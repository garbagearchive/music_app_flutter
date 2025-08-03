import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/pages/logout_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  final String username;

  const AccountPage({super.key, required this.username});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    loadSavedAvatar(widget.username);
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      await saveAvatar(widget.username, bytes);
    }
  }

  Future<void> saveAvatar(String username, Uint8List bytes) async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = base64Encode(bytes);
    await prefs.setString('avatar_$username', base64Image);
  }

  Future<void> loadSavedAvatar(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('avatar_$username');
    if (base64Image != null) {
      setState(() {
        _imageBytes = base64Decode(base64Image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ACCOUNT')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepPurple, // 🎨 Màu viền bạn muốn
                    width: 4.0, // 🧱 Độ dày viền
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageBytes != null
                      ? MemoryImage(_imageBytes!)
                      : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Username: ${widget.username}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LogoutPage(username: widget.username),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
