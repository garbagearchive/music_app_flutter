import 'package:flutter/material.dart';
import 'package:music_app/pages/home_page.dart';
import 'package:music_app/pages/login_page.dart'; // thêm nếu chưa có
import 'package:shared_preferences/shared_preferences.dart'; // nếu dùng SharedPreferences

class LogoutPage extends StatelessWidget {
  final String username;

  const LogoutPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false, // chặn nút back vật lý
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text("Do you want to logout?", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nút YES - Đăng xuất
                  ElevatedButton(
                    onPressed: () async {
                      // Xóa thông tin đăng nhập nếu có
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      // Điều hướng về LoginPage, xoá hết stack
                      Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Yes"),
                  ),
                  const SizedBox(width: 20),
                  // Nút NO - Quay lại Home
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage(username: username)),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("No"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
