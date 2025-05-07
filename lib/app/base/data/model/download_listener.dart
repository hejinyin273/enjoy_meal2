


typedef OnProgress = void Function(String fileId, int count, int total);
typedef OnSuccess = void Function(String fileId, String filePath);
typedef OnFailed = void Function(String fileId, String msg);
typedef OnPaused = void Function(String fileId);
typedef OnUpdate = void Function(String fileId);

class DownloadListener{
  OnProgress onProgress;
  OnSuccess onSuccess;
  OnFailed onFailed;
  OnPaused onPaused;
  OnUpdate onUpdate;

  DownloadListener({required this.onProgress, required this.onSuccess, required this.onFailed, required this.onPaused, required this.onUpdate});
}