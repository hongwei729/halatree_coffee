/// Client-side password rules before signup or reset-password submit.
class PasswordValidator {
  PasswordValidator._();

  /// Validates password and confirmation for signup / reset flows.
  /// Returns `null` when valid, otherwise an error message for the user.
  static String? validateSignupPassword(String password, String confirmPassword) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return 'Password must contain at least one letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }
}
