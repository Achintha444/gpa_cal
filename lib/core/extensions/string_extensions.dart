/// Extension methods on [String] for common string transformations used in the app.
extension StringExtensions on String {
  /// Returns initials from this string — the first letter of each word, uppercased,
  /// capped at a maximum of 2 characters.
  ///
  /// Examples:
  /// ```dart
  /// 'Achintha Isuru'.initials  // → 'AI'
  /// 'University of Moratuwa'.initials  // → 'UO' (first two words)
  /// 'Alice'.initials  // → 'A'
  /// ''.initials  // → ''
  /// ```
  String get initials {
    final List<String> words = trim().split(RegExp(r'\s+')).where(
      (String word) => word.isNotEmpty,
    ).toList();

    if (words.isEmpty) {
      return '';
    }

    return words
        .take(2)
        .map((String word) => word[0].toUpperCase())
        .join();
  }
}
