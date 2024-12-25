import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/services.dart';
import 'package:retail_app/services/sharepref/set_all_pref.dart';
import 'package:retail_app/src/login/model/login_model.dart';
import 'package:retail_app/themes/themes.dart';
import 'package:retail_app/widgets/no_data_widget.dart';
import '../../constants/text_style.dart';
import '../../services/router/router_name.dart';
import '../provider/dashboard_provider.dart';
import 'db/login_db.dart';
import 'login_state.dart';

class CompanyListScreen extends StatefulWidget {
  final bool automaticallyImplyLeading;
  const CompanyListScreen({
    super.key,
    required this.automaticallyImplyLeading,
  });

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {

  @override
  void initState() {
    super.initState();
    getDataListFromDatabase();
  }


  List<CompanyDetailsModel> _companyList = [];

  List<CompanyDetailsModel> get companyList => _companyList;

  set getDataList(List<CompanyDetailsModel> value) {
    _companyList = value;
    setState(() {});
  }
  getDataListFromDatabase() async {
    await ClientListDBHelper.instance.getDataList().then((value) {
      getDataList = value;
    });
    setState(() {});
  }

  onBack() async {
    await SystemNavigator.pop();
  }
  Future<bool> _onWillPop() async {
    bool shouldNavigateBack = true; // Change this based on your logic
    if (shouldNavigateBack) {
      Navigator.pushNamedAndRemoveUntil(context, loginPath, (route) => false);
    } else {
      print("Stay on the page!");
    }
    return shouldNavigateBack;
  }


  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashBoardProvider>(context, listen: false);
   // final state = context.watch<LoginState>();
    return WillPopScope(
      onWillPop: () {
        return _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title:  Text("Company List",style: cardTextStyleHeader,),
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: companyList.isNotEmpty
            ? ListView.builder(
          itemCount: companyList.length,
          itemBuilder: (context, index) {
            CompanyDetailsModel companyDetail = companyList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              elevation: 4, // Add elevation for a card-like appearance
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                onTap: () async {
                  await SetAllPref.companySelected(value: true);
                  await SetAllPref.companyInital(value: companyDetail.initial);
                  await SetAllPref.companyDetail(value: companyDetail);
                  await SetAllPref.setStartDate(value: companyDetail.startDate);
                  await SetAllPref.setEndDate(value: companyDetail.endDate);
                  await GetAllPref.companyDetail();
                  await dashboardProvider.loadDashBoard(context: context, companyModel: companyDetail,);

                  //  await onListClicked(context, detailsModel: companyDetail);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company: ${companyDetail.companyName}',
                        style: cardTextStyleHeaderCompany,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Text('Start Date: ${companyDetail.startDate}',
                            style: cardTextStyleSalePurchase,
                          ),
                          const SizedBox(width: 16.0),
                          Text('End Date: ${companyDetail.endDate}',
                            style: cardTextStyleSalePurchase,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ) : const NoDataWidget(),
      ),
    );
  }

  onListClicked(context, {required CompanyDetailsModel detailsModel}) async {
    late final NavigatorState navigator = Navigator.of(context);
    await SetAllPref.companySelected(value: true);
    await SetAllPref.companyDetail(value: detailsModel);
    return navigator.pushReplacementNamed(indexPath);
  }
}
