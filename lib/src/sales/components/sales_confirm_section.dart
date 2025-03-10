import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/sales/model/outlet_model.dart';
import 'package:retail_app/src/sales/sales_state.dart';
import 'package:retail_app/utils/loading_indicator.dart';
import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';
import '../../imagepicker/image_picker_state.dart';


class OrderConfirmSection extends StatefulWidget {
  const OrderConfirmSection({super.key});

  @override
  State<OrderConfirmSection> createState() => _OrderConfirmSectionState();
}

class _OrderConfirmSectionState extends State<OrderConfirmSection> {
  late int value = 1;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductOrderState>(context, listen: false).onAddCommentInit();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductOrderState>();
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Select Party")),
          body: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            children: [
              FutureBuilder<List<OutletDataModel>>(
                future: state.getDataList(),
                builder: (context, snapshot,) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<OutletDataModel> groupList = snapshot.data!;

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: state.selectedGlCode,
                          hint: const Text('Select Group'),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 0.0,
                          ),
                          items: groupList.map((party) {
                            return DropdownMenuItem<String>(
                              value: party.glCode.toString(),
                              child: Text(party.glDesc.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              state.selectedGlCode = value;
                            });
                          },
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
              const SizedBox(height: 15.0,),
              Form(
                key: state.commentKey,
                child: TextFormField(
                  controller: state.comment,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 30.0),
                  onChanged: (value) {
                    state.commentKey.currentState!.validate();
                  },
                  decoration: TextFormDecoration.decoration(
                    hintText: "Comment",
                    hintStyle: hintTextStyle.copyWith(fontSize: 20.0),
                    containPadding: const EdgeInsets.all(20.0),
                  ),
                ),
              ),
              verticalSpace(10.0),
              ElevatedButton(
                onPressed: () async {
                  if (state.commentKey.currentState!.validate()) {
                    await state.onFinalOrderSaveToDB().whenComplete(() async {
                      state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                      await state.productOrderAPICall(context);
                    });

                  }
                },
                child: const Text("Add Comment"),
              )
            ],
          ),
        ),
        if (state.isLoading) LoadingScreen.loadingScreen()
      ],
    );
  }


}
