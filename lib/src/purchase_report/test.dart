import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/purchase_report/purchase_report_state.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PurchaseReportState>(context, listen: false).getContext = context;
      Provider.of<PurchaseReportState>(context, listen: false).getPurchaseTotalFromDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sum Purchase'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Consumer<PurchaseReportState>(
        builder: (context, customerState, _) {
          if (customerState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (customerState.totalSum == 0.0) {
            return const Center(child: Text('No purchases found.'));
          } else {
            return Center(
              child: Text(
                'Total Sum: ${customerState.totalSum}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}