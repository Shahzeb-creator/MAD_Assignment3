class Validator {
  static String? validateEmail(String value) {
    if (value.isEmpty) return "Email required";
    if (!value.contains('@')) return "Invalid email";
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return "Password required";
    if (value.length < 6) return "Min 6 chars required";
    if (!RegExp(r'[A-Z]').hasMatch(value)) return "1 uppercase required";
    if (!RegExp(r'[!@#$%^&*]').hasMatch(value)) return "1 special char required";
    return null;
  }
}