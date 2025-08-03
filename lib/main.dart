import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/playlist_provider.dart';
import 'themes/theme_changer.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/account_page.dart';
import 'pages/logout_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/forgot': (_) => const ForgotPasswordPage(),
        '/home': (_) => const HomePage(username: ''),
        '/account': (_) => const AccountPage(username: ''),
        '/logout': (_) => const LogoutPage(username: ''),
      },
    );
  }
}
