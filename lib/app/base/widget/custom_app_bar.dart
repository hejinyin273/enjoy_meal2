import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/color_conf.dart';
import '../config/text_styles_conf.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitleText;
  final List<Widget>? actions;
  final bool isBackButtonEnabled;
  final Widget? leading;
  final Widget? titleWidget;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.appBarTitleText,
    this.actions,
    this.isBackButtonEnabled = true,
    this.leading,
    this.titleWidget,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? ColorConf.appBarColor,
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: isBackButtonEnabled,
      leading: leading,
      actions: actions,
      systemOverlayStyle: const SystemUiOverlayStyle(
        //Status bar color for android
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: const IconThemeData(color: ColorConf.appBarIconColor),
      title: titleWidget ?? Text(
        appBarTitleText,
        style: pageTitleStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
