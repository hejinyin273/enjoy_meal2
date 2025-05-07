

class DownloadInfo {
  String fileId;
  String fileName = "";
  String fileImgUrl = "";
  String mainInfo = "";
  String url;
  int loadedSize = 0;
  int fileSize = 0;
  String filePath = "";
  String version;
  int status = 0;
  int type;
  String? packageMd5;
  String? relyIds;
  String? extraId;
  int? extraOne;
  String? extraTwo;
  int saveTime = 0;
  String? describe;

  DownloadInfo({required this.fileId, required this.url, required this.type, required this.version});

  DownloadInfo.fromJson(Map<String, dynamic> json)
      : fileId = json["fileId"],
        fileName = json["fileName"],
        fileImgUrl = json["fileImgUrl"],
        mainInfo = json["mainInfo"],
        url = json["url"],
        loadedSize = json["loadedSize"],
        fileSize = json["fileSize"],
        filePath = json["filePath"],
        version = json["version"],
        status = json["status"],
        type = json["type"],
        packageMd5 = json["packageMd5"],
        relyIds = json["relyIds"],
        extraId = json["extraId"],
        extraOne = json["extraOne"],
        extraTwo = json["extraTwo"],
        saveTime = json["saveTime"],
        describe = json["describe"];



  Map<String, dynamic> toJson() => {
    "fileId": fileId,
    "fileName": fileName,
    "fileImgUrl": fileImgUrl,
    "mainInfo": mainInfo,
    "url": url,
    "loadedSize": loadedSize,
    "fileSize": fileSize,
    "filePath": filePath,
    "version": version,
    "status": status,
    "type": type,
    "packageMd5": packageMd5,
    "relyIds": relyIds,
    "extraId": extraId,
    "extraOne": extraOne,
    "extraTwo": extraTwo,
    "saveTime": saveTime,
    "describe": describe
  };

  Map<String, dynamic> toStartMap() => {
    "fileId": fileId,
    "fileName": fileName,
    "fileImgUrl": fileImgUrl,
    "mainInfo": mainInfo,
    "url": url,
    "version": version,
    "type": type,
    "extraId": extraId,
    "packageMd5": packageMd5,
    "relyIds": relyIds,
  };

  @override
  String toString() {
    return 'DownloadInfo{fileId: $fileId, fileName: $fileName, fileImgUrl: $fileImgUrl, mainInfo: $mainInfo, url: $url, loadedSize: $loadedSize, fileSize: $fileSize, filePath: $filePath, version: $version, status: $status, type: $type, packageMd5: $packageMd5, relyIds: $relyIds, extraId: $extraId, extraOne: $extraOne, extraTwo: $extraTwo, saveTime: $saveTime, describe: $describe}';
  }
}

class DownloadStatus {
  static const int pending = 0;
  static const int loading = 1;
  static const int stopped = 2;
  static const int success = 3;
}



class DownloadFileType {
  static const int app = 0;
}