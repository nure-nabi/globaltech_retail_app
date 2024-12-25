import 'package:flutter/material.dart';
import '../../services/router/router_name.dart';
import '../../services/sharepref/get_all_pref.dart';
import '../branch/api/branch_api.dart';
import '../branch/model/branch_model.dart';
import '../login/model/login_model.dart';

class DashBoardProvider with ChangeNotifier {
  Future<void> loadDashBoard({
    required BuildContext context,
    required CompanyDetailsModel companyModel,
  }) async {

    late final NavigatorState navigator = Navigator.of(context);
    BranchModel model = await BranchAPI.branch(
      dbName: companyModel.dbName,
      usercode: await GetAllPref.userName(),
    );

    if(model.statusCode == 200){
       navigator.pushNamed(branchPath);
    }else{
      navigator.pushReplacementNamed(indexPath);
    }

          // final branchListResponse = await BranchListService().getBranchList(
          //   BranchListRequestModel(
          //     dbName: HiveStorage.get(UserKey.databaseName.name),
          //   ),
          // );


      }

      @override
  notifyListeners();
}