import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  final Color bgColor;
  final Color borderColor;

  ScannerOverlayPainter({required this.bgColor, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Hole Dimensions
    final double scanAreaWidth = size.width * 0.63;
    final double scanAreaHeight = size.width * 0.63;
    final double holeRadius = 16.0;
    const double cornerRadius = 24.0;
    const double cornerLength = 40.0;
    const double padding = 20.0;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect cutoutRect = Rect.fromCenter(
      center: center,
      width: scanAreaWidth,
      height: scanAreaHeight,
    );

    // 2. Draw Semi-Transparent Background with Hole
    final backgroundPaint = Paint()..color = bgColor;

    // Inflation fix: draw 5 pixels beyond the size to kill top/bottom lines
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height).inflate(5));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutoutRect, Radius.circular(holeRadius)),
      );

    canvas.drawPath(
      Path.combine(PathOperation.difference, backgroundPath, cutoutPath),
      backgroundPaint,
    );

    // 3. Draw Rounded "Focus" Corners
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final double left = cutoutRect.left - padding;
    final double right = cutoutRect.right + padding;
    final double top = cutoutRect.top - padding;
    final double bottom = cutoutRect.bottom + padding;

    // --- TOP LEFT ---
    canvas.drawPath(
      Path()
        ..moveTo(left, top + cornerLength)
        ..lineTo(left, top + cornerRadius)
        ..arcToPoint(
          Offset(left + cornerRadius, top),
          radius: const Radius.circular(cornerRadius),
        )
        ..lineTo(left + cornerLength, top),
      borderPaint,
    );

    // --- TOP RIGHT ---
    canvas.drawPath(
      Path()
        ..moveTo(right - cornerLength, top)
        ..lineTo(right - cornerRadius, top)
        ..arcToPoint(
          Offset(right, top + cornerRadius),
          radius: const Radius.circular(cornerRadius),
        )
        ..lineTo(right, top + cornerLength),
      borderPaint,
    );

    // --- BOTTOM LEFT ---
    canvas.drawPath(
      Path()
        ..moveTo(left, bottom - cornerLength)
        ..lineTo(left, bottom - cornerRadius)
        ..arcToPoint(
          Offset(left + cornerRadius, bottom),
          radius: const Radius.circular(cornerRadius),
          clockwise: false,
        )
        ..lineTo(left + cornerLength, bottom),
      borderPaint,
    );

    // --- BOTTOM RIGHT ---
    canvas.drawPath(
      Path()
        ..moveTo(right, bottom - cornerLength)
        ..lineTo(right, bottom - cornerRadius)
        ..arcToPoint(
          Offset(right - cornerRadius, bottom),
          radius: const Radius.circular(cornerRadius),
          clockwise: true,
        )
        ..lineTo(right - cornerLength, bottom),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
