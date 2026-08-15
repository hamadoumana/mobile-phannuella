class Validators {
  Validators._();

  static bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

  static bool isEmail(String? value) {
    if (value == null) return false;
    return RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(value);
  }
}
