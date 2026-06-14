import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:gpa_cal/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:gpa_cal/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';
import 'package:gpa_cal/shared/widgets.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The analytics tab screen showing GPA trends and semester statistics.
///
/// Provides a [BlocProvider] scoped to this route, so the [AnalyticsBloc]
/// is created and disposed with this page. Dispatches [AnalyticsDataRequested]
/// on mount to always show fresh data.
///
/// Route path: `/analytics`
class AnalyticsPage extends StatelessWidget {
  /// Creates an [AnalyticsPage].
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnalyticsBloc>(
      create: (BuildContext ctx) => AnalyticsBloc(
        semesterRepository: ctx.read<SemesterRepository>(),
        userDetailsRepository: ctx.read<UserDetailsRepository>(),
      )..add(const AnalyticsDataRequested()),
      child: const _AnalyticsView(),
    );
  }
}

/// The inner view that observes [AnalyticsBloc] and renders the analytics content.
class _AnalyticsView extends StatelessWidget {
  /// Creates an [_AnalyticsView].
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (BuildContext context, AnalyticsState state) {
            return switch (state.status) {
              AnalyticsStatus.initial ||
              AnalyticsStatus.loading =>
                const _AnalyticsLoadingView(),
              AnalyticsStatus.error =>
                _AnalyticsErrorView(message: state.errorMessage),
              AnalyticsStatus.insufficientData => _AnalyticsInsufficientView(
                  userResult: state.userResult,
                ),
              AnalyticsStatus.success => _AnalyticsSuccessView(
                  state: state,
                ),
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

/// Shown while [AnalyticsStatus.loading] or [AnalyticsStatus.initial].
class _AnalyticsLoadingView extends StatelessWidget {
  /// Creates an [_AnalyticsLoadingView].
  const _AnalyticsLoadingView();

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
// Error
// ---------------------------------------------------------------------------

/// Shown when [AnalyticsStatus.error] occurs.
class _AnalyticsErrorView extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Creates an [_AnalyticsErrorView].
  const _AnalyticsErrorView({required this.message});

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
                  .read<AnalyticsBloc>()
                  .add(const AnalyticsDataRequested()),
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
// Insufficient data
// ---------------------------------------------------------------------------

/// Shown when fewer than 2 semesters exist and analytics cannot be computed.
class _AnalyticsInsufficientView extends StatelessWidget {
  /// The partial user result — may contain 0 or 1 semester.
  final UserResult? userResult;

  /// Creates an [_AnalyticsInsufficientView].
  const _AnalyticsInsufficientView({required this.userResult});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _AnalyticsHeader(),
        const Divider(height: 1, indent: 0, endIndent: 0),
        Expanded(
          child: EmptyStateView(
            icon: LucideIcons.barChart3,
            headline: 'Need more data',
            body:
                'Add at least 2 semesters to see your GPA trends and analytics.',
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Success
// ---------------------------------------------------------------------------

/// Shown when [AnalyticsStatus.success] — full analytics can be displayed.
class _AnalyticsSuccessView extends StatelessWidget {
  /// The current analytics state containing all metrics.
  final AnalyticsState state;

  /// Creates an [_AnalyticsSuccessView].
  const _AnalyticsSuccessView({required this.state});

  @override
  Widget build(BuildContext context) {
    final UserResult userResult = state.userResult!;
    final List<Semester> semesters = userResult.semesters;

    return CustomScrollView(
      slivers: [
        // Header
        const SliverToBoxAdapter(child: _AnalyticsHeader()),
        const SliverToBoxAdapter(
          child: Divider(height: 1, indent: 0, endIndent: 0),
        ),

        // GPA Trend chart
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.space24,
              AppSpacing.screenPadding,
              0,
            ),
            child: _GpaTrendCard(
              semesters: semesters,
              gpaType: state.gpaType,
            ),
          ),
        ),

        // Summary cards row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              AppSpacing.space16,
              0,
              0,
            ),
            child: _SummaryCardsRow(state: state),
          ),
        ),

        // What-If CTA card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.space16,
              AppSpacing.screenPadding,
              0,
            ),
            child: _WhatIfCtaCard(
              onTap: () => context.pushNamed(AppRoutes.whatIf),
            ),
          ),
        ),

        // All semesters section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.space32,
              AppSpacing.screenPadding,
              AppSpacing.space12,
            ),
            child: Text('All Semesters', style: AppTypography.headlineMedium),
          ),
        ),

        // Semester breakdown rows
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext _, int index) {
              final Semester semester = semesters[index];
              final bool isLast = index == semesters.length - 1;
              return _SemesterBreakdownRow(
                semester: semester,
                showDivider: !isLast,
              );
            },
            childCount: semesters.length,
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.space48),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

/// The page header showing the "Analytics" title.
class _AnalyticsHeader extends StatelessWidget {
  /// Creates an [_AnalyticsHeader].
  const _AnalyticsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.space20,
      ),
      child: Text('Analytics', style: AppTypography.headlineLarge),
    );
  }
}

// ---------------------------------------------------------------------------
// GPA Trend Chart
// ---------------------------------------------------------------------------

/// A card containing a custom-painted line chart of semester SGPA values.
///
/// Renders a polyline connecting each semester's SGPA value with data point
/// circles. Semester names appear along the x-axis. The y-axis range is
/// 0 to the GPA scale maximum (4.0 or 4.2).
class _GpaTrendCard extends StatelessWidget {
  /// The list of semesters to chart, ordered oldest to newest.
  final List<Semester> semesters;

  /// The GPA scale type: `0` for 4.0, `1` for 4.2.
  final int gpaType;

  /// Creates a [_GpaTrendCard].
  const _GpaTrendCard({
    required this.semesters,
    required this.gpaType,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.cardFlat,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GPA TREND',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.08 * 12,
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            SizedBox(
              height: 160,
              child: _GpaTrendPainter(
                semesters: semesters,
                gpaType: gpaType,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom-painted line chart for semester SGPA values.
class _GpaTrendPainter extends StatelessWidget {
  /// The list of semesters to chart.
  final List<Semester> semesters;

  /// The GPA scale type for determining the y-axis maximum.
  final int gpaType;

  /// Creates a [_GpaTrendPainter].
  const _GpaTrendPainter({
    required this.semesters,
    required this.gpaType,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(
        semesters: semesters,
        gpaType: gpaType,
      ),
      child: Container(),
    );
  }
}

/// The [CustomPainter] that draws the SGPA line chart.
class _LineChartPainter extends CustomPainter {
  /// The semesters providing data points.
  final List<Semester> semesters;

  /// The GPA scale type for the y-axis maximum.
  final int gpaType;

  /// Creates a [_LineChartPainter].
  const _LineChartPainter({
    required this.semesters,
    required this.gpaType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (semesters.isEmpty) return;

    final double maxGpa = gpaType == 1 ? 4.2 : 4.0;
    // Reserve bottom for labels.
    const double labelHeight = 24.0;
    const double topPad = 8.0;
    final double chartHeight = size.height - labelHeight - topPad;
    final double chartWidth = size.width;

    final Paint linePaint = Paint()
      ..color = AppColors.gpa
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint pointFillPaint = Paint()
      ..color = AppColors.gpa
      ..style = PaintingStyle.fill;

    final Paint pointBorderPaint = Paint()
      ..color = AppColors.surface
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines at 25% intervals.
    for (int i = 1; i <= 4; i++) {
      final double y = topPad + chartHeight * (1.0 - (i * 0.25));
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    // Compute data point positions.
    final int count = semesters.length;
    final List<Offset> points = [];

    for (int i = 0; i < count; i++) {
      final double x =
          count == 1 ? chartWidth / 2 : chartWidth * i / (count - 1);
      final double normalized = (semesters[i].sgpa / maxGpa).clamp(0.0, 1.0);
      final double y = topPad + chartHeight * (1.0 - normalized);
      points.add(Offset(x, y));
    }

    // Draw the polyline.
    if (points.length > 1) {
      final Path path = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw data point circles.
    for (final Offset point in points) {
      canvas.drawCircle(point, 5.0, pointFillPaint);
      canvas.drawCircle(point, 5.0, pointBorderPaint);
    }

    // Draw x-axis semester labels.
    final TextStyle labelStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 10,
      color: AppColors.textPlaceholder,
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i < count; i++) {
      final double x =
          count == 1 ? chartWidth / 2 : chartWidth * i / (count - 1);
      final double labelY = topPad + chartHeight + 6;

      // Abbreviate long names to keep them from overlapping.
      final String rawName = semesters[i].name;
      final String label =
          rawName.length > 8 ? '${rawName.substring(0, 6)}…' : rawName;

      final TextSpan span = TextSpan(text: label, style: labelStyle);
      final TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(
          (x - tp.width / 2).clamp(0, chartWidth - tp.width),
          labelY,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.semesters != semesters || oldDelegate.gpaType != gpaType;
  }
}

// ---------------------------------------------------------------------------
// Summary Cards Row
// ---------------------------------------------------------------------------

/// A horizontally scrollable row of summary metric cards.
class _SummaryCardsRow extends StatelessWidget {
  /// The analytics state containing all computed metrics.
  final AnalyticsState state;

  /// Creates a [_SummaryCardsRow].
  const _SummaryCardsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final Semester? best = state.bestSemester;
    final Semester? worst = state.worstSemester;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        children: [
          if (best != null)
            _SummaryCard(
              label: 'Best Semester',
              title: best.name,
              value: best.sgpa.toStringAsFixed(2),
              valueColor: AppColors.success,
            ),
          if (best != null) const SizedBox(width: AppSpacing.space12),
          if (worst != null && worst.hash != best?.hash)
            _SummaryCard(
              label: 'Lowest Semester',
              title: worst.name,
              value: worst.sgpa.toStringAsFixed(2),
              valueColor: AppColors.gpa,
            ),
          if (worst != null && worst.hash != best?.hash)
            const SizedBox(width: AppSpacing.space12),
          _SummaryCard(
            label: 'Total Credits',
            title: 'Accumulated',
            value: '${state.totalCredits}',
            valueColor: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.space12),
          _SummaryCard(
            label: 'Avg Credits/Sem',
            title: 'Per Semester',
            value: state.averageCreditsPerSemester.toStringAsFixed(1),
            valueColor: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

/// A single summary metric card in the horizontal scroll row.
class _SummaryCard extends StatelessWidget {
  /// The uppercase section label.
  final String label;

  /// The subtitle line shown below the label.
  final String title;

  /// The large numeric or text value to highlight.
  final String value;

  /// The color applied to [value].
  final Color valueColor;

  /// Creates a [_SummaryCard].
  const _SummaryCard({
    required this.label,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: DecoratedBox(
        decoration: AppDecorations.cardFlat,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textPlaceholder,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                title,
                style: AppTypography.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: AppTypography.headlineSmall.copyWith(
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// What-If CTA Card
// ---------------------------------------------------------------------------

/// A card prompting the user to try the What-If Calculator.
class _WhatIfCtaCard extends StatelessWidget {
  /// Called when the user taps the CTA button.
  final VoidCallback onTap;

  /// Creates a [_WhatIfCtaCard].
  const _WhatIfCtaCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.cardFlat,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What grades do I need?',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    'Calculate what you need to reach your target GPA.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Try What-If',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space4),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: AppColors.accent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Semester breakdown row
// ---------------------------------------------------------------------------

/// A single row in the per-semester breakdown list.
///
/// Shows the semester name on the left, credit count in the centre,
/// and the SGPA highlighted in [AppColors.gpa] on the right.
/// Optionally renders a full-width divider below the row.
class _SemesterBreakdownRow extends StatelessWidget {
  /// The semester to display.
  final Semester semester;

  /// Whether to show a divider below this row.
  final bool showDivider;

  /// Creates a [_SemesterBreakdownRow].
  const _SemesterBreakdownRow({
    required this.semester,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.space8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              semester.name,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Text(
            '${semester.totalCredit.toInt()} cr',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPlaceholder,
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Text(
            semester.sgpa.toStringAsFixed(2),
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
