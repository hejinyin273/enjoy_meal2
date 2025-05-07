


// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class CustomPopupMenu extends StatelessWidget {
  CustomPopupMenu({
    super.key,
    required this.targetWidget,
    required this.menuWidget,
    this.margin,
    this.padding,
    this.color,
    this.width,
    this.height,
    this.decoration,
    this.offset = const Offset(0, 10),
    this.targetAnchor = Alignment.bottomCenter,
    this.followerAnchor = Alignment.topCenter,
  });

  final Widget targetWidget;
  final Widget menuWidget;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? width;
  final double? height;
  final Decoration? decoration;
  final Offset offset;
  final Alignment targetAnchor;
  final Alignment followerAnchor;

  /// 内部变量
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _showOverlay(context);
      },
      child: Container(
        margin: margin,
        padding: padding,
        color: color,
        width: width,
        height: height,
        decoration: decoration,
        child: CompositedTransformTarget(
          link: _layerLink,
          child: targetWidget,
        ),
      ),
    );
  }

  /// 显示浮层
  void _showOverlay(BuildContext context) {
    /// 防止重复创建，不然失去句柄的OverlayEntry将无法消除
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      if (_overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    }
  }

  /// 隐藏浮层
  void _hideOverlay() {
    /// 防止null调用异常
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  /// 创建浮层
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            _hideOverlay();
          },
          child: UnconstrainedBox(
            child: CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomCenter,
              followerAnchor: Alignment.topCenter,
              offset: const Offset(-100, -10),
              child: Material(
                child: menuWidget,
              ),
            ),
          ),
        );
      },
    );
  }
}