import 'package:retail_app/services/api/api_provider.dart';
import 'package:retail_app/src/login/model/login_model.dart';

class LoginAPI {
  static Future login({
    required String username,
    required String password,
  }) async {
    var jsonData = await APIProvider.getAPI(
      endPoint: "User/MobileLoginUser?username=$username&password=$password",
    );

    return CompanyModel.fromJson(jsonData);
  }
}
