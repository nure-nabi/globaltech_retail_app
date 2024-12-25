import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/products/products_state.dart';

import '../../constants/text_style.dart';
import '../../themes/themes.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'model/product_model.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductState>(context, listen: false).getContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductState>(builder: (context, state, child) {
      return Stack(children: [
        Scaffold(
          appBar: AppBar(title:  Text("Product Groups",style: cardTextStyleHeader,)),
          body: Column(
            children: [
             // verticalSpace(10.0),
             // Text("Product List", style: cardTextStyleHeader),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onChanged: (value) {
                    state.filterProductGroup = value;
                    setState(() {});
                  },
                  decoration: TextFormDecoration.decoration(
                    hintText: "Search Product Groups",
                    hintStyle: hintTextStyle,
                    prefixIcon: Icons.search,
                  ),
                ),
              ),
              Expanded(
                child: state.filterGroupList.isNotEmpty
                    ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.filterGroupList.length,
                  itemBuilder: (context, index) {
                    ProductDataModel indexData =
                    state.filterGroupList[index];
                    Color bgColor = index.isEven ? Colors.white : Colors.grey[200]!;
                    return Container(
                      decoration: ContainerDecoration.decoration(
                        color:bgColor,
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5.0),
                      child: InkWell(
                        onTap: () async {
                          CustomLog.actionLog(
                            value: "GroupName => ${indexData.groupName}",
                          );
                          state.getSelectedGroup = indexData;
                          await state.groupSelected();

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 12.0),
                          child: ArrowListWidget(
                            child: Text(
                              indexData.groupName,
                              style: cardTextStyleProductHeader,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : const NoDataWidget(),
              )
            ],
          ),
        ),
        if (state.isLoading) LoadingScreen.loadingScreen(),
      ]);
    });
  }
}
