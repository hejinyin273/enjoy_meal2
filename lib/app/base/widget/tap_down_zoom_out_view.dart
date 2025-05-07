
import 'package:flutter/material.dart';

class TapDownZoomOutView extends StatefulWidget {
  final bool needAnimation;
  final Duration duration;
  final Alignment alignment;
  final Widget child;
  final Function()? onClicked;

  const TapDownZoomOutView({super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    this.needAnimation = true,
    this.alignment = Alignment.center,
    this.onClicked,
  });

  @override
  State<TapDownZoomOutView> createState() => _TapDownZoomOutViewState();
}

class _TapDownZoomOutViewState extends State<TapDownZoomOutView> {
  double scale = 1.0;
  Offset downOffset = Offset.zero;

  void _updateScale(double newScale) {
    setState(() {
      scale = newScale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (details) {
        _updateScale(1.0);
        final rangeRect = Rect.fromCenter(
          center: downOffset,
          width: 32,
          height: 32,
        );

        if (rangeRect.contains(details.localPosition)) {
          if (widget.onClicked != null) {
            widget.onClicked!();
          }
        }
      },
      onPointerDown: (details) {
        setState(() {
          scale = 0.95;
          downOffset = details.localPosition;
        });
      },
      onPointerMove: (details) {
        final rangeRect = Rect.fromCenter(
          center: downOffset,
          width: 32,
          height: 32,
        );

        if (!rangeRect.contains(details.localPosition)) {
          _updateScale(1.0);
          downOffset = Offset.zero;
        }
      },
      onPointerCancel: (_) => _updateScale(1.0),
      child: widget.needAnimation
          ? AnimatedScale(
        scale: scale,
        duration: widget.duration,
        alignment: widget.alignment,
        child: widget.child,
      )
          : Transform.scale(
        scale: scale,
        alignment: widget.alignment,
        child: widget.child,
      ),
    );
  }
}
