

import '../../../config/constants.dart';
import '../../model/language.dart';

class CallRecordResp {
  late int id;
  late int callStaffId;
  late String createTime;
  late String callContentZh;
  late String callContentJa;
  late String callContentEn;
  late String tableNumber;

  CallRecordResp.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        callStaffId = json["callStaffId"],
        createTime = json["createTime"],
        callContentZh = json["callContentZh"],
        callContentJa = json["callContentJa"],
        callContentEn = json["callContentEn"],
        tableNumber = json["tableNumber"];

  String getCallContent() {
    if (Language.zh == Conf.selectedLanguage) {
      return callContentZh;
    } else if (Language.jp == Conf.selectedLanguage) {
      return callContentJa;
    } else {
      return callContentEn;
    }
  }
}