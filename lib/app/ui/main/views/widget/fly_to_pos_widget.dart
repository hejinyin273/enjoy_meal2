import 'dart:math';

import 'package:enjoy_meal/app/base/utils/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlyToPosWidget extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final String imgUrl;

  const FlyToPosWidget({super.key, required this.startPosition, required this.endPosition, required this.imgUrl});

  @override
  State<FlyToPosWidget> createState() => _FlyToPosState();
}

class _FlyToPosState extends State<FlyToPosWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double left; // 小圆点的left（动态计算）
  late double top; // 小远点的right（动态计算）

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // 二阶贝塞尔曲线用值
    var x0 = widget.startPosition.dx;
    var y0 = widget.startPosition.dy;

    var x1 = widget.startPosition.dx + 250;
    var y1 = widget.startPosition.dy - 100;

    var x2 = widget.endPosition.dx;
    var y2 = widget.endPosition.dy;

    _animation.addListener(() {
      // t 动态变化的值
      var t = _animation.value;
      if (mounted) {
        setState(() {
          left = pow(1 - t, 2) * x0 + 2 * t * (1 - t) * x1 + pow(t, 2) * x2;
          top = pow(1 - t, 2) * y0 + 2 * t * (1 - t) * y1 + pow(t, 2) * y2;
        });
      }
    });

    // 初始化小圆点的位置
    left = widget.startPosition.dx;
    top = widget.startPosition.dy;

    // 显示小圆点的时候动画就开始
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // 用 Stack -> Positioned 来控制小圆点的位置
    return Stack(
      children: <Widget>[
        Positioned(
          left: left,
          top: top,
          child: ClipOval(
            child: SizedBox(
              width: 64.w,
              height: 64.w,
              child: widget.imgUrl.isNotEmpty
                  ? ViewUtil.cachedImage(widget.imgUrl)
                  : Container(
                color: Colors.grey,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}