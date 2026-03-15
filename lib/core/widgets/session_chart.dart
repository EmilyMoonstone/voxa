import 'package:flutter/material.dart';

import '../../features/goal_setting/domain/voice_target.dart';
import '../../features/record/domain/practice_session.dart';
import '../theme/voxa_tokens.dart';

class SessionChart extends StatelessWidget {
  const SessionChart({
    required this.points,
    required this.target,
    required this.toleranceHz,
    super.key,
  });

  final List<ChartPoint> points;
  final VoiceTarget target;
  final int toleranceHz;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: CustomPaint(
        painter: _SessionChartPainter(
          points: points,
          target: target,
          toleranceHz: toleranceHz,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _SessionChartPainter extends CustomPainter {
  const _SessionChartPainter({
    required this.points,
    required this.target,
    required this.toleranceHz,
    required this.color,
  });

  final List<ChartPoint> points;
  final VoiceTarget target;
  final int toleranceHz;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.08), color.withValues(alpha: 0.03)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(VoxaRadius.lg),
      ),
      backgroundPaint,
    );

    for (var index = 1; index < 4; index++) {
      final dy = size.height * (index / 4);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    final voicedPoints = points
        .where((point) => point.frequencyHz != null)
        .toList(growable: false);
    if (voicedPoints.length < 2) {
      return;
    }

    final minY = voicedPoints
        .map((point) => point.frequencyHz!)
        .reduce((a, b) => a < b ? a : b);
    final maxY = voicedPoints
        .map((point) => point.frequencyHz!)
        .reduce((a, b) => a > b ? a : b);
    final range = (maxY - minY).abs() < 1 ? 1.0 : maxY - minY;
    final minX = points.first.timestampMs.toDouble();
    final maxX = points.last.timestampMs.toDouble();
    final xRange = (maxX - minX).abs() < 1 ? 1.0 : maxX - minX;

    Offset? previousPoint;
    Color? previousColor;
    for (final point in points) {
      if (point.frequencyHz == null) {
        previousPoint = null;
        previousColor = null;
        continue;
      }

      final dx = size.width * ((point.timestampMs - minX) / xRange);
      final dy =
          size.height - ((point.frequencyHz! - minY) / range) * size.height;
      final currentPoint = Offset(dx, dy);
      final color = _colorForFrequency(point.frequencyHz!);
      if (previousPoint != null && previousColor != null) {
        _paintSegment(
          canvas,
          previousPoint,
          currentPoint,
          previousColor,
          color,
        );
      }
      previousPoint = currentPoint;
      previousColor = color;
    }
  }

  void _paintSegment(
    Canvas canvas,
    Offset start,
    Offset end,
    Color startColor,
    Color endColor,
  ) {
    final shaderRect = Rect.fromPoints(start, end).inflate(12);
    final gradient = LinearGradient(
      colors: [startColor, endColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(shaderRect);
    final glowPaint = Paint()
      ..shader = gradient
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final linePaint = Paint()
      ..shader = gradient
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, glowPaint);
    canvas.drawLine(start, end, linePaint);
  }

  Color _colorForFrequency(double frequencyHz) {
    if ((frequencyHz - target.targetHz).abs() <= toleranceHz) {
      return VoxaColors.pitchInRange;
    }
    if (frequencyHz < target.targetHz) {
      return VoxaColors.coral;
    }
    return VoxaColors.pitchHigh;
  }

  @override
  bool shouldRepaint(_SessionChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.target != target ||
        oldDelegate.toleranceHz != toleranceHz ||
        oldDelegate.color != color;
  }
}
