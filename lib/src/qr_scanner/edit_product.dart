// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:provider/provider.dart';
//
// import '../../widgets/alert/custom_alert.dart';
// import '../sales/model/product_sales_model.dart';
// import '../sales/sales.dart';
//
// class EditPendingSyncProductDetails extends StatefulWidget {
//   final ProductOrderModel productDetail;
//   final String orderId;
//
//   const EditPendingSyncProductDetails({super.key, required this.productDetail,required this.orderId});
//
//   @override
//   State<EditPendingSyncProductDetails> createState() =>
//       _EditPendingSyncProductDetailsState();
// }
//
// class _EditPendingSyncProductDetailsState
//     extends State<EditPendingSyncProductDetails> {
//   late final _updateQty = TextEditingController(text: "0");
//   late final _updateRate = TextEditingController(text: "0");
//
//   @override
//   void initState() {
//     super.initState();
//     _updateQty.text = widget.productDetail.quantity;
//     _updateRate.text = widget.productDetail.rate;
//   }
//
//   @override
//   void dispose() {
//     _updateQty.dispose();
//     _updateRate.dispose();
//     super.dispose();
//   }
//
//   calculateValue() {
//     if (_updateQty.text.isEmpty || _updateRate.text.isEmpty) {
//       return "0.00";
//     } else {
//       return (double.parse(_updateQty.text) * double.parse(_updateRate.text))
//           .toStringAsFixed(2);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<ProductOrderState>();
//     ProductOrderModel productDetail = widget.productDetail;
//     return CustomAlertWidget(
//       title: productDetail.productName,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Current Value",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             Container(height: 0.5, color: hintColor),
//             verticalSpace(5.0),
//             OrderProductShowList(
//               titleText: 'Quantity ',
//               detailsText: productDetail.quantity,
//             ),
//             OrderProductShowList(
//               titleText: 'Rate ',
//               detailsText: productDetail.rate,
//             ),
//             OrderProductShowList(
//               titleText: 'Balance ',
//               detailsText: productDetail.total,
//             ),
//             verticalSpace(5.0),
//             Container(height: 0.5, color: hintColor),
//             verticalSpace(5.0),
//             const Text(
//               "Update Value",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             verticalSpace(5.0),
//             Container(height: 0.5, color: hintColor),
//             verticalSpace(10.0),
//             Row(children: [
//               Expanded(
//                 child: TextFieldFormat(
//                   textFieldName: "Quantity",
//                   textFormField: TextFormField(
//                     controller: _updateQty,
//                     autofocus: true,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: <TextInputFormatter>[
//                       FilteringTextInputFormatter.digitsOnly
//                     ],
//                     onChanged: (value) async {
//                       await calculateValue();
//                       setState(() {});
//                     },
//                     maxLength: 10,
//                     maxLines: 1,
//                     decoration: TextFormDecoration.decoration(hintText: ""),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: TextFieldFormat(
//                   textFieldName: "Rate",
//                   textFormField: TextFormField(
//                     controller: _updateRate,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: <TextInputFormatter>[
//                       FilteringTextInputFormatter.digitsOnly
//                     ],
//                     onChanged: (value) async {
//                       await calculateValue();
//                       setState(() {});
//                     },
//                     maxLength: 10,
//                     maxLines: 1,
//                     decoration: TextFormDecoration.decoration(hintText: ""),
//                   ),
//                 ),
//               ),
//             ]),
//             OrderProductShowList(
//               titleText: 'Amount ',
//               titleStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.0,
//                 color: Colors.black,
//               ),
//               detailsText: calculateValue(),
//               detailStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.0,
//                 color: Colors.black,
//               ),
//             ),
//             Divider(
//               thickness: 1,
//               color: Colors.grey.shade200,
//               height: 10.0,
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: CancleButton(
//                       buttonName: "CANCEL",
//                       onClick: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                   horizantalSpace(10.0),
//                   Expanded(
//                     child: SaveButton(
//                       buttonName: "CONFIRM",
//                       onClick: () async {
//                         Navigator.pop(context);
//                         await state.updatePendingSyncOrderProductDetail(
//                            productDetail.productCode,
//                            _updateRate.text.trim(),
//                            _updateQty.text.trim(),
//                           widget.orderId,
//                         );
//                         setState(() {
//
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }