


import 'package:dio/dio.dart';

import '../model/download_listener.dart';
import '../protocol/response/base_resp.dart';

abstract class NetClientAdapter{
  Future<BaseResp<T>> requestBase<T>(String method, String path, {dynamic data, Map<String, dynamic>? params});

  Future<void> doDownload(String url, String savePath,
      {required String fileId, required CancelToken cancelToken,
        Map<String, dynamic>? params,
        dynamic data,
        Options? options,
        DownloadListener? downloadListener});
}

