import 'package:flutter/material.dart';
import 'package:music_app/pages/home_page.dart';
import 'package:music_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatelessWidget {
  final String username;

  const LogoutPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async => false, // prevent physical back button
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                size: 80,
                color: colorScheme.inversePrimary, // replaces deepPurple
              ),
              const SizedBox(height: 20),
              Text(
                "Do you want to logout?",
                style: TextStyle(
                  fontSize: 20,
                  color: colorScheme.inversePrimary, // adapts to theme
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // YES Button
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor:
                          colorScheme.surface, // usually white/black
                    ),
                    child: const Text("Yes"),
                  ),
                  const SizedBox(width: 20),
                  // NO Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(username: username),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: colorScheme.surface,
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
