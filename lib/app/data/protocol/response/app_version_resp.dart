

class AppVersionResp{

  String appVersion;
  String downloadUrl;
  String appFileMd5;

  AppVersionResp.fromJson(Map<String, dynamic> json)
      : appVersion = json["appVersion"],
        appFileMd5 = json["appFileMd5"],
        downloadUrl = json["downloadUrl"];
}