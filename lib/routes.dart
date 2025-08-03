import 'package:flutter/material.dart';
import 'package:music_app/pages/forgot_password_page.dart';
import 'package:music_app/pages/login_page.dart';
import 'package:music_app/pages/register_page.dart';


final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/forgot': (context) => const ForgotPasswordPage(),
};