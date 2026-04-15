import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';

class AIScoreGauge extends StatelessWidget {
  final double score;
  final double maxScore;
  final String label;
  final double size;

  const AIScoreGauge({super.key, required this.score, this.maxScore = 100, this.label = '', this.size = 120});

  Color get _color {
    final pct = score / maxScore;
    if (pct >= 0.8) return AppColors.success;
    if (pct >= 0.6) return const Color(0xFF10B981);
    if (pct >= 0.4) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final pct = (score / maxScore).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: pct,
              strokeWidth: 8,
              backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(_color),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toStringAsFixed(0),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: _color),
              ),
              if (label.isNotEmpty)
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
