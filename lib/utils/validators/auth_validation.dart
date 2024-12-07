class AuthValidation {
  // Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required.";
    }
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email address.";
    }
    return null;
  }

  // Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long.";
    }
    if (!value.contains(RegExp(r'\d'))) {
      return "Password must contain at least one number.";
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain at least one special character.";
    }
    return null;
  }

  static String? validateName(String? value,String name) {
    if (value == null || value.trim().isEmpty) {
      return "$name name is required.";
    }
    if (value.length < 2) {
      return "$name name must be at least 2 characters.";
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return "$name name must contain only letters.";
    }
    return null;
  }
}
