import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';
// ignore_for_file: must_be_immutable

class CustomProgressDialog extends StatelessWidget {
  final int eventId;
  final String? msg;
  Function(bool didPop, int eventId, DateTime dateTime)? onPopInvoked;
  EdgeInsetsGeometry? loadingMargin;
  DateTime? dateTime;

  CustomProgressDialog({super.key, required this.eventId, this.msg, this.onPopInvoked, this.loadingMargin}){
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var progressWidget = GifView.asset(
      'images/gif_loading.gif',
      height: 80.w,
      width: 80.w,
      frameRate: 30, // default is 15 FPS
    );
    List<Widget> widgetList = [];
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
          margin: loadingMargin??const EdgeInsets.all(0),
          padding: const EdgeInsets.all(20.0),
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
                  style: const TextStyle(color: Colors.white, fontSize: 16.0, decoration: TextDecoration.none),
                ),
              )
            ],
          ),
        ),
      );
    }
    widgetList.add(const Opacity(
      opacity: 0.6,
      child: ModalBarrier(color: Colors.black87),
    ));
    widgetList.add(layoutProgress);

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (pop, data){
          if (onPopInvoked != null) {
            onPopInvoked!(pop, eventId, dateTime!);
          }
        },
        child: Stack(
          children: widgetList,
        )
    );
  }
}