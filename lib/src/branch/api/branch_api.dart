import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/login/model/login_model.dart';

import '../model/branch_model.dart';

class BranchAPI {
  static Future branch({
    required String dbName,
    required String usercode,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "User/GetCompanyUnits?DbName=$dbName&Usercode=$usercode",
    );

    return BranchModel.fromJson(jsonData);
  }


}
