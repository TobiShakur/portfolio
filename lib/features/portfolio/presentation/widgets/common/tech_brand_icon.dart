import 'package:flutter/material.dart';
import 'package:portfolio/features/portfolio/domain/entities/tech_brand.dart';

/// Embedded crisp vector brand logos rendered via [CustomPaint] with zero
/// external network requests.
class TechBrandIcon extends StatelessWidget {
  const TechBrandIcon({
    required this.brand,
    super.key,
    this.size = 16.0,
    this.monochromeColor,
  });

  final TechBrand brand;
  final double size;
  final Color? monochromeColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _TechBrandPainter(
          brand: brand,
          monochromeColor: monochromeColor,
        ),
      ),
    );
  }
}

class _TechBrandPainter extends CustomPainter {
  const _TechBrandPainter({
    required this.brand,
    required this.monochromeColor,
  });

  final TechBrand brand;
  final Color? monochromeColor;

  Color _c(Color official) => monochromeColor ?? official;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 24.0;
    final sy = size.height / 24.0;
    canvas.save();
    canvas.scale(sx, sy);

    switch (brand) {
      case TechBrand.flutter:
        _paintFlutter(canvas);
      case TechBrand.dart:
        _paintDart(canvas);
      case TechBrand.firebase:
        _paintFirebase(canvas);
      case TechBrand.cloudflare:
        _paintCloudflare(canvas);
      case TechBrand.gemini:
        _paintGemini(canvas);
      case TechBrand.appleIos:
        _paintApple(canvas);
      case TechBrand.android:
        _paintAndroid(canvas);
      case TechBrand.figma:
        _paintFigma(canvas);
      case TechBrand.openStreetMap:
        _paintOpenStreetMap(canvas);
      case TechBrand.githubActions:
        _paintGitHubActions(canvas);
    }

    canvas.restore();
  }

  void _paintFlutter(Canvas canvas) {
    final top = Path()
      ..moveTo(14.3, 2.0)
      ..lineTo(4.0, 12.3)
      ..lineTo(7.2, 15.5)
      ..lineTo(20.7, 2.0)
      ..close();
    canvas.drawPath(top, Paint()..color = _c(const Color(0xFF54C5F8)));

    final mid = Path()
      ..moveTo(14.3, 11.2)
      ..lineTo(8.9, 16.6)
      ..lineTo(14.3, 22.0)
      ..lineTo(20.7, 22.0)
      ..lineTo(15.3, 16.6)
      ..lineTo(20.7, 11.2)
      ..close();
    canvas.drawPath(mid, Paint()..color = _c(const Color(0xFF29B6F6)));

    final fold = Path()
      ..moveTo(8.9, 16.6)
      ..lineTo(12.1, 13.4)
      ..lineTo(15.3, 16.6)
      ..lineTo(12.1, 19.8)
      ..close();
    canvas.drawPath(
      fold,
      Paint()..color = _c(const Color(0xFF0288D1)),
    );
  }

  void _paintDart(Canvas canvas) {
    final topWing = Path()
      ..moveTo(6.0, 6.0)
      ..lineTo(14.5, 2.5)
      ..lineTo(20.5, 8.5)
      ..lineTo(20.5, 16.5)
      ..lineTo(17.5, 16.5)
      ..lineTo(6.0, 6.0)
      ..close();
    canvas.drawPath(topWing, Paint()..color = _c(const Color(0xFF40C4FF)));

    final body = Path()
      ..moveTo(6.0, 6.0)
      ..lineTo(2.5, 14.5)
      ..lineTo(8.5, 20.5)
      ..lineTo(16.5, 20.5)
      ..lineTo(16.5, 17.5)
      ..lineTo(6.0, 6.0)
      ..close();
    canvas.drawPath(body, Paint()..color = _c(const Color(0xFF00B0FF)));

    final tip = Path()
      ..moveTo(8.5, 20.5)
      ..lineTo(16.5, 20.5)
      ..lineTo(20.5, 16.5)
      ..lineTo(15.5, 16.5)
      ..close();
    canvas.drawPath(tip, Paint()..color = _c(const Color(0xFF0081CB)));
  }

  void _paintFirebase(Canvas canvas) {
    final leftFlame = Path()
      ..moveTo(5.2, 17.8)
      ..lineTo(7.4, 3.6)
      ..quadraticBezierTo(7.7, 2.4, 8.7, 3.2)
      ..lineTo(12.0, 9.4)
      ..lineTo(5.2, 17.8)
      ..close();
    canvas.drawPath(leftFlame, Paint()..color = _c(const Color(0xFFFFA000)));

    final centerFlame = Path()
      ..moveTo(5.2, 17.8)
      ..lineTo(12.6, 8.8)
      ..quadraticBezierTo(13.2, 8.0, 13.8, 8.9)
      ..lineTo(15.6, 12.2)
      ..lineTo(5.2, 17.8)
      ..close();
    canvas.drawPath(centerFlame, Paint()..color = _c(const Color(0xFFF57C00)));

    final rightFlame = Path()
      ..moveTo(5.2, 17.8)
      ..lineTo(17.1, 6.6)
      ..quadraticBezierTo(18.0, 5.9, 18.2, 7.1)
      ..lineTo(19.2, 18.1)
      ..lineTo(12.4, 21.8)
      ..quadraticBezierTo(11.8, 22.1, 11.2, 21.8)
      ..close();
    canvas.drawPath(rightFlame, Paint()..color = _c(const Color(0xFFFFCA28)));
  }

  void _paintCloudflare(Canvas canvas) {
    final cloud = Path()
      ..moveTo(16.8, 17.2)
      ..lineTo(6.2, 17.2)
      ..cubicTo(3.8, 17.2, 2.0, 15.4, 2.0, 13.2)
      ..cubicTo(2.0, 11.2, 3.4, 9.5, 5.4, 9.2)
      ..cubicTo(6.1, 6.6, 8.5, 4.8, 11.4, 4.8)
      ..cubicTo(14.5, 4.8, 17.1, 7.0, 17.6, 10.0)
      ..cubicTo(19.9, 10.2, 21.8, 11.8, 21.8, 13.9)
      ..cubicTo(21.8, 15.8, 19.6, 17.2, 16.8, 17.2)
      ..close();
    canvas.drawPath(cloud, Paint()..color = _c(const Color(0xFFF6821F)));

    final rays = Paint()
      ..color = _c(const Color(0xFFFBAD41))
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(18.2, 18.8), const Offset(21.6, 18.8), rays);
    canvas.drawLine(const Offset(19.2, 16.5), const Offset(22.2, 16.5), rays);
  }

  void _paintGemini(Canvas canvas) {
    final star = Path()
      ..moveTo(12.0, 2.0)
      ..cubicTo(12.6, 8.0, 16.0, 11.4, 22.0, 12.0)
      ..cubicTo(16.0, 12.6, 12.6, 16.0, 12.0, 22.0)
      ..cubicTo(11.4, 16.0, 8.0, 12.6, 2.0, 12.0)
      ..cubicTo(8.0, 11.4, 11.4, 8.0, 12.0, 2.0)
      ..close();

    final paint = Paint();
    if (monochromeColor != null) {
      paint.color = monochromeColor!;
    } else {
      paint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF60A5FA), Color(0xFF34D399)],
      ).createShader(const Rect.fromLTWH(2, 2, 20, 20));
    }
    canvas.drawPath(star, paint);
  }

  void _paintApple(Canvas canvas) {
    final paint = Paint()..color = _c(const Color(0xFFF4F6F8));

    final leaf = Path()
      ..moveTo(12.4, 6.4)
      ..cubicTo(12.4, 4.2, 14.1, 2.5, 16.1, 2.3)
      ..cubicTo(16.2, 4.4, 14.5, 6.2, 12.4, 6.4)
      ..close();
    canvas.drawPath(leaf, paint);

    final body = Path()
      ..moveTo(18.4, 12.8)
      ..cubicTo(18.4, 10.6, 19.8, 9.4, 20.0, 9.2)
      ..cubicTo(18.8, 7.6, 17.0, 7.3, 16.2, 7.3)
      ..cubicTo(14.7, 7.2, 13.4, 8.2, 12.6, 8.2)
      ..cubicTo(11.8, 8.2, 10.6, 7.3, 9.4, 7.3)
      ..cubicTo(7.4, 7.3, 5.3, 8.7, 4.4, 11.0)
      ..cubicTo(3.1, 14.2, 4.3, 18.8, 6.4, 21.0)
      ..cubicTo(7.3, 22.0, 8.3, 22.2, 9.4, 21.8)
      ..cubicTo(10.3, 21.5, 11.2, 21.1, 12.5, 21.1)
      ..cubicTo(13.8, 21.1, 14.6, 21.5, 15.6, 21.8)
      ..cubicTo(16.7, 22.2, 17.6, 21.8, 18.5, 20.8)
      ..cubicTo(19.6, 19.6, 20.1, 18.4, 20.3, 18.0)
      ..cubicTo(18.7, 17.2, 18.4, 15.0, 18.4, 12.8)
      ..close();
    canvas.drawPath(body, paint);
  }

  void _paintAndroid(Canvas canvas) {
    final green = _c(const Color(0xFF3DDC84));
    final antenna = Paint()
      ..color = green
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(7.2, 6.4), const Offset(9.2, 9.4), antenna);
    canvas.drawLine(const Offset(16.8, 6.4), const Offset(14.8, 9.4), antenna);

    final head = Path()
      ..moveTo(4.0, 17.5)
      ..arcTo(
        const Rect.fromLTWH(4.0, 8.0, 16.0, 16.0),
        3.14159,
        3.14159,
        false,
      )
      ..close();
    canvas.drawPath(head, Paint()..color = green);

    final eyePaint = Paint()..color = const Color(0xFF080A0C);
    canvas.drawCircle(const Offset(9.0, 13.5), 1.15, eyePaint);
    canvas.drawCircle(const Offset(15.0, 13.5), 1.15, eyePaint);
  }

  void _paintFigma(Canvas canvas) {
    // Top-left pill
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        6.0,
        2.5,
        12.0,
        8.5,
        topLeft: const Radius.circular(3.0),
        bottomLeft: const Radius.circular(3.0),
      ),
      Paint()..color = _c(const Color(0xFFF24E1E)),
    );
    // Top-right pill
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        12.0,
        2.5,
        18.0,
        8.5,
        topRight: const Radius.circular(3.0),
        bottomRight: const Radius.circular(3.0),
      ),
      Paint()..color = _c(const Color(0xFFFF7262)),
    );
    // Mid-left pill
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        6.0,
        8.5,
        12.0,
        14.5,
        topLeft: const Radius.circular(3.0),
        bottomLeft: const Radius.circular(3.0),
      ),
      Paint()..color = _c(const Color(0xFFFBBF24)),
    );
    // Mid-right circle
    canvas.drawCircle(
      const Offset(15.0, 11.5),
      3.0,
      Paint()..color = _c(const Color(0xFF1ABCFE)),
    );
    // Bottom-left droplet
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        6.0,
        14.5,
        12.0,
        20.5,
        topLeft: const Radius.circular(3.0),
        bottomLeft: const Radius.circular(3.0),
        bottomRight: const Radius.circular(3.0),
      ),
      Paint()..color = _c(const Color(0xFF0ACF83)),
    );
  }

  void _paintOpenStreetMap(Canvas canvas) {
    final mapPin = Path()
      ..moveTo(12.0, 2.5)
      ..cubicTo(8.1, 2.5, 5.0, 5.6, 5.0, 9.5)
      ..cubicTo(5.0, 14.5, 12.0, 21.5, 12.0, 21.5)
      ..cubicTo(12.0, 21.5, 19.0, 14.5, 19.0, 9.5)
      ..cubicTo(19.0, 5.6, 15.9, 2.5, 12.0, 2.5)
      ..close();
    canvas.drawPath(mapPin, Paint()..color = _c(const Color(0xFF7EBC6F)));

    canvas.drawCircle(
      const Offset(12.0, 9.5),
      3.0,
      Paint()..color = const Color(0xFF080A0C),
    );
    canvas.drawCircle(
      const Offset(12.0, 9.5),
      1.3,
      Paint()..color = _c(const Color(0xFF34D399)),
    );
  }

  void _paintGitHubActions(Canvas canvas) {
    final blue = _c(const Color(0xFF79C0FF));
    final ringPaint = Paint()
      ..color = blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(const Offset(12.0, 12.0), 8.2, ringPaint);

    final play = Path()
      ..moveTo(10.0, 8.4)
      ..lineTo(16.4, 12.0)
      ..lineTo(10.0, 15.6)
      ..close();
    canvas.drawPath(play, Paint()..color = blue);
  }

  @override
  bool shouldRepaint(covariant _TechBrandPainter oldDelegate) {
    return oldDelegate.brand != brand ||
        oldDelegate.monochromeColor != monochromeColor;
  }
}
