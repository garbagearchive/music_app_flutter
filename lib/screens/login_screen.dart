import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  Future<void> handleLogin() async {
    if (_formKey.currentState?.validate() != true) return;

    try {
      final message = await ApiService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    ValueNotifier<bool>? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: toggleObscure ?? ValueNotifier(false),
      builder: (context, obscure, _) {
        return TextFormField(
          controller: controller,
          obscureText: isPassword ? obscure : false,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.deepPurple,
                    ),
                    onPressed: () => toggleObscure?.value = !obscure,
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        label: "Username",
                        icon: Icons.person_outline,
                        controller: usernameController,
                        validator: Validators.validateUsername,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Password",
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        isPassword: true,
                        toggleObscure: _obscurePassword,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text("Login", style: TextStyle(fontSize: 18)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/forgot'),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
