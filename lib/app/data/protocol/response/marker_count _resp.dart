


class MarkerCountResp {
  late int waitMakeDishCount;
  late int callCount;


  MarkerCountResp(this.waitMakeDishCount, this.callCount);

  MarkerCountResp.fromJson(Map<String, dynamic> json)
      : waitMakeDishCount = json["waitMakeDishCount"],
        callCount = json["callCount"];

}