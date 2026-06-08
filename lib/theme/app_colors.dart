import 'package:flutter/material.dart';

/// Defines the full V4 Editorial color palette for GPA Cal.
///
/// All tokens are `const` where possible. Derived colors with
/// transparency use pre-computed alpha hex values — never `withOpacity()`.
///
/// Usage:
/// ```dart
/// Container(color: AppColors.accent)
/// Text('GPA', style: TextStyle(color: AppColors.gpa))
/// ```
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------------

  /// The main app background — pure white.
  static const Color background = Color(0xFFFFFFFF);

  /// Card and modal surfaces — pure white.
  static const Color surface = Color(0xFFFFFFFF);

  /// Muted surface used for input field backgrounds and secondary areas.
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  /// Default border color used on cards and dividers.
  static const Color border = Color(0xFFE2E8F0);

  // ---------------------------------------------------------------------------
  // Brand & Text
  // ---------------------------------------------------------------------------

  /// Primary brand accent — vibrant blue.
  static const Color accent = Color(0xFF2563EB);

  /// GPA number highlight — warm orange.
  static const Color gpa = Color(0xFFF97316);

  /// Primary text — near-black for maximum readability.
  static const Color textPrimary = Color(0xFF0F172A);

  /// Secondary text — medium slate for supporting content.
  static const Color textSecondary = Color(0xFF64748B);

  /// Placeholder text — light slate for empty states and hints.
  static const Color textPlaceholder = Color(0xFF94A3B8);

  // ---------------------------------------------------------------------------
  // Semantic
  // ---------------------------------------------------------------------------

  /// Semantic success color — green.
  static const Color success = Color(0xFF16A34A);

  /// Semantic warning color — orange (same hue as [gpa]).
  static const Color warning = Color(0xFFF97316);

  /// Semantic error color — red.
  static const Color error = Color(0xFFDC2626);

  /// Disabled state color — light slate.
  static const Color disabled = Color(0xFFCBD5E1);

  // ---------------------------------------------------------------------------
  // Derived — pre-computed alpha values (no withOpacity())
  // ---------------------------------------------------------------------------

  /// Accent tint at 8% opacity — used for selected/highlighted backgrounds.
  ///
  /// Alpha `0x14` = 20 / 255 ≈ 8%.
  static const Color accentTint = Color(0x142563EB);

  /// Warning tint at 8% opacity — used for warning chip backgrounds.
  ///
  /// Alpha `0x14` = 20 / 255 ≈ 8%.
  static const Color warningTint = Color(0x14F97316);

  /// Error tint at 6% opacity — used for error field backgrounds.
  ///
  /// Alpha `0x0F` = 15 / 255 ≈ 6%.
  static const Color errorTint = Color(0x0FDC2626);

  /// Error feedback tint at 8% opacity — used for error chip / banner backgrounds.
  ///
  /// Alpha `0x14` = 20 / 255 ≈ 8%.
  static const Color errorFeedbackTint = Color(0x14DC2626);

  /// Success tint at 8% opacity — used for success chip / banner backgrounds.
  ///
  /// Alpha `0x14` = 20 / 255 ≈ 8%.
  static const Color successTint = Color(0x1416A34A);

  /// Accent shadow at 25% opacity — used for FAB / elevated button shadows.
  ///
  /// Alpha `0x40` = 64 / 255 = 25%.
  static const Color accentShadow = Color(0x402563EB);
}
