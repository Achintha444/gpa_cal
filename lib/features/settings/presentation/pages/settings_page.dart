import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/extensions/string_extensions.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:gpa_cal/features/settings/presentation/bloc/settings_event.dart';
import 'package:gpa_cal/features/settings/presentation/bloc/settings_state.dart';
import 'package:gpa_cal/features/settings/presentation/widgets/clear_data_sheet.dart';
import 'package:gpa_cal/features/settings/presentation/widgets/profile_edit_sheet.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The settings tab screen for profile, preferences, and data management.
///
/// Provides a [BlocProvider] scoped to this route. Dispatches
/// [SettingsDataRequested] on mount and listens for [SettingsStatus.cleared]
/// to navigate to `/welcome`.
///
/// Route path: `/settings`
class SettingsPage extends StatelessWidget {
  /// Creates a [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (BuildContext ctx) => SettingsBloc(
        userDetailsRepository: ctx.read<UserDetailsRepository>(),
      )..add(const SettingsDataRequested()),
      child: const _SettingsView(),
    );
  }
}

/// The inner view that observes [SettingsBloc] and renders the settings UI.
class _SettingsView extends StatelessWidget {
  /// Creates a [_SettingsView].
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listenWhen: (SettingsState prev, SettingsState curr) =>
              prev.status != curr.status,
          listener: (BuildContext context, SettingsState state) {
            if (state.status == SettingsStatus.cleared) {
              // All data deleted — go to welcome and clear the navigation stack.
              context.goNamed(AppRoutes.welcome);
            }
            if (state.status == SettingsStatus.error &&
                state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (BuildContext context, SettingsState state) {
            return switch (state.status) {
              SettingsStatus.initial ||
              SettingsStatus.loading =>
                const _SettingsLoadingView(),
              SettingsStatus.error when state.userDetails == null =>
                _SettingsErrorView(message: state.errorMessage),
              _ => _SettingsSuccessView(state: state),
            };
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading
// ---------------------------------------------------------------------------

/// Shown while settings data is being loaded.
class _SettingsLoadingView extends StatelessWidget {
  /// Creates a [_SettingsLoadingView].
  const _SettingsLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.accent,
        strokeWidth: 2,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error (no data available at all)
// ---------------------------------------------------------------------------

/// Shown when loading fails and no cached data is available.
class _SettingsErrorView extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Creates a [_SettingsErrorView].
  const _SettingsErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.alertCircle,
              size: 40,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.space16),
            Text(
              message.isNotEmpty ? message : 'Something went wrong.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space24),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<SettingsBloc>()
                  .add(const SettingsDataRequested()),
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(elevation: 0),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Success
// ---------------------------------------------------------------------------

/// The main settings screen content — shown when user data is loaded.
class _SettingsSuccessView extends StatelessWidget {
  /// The current settings state.
  final SettingsState state;

  /// Creates a [_SettingsSuccessView].
  const _SettingsSuccessView({required this.state});

  @override
  Widget build(BuildContext context) {
    final UserDetails details = state.userDetails!;
    final bool isUpdating = state.status == SettingsStatus.updating ||
        state.status == SettingsStatus.clearing;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.space20,
                ),
                child: Text('Settings', style: AppTypography.headlineLarge),
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(height: 1, indent: 0, endIndent: 0),
            ),

            // Profile section
            SliverToBoxAdapter(
              child: _ProfileSection(
                userDetails: details,
                onEditTap: () => _showProfileEditSheet(context, details),
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(
                height: 1,
                indent: 0,
                endIndent: 0,
                color: Color(0x80E2E8F0),
              ),
            ),

            // Preferences section
            SliverToBoxAdapter(
              child: _PreferencesSection(gpaType: details.gpaType),
            ),
            const SliverToBoxAdapter(
              child: Divider(
                height: 1,
                indent: 0,
                endIndent: 0,
                color: Color(0x80E2E8F0),
              ),
            ),

            // Data section
            SliverToBoxAdapter(
              child: _DataSection(
                onClearTap: () => _showClearDataSheet(context),
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(
                height: 1,
                indent: 0,
                endIndent: 0,
                color: Color(0x80E2E8F0),
              ),
            ),

            // About section
            const SliverToBoxAdapter(child: _AboutSection()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.space48),
            ),
          ],
        ),

        // Overlay while updating or clearing.
        if (isUpdating)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33FFFFFF),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Shows the [ProfileEditSheet] and dispatches [ProfileUpdated] on save.
  Future<void> _showProfileEditSheet(
    BuildContext context,
    UserDetails userDetails,
  ) async {
    final UserDetails? updated = await showModalBottomSheet<UserDetails>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileEditSheet(userDetails: userDetails),
    );

    if (updated != null && context.mounted) {
      context.read<SettingsBloc>().add(
            ProfileUpdated(
              name: updated.name,
              university: updated.university,
            ),
          );
    }
  }

  /// Shows the [ClearDataSheet] and dispatches [ClearAllDataRequested] on confirm.
  Future<void> _showClearDataSheet(BuildContext context) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ClearDataSheet(),
    );

    if (confirmed == true && context.mounted) {
      context.read<SettingsBloc>().add(const ClearAllDataRequested());
    }
  }
}

// ---------------------------------------------------------------------------
// Profile section
// ---------------------------------------------------------------------------

/// Displays the user's avatar, name, university, and an "Edit Profile" button.
class _ProfileSection extends StatelessWidget {
  /// The user's current profile details.
  final UserDetails userDetails;

  /// Called when the user taps "Edit Profile".
  final VoidCallback onEditTap;

  /// Creates a [_ProfileSection].
  const _ProfileSection({
    required this.userDetails,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final String initials = userDetails.name.initials;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.space24,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials.isEmpty ? '?' : initials,
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space16),

          // Name and university
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userDetails.name,
                  style: AppTypography.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  userDetails.university,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space12),

          // Edit button
          TextButton(
            onPressed: onEditTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Edit',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Preferences section
// ---------------------------------------------------------------------------

/// The "PREFERENCES" section with the GPA scale segmented control.
class _PreferencesSection extends StatelessWidget {
  /// The current GPA type: `0` for 4.0, `1` for 4.2.
  final int gpaType;

  /// Creates a [_PreferencesSection].
  const _PreferencesSection({required this.gpaType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.space20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREFERENCES',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.08 * 12,
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          _GpaScaleRow(gpaType: gpaType),
        ],
      ),
    );
  }
}

/// A row showing the "GPA Scale" label and a segmented toggle control.
class _GpaScaleRow extends StatelessWidget {
  /// The current GPA type.
  final int gpaType;

  /// Creates a [_GpaScaleRow].
  const _GpaScaleRow({required this.gpaType});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('GPA Scale', style: AppTypography.bodyLarge),
        ),
        _GpaSegmentedControl(
          gpaType: gpaType,
          onChanged: (int type) =>
              context.read<SettingsBloc>().add(GpaTypeChanged(type)),
        ),
      ],
    );
  }
}

/// A two-option segmented control for selecting between 4.0 and 4.2 GPA scales.
///
/// Uses [AppColors.surfaceMuted] as the background and [AppColors.accent] for
/// the active segment — matching the onboarding GPA-type selector design.
class _GpaSegmentedControl extends StatelessWidget {
  /// The currently active GPA type.
  final int gpaType;

  /// Called when the user selects a different scale.
  final ValueChanged<int> onChanged;

  /// Creates a [_GpaSegmentedControl].
  const _GpaSegmentedControl({
    required this.gpaType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall + 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentButton(
            label: '4.0',
            isActive: gpaType == 0,
            onTap: () => onChanged(0),
          ),
          const SizedBox(width: 2),
          _SegmentButton(
            label: '4.2',
            isActive: gpaType == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

/// A single segment option within [_GpaSegmentedControl].
class _SegmentButton extends StatelessWidget {
  /// The label text for this segment.
  final String label;

  /// Whether this segment is currently active.
  final bool isActive;

  /// Called when this segment is tapped.
  final VoidCallback onTap;

  /// Creates a [_SegmentButton].
  const _SegmentButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space16,
          vertical: AppSpacing.space8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: isActive ? AppColors.surface : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data section
// ---------------------------------------------------------------------------

/// The "DATA" section with Export PDF (coming soon) and Clear All Data rows.
class _DataSection extends StatelessWidget {
  /// Called when the user taps "Clear All Data".
  final VoidCallback onClearTap;

  /// Creates a [_DataSection].
  const _DataSection({required this.onClearTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.space20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DATA',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.08 * 12,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),

          // Export PDF row (non-functional V1)
          _SettingsRow(
            icon: LucideIcons.upload,
            iconColor: AppColors.textSecondary,
            label: 'Export as PDF',
            labelColor: AppColors.textPrimary,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const Divider(
            height: 1,
            indent: 0,
            endIndent: 0,
            color: Color(0x80E2E8F0),
          ),

          // Clear All Data row
          _SettingsRow(
            icon: LucideIcons.trash2,
            iconColor: AppColors.error,
            label: 'Clear All Data',
            labelColor: AppColors.error,
            onTap: onClearTap,
          ),
        ],
      ),
    );
  }
}

/// A single settings list row with an icon, label, and chevron.
class _SettingsRow extends StatelessWidget {
  /// The leading icon.
  final IconData icon;

  /// The color applied to [icon].
  final Color iconColor;

  /// The row label text.
  final String label;

  /// The color applied to [label].
  final Color labelColor;

  /// Called when the row is tapped.
  final VoidCallback onTap;

  /// Creates a [_SettingsRow].
  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(color: labelColor),
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: AppColors.textPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// About section
// ---------------------------------------------------------------------------

/// The "ABOUT" section showing the app version.
class _AboutSection extends StatelessWidget {
  /// Creates an [_AboutSection].
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.space20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.08 * 12,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          SizedBox(
            height: 56,
            child: Row(
              children: [
                Expanded(
                  child: Text('Version', style: AppTypography.bodyLarge),
                ),
                Text(
                  '2.0.0',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
