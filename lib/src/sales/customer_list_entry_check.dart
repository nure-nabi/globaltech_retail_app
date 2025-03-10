// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:retail_app/services/services.dart';
// import 'package:retail_app/src/sales/model/outlet_model.dart';
// import 'package:retail_app/src/sales/sales_state.dart';
// import 'package:retail_app/utils/loading_indicator.dart';
// import '../../../themes/themes.dart';
// import '../../../widgets/widgets.dart';
// import '../../constants/text_style.dart';
// import '../../services/router/router_name.dart';
// import '../../services/sharepref/set_all_pref.dart';
// import '../purchase/vendor_state.dart';
// import 'db/product_sales_db.dart';
// import 'db/temp_product_sales_db.dart';
//
// class CustomerListEntry extends StatefulWidget {
//  final String ledgerName;
//   const CustomerListEntry({super.key,required this.ledgerName});
//
//   @override
//   State<CustomerListEntry> createState() => _CustomerListEntryState();
// }
//
// class _CustomerListEntryState extends State<CustomerListEntry> {
//   final TextEditingController textEditingController = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Provider.of<LedgerState>(context, listen: false).getContext = context;
//     Provider.of<LedgerState>(context, listen: false).init(widget.ledgerName);
//
//    // orderState.clear2();
//
//   }
//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     final state = context.watch<LedgerState>();
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Customer List",style: cardTextStyleHeader,),
//         ),
//         body: Column(
//           children: [
//             Expanded(child:
//             ListView.builder(
//               itemCount: state.LedgerList.length,
//                 itemBuilder: (context,index){
//                   return InkWell(
//                     onTap: ()async{
//                       state.getCustomer = state.LedgerList[index].glDesc;
//                       await  SetAllPref.customerName(value: state.LedgerList[index].glDesc);
//                         String selectedGlCode = state.LedgerList[index].glCode;
//                         String address = state.LedgerList[index].address;
//                         state.selectedGlCode = state.LedgerList[index].glCode;
//                         await  SetAllPref.outLetCode(value: selectedGlCode);
//                         await  SetAllPref.customerAddress(value: address.toString());
//                       SetAllPref.salePurchaseMap(value: "sale");
//                       Navigator.pushNamed(context,productScreenPath);
//                       await ProductOrderDatabase.instance.deleteData();
//                       await TempProductOrderDatabase.instance.deleteData();
//
//                     },
//                     child: Card(
//                       elevation: 1,
//                       child: Padding(
//                           padding: EdgeInsets.only(left: 5,top: 10,bottom: 10,right: 5),
//                         child: Text(state.LedgerList[index].glDesc, style: cardTextStyleProductHeader,),
//                       ),
//                     ),
//                   );
//                 }
//             ))
//           ],
//         )
//     );
//   }
// }
