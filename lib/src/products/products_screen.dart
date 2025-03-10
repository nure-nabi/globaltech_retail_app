import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/src/products/products_state.dart';

import '../../constants/assets_list.dart';
import '../../constants/text_style.dart';
import '../../services/router/router_name.dart';
import '../../themes/themes.dart';
import '../../utils/flutter_speed_dial.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../index/components/grid_section.dart';
import '../qr_scanner/qr_list_product.dart';
import '../qr_scanner/qr_scanner.dart';
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
          appBar: AppBar(

            title:  Text("Product Groups",style: cardTextStyleHeader,),
            actions:   [
              IconButton(
                icon: Icon(Icons.sync),
                onPressed: () {
                  state.getDataFromAPI();
                },
              )
            ],
            //getDataFromAPI

          ),
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
          floatingActionButton: FloatingActionButton(
            heroTag: "Options",
            onPressed: () => {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.black.withOpacity(.4),
                  transitionDuration: const Duration(milliseconds: 100),
                  reverseTransitionDuration: const Duration(milliseconds: 100),
                  pageBuilder: (_, __, ___) => const SpeedDialOptionsWidget(),
                ),
              ),

              ///
            },
            child: const Icon(Icons.menu, size: 35.0),
          ),
        ),

        if (state.isLoading) LoadingScreen.loadingScreen(),
      ]);
    });
  }
}
