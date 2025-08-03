class Validators {
  static final RegExp emailRegex =
      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  static final RegExp passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

  /// Validate username (not empty and at least 3 chars)
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username is required";
    } else if (value.length < 3) {
      return "Username must be at least 3 characters";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    } else if (!passwordRegex.hasMatch(value)) {
      return "Password must be 8+ chars, include uppercase, number, and symbol";
    }
    return null;
  }
}