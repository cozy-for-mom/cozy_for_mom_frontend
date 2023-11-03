import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final BoxPainter _painter;

  CustomTabIndicator({required Color color}) : _painter = _CustomPainter(color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _painter;
  }
}

class _CustomPainter extends BoxPainter {
  final Paint _paint;

  _CustomPainter(Color color)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    Paint paint = Paint()
      ..color = _paint.color
      ..style = PaintingStyle.fill;

    const double indicatorHeight = 7.0; // 역삼각형 높이
    final double indicatorWidth = cfg.size!.width / 3.5; // 역삼각형 너비
    final double x = offset.dx + (cfg.size!.width - indicatorWidth) / 2;
    final double y = offset.dy + cfg.size!.height - indicatorHeight;

    final Path path = Path()
      ..moveTo(x, y)
      ..lineTo(x + indicatorWidth, y)
      ..lineTo(x + indicatorWidth / 2, y + indicatorHeight)
      ..close();

    canvas.drawPath(path, paint);
  }
}
