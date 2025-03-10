import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:retail_app/src/pdc/state/pdc_state.dart';

import '../../themes/colors.dart';
import '../../themes/fonts_style.dart';
import '../../utils/loading_indicator.dart';
import '../../widgets/container_decoration.dart';
import '../../widgets/mydropdown/dropdown_class.dart';
import '../../widgets/no_data_widget.dart';
import '../../widgets/title_value_widget.dart';
import 'model/pdc_model.dart';
import 'model/pdf_bounce_cheque_model.dart';



class PDCScreen extends StatefulWidget {
  const PDCScreen({super.key});

  @override
  State<PDCScreen> createState() => _PDCScreenState();
}

class _PDCScreenState extends State<PDCScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PDCState>().getContext = context;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PDCState>(
      builder: (context, state, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: const Text("PDC Report")),
              body: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Builder(
                  builder: (context) {
                    return Column(
                      children: [
                        TabBar(labelColor: primaryColor, tabs: const [
                          Tab(text: 'Filter PDC Report'),
                          Tab(text: 'Cheque Bounce Report'),
                        ]),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildFilterPDCReport(state),
                              _buildBounceReport(state),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (state.isLoading) LoadingScreen.loadingScreen(),
          ],
        );
      },
    );
  }

  Widget _buildFilterPDCReport(PDCState state) {
    return Column(
      children: [
        _FilterSection(),
        Expanded(
          child: state.filterDataList.isNotEmpty
              ? _PDCReportList()
              : const NoDataWidget(),
        ),
      ],
    );
  }

  Widget _buildBounceReport(PDCState state) {
    return state.bounceList.isNotEmpty
        ? _PDCBounceReportList()
        : const NoDataWidget();
  }
}

class _FilterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PDCState>(context);
    return Container(
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
                dropdownMaxHeight: 250.0,
                buttonWidth: 50.0,
                items: state.filterTypeList
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ))
                    .toList(),
                hint: "Due",
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
    );
  }
}

class _PDCReportList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PDCState>(context);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: state.filterDataList.length,
      itemBuilder: (context, index) {
        final indexData = state.filterDataList[index];
        return _PDCReportItem(indexData: indexData);
      },
    );
  }
}

Color getPDCFilterColor(String type) {
  switch (type) {
    case "CANCEL":
      return Colors.red;
    case "DUE":
      return Colors.blue;
    case "DEPOSIT":
      return Colors.green;
    default:
      return Colors.white;
  }
}

class _PDCReportItem extends StatelessWidget {
  final PDCReportDataModel indexData;

  const _PDCReportItem({required this.indexData});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PDCState>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: ContainerDecoration.decoration(
        color: getPDCFilterColor(
          indexData.bankName.toUpperCase(),
        ).withOpacity(.15),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${indexData.glDesc}-- ( ${indexData.bankName.toUpperCase()} ) ",
                style: tableHeaderTextStyle.copyWith(
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
            ],
          ),
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
  }
}

class _PDCBounceReportList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PDCState>(context);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: state.bounceList.length,
      itemBuilder: (context, index) {
        final indexData = state.bounceList[index];
        return _PDCBounceReportItem(indexData: indexData);
      },
    );
  }
}

class _PDCBounceReportItem extends StatelessWidget {
  final PdcBounceDataModel indexData;

  const _PDCBounceReportItem({required this.indexData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: ContainerDecoration.decoration(),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                indexData.glDesc,
                style: tableHeaderTextStyle.copyWith(
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 5.0),
              PDCTitleValueWidget(
                title: "Voucher No",
                value: indexData.vno,
              ),
              PDCTitleValueWidget(
                title: "Bank Name",
                value: indexData.bankName,
              ),
              PDCTitleValueWidget(
                title: "Chq Date",
                value:
                    "${indexData.chMiti} - ${indexData.chdate.substring(0, 10)}",
              ),
              PDCTitleValueWidget(
                title: "Chq No.",
                value: indexData.chequeNo,
              ),
              PDCTitleValueWidget(
                title: "Remarks",
                value: indexData.remarks,
              ),
              PDCTitleValueWidget(
                title: "Amount",
                value: "${indexData.amount}",
              ),
              PDCTitleValueWidget(
                title: "Bounce Date",
                value:
                    "${indexData.bounceMiti} - ${indexData.bounceDate.substring(0, 10)}",
              ),
              PDCTitleValueWidget(
                title: "Bounce Remarks",
                value: indexData.bounceRemarks,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
