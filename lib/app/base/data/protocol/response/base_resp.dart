

class BaseResp<T>{
  int status;
  String message;
  T? data;

  BaseResp(this.status, this.message, this.data);

  BaseResp.fromJson(Map<String, dynamic> json)
      : status=json['status'],
        message=json['message'],
        data=json['data'];

  bool isSuccessWithData(){
    return this.status == 200 && this.data != null;
  }

  bool isSuccess(){
    return this.status == 200;
  }

  @override
  String toString() {
    return 'BaseResp{code: $status, message: $message, data: $data}';
  }
}

