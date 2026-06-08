import 'package:flutter/material.dart';

/// Defines the V4 Editorial spacing and border-radius scale for GPA Cal.
///
/// All values follow an **8pt grid**. Prefer semantic aliases
/// ([screenPadding], [cardPadding], etc.) over raw scale values when
/// the usage context is clear.
///
/// Usage:
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(AppSpacing.screenPadding),
///   child: ...,
/// )
/// ClipRRect(
///   borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
///   child: ...,
/// )
/// ```
abstract final class AppSpacing {
  // ---------------------------------------------------------------------------
  // Base scale — 8pt grid
  // ---------------------------------------------------------------------------

  /// 4px — micro gap between tightly-coupled elements.
  static const double space4 = 4.0;

  /// 8px — tight spacing between related inline elements.
  static const double space8 = 8.0;

  /// 12px — compact row / item spacing.
  static const double space12 = 12.0;

  /// 16px — standard card padding and list row spacing.
  static const double space16 = 16.0;

  /// 20px — medium breathing room between grouped items.
  static const double space20 = 20.0;

  /// 24px — screen edge padding and section spacing.
  static const double space24 = 24.0;

  /// 32px — large section separation.
  static const double space32 = 32.0;

  /// 48px — hero-area vertical padding.
  static const double space48 = 48.0;

  /// 64px — large decorative spacing / bottom nav clearance.
  static const double space64 = 64.0;

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------

  /// Horizontal padding applied to the screen edges.
  static const double screenPadding = space24;

  /// Padding inside card containers.
  static const double cardPadding = space16;

  /// Vertical gap between items inside a card.
  static const double cardGap = space12;

  /// Vertical gap between major page sections.
  static const double sectionGap = space32;

  // ---------------------------------------------------------------------------
  // Border radii — raw doubles
  // ---------------------------------------------------------------------------

  /// 8px radius — used on chips, badges, and small containers.
  static const double radiusSmall = 8.0;

  /// 12px radius — used on input fields and compact cards.
  static const double radiusMedium = 12.0;

  /// 16px radius — primary card radius.
  static const double radiusLarge = 16.0;

  /// 24px radius — bottom sheets and hero containers.
  static const double radiusXLarge = 24.0;

  /// 9999px radius — pill / fully-rounded shapes.
  static const double radiusFull = 9999.0;

  // ---------------------------------------------------------------------------
  // Border radii — BorderRadius constants (convenience)
  // ---------------------------------------------------------------------------

  /// [BorderRadius] for [radiusSmall] corners.
  static const BorderRadius borderRadiusSmall =
      BorderRadius.all(Radius.circular(radiusSmall));

  /// [BorderRadius] for [radiusMedium] corners.
  static const BorderRadius borderRadiusMedium =
      BorderRadius.all(Radius.circular(radiusMedium));

  /// [BorderRadius] for [radiusLarge] corners.
  static const BorderRadius borderRadiusLarge =
      BorderRadius.all(Radius.circular(radiusLarge));

  /// [BorderRadius] for [radiusXLarge] corners.
  static const BorderRadius borderRadiusXLarge =
      BorderRadius.all(Radius.circular(radiusXLarge));

  /// [BorderRadius] for [radiusFull] pill shape.
  static const BorderRadius borderRadiusFull =
      BorderRadius.all(Radius.circular(radiusFull));

  /// [BorderRadius] for bottom-sheet top corners only (XLarge).
  static const BorderRadius borderRadiusTopXLarge = BorderRadius.only(
    topLeft: Radius.circular(radiusXLarge),
    topRight: Radius.circular(radiusXLarge),
  );
}
