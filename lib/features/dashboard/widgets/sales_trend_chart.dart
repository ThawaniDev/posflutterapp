import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';

class SalesTrendChart extends StatelessWidget {
  final Map<String, dynamic> salesTrend;

  const SalesTrendChart({super.key, required this.salesTrend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = (salesTrend['current'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final previous = (salesTrend['previous'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (current.isEmpty) {
      return PosCard(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No sales data available',
              style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ),
        ),
      );
    }

    final maxValue = _maxRevenue(current, previous);

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Sales Trend', style: AppTypography.headlineSmall),
              const Spacer(),
              _LegendDot(color: AppColors.primary, label: 'This Period'),
              AppSpacing.gapW12,
              _LegendDot(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight, label: 'Previous'),
            ],
          ),
          AppSpacing.gapH16,
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: Size.infinite,
              painter: _SalesChartPainter(
                current: current,
                previous: previous,
                maxValue: maxValue,
                primaryColor: AppColors.primary,
                secondaryColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                gridColor: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
              ),
            ),
          ),
          AppSpacing.gapH8,
          // Date labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (current.isNotEmpty)
                Text(
                  _shortDate(current.first['date'] as String? ?? ''),
                  style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              if (current.length > 1)
                Text(
                  _shortDate(current.last['date'] as String? ?? ''),
                  style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
            ],
          ),
        ],
      ),
    );
  }

  double _maxRevenue(List<Map<String, dynamic>> a, List<Map<String, dynamic>> b) {
    double max = 0;
    for (final item in [...a, ...b]) {
      final val = (item['revenue'] as num?)?.toDouble() ?? 0;
      if (val > max) max = val;
    }
    return max == 0 ? 1 : max;
  }

  String _shortDate(String dateStr) {
    if (dateStr.length < 10) return dateStr;
    final parts = dateStr.split('-');
    if (parts.length >= 3) return '${parts[1]}/${parts[2]}';
    return dateStr;
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.micro),
      ],
    );
  }
}

class _SalesChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> current;
  final List<Map<String, dynamic>> previous;
  final double maxValue;
  final Color primaryColor;
  final Color secondaryColor;
  final Color gridColor;

  _SalesChartPainter({
    required this.current,
    required this.previous,
    required this.maxValue,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Draw 4 horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw previous period (dashed-like thinner line)
    if (previous.isNotEmpty) {
      _drawLine(canvas, size, previous, secondaryColor, 1.5);
    }

    // Draw current period
    if (current.isNotEmpty) {
      _drawLine(canvas, size, current, primaryColor, 2.5);
      _drawFill(canvas, size, current, primaryColor.withValues(alpha: 0.1));
    }
  }

  void _drawLine(Canvas canvas, Size size, List<Map<String, dynamic>> data, Color color, double width) {
    if (data.length < 2) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = size.width * i / (data.length - 1);
      final val = (data[i]['revenue'] as num?)?.toDouble() ?? 0;
      final y = size.height - (val / maxValue * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawFill(Canvas canvas, Size size, List<Map<String, dynamic>> data, Color color) {
    if (data.length < 2) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    for (int i = 0; i < data.length; i++) {
      final x = size.width * i / (data.length - 1);
      final val = (data[i]['revenue'] as num?)?.toDouble() ?? 0;
      final y = size.height - (val / maxValue * size.height);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SalesChartPainter oldDelegate) =>
      current != oldDelegate.current || previous != oldDelegate.previous;
}
