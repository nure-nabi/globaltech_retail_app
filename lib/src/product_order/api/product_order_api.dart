import 'dart:convert';

import '../../../model/model.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class OrderProductAPI {
  static postOrder({required bodyData}) async {
    var body = jsonEncode(bodyData[0]);

    CustomLog.successLog(value: "\n\n\n\n\n\n BODY =>  $body");

    var jsonData = await APIProvider.postAPI(
      endPoint: "Order/BToBSaveOrder",
      body: body,
    );
    return BasicModel.fromJson(jsonData);
  }
}
