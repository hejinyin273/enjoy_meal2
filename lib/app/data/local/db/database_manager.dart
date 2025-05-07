

import '../../model/download_model.dart';

abstract class DatabaseManager {

  Future<int> addDownloadInfo(DownloadInfo downloadInfo);

  Future<List<DownloadInfo>> rawQueryDownloadInfo(String sql);

  Future<List<DownloadInfo>>  getAllDownloadInfo({String? where, List<Object?>? whereArgs, int? limit, int? offset, String? orderBy});

  Future<DownloadInfo?> getDownloadInfoByFileId(String fileId);

  Future<DownloadInfo?> getLatestPendingDownloadInfo();

  Future<List<DownloadInfo>> getLatestPendingList();

  Future<int> updateDownloadInfoNewVersion(DownloadInfo downloadInfo, int status);

  Future<int> updateDownloadInfoStatus(String fileId, int status);

  Future<int> updateDownloadInfoPending(String fileId);

  Future<int> updateDownloadInfoLoading(String fileId, int status, int fileSize);

  Future<int> updateDownloadInfoStop();

  Future<int> updateFailedDownloadStatus(String fileId);

  Future<int> deleteDownloadInfo(String fileId);

  Future<int> bulkUpdateLoadedSize(Map<String, int> loadedMap);
}