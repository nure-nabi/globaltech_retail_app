import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/widgets/container_decoration.dart';
import 'package:retail_app/widgets/mydropdown/dropdown_class.dart';
import 'package:retail_app/widgets/no_data_widget.dart';
import 'package:retail_app/widgets/title_value_widget.dart';

import '../../themes/themes.dart';
import '../../utils/utils.dart';
import 'model/pdc_model.dart';
import 'pdc_state.dart';

class PDCScreen extends StatefulWidget {
  const PDCScreen({Key? key}) : super(key: key);

  @override
  State<PDCScreen> createState() => _PDCScreenState();
}

class _PDCScreenState extends State<PDCScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PDCState>(context, listen: false).getContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PDCState>(
      builder: (context, state, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: const Text("PDC Report")),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: ContainerDecoration.decoration(
                        color: Colors.transparent,
                        bColor: Colors.grey.shade100,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              "Filter Data",
                              style: textFormTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: CustomDropDown(
                                buttonWidth: 50.0,
                                items: state.filterTypeList
                                    .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 14),
                                    )))
                                    .toList(),
                                // hint: "ALL",
                                hint: "Deu",
                                primaryColor: primaryColor,
                                borderColor: tableColor1,
                                onChanged: (value) {
                                  state.searchListData = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: state.filterDataList.isNotEmpty
                          ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.filterDataList.length,
                        itemBuilder: (context, index) {
                          PDCReportDataModel indexData =
                          state.filterDataList[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            decoration: ContainerDecoration.decoration(),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      indexData.glDesc,
                                      style:
                                      tableHeaderTextStyle.copyWith(
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    PDCTitleValueWidget(
                                      title: "Voucher No",
                                      value: indexData.vno,
                                    ),
                                    PDCTitleValueWidget(
                                      title: "Voucher Date",
                                      value: indexData.vMiti,
                                    ),
                                    PDCTitleValueWidget(
                                      title: "Bank Name",
                                      value: indexData.bankName,
                                    ),
                                    PDCTitleValueWidget(
                                      title: "Chq No.",
                                      value: indexData.chequeNo,
                                    ),
                                    PDCTitleValueWidget(
                                      title: "Chq Date",
                                      value:
                                      "${indexData.chMiti} - ${indexData.chDate.substring(0, 10)}",
                                    ),
                                    PDCTitleValueWidget(
                                      title: "Amount",
                                      value: indexData.amount,
                                    ),
                                    // const SizedBox(height: 10.0),
                                    // Container(
                                    //   decoration: ContainerDecoration
                                    //       .decoration(),
                                    //   padding: const EdgeInsets.all(10.0),
                                    //   child: Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       Text(
                                    //         "CHEQUE DETAILS",
                                    //         style: tableHeaderTextStyle
                                    //             .copyWith(
                                    //           letterSpacing: 1,
                                    //           color: Colors.black,
                                    //           decoration: TextDecoration
                                    //               .underline,
                                    //         ),
                                    //       ),
                                    //       const SizedBox(height: 5.0),
                                    //       PDCTitleValueWidget(
                                    //         title: "Chq No.",
                                    //         value: indexData.chequeNo,
                                    //       ),
                                    //       PDCTitleValueWidget(
                                    //         title: "Date",
                                    //         value: indexData.chMiti,
                                    //       ),
                                    //       PDCTitleValueWidget(
                                    //         title: "Amount",
                                    //         value: indexData.amount,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),

                                ///
                                InkWell(
                                  onTap: () {
                                    state.getPDCReportPrintFromAPI(
                                      vNo: indexData.vno,
                                      name: indexData.glDesc,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.print,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                          : const NoDataWidget(),
                    )
                  ],
                ),
              ),
            ),
            if (state.isLoading) LoadingScreen.loadingScreen(),
          ],
        );
      },
    );
  }
}
