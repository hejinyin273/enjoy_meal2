import 'package:flutter/material.dart';


class CustomTabIndicator extends Decoration{
  final double indWidth;
  final double indHeight;
  final double radius;

  const CustomTabIndicator({this.indWidth = 70.0, this.indHeight = 12.0, this.radius = 5});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomBoxPainter(this, onChanged, indWidth, indHeight, radius);
  }
}

class _CustomBoxPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double indWidth;
  final double indHeight;
  final double radius;

  _CustomBoxPainter(this.decoration, VoidCallback? onChanged, this.indWidth, this.indHeight, this.radius)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    final newOffset = Offset(offset.dx + (size.width - indWidth) / 2, size.height - indHeight);
    final Rect rect = newOffset & Size(indWidth, indHeight);
    final Paint paint = Paint();
    paint.color = Colors.yellow;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }
}
