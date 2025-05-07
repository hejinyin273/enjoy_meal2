import 'dart:io';

import 'package:enjoy_meal/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'base/utils/android_helper.dart';
import 'bindings/initial_binding.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double height = 1280;
  double width = 800;
  Orientation lastOrientation = Orientation.portrait;

  @override
  void initState() {
    super.initState();

    if(Platform.isAndroid) {
      AndroidHelper.initAndroid();
    }

  }

  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;
    if (Orientation.portrait == orientation) {
      height = 1280;
      width = 800;
    } else {
      height = 800;
      width = 1280;
    }
    return ScreenUtilInit(
      designSize: Size(width, height),
      builder: (context, child) => _materialApp(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final orientation = MediaQuery.of(context).orientation;
    if (lastOrientation != orientation) {
      setState(() {});
    }
    lastOrientation = MediaQuery.of(context).orientation;
  }

  Widget _materialApp() {
    return GetMaterialApp(
      title: "享受美餐",
      initialRoute: AppPages.initial,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      defaultTransition: Transition.noTransition,
      builder: FToastBuilder(),
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF00BAA4),
          selectionColor: Color(0xFF00BAA4),
          selectionHandleColor: Color(0xFF00BAA4),
        ),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF38686A),
        textTheme: const TextTheme(
          labelLarge: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
    );
  }

}
