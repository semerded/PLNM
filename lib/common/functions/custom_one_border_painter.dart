import 'package:flutter/material.dart';

class OneSideProgressBorderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final borderSide side; // Added to determine which side to paint

  OneSideProgressBorderPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.side,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    // Draw progress on the specified border side
    if (side == borderSide.top) {
      final double progressWidth = progress * size.width;
      path.moveTo(0, 0);
      path.lineTo(progressWidth, 0);
    } else if (side == borderSide.bottom) {
      final double progressWidth = progress * size.width;
      path.moveTo(0, size.height);
      path.lineTo(progressWidth, size.height);
    } else if (side == borderSide.left) {
      final double progressHeight = progress * size.height;
      path.moveTo(0, 0);
      path.lineTo(0, progressHeight);
    } else if (side == borderSide.right) {
      final double progressHeight = progress * size.height;
      path.moveTo(size.width, 0);
      path.lineTo(size.width, progressHeight);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

enum borderSide { top, bottom, left, right }
