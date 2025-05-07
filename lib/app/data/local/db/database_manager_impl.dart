


import '../../model/download_model.dart';
import 'database_helper.dart';
import 'database_manager.dart';

class DatabaseManagerImpl implements DatabaseManager {

  @override
  Future<int> addDownloadInfo(DownloadInfo downloadInfo) async{
    var dbClient = await DatabaseHelper().db;
    try{
      var result = await dbClient.insert(DatabaseHelper.tableDownloadInfo, downloadInfo.toJson());
      return result;
    }catch(err) {
      //print("addDownloadInfo()==========>>>>> err=$err");
    }
    return -1;
  }

  @override
  Future<List<DownloadInfo>> rawQueryDownloadInfo(String sql) async {
    var dbClient = await DatabaseHelper().db;
    var result = await dbClient.rawQuery(sql);
    List<DownloadInfo> dataList = [];
    for (var item in result) {
      dataList.add(DownloadInfo.fromJson(item));
    }
    return dataList;
  }

  @override
  Future<List<DownloadInfo>> getAllDownloadInfo({String? where, List<Object?>? whereArgs, int? limit, int? offset, String? orderBy}) async{
    var dbClient = await DatabaseHelper().db;
    var result = await dbClient.query(
      DatabaseHelper.tableDownloadInfo,
      columns: DatabaseHelper.tableDownloadInfoColumns,
      where: where,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
      orderBy: orderBy ?? "saveTime DESC",
    );
    List<DownloadInfo> dataList = [];
    for (var item in result) {
      dataList.add(DownloadInfo.fromJson(item));
    }
    return dataList;
  }

  @override
  Future<DownloadInfo?> getDownloadInfoByFileId(String fileId) async{
    var dbClient = await DatabaseHelper().db;
    var result = await dbClient.query(
        DatabaseHelper.tableDownloadInfo,
        columns: DatabaseHelper.tableDownloadInfoColumns,
        where: "fileId='$fileId'"
    );
    if (result.isNotEmpty) {
      return DownloadInfo.fromJson(result.first);
    }
    return null;
  }

  @override
  Future<DownloadInfo?> getLatestPendingDownloadInfo() async{
    var dbClient = await DatabaseHelper().db;
    var result = await dbClient.query(
      DatabaseHelper.tableDownloadInfo,
      columns: DatabaseHelper.tableDownloadInfoColumns,
      where: "status=0",
      limit: 1,
      orderBy: "saveTime DESC",
    );
    if (result.isNotEmpty) {
      return DownloadInfo.fromJson(result.first);
    }
    return null;
  }

  @override
  Future<List<DownloadInfo>> getLatestPendingList() async{
    var dbClient = await DatabaseHelper().db;
    var result = await dbClient.query(
      DatabaseHelper.tableDownloadInfo,
      columns: DatabaseHelper.tableDownloadInfoColumns,
      where: "status=0",
      orderBy: "saveTime DESC",
    );
    List<DownloadInfo> dataList = [];
    for (var item in result) {
      dataList.add(DownloadInfo.fromJson(item));
    }
    return dataList;
  }

  @override
  Future<int> updateDownloadInfoLoading(String fileId, int status, int fileSize) async{
    var dbClient = await DatabaseHelper().db;
    int result = await dbClient.update(DatabaseHelper.tableDownloadInfo, {
      "status": status,
      "fileSize": fileSize
    },
        where: "fileId='$fileId' and status<>1"
    );
    return result;
  }

  @override
  Future<int> updateDownloadInfoNewVersion(DownloadInfo downloadInfo, int status) async{
    var dbClient = await DatabaseHelper().db;
    var downloadInfoMap = downloadInfo.toJson();
    downloadInfoMap.remove("fileId");
    int result = await dbClient.update(DatabaseHelper.tableDownloadInfo, downloadInfoMap,
        where: "fileId='${downloadInfo.fileId}'"
    );
    return result;
  }

  @override
  Future<int> updateDownloadInfoPending(String fileId) async{
    var dbClient = await DatabaseHelper().db;
    int result = await dbClient.update(DatabaseHelper.tableDownloadInfo, {"status": 0},
        where: "fileId='$fileId' and status=2"
    );
    return result;
  }

  @override
  Future<int> updateDownloadInfoStatus(String fileId, int status) async{
    var dbClient = await DatabaseHelper().db;
    int result = await dbClient.update(DatabaseHelper.tableDownloadInfo, {"status": status},
        where: "fileId='$fileId'"
    );
    return result;
  }

  @override
  Future<int> updateDownloadInfoStop() async{
    var dbClient = await DatabaseHelper().db;
    int result = await dbClient.update(DatabaseHelper.tableDownloadInfo, {"status": 2},
        where: "(status=0 or status=1)"
    );
    return result;
  }

  @override
  Future<int> updateFailedDownloadStatus(String fileId) async{
    var dbClient = await DatabaseHelper().db;
    int result = await dbClient.update(DatabaseHelper.tableDownloadInfo, {"status": 2},
        where: "fileId='$fileId' and (status=0 or status=1 or status=2)"
    );
    return result;
  }

  @override
  Future<int> deleteDownloadInfo(String fileId) async{
    var dbClient = await DatabaseHelper().db;
    var result = await dbClient.delete(
      DatabaseHelper.tableDownloadInfo,
      where: "fileId='$fileId'",
    );
    return result;
  }

  @override
  Future<int> bulkUpdateLoadedSize(Map<String, int> loadedMap) async{
    var dbClient = await DatabaseHelper().db;
    var batch = dbClient.batch();
    loadedMap.forEach((fileId, loadedSize){
      batch.update(DatabaseHelper.tableDownloadInfo,
          {"loadedSize": loadedSize},
        where: "fileId='$fileId'"
      );
    });
    var results = await batch.commit();
    return results.length;
  }
}