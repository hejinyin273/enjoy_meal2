import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';

class ProgressDialog extends StatelessWidget {
  final bool loading;
  final String? msg;
  final Widget? progress;
  final double alpha;
  final Color textColor;
  final EdgeInsetsGeometry? loadingMargin;
  const ProgressDialog({super.key,
        required this.loading,
        this.msg,
        this.progress,
        this.alpha = 0.6,
        this.textColor = Colors.white, this.loadingMargin});

  @override
  Widget build(BuildContext context) {
    var progressWidget = progress??GifView.asset(
      'images/gif_loading.gif',
      height: 80.w,
      width: 80.w,
      frameRate: 30, // default is 15 FPS
    );
    List<Widget> widgetList = [];
    if (loading) {
      Widget layoutProgress;
      if (msg == null) {
        layoutProgress = Container(
          margin: loadingMargin??const EdgeInsets.all(20.0),
          child: Center(
            child: progressWidget,
          ),
        );
      } else {
        layoutProgress = Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: loadingMargin??const EdgeInsets.all(0),
            /*decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4.0)),*/
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                progressWidget,
                Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: Text(
                    msg!,
                    style: TextStyle(color: textColor, fontSize: 16.0, decoration: TextDecoration.none),
                  ),
                )
              ],
            ),
          ),
        );
      }
      widgetList.add(Opacity(
        opacity: alpha,
        child: const ModalBarrier(color: Colors.black87),
      ));
      widgetList.add(layoutProgress);
    }
    return Stack(
      children: widgetList,
    );
  }
}