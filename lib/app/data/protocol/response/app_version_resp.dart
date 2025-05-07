

class AppVersionResp{

  String appVersion;
  String downloadUrl;

  AppVersionResp.fromJson(Map<String, dynamic> json)
      : appVersion = json["appVersion"],
        downloadUrl = json["downloadUrl"];
}