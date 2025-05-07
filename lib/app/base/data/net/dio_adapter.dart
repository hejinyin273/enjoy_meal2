
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../config/base_conf.dart';
import '../../utils/log_util.dart';
import '../model/download_listener.dart';
import '../protocol/response/base_resp.dart';
import 'exceptions/api_exception.dart';
import 'exceptions/app_exception.dart';
import 'exceptions/base_exception.dart';
import 'exceptions/custom_status_code_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/not_found_exception.dart';
import 'exceptions/service_unavailable_exception.dart';
import 'exceptions/timeout_exception.dart';
import 'exceptions/unauthorize_exception.dart';
import 'pretty_dio_logger.dart';
import 'net_client_adapter.dart';
import 'net_config.dart';

class DioAdapter extends NetClientAdapter{
  final Logger logger = LogUtil().logger;

  DioAdapter(){
    DioUtil();
    DioFileUtil();
  }

  @override
  Future<BaseResp<T>> requestBase<T>(String method, String path, {dynamic data, Map<String, dynamic>? params}) async{
    DioUtil.dio.options.method = method;
    try {
      Response response = await DioUtil.dio.request(path, data: data, queryParameters: params);
      return BaseResp.fromJson(response.data);
    }on DioException catch(err){
      logger.e("request error1: $err");
      if (err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException("网络超时！");
      } else if (err.type == DioExceptionType.badCertificate) {
        throw AppException(message: "错误证书！");
      } else if (err.type == DioExceptionType.badResponse) {
        throw _parseDioErrorResponse(err);
      } else if (err.type == DioExceptionType.cancel) {
        throw AppException(message: "连接被取消！");
      } else if (err.type == DioExceptionType.connectionError) {
        throw NetworkException("网络异常！");
      } else {
        throw NetworkException("网络异常！");
      }
    }catch(err){
      logger.e("request error2: $err");
      if (err is BaseException) {
        rethrow;
      }
      throw AppException(message: err.toString());
    }
  }

  Exception _parseDioErrorResponse(DioException dioError) {
    int statusCode = dioError.response?.statusCode ?? -1;
    String? status;
    String? serverMessage;
    String? customHeaderStatusCode;

    try {

      var headers = dioError.response?.headers;
      if(headers != null) {
        customHeaderStatusCode = headers.value("StatusCode");
        logger.i("==>customHeaderStatusCode=$customHeaderStatusCode");
        if("401" == customHeaderStatusCode) {
          return UnauthorizedException("登录过期了");
        } else if ("402" == customHeaderStatusCode) {
          return CustomStatusCodeException(402, "用户在其他设备登录", "402");
        }
      }

      if (statusCode == -1 || statusCode == HttpStatus.ok) {
        statusCode = dioError.response?.data["statusCode"];
      }
      status = dioError.response?.data["status"];
      serverMessage = dioError.response?.data["message"];
    } catch (e, s) {
      logger.i("$e");
      logger.i(s.toString());

      serverMessage = "未知错误，请稍候重试！";
    }

    switch (statusCode) {
      case HttpStatus.serviceUnavailable:
        return ServiceUnavailableException("服务暂时不可用");
      case HttpStatus.unauthorized:
        return UnauthorizedException("登录过期了");
      case HttpStatus.notFound:
        return NotFoundException(serverMessage ?? "", status ?? "");
      default:
        return ApiException(
            httpCode: statusCode,
            status: status ?? "",
            message: serverMessage ?? "");
    }
  }

  @override
  Future<void> doDownload(String url, String savePath,
      {required String fileId, required CancelToken cancelToken, Map<String, dynamic>? params, dynamic data, Options? options, DownloadListener? downloadListener}) async {
    try {
      int downloadFileLength = 0; //记录已下载的文件长度
      final downloadFile = File(savePath);
      if(downloadFile.existsSync()){  //存在，拿到这个文件已经下载的长度，从这里开始下载
        downloadFileLength = await downloadFile.length();
      }

      DioFileUtil.dio.options = DioFileUtil._getDefaultOption();
      DioFileUtil.dio.options.responseType = ResponseType.stream;/// 以流的方式接收响应数据
      DioFileUtil.dio.options.followRedirects = false;
      DioFileUtil.dio.options.headers[HttpHeaders.acceptHeader] = "text/plain,"
          "text/plain,"
          "multipart/form-data,"
          "application/json,"
          "text/html,"
          "image/jpeg,"
          "image/png,"
          "application/octet-stream,"
          "text/json,"
          "text/javascript,"
          "text/html";
      DioFileUtil.dio.options.headers["range"] = "bytes=$downloadFileLength-";/// 分段下载重点位置

      var response = await DioFileUtil.dio.get<ResponseBody>(url);

      RandomAccessFile raf = downloadFile.openSync(mode: FileMode.append);
      int received = downloadFileLength;
      int total = await _getContentLength(response);
      int lastProgress = 0;
      Stream<Uint8List> stream = response.data!.stream;
      StreamSubscription<Uint8List>? subscription;
      subscription = stream.listen((data) {
        raf.writeFromSync(data);/// 写入文件必须同步
        received += data.length;

        //计算已经下载的百分比
        int progress = received * 100 ~/ total;
        if(progress > lastProgress) {
          downloadListener?.onProgress(fileId, received, total);
          lastProgress = progress;
        }

      },
        onDone: () async {
          await raf.close();
          downloadListener?.onSuccess(fileId, savePath);
        },
        onError: (e) async {
          await raf.close();
          logger.e("request error0: $e");
          if (e is DioException) {
            downloadListener?.onFailed(fileId, _getErrMsg(e));
          } else {
            downloadListener?.onFailed(fileId, "未知错误，请稍候重试！");
          }
        },
        cancelOnError: true,
      );
      cancelToken.whenCancel.then((_) async {
        await subscription?.cancel();
        await raf.close();
        downloadListener?.onPaused(fileId);
      });
    } on DioException catch (err) {
      logger.e("request error1: $err");
      /// 请求已发出，服务器用状态代码响应它不在200的范围内
      if (CancelToken.isCancel(err)) {
        logger.e("cancelToken.isCancel");
        downloadListener?.onPaused(fileId);
      } else {
        downloadListener?.onFailed(fileId, _getErrMsg(err));
      }
    } catch (err) {
      logger.e("request error2: $err");
      downloadListener?.onFailed(fileId, "未知错误，请稍候重试！");
    }
    return;
  }

  Future<int> _getContentLength(Response<ResponseBody> response) async {
    try {
      var headerContent = response.headers.value(HttpHeaders.contentRangeHeader);
      logger.i("headerContent=$headerContent");
      if (headerContent != null) {
        return int.parse(headerContent.split('/').last);
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  String _getErrMsg(DioException err){
    if (err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout) {
      return "网络超时！";
    } else if (err.type == DioExceptionType.badCertificate) {
      return "错误证书！";
    } else if (err.type == DioExceptionType.badResponse) {
      return "服务暂时不可用";
    } else if (err.type == DioExceptionType.connectionError) {
      return "网络异常！";
    } else {
      return "网络异常！";
    }
  }
}

class DioUtil{
  static final DioUtil _singleton = DioUtil._init();
  static late Dio dio;
  factory DioUtil() {
    return _singleton;
  }
  DioUtil._init(){
    dio = Dio(_getDefaultOption());
    dio.interceptors.add(TokenInterceptor());
    dio.interceptors.add(PrettyDioLogger(requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  static BaseOptions _getDefaultOption(){
    BaseOptions options = BaseOptions();
    options.contentType = Headers.jsonContentType;
    options.connectTimeout = const Duration(seconds: 10);
    options.receiveTimeout = const Duration(seconds: 10);
    options.baseUrl = NetConfig.baseUrl;
    return options;
  }
}

class DioFileUtil{
  static final DioFileUtil _singleton = DioFileUtil._init();
  static late Dio dio;
  factory DioFileUtil() {
    return _singleton;
  }
  DioFileUtil._init(){
    dio = Dio(_getDefaultOption());
    dio.interceptors.add(PrettyDioLogger(requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));
  }

  static BaseOptions _getDefaultOption(){
    BaseOptions options = BaseOptions();
    options.contentType = Headers.jsonContentType;
    options.connectTimeout = const Duration(seconds: 10);
    options.receiveTimeout = const Duration(seconds: 10);
    return options;
  }
}

class TokenInterceptor extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if(BaseConf.token.isNotEmpty) {
      options.headers["Authorization"] = BaseConf.token;
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null && err.response!.statusCode == 401) {
      ///todo 401
    }
    super.onError(err, handler);
  }
}
