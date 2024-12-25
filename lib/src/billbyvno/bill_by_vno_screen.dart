import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enum/enum.dart';
import '../../themes/themes.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'bill_by_vno_state.dart';

class BillDetailsByVnoScreen extends StatefulWidget {
  final String vNo, name;
  final BillPrintEnum billPrintEnum;

  const BillDetailsByVnoScreen({
    Key? key,
    required this.vNo,
    required this.name,
    required this.billPrintEnum,
  }) : super(key: key);

  @override
  State<BillDetailsByVnoScreen> createState() => _BillDetailsByVnoScreenState();
}

class _BillDetailsByVnoScreenState extends State<BillDetailsByVnoScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BillNoByVnoState>(context, listen: false).getPrintEnum =
        widget.billPrintEnum;
    Provider.of<BillNoByVnoState>(context, listen: false).init(vNo: widget.vNo);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BillNoByVnoState>(
      builder: (context, state, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: Text('Bill no: ${widget.vNo}'),),
              body: Column(children: [
                SizedBox(
                  height: 50.0,
                 width: double.infinity,
                 child: Center(
                   child: Text('Product List:',
                   style: TextStyle(
                     color: primaryColor,
                     fontSize: 16.0,
                     fontWeight: FontWeight.bold,
                   ),),
                 ),
                ),
                Divider(
                  height: 5.0,
                  color: primaryColor,
                  thickness: 2.1,
                ),
                (state.dataList.isNotEmpty)
                    ? Expanded(
                  child: ListView.builder(
                      itemCount: state.dataList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 9.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2.0),
                          color: (index % 2 == 0)
                              ? Colors.white
                              : Colors.blueGrey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            'Product: ${state.dataList[index].dPDesc}',
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.0),
                                          child: Text(
                                            "Qty : ${state.dataList[index].dQty} (${state.dataList[index].unitCode})",
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          child: Text(
                                            "Rate : ${state.dataList[index].dLocalRate}",
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0.0),
                                          child: Text(
                                            "Amount : ${state.dataList[index].dBasicAmt}",
                                            overflow:
                                            TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15.0),
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
                    : const NoDataWidget(),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: InkWell(
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.green,
                     borderRadius: BorderRadius.circular(24.0),
                     ),
                     height: 50.0,
                     width: 190.0,
                     child: const Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text('Print',style: TextStyle(
                           fontSize: 18.0,
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                         ),),
                         SizedBox(width: 3.0),
                         Icon(Icons.print,color: Colors.white,),
                       ],
                     ),
                   ),
                   onTap: ()
                   {
                    state.onPrint(name: widget.name);
                   },
                 ),
               ),
              ]),
            ),
            if (state.isLoading) LoadingScreen.loadingScreen(),
          ],
        );
      },
    );
  }
}
