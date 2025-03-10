import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../../themes/colors.dart';
import '../../widgets/alert/custom_alert.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/space.dart';
import '../sales/sales.dart';

class ProductOrderScreen extends StatefulWidget {
  const ProductOrderScreen({super.key});

  @override
  State<ProductOrderScreen> createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductOrderState>(context, listen: false).getContext = context;
    Provider.of<ProductOrderState>(context, listen: false).calculate();

  }

  @override
  Widget build(BuildContext context) {
   // Provider.of<ProductOrderState>(context, listen: true);
    return Consumer<ProductOrderState>(
      builder: (context, state, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // InkWell(
              //   onTap: () {},
              //   child: Container(
              //     color: Colors.white,
              //     child: Stack(
              //       alignment: Alignment.bottomRight,
              //       children: [
              //         Center(
              //           child: state.productDetail.images.isNotEmpty?Image.network(
              //             state.productDetail.images.first.getImageUrl(),
              //             height: 170.0,
              //             fit: BoxFit.contain,
              //           ):Image.asset('assets/images/ErrorImage.png'),
              //         ),
              //         IconButton(
              //           onPressed: () {},
              //           icon: Icon(
              //             Icons.visibility,
              //             color: successColor,
              //             size: 40.0,
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              StatefulBuilder(
                builder: (context, void Function(void Function()) setState) {
                  return CustomAlertWidget(
                    title: state.productDetail.pDesc,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(5.0),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Form(
                          key: state.orderFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              verticalSpace(10.0),
                              RowDataWidget(
                                valueFlex: 2,
                                title: "PCode",
                                titleBold: true,
                                valueBold: true,
                                value: state.productDetail.pShortName,
                              ),
                              RowDataWidget(
                                valueFlex: 2,
                                title: "Group",
                                titleBold: true,
                                valueBold: true,
                                value: state.productDetail.groupName,
                              ),
                              RowDataWidget(
                                valueFlex: 2,
                                title: "Sale Rate",
                                titleBold: true,
                                valueBold: true,
                                value: state.productDetail.salesRate,
                              ),
                              Divider(color: hintColor),
                              Container(
                                margin: const EdgeInsets.all(3.0),
                                child: Row(children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Quantity",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(' : ',
                                        textAlign: TextAlign.center),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      controller: state.quantity,
                                      onTap: () {
                                        state.quantity.text = "";
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            state.quantity.text == "0.00") {
                                          return "";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (text) {
                                        state.orderFormKey.currentState!
                                            .validate();
                                        state.calculate();
                                        setState(() {});
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,3}')),
                                      ],
                                      decoration: InputDecoration(
                                        filled: true,
                                        counter: const Offstage(),
                                        isDense: true,
                                        hintText: "",
                                        labelStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                        contentPadding:
                                        const EdgeInsets.all(10.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Container(
                                margin: const EdgeInsets.all(3.0),
                                child: Row(children: [
                                  const Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Sales Rate",
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                  const Expanded(
                                      child: Text(' : ',
                                          textAlign: TextAlign.center)),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      controller: state.salesRate,
                                      onTap: () {
                                        state.salesRate.text = "";
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (text) {
                                        state.orderFormKey.currentState!.validate();
                                        state.calculate();
                                        setState(() {});
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        counter: const Offstage(),
                                        isDense: true,
                                        hintText: "",
                                        labelStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                        contentPadding:
                                        const EdgeInsets.all(10.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Row(children: [
                                const Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Amount",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                const Expanded(
                                    child: Text(' : ',
                                        textAlign: TextAlign.center)),
                                Expanded(
                                    flex: 5,
                                    child: Text(
                                      "${state.totalPrice}",
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ]),
                              Divider(
                                thickness: 1,
                                color: Colors.grey.shade200,
                                height: 10.0,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CancleButton(
                                        buttonName: "CANCEL",
                                        onClick: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    horizantalSpace(10.0),
                                    Expanded(
                                      child: SaveButton(
                                        buttonName: "CONFIRM",
                                        onClick: () async {
                                        //  Provider.of<ProductOrderState>(context,listen: false).init();
                                          await state.saveTempProduct();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class RowDataWidget extends StatelessWidget {
  final String title, value;
  final bool? titleBold, valueBold /*,  showChild */;

  final int? valueFlex;

  // final Widget? child;
  final TextAlign? valueAlign;

  const RowDataWidget({
    super.key,
    required this.title,
    required this.value,
    this.titleBold = false,
    this.valueBold = false,
    this.valueFlex,
    this.valueAlign,

    // this.child,
    // this.showChild = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(children: [
        Expanded(
            child: Text(
              title,
              style: titleBold == true
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : null,
            )),
        const Expanded(child: Text(' : ', textAlign: TextAlign.center)),
        // if (showChild == true)
        Expanded(
          flex: valueFlex ?? 1,
          child: Text(
            value,
            textAlign: valueAlign ?? TextAlign.start,
            style: valueBold == true
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
        ),
      ]),
    );
  }
}

class OrderProductShowList extends StatelessWidget {
  final String titleText, detailsText;
  final TextStyle? titleStyle, detailStyle;

  const OrderProductShowList({
    super.key,
    required this.titleText,
    required this.detailsText,
    this.titleStyle,
    this.detailStyle,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );
    return detailsText.isEmpty
        ? verticalSpace(0)
        : Container(
      margin: const EdgeInsets.all(3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(titleText, style: titleStyle ?? textStyle),
          ),
          Expanded(
            child: Text(":", style: titleStyle ?? textStyle),
          ),
          Expanded(
            flex: 3,
            child: Text(
              detailsText,
              style: detailStyle ?? titleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
