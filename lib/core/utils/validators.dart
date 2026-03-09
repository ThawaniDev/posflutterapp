class Validators {
  Validators._();

  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '\${fieldName ?? "This field"} is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}\$');
    if (!regex.hasMatch(value)) return 'Invalid email address';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    final regex = RegExp(r'^\+?[0-9]{8,15}\$');
    if (!regex.hasMatch(value)) return 'Invalid phone number';
    return null;
  }

  static String? minLength(String? value, int min, [String? fieldName]) {
    if (value == null || value.length < min) {
      return '\${fieldName ?? "This field"} must be at least \$min characters';
    }
    return null;
  }

  static String? pin(String? value) {
    if (value == null || value.isEmpty) return 'PIN is required';
    if (value.length != 4) return 'PIN must be 4 digits';
    if (!RegExp(r'^[0-9]{4}\$').hasMatch(value)) return 'PIN must be digits only';
    return null;
  }
}
