extension StringExtension on String {
  String ifEmpty(String defaultValue) {
    return isEmpty ? defaultValue : this;
  }
}