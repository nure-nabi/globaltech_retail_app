import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/purchase_report/purchase_report_state.dart';
import 'package:retail_app/src/salesreport/sales_report_state.dart';

class TestScreen2 extends StatefulWidget {
  const TestScreen2({Key? key});

  @override
  State<TestScreen2> createState() => _TestScreen2State();
}

class _TestScreen2State extends State<TestScreen2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SalesReportState>(context, listen: false).getContext = context;
      Provider.of<SalesReportState>(context, listen: false).getSaleTotalFromDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Purchase'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Consumer<SalesReportState>(
        builder: (context, saleReportState, _) {
          if (saleReportState.isLoading) {
            return  Center(child: CircularProgressIndicator());
          } else if (saleReportState.totalSum == 0.0) {
            return const Center(child: Text('No purchases found tt.'));
          } else {
            return Center(
              child: Text(
                'Total Sum: ${saleReportState.totalSum}',
                style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}