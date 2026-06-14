import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_cal/theme/app_colors.dart';

/// Defines the V4 Editorial type scale for GPA Cal.
///
/// Headings use **Inter Tight** (condensed, high-impact) and body copy
/// uses **Inter** (optimised for legibility at small sizes). Both are
/// served via the `google_fonts` package.
///
/// All tokens default to [AppColors.textPrimary] — override `color` at
/// the call-site when a different color is needed.
///
/// Usage:
/// ```dart
/// Text('GPA Cal', style: AppTypography.displayLarge)
/// Text('3.87', style: AppTypography.displayLarge.copyWith(color: AppColors.gpa))
/// ```
abstract final class AppTypography {
  // ---------------------------------------------------------------------------
  // Display
  // ---------------------------------------------------------------------------

  /// 32 / 38px — Inter Tight Bold — for hero numbers and splash headlines.
  static TextStyle get displayLarge => GoogleFonts.interTight(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 38 / 32,
        letterSpacing: -0.02 * 32,
        color: AppColors.textPrimary,
      );

  // ---------------------------------------------------------------------------
  // Headlines
  // ---------------------------------------------------------------------------

  /// 24 / 30px — Inter Tight Bold — for section titles and card headers.
  static TextStyle get headlineLarge => GoogleFonts.interTight(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 30 / 24,
        letterSpacing: -0.02 * 24,
        color: AppColors.textPrimary,
      );

  /// 20 / 26px — Inter Tight SemiBold — for page titles and modal headers.
  static TextStyle get headlineMedium => GoogleFonts.interTight(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 26 / 20,
        letterSpacing: -0.01 * 20,
        color: AppColors.textPrimary,
      );

  /// 18 / 24px — Inter Tight SemiBold — for card titles and sub-section headers.
  static TextStyle get headlineSmall => GoogleFonts.interTight(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        letterSpacing: -0.01 * 18,
        color: AppColors.textPrimary,
      );

  // ---------------------------------------------------------------------------
  // Titles
  // ---------------------------------------------------------------------------

  /// 18 / 24px — Inter Tight SemiBold — for list item titles.
  static TextStyle get titleLarge => GoogleFonts.interTight(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        letterSpacing: -0.01 * 18,
        color: AppColors.textPrimary,
      );

  /// 16 / 22px — Inter Tight SemiBold — for card titles and sub-section headers.
  static TextStyle get titleMedium => GoogleFonts.interTight(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 22 / 16,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  /// 14 / 20px — Inter Tight SemiBold — for field labels and list item subtitles.
  static TextStyle get titleSmall => GoogleFonts.interTight(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  /// 16 / 24px — Inter Regular — primary reading text.
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  /// 14 / 20px — Inter Regular — secondary reading text and descriptions.
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  // ---------------------------------------------------------------------------
  // Labels
  // ---------------------------------------------------------------------------

  /// 14 / 20px — Inter Medium — prominent labels, buttons, and tags.
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0.01 * 14,
        color: AppColors.textPrimary,
      );

  /// 12 / 16px — Inter Medium — secondary labels, chips, and metadata.
  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.02 * 12,
        color: AppColors.textPrimary,
      );

  /// 10 / 14px — Inter Medium — fine print, timestamps, and bottom nav labels.
  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 14 / 10,
        letterSpacing: 0.05 * 10,
        color: AppColors.textPrimary,
      );
}
