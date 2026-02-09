import 'dart:math';
import 'package:flutter/material.dart';

/// CustomPainter that draws a moon phase circle.
/// [phase] is 0.0–1.0 (0=new moon, 0.5=full moon).
class MoonPainter extends CustomPainter {
  final double phase;
  final Color moonColor;
  final Color shadowColor;

  const MoonPainter({
    required this.phase,
    required this.moonColor,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Draw full moon base
    final moonPaint = Paint()..color = moonColor;
    canvas.drawCircle(center, radius, moonPaint);

    // Draw shadow to create phase effect
    final shadowPaint = Paint()..color = shadowColor;
    final path = Path();

    // The terminator (line between light and dark) is an ellipse
    // whose x-radius depends on the phase
    // phase 0.0 = fully shadowed (new moon)
    // phase 0.5 = fully lit (full moon)

    if ((phase - 0.5).abs() < 0.01) {
      // Full moon — no shadow
      return;
    }
    if (phase < 0.01 || phase > 0.99) {
      // New moon — fully shadowed
      canvas.drawCircle(center, radius, shadowPaint);
      return;
    }

    // Determine how much of the terminator ellipse to show
    // cosAngle maps phase to terminator x-scale (-1 to 1)
    final cosAngle = cos(phase * 2 * pi);

    if (phase < 0.5) {
      // Waxing: shadow on the left side shrinking
      // Shadow covers from left edge to terminator
      path.addArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2, // start at top
        pi, // left semicircle (pi radians)
      );
      // Close with elliptical terminator
      final terminatorRadiusX = radius * cosAngle.abs();
      if (cosAngle <= 0) {
        // Shadow is more than half — terminator curves left
        path.arcTo(
          Rect.fromCenter(
            center: center,
            width: terminatorRadiusX * 2,
            height: radius * 2,
          ),
          pi / 2,
          pi,
          false,
        );
      } else {
        // Shadow is less than half — terminator curves right
        path.arcTo(
          Rect.fromCenter(
            center: center,
            width: terminatorRadiusX * 2,
            height: radius * 2,
          ),
          pi / 2,
          -pi,
          false,
        );
      }
    } else {
      // Waning: shadow on the right side growing
      path.addArc(
        Rect.fromCircle(center: center, radius: radius),
        pi / 2, // start at bottom
        pi, // right semicircle
      );
      final terminatorRadiusX = radius * cosAngle.abs();
      if (cosAngle >= 0) {
        // Shadow is less than half
        path.arcTo(
          Rect.fromCenter(
            center: center,
            width: terminatorRadiusX * 2,
            height: radius * 2,
          ),
          -pi / 2,
          pi,
          false,
        );
      } else {
        path.arcTo(
          Rect.fromCenter(
            center: center,
            width: terminatorRadiusX * 2,
            height: radius * 2,
          ),
          -pi / 2,
          -pi,
          false,
        );
      }
    }

    path.close();
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(MoonPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.moonColor != moonColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}
