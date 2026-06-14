import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';

/// Builds and returns the V4 Editorial [ThemeData] for GPA Cal.
///
/// Wire this up in your root [MaterialApp]:
/// ```dart
/// MaterialApp(
///   theme: appTheme(),
///   ...
/// )
/// ```
///
/// All tokens are sourced from [AppColors], [AppTypography], and
/// [AppSpacing] — never hardcoded inline.
ThemeData appTheme() {
  final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.accent,
    onPrimary: AppColors.surface,
    primaryContainer: AppColors.accentTint,
    onPrimaryContainer: AppColors.accent,
    secondary: AppColors.gpa,
    onSecondary: AppColors.surface,
    secondaryContainer: AppColors.warningTint,
    onSecondaryContainer: AppColors.gpa,
    tertiary: AppColors.success,
    onTertiary: AppColors.surface,
    tertiaryContainer: AppColors.successTint,
    onTertiaryContainer: AppColors.success,
    error: AppColors.error,
    onError: AppColors.surface,
    errorContainer: AppColors.errorFeedbackTint,
    onErrorContainer: AppColors.error,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceMuted,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.disabled,
    shadow: const Color(0x0F000000),
    scrim: const Color(0x66000000),
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.accentTint,
  );

  /// Text theme built entirely from [AppTypography] tokens.
  final TextTheme textTheme = TextTheme(
    displayLarge: AppTypography.displayLarge,
    displayMedium: AppTypography.headlineLarge,
    displaySmall: AppTypography.headlineMedium,
    headlineLarge: AppTypography.headlineLarge,
    headlineMedium: AppTypography.headlineMedium,
    headlineSmall: AppTypography.titleLarge,
    titleLarge: AppTypography.titleLarge,
    titleMedium: AppTypography.titleMedium,
    titleSmall: AppTypography.labelLarge,
    bodyLarge: AppTypography.bodyLarge,
    bodyMedium: AppTypography.bodyMedium,
    bodySmall: AppTypography.labelMedium,
    labelLarge: AppTypography.labelLarge,
    labelMedium: AppTypography.labelMedium,
    labelSmall: AppTypography.labelSmall,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: textTheme,

    // -------------------------------------------------------------------------
    // App Bar
    // -------------------------------------------------------------------------
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTypography.headlineMedium,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),
    ),

    // -------------------------------------------------------------------------
    // Input Decoration
    // -------------------------------------------------------------------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceMuted,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space12,
      ),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMedium,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMedium,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMedium,
        borderSide: const BorderSide(color: AppColors.accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMedium,
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMedium,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textPlaceholder,
      ),
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      floatingLabelStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.accent,
      ),
      errorStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.error,
      ),
    ),

    // -------------------------------------------------------------------------
    // Elevated Button — primary CTA
    // -------------------------------------------------------------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.surface,
        disabledBackgroundColor: AppColors.disabled,
        disabledForegroundColor: AppColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        iconSize: 16,
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space24,
          vertical: AppSpacing.space12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMedium,
        ),
        textStyle: AppTypography.labelLarge.copyWith(
          color: AppColors.surface,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // -------------------------------------------------------------------------
    // Outlined Button — secondary CTA
    // -------------------------------------------------------------------------
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        disabledForegroundColor: AppColors.disabled,
        elevation: 0,
        iconSize: 16,
        minimumSize: const Size(double.infinity, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space24,
          vertical: AppSpacing.space12,
        ),
        side: const BorderSide(color: AppColors.border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMedium,
        ),
        textStyle: AppTypography.labelLarge,
      ),
    ),

    // -------------------------------------------------------------------------
    // Text Button — tertiary / inline actions
    // -------------------------------------------------------------------------
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        iconSize: 16,
        textStyle: AppTypography.labelLarge.copyWith(color: AppColors.accent),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.space8,
        ),
      ),
    ),

    // -------------------------------------------------------------------------
    // Divider
    // -------------------------------------------------------------------------
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 0,
      indent: 0,
      endIndent: 0,
    ),

    // -------------------------------------------------------------------------
    // Bottom Sheet
    // -------------------------------------------------------------------------
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusTopXLarge,
      ),
      showDragHandle: false,
      dragHandleColor: AppColors.border,
    ),

    // -------------------------------------------------------------------------
    // Bottom Navigation Bar
    // -------------------------------------------------------------------------
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textPlaceholder,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTypography.labelSmall.copyWith(
        color: AppColors.accent,
      ),
      unselectedLabelStyle: AppTypography.labelSmall.copyWith(
        color: AppColors.textPlaceholder,
      ),
    ),

    // -------------------------------------------------------------------------
    // Snack Bar
    // -------------------------------------------------------------------------
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.surface,
      ),
      actionTextColor: AppColors.accent,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMedium,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),

    // -------------------------------------------------------------------------
    // Tooltip
    // -------------------------------------------------------------------------
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: AppSpacing.borderRadiusSmall,
      ),
      textStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.surface,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space8,
      ),
    ),

    // -------------------------------------------------------------------------
    // Chip
    // -------------------------------------------------------------------------
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceMuted,
      selectedColor: AppColors.accentTint,
      disabledColor: AppColors.disabled,
      labelStyle: AppTypography.labelMedium,
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.accent,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusFull,
        side: BorderSide.none,
      ),
      elevation: 0,
      pressElevation: 0,
    ),

    // -------------------------------------------------------------------------
    // Card
    // -------------------------------------------------------------------------
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLarge,
        side: BorderSide(color: AppColors.border, width: 1),
      ),
    ),

    // -------------------------------------------------------------------------
    // Icon
    // -------------------------------------------------------------------------
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: 24,
    ),

    // -------------------------------------------------------------------------
    // Progress Indicator
    // -------------------------------------------------------------------------
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.accent,
    ),

    // -------------------------------------------------------------------------
    // Typography fallback (Google Fonts Inter as default font family)
    // -------------------------------------------------------------------------
    typography: Typography.material2021(),
  ).copyWith(
    // Apply Google Fonts Inter as the default font family via textTheme override.
    textTheme: GoogleFonts.interTextTheme(textTheme),
  );
}
