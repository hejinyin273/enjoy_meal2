
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

abstract class BaseView<Controller extends BaseController>
    extends GetView<Controller> {

  BaseView({super.key});

  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  PreferredSizeWidget? appBar(BuildContext context);

  Widget body(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          annotatedRegion(context),
        ],
      ),
    );
  }

  Widget annotatedRegion(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        //Status bar color for android
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: pageScaffold(context),
      ),
    );
  }

  Widget pageScaffold(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (pop, data){
        controller.onPopInvokedWithResult(pop, data);
      },
      canPop: canPop(),
      child: Scaffold(
        //sets ios status bar color
          backgroundColor: pageBackgroundColor(),
          key: globalKey,
          appBar: appBar(context),
          floatingActionButton: floatingActionButton(),
          body: pageContent(context),
          bottomNavigationBar: bottomNavigationBar(),
          drawer: drawer(),
          onDrawerChanged: (isOpen) {
            drawerCallback(isOpen);
          },
          drawerEnableOpenDragGesture:getDrawerEnableOpenDragGesture(true),
          drawerScrimColor: Colors.transparent,
          extendBody: true,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true//getResizeState(),
      ),
    );
  }

  bool getDrawerEnableOpenDragGesture(bool enableOpen) {
    return enableOpen;
  }

  void drawerCallback(bool isOpen) {

  }

  Widget pageContent(BuildContext context) {
    return SafeArea(
      child: body(context),
    );
  }

  void showToast(String message) {
    controller.showToast(message);
  }

  Color pageBackgroundColor() {
    return const Color(0xFFFFFFFF);
  }

  Color statusBarColor() {
    return const Color(0xFFFFFFFF);
  }

  Color? drawerScrimColor() {
    return null;
  }

  Widget? floatingActionButton() {
    return null;
  }

  bool getResizeState() {
    return false;
  }

  Widget? bottomNavigationBar() {
    return null;
  }

  Widget? drawer() {
    return null;
  }

  bool canPop() {
    return true;
  }
}