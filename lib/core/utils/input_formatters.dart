import 'package:flutter/services.dart';

/// Provides pre-configured [TextInputFormatter] instances for common form fields.
///
/// Centralising formatters here ensures consistent input constraints across
/// all form widgets without duplicating configuration.
///
/// Usage:
/// ```dart
/// TextField(
///   inputFormatters: [InputFormatters.semesterNameFormatter],
/// )
/// ```
abstract final class InputFormatters {
  /// Formatter for semester name fields.
  ///
  /// Allows alphanumeric characters, spaces, hyphens, and underscores.
  /// Limits input to a maximum of 20 characters.
  static final TextInputFormatter semesterNameFormatter =
      _MaxLengthFilteringFormatter(
    allow: RegExp(r'[a-zA-Z0-9 \-_]'),
    maxLength: 20,
  );
}

/// A [TextInputFormatter] that filters input using a regular expression
/// and enforces a maximum character length.
///
/// This combines filtering and length restriction into a single formatter,
/// which is more efficient than chaining two separate formatters.
class _MaxLengthFilteringFormatter extends TextInputFormatter {
  /// The regex pattern specifying allowed characters.
  final RegExp allow;

  /// The maximum number of characters permitted in the field.
  final int maxLength;

  /// Creates a formatter with the given [allow] pattern and [maxLength].
  const _MaxLengthFilteringFormatter({
    required this.allow,
    required this.maxLength,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Filter characters that do not match the allow pattern.
    final String filtered = newValue.text
        .split('')
        .where((String char) => allow.hasMatch(char))
        .join();

    // Enforce max length on the filtered result.
    final String truncated =
        filtered.length > maxLength ? filtered.substring(0, maxLength) : filtered;

    // If unchanged, return old value to avoid unnecessary cursor repositioning.
    if (truncated == oldValue.text) {
      return oldValue;
    }

    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: truncated.length),
    );
  }
}
