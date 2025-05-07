

import 'package:enjoy_meal/app/data/model/restaurant_data.dart';

class PageDishList{
  int mainCategoryId;
  int subCategoryId;
  int displayMode;
  List<DishInfo> dishList = [];
  PackageInfo? packageInfo;
  String? bgUrl;
  bool isShowImg = true;///use for set menu view

  PageDishList(this.mainCategoryId, this.subCategoryId, this.displayMode, this.dishList, {this.packageInfo});

  String? getUseBgUrl() {
    if (bgUrl != null && bgUrl!.isNotEmpty) {
      return bgUrl;
    }
    return null;
  }
}

