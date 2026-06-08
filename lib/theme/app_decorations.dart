import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';

/// Provides pre-built [BoxDecoration] and [BoxShadow] constants for GPA Cal.
///
/// Use these tokens instead of building inline decorations so that the
/// visual language stays consistent across all features.
///
/// Usage:
/// ```dart
/// DecoratedBox(
///   decoration: AppDecorations.card,
///   child: Padding(
///     padding: EdgeInsets.all(AppSpacing.cardPadding),
///     child: ...,
///   ),
/// )
/// ```
abstract final class AppDecorations {
  // ---------------------------------------------------------------------------
  // Shadows
  // ---------------------------------------------------------------------------

  /// No shadow — used for completely flat surfaces.
  static const List<BoxShadow> elevation0 = [];

  /// Subtle card shadow — 1px y-offset, low spread.
  ///
  /// Black at ~6% opacity (`0x0F` = 15/255).
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  /// FAB / accent button shadow — accent color at 25% opacity.
  ///
  /// Uses [AppColors.accentShadow] (`0x40` = 64/255 ≈ 25%).
  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: AppColors.accentShadow,
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  /// Bottom sheet top shadow — dark at ~8% opacity.
  ///
  /// Negative y-offset lifts the sheet visually.
  /// Black at 8% (`0x14` = 20/255).
  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, -8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Card decorations
  // ---------------------------------------------------------------------------

  /// Standard card — white background, 1px border, [AppSpacing.radiusLarge],
  /// with [elevation1] shadow.
  static const BoxDecoration card = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppSpacing.borderRadiusLarge,
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.border, width: 1),
    ),
    boxShadow: elevation1,
  );

  /// Flat card — same as [card] but without any shadow.
  ///
  /// Preferred when a card sits inside a scrollable area where shadows
  /// create visual noise.
  static const BoxDecoration cardFlat = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppSpacing.borderRadiusLarge,
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.border, width: 1),
    ),
  );

  // ---------------------------------------------------------------------------
  // Input decorations
  // ---------------------------------------------------------------------------

  /// Resting input field — muted surface background, no border.
  ///
  /// Apply [inputFocused] on focus to show the accent border.
  static const BoxDecoration input = BoxDecoration(
    color: AppColors.surfaceMuted,
    borderRadius: AppSpacing.borderRadiusMedium,
  );

  /// Focused input field — white background, 2px accent border.
  static const BoxDecoration inputFocused = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppSpacing.borderRadiusMedium,
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.accent, width: 2),
    ),
  );

  // ---------------------------------------------------------------------------
  // Sheet decorations
  // ---------------------------------------------------------------------------

  /// Bottom sheet — white background, rounded top corners, [elevation3] shadow.
  static const BoxDecoration bottomSheet = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppSpacing.borderRadiusTopXLarge,
    boxShadow: elevation3,
  );
}
