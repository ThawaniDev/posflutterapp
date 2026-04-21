import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';

class RiskScoreGauge extends StatelessWidget {

  const RiskScoreGauge({super.key, required this.score, this.size = 80});
  final double score;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = score >= 70
        ? AppColors.error
        : score >= 40
        ? AppColors.warning
        : AppColors.success;
    final label = score >= 70
        ? 'High'
        : score >= 40
        ? 'Medium'
        : 'Low';

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GaugePainter(value: score / 100, color: color),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toStringAsFixed(0),
                style: TextStyle(fontSize: size * 0.25, fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                label,
                style: TextStyle(fontSize: size * 0.12, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {

  _GaugePainter({required this.value, required this.color});
  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;
    const startAngle = -math.pi * 0.75;
    const totalAngle = math.pi * 1.5;

    // Background arc
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, totalAngle, false, bgPaint);

    // Value arc
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalAngle * value.clamp(0, 1),
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value || old.color != color;
}
