

import 'dart:convert';
import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/services/router/router_name.dart';

import 'package:retail_app/src/sales/components/sales_confirm_section.dart';
import 'package:retail_app/src/sales/db/temp_product_sales_db.dart';
import 'package:retail_app/src/sales/model/temp_product_sales_model.dart';
import 'package:retail_app/src/sales/sales_screen.dart';
import 'package:retail_app/src/sales/sales_state.dart';
import 'package:retail_app/src/sales_bill_term/sales_bill_term_state.dart';
import 'package:retail_app/utils/alert_dialog.dart';
import 'package:retail_app/widgets/text_form_forrmat.dart';
import '../../../component/scroll_fab.dart';
import '../../../constants/assets_list.dart';
import '../../../constants/text_style.dart';
import '../../../services/sharepref/get_all_pref.dart';
import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../imagepicker/image_picker_screen.dart';
import '../../imagepicker/image_picker_state.dart';
import '../../print_bill/print_bill.dart';

class OrderListSection extends StatefulWidget {
  const OrderListSection({super.key});

  @override
  State<OrderListSection> createState() => _OrderListSectionState();
}

class _OrderListSectionState extends State<OrderListSection> {
  final scrollController = ScrollController();
  List<TextEditingController> _controllers = [] ;
  List<TextEditingController> _controllersAmount = [] ;
  double value = 0.00;
  String purchaseCatagory = "";
  String? imageData;
  String? imageName;
  bool isChecked = false;
  double discAmount = 0.0;
  double vatAmount = 0.0;

  bool flag = false;

  late bool dataInserted = false;

  final List<String> saleTypeList = [
    'Cash',
    'Credit',
    //'Card',
    //'Fonepay',
  ];
  String? selectedValue ="";


  File ? _selectedImage;
  File ? _selectedImage2;

  Future pickImageFromGallery(ProductOrderState state) async {
  final returnimage =  await ImagePicker().pickImage(source: ImageSource.gallery);


  if(returnimage == null) return;
  setState(() async{
    _selectedImage = File(returnimage.path);
    imageName  = returnimage.path.split('/').last;
    imageData = base64Encode(_selectedImage!.readAsBytesSync());
    Uint8List imageBytes = File(_selectedImage!.path).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    //state.setimageName = base64Image!;
   // state.setImageData = base64Image!;
    state.setimageName = await encodeImageFromFile(returnimage.path);
    state.setImageData = await encodeImageFromFile(returnimage.path);
    _showSaveOrderAlertDialog(context,state);
  });
  }


  Future<void> pickImageFromCamera(ProductOrderState state) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _selectedImage = File(croppedFile.path);
        imageName  = pickedFile.path.split('/').last;
        imageData = base64Encode(_selectedImage!.readAsBytesSync());
        Uint8List imageBytes = File(_selectedImage!.path).readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        state.setimageName = base64Image!;
        state.setImageData = base64Image!;
        _showSaveOrderAlertDialog(context,state);
      });
    }
  }

  Future<String> encodeImageFromFile(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      return convertRawImageToBase64(bytes);
    } catch (error) {
      // Handle errors related to file reading or conversion
      print('Error encoding image: $error');
      rethrow; // Re-throw the error for proper handling
    }
  }
  String convertRawImageToBase64(Uint8List imageBytes) {
    // Check if the image bytes are empty
    if (imageBytes.isEmpty) {
      throw Exception('The provided image bytes are empty.');
    }

    // Encode the image bytes to base64 string
    try {
      return base64Encode(imageBytes);
    } catch (error) {
      // Handle any potential encoding errors
      throw Exception('Error encoding image to base64: $error');
    }
  }
  @override
  void initState() {
    super.initState();
     Provider.of<ProductOrderState>(context, listen: false).getContext = context;

     //  Provider.of<ProductOrderState>(context, listen: false);
    Provider.of<SalesTermState>(context, listen: false).termSelected("Bill");
  }

  Future<bool> onBackFromTempList() async {
    return await ShowAlert(context).alert(
      child: ConfirmationWidget(
        title: "PLEASE CONFIRM YOUR ORDER ?",
        description: "Otherwise order will get cleared.",
        onCancel: () async {
          await TempProductOrderDatabase.instance.deleteData().whenComplete(() {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(indexPath, (route) => true);
          });
        },
        onConfirm: () {
          Navigator.popAndPushNamed(context, orderConfirmPath);
        },
      ),
    );
  }

  Future<void> _showSaveOrderAlertDialog(BuildContext context, ProductOrderState state) async {
    Provider.of<ProductOrderState>(context, listen: false).getContext = context;
    flag =false;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Provider.of<ProductOrderState>(context, listen: true);
        //context.watch<ProductOrderState>();
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: ContainerDecoration.decoration(
                        color: primaryColor,
                        bColor: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Align(
                              alignment:
                              Alignment.center ,
                              child: Text(
                               "Are you sure save data?",
                                style: cardTextStyleHeader,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async{
                            await  state.godownClear();
                            await  state.godownListApiCall();
                            },
                              child: const Icon(Icons.sync,color: Colors.white,))
                        ],
                      ),
                    ),

                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10,),
                            state.godownList.isNotEmpty ?
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: DropdownButtonFormField2<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  // Add Horizontal padding using menuItemStyleData.padding so it matches
                                  // the menu padding when button's width is not specified.
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  // Add more decoration..
                                ),
                                hint:  Text(
                                  'Choose Godown',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: state.godownList
                                    .map((item) => DropdownMenuItem<String>(
                                  value: item.godownDesc,
                                  child: Text(
                                    item.godownDesc!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select godown.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {

                                  int index = state.godownList.indexWhere(
                                          (party) => party.godownDesc.toString() == value);
                                  if (index != -1) {
                                    state.getGodownCode = state.godownList[index].godownCode!;
                                  }
                                },
                                onSaved: (value) {
                                //  state.getSalePaymentModeCode = value.toString();

                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 295,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              )

                            ) : SizedBox(),
                            SizedBox(height: 10,),
                            Text('Bill Amount: ${state.calculateTotalAmount()}',style: labelTextStyle),
                            SizedBox(height: 10,),
                            //drop
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: state.salesPaymentModeCode == "" ? DropdownButtonFormField2<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  // Add Horizontal padding using menuItemStyleData.padding so it matches
                                  // the menu padding when button's width is not specified.
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  // Add more decoration..
                                ),
                                hint: const Text(
                                  'Choose Cash/Credit',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: saleTypeList
                                    .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select gender.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {

                                  if(value.toString() == "Cash"){
                                    setState((){});
                                    state.getIsCashOrCredit = "Cash";
                                    state.paymentMode = "Cash";
                                    state.tenderAmount.text = '${state.calculateTotalAmount()}';
                                  }else if(value.toString() == "Credit"){
                                    setState((){});
                                    state.getIsCashOrCredit = "Credit";
                                    state.paymentMode = "Credit";
                                    state.tenderAmount.text ="0.0";
                                  }
                                  state.paymentType = value.toString();
                                 // state.paymentMode
                                 // Fluttertoast.showToast(msg: state.paymentType);
                                },
                                onSaved: (value) {
                                  state.paymentType = value.toString();
                                 // Fluttertoast.showToast(msg: state.paymentType);
                                  // selectedValue = value.toString();
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                              )
                                  : DropdownButtonFormField2<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  // Add Horizontal padding using menuItemStyleData.padding so it matches
                                  // the menu padding when button's width is not specified.
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  // Add more decoration..
                                ),
                                hint:  Text(
                                  'Choose Online Payment',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: const [],
                                onChanged: (value) {},

                              ),
                            ),
                            //drop payment mode
                            SizedBox(height: 10,),
                            state.salePaymentModeList.isNotEmpty ?
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: state.paymentType == "" ? DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                // Add Horizontal padding using menuItemStyleData.padding so it matches
                                // the menu padding when button's width is not specified.
                                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                // Add more decoration..
                              ),
                              hint:  Text(
                                'Choose Online Payment',
                                style: TextStyle(fontSize: 14),
                              ),
                              items: state.salePaymentModeList
                                  .map((item) => DropdownMenuItem<String>(
                                value: item.paymentMode,
                                child: Text(
                                  item.paymentMode!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select gender.';
                                }
                                return null;
                              },
                              onChanged: (value) {

                                // state.paymentType = value.toString();
                                state.getSalePaymentModeCode = value.toString();
                                state.getTenderAmount = "0.0";
                                // Fluttertoast.showToast(msg: state.paymentType);
                              },
                              onSaved: (value) {
                                // state.paymentType = value.toString();
                                state.getSalePaymentModeCode = value.toString();
                                // Fluttertoast.showToast(msg: state.paymentType);
                                // selectedValue = value.toString();
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            )
                                  : DropdownButtonFormField2<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  // Add Horizontal padding using menuItemStyleData.padding so it matches
                                  // the menu padding when button's width is not specified.
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  // Add more decoration..
                                ),
                                hint:  Text(
                                  'Choose Online Payment',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: const [],
                                onChanged: (value) {},

                              ),
                            ) : SizedBox(),

                            SizedBox(height: 10,),

                            Row(
                              children: [
                               // Text(state.isCashOrCredit,style: productTitleTextStyle,),
                                // Switch(
                                //   activeColor: Colors.white,
                                //   value: flag,
                                //   activeTrackColor: primaryColor,
                                //   inactiveThumbColor: Colors.white,
                                //   inactiveTrackColor: Colors.grey.shade300,
                                //   onChanged: (value) async {
                                //     if(value == true){
                                //       flag = true;
                                //       setState((){});
                                //       state.getIsCashOrCredit = "Cash";
                                //       state.paymentMode = "Cash";
                                //       state.tenderAmount.text = '${state.calculateTotalAmount()}';
                                //
                                //     }else if(value == false){
                                //       flag = false;
                                //       setState((){});
                                //       state.getIsCashOrCredit = "Credit";
                                //       state.paymentMode = "Credit";
                                //       state.tenderAmount.text ="0.0";
                                //
                                //     }
                                //    // Fluttertoast.showToast(msg: state.isCashOrCredit);
                                //    // setState((){});
                                //     },
                                // ),
                                // SizedBox(width: 10,),
                                if(state.salesPaymentModeCode.isNotEmpty)...[
                                  ] else if(state.paymentMode == "Credit")...[
                                  Consumer<ProductOrderState>(builder: (BuildContext context, productOrderState, Widget? child) {
                                    if (productOrderState.tenderAmount.text != "") {
                                      return Text('Balance: ${productOrderState
                                          .balanceAmount.toStringAsFixed(2)}',style: labelTextStyle);
                                    } else {
                                      return Text('Balance: 0.0 ${state.salesPaymentModeCode}',style: labelTextStyle);
                                    }
                                  }
                                  )
                                ]

                              ],
                            ),

                            if(state.salesPaymentModeCode.isNotEmpty)...[
                            ]
                            else if(state.paymentMode == "Credit")...[
                              Container(
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    controller: state.tenderAmount,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Tender Amount",
                                    ),
                                    validator: (value){

                                    },
                                    onTap: (){
                                      state.getTenderAmount ="";
                                    },
                                    onChanged: (value) {

                                      state.calculateCash(double.parse(state.calculateTotalAmount()),double.parse(value == "" ? '0':value));
                                      if(value == ""){

                                      }
                                      state.getTenderAmount = value;
                                      if(double.parse(value) > double.parse(state.calculateTotalAmount())){
                                        //  Fluttertoast.showToast(msg: "value.toString");

                                      }else{

                                        // Fluttertoast.showToast(msg: "value.toString()");
                                      }
                                      setState(() {
                                      });


                                    },



                                  ),
                                ),
                              ),
                            ] ,
                            SizedBox(height: 5,),
                            Container(
                              height: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Remarks",
                                  ),
                                   controller: state.comment,
                                  onTap: () {
                                  },
                                  validator: (value) {
                                  },
                                  onChanged: (value) {
                                     state.getComment = value;
                                    setState(() {
                                    });
                                  },
                                ),
                              ),
                            ),
                           //  Container(
                           //    alignment: Alignment.topLeft,
                           //    child: Padding(
                           //      padding: const EdgeInsets.all(8.0),
                           //      child: Row(
                           //        children: [
                           //          Checkbox(
                           //            value: state.isChecked,
                           //            onChanged: (bool? value) {
                           //              state.setImageData ="";
                           //              setState(() {
                           //                state.setIsChecked = value ?? false;
                           //              //  Fluttertoast.showToast(msg: state.isChecked.toString());
                           //              });
                           //
                           //            },
                           //          ),
                           //          const Text(
                           //            'Add Image',
                           //            style: TextStyle(fontSize: 14,color: Colors.green,fontWeight: FontWeight.bold),
                           //          ),
                           //        ],
                           //      ),
                           //    ),
                           //  ),
                           //
                           //  state.isChecked == true ?
                           // Column(
                           //   children: [
                           //     Padding(
                           //       padding: const EdgeInsets.all(8.0),
                           //       child: Row(
                           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           //         children: [
                           //           InkWell(
                           //             onTap :() async {
                           //               setState(() {
                           //                 pickImageFromCamera(state);
                           //                 Navigator.pop(context);
                           //               });
                           //
                           //             },
                           //             child: Container(
                           //               padding: const EdgeInsets.all(14.0),
                           //               decoration: BoxDecoration(
                           //                 // color: Colors.grey,
                           //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
                           //                   border: Border.all(width: 1,color: Colors.black26)
                           //
                           //               ),
                           //               child: const Text("From Camera"),
                           //             ),
                           //           ),
                           //           InkWell(
                           //             onTap: (){
                           //               pickImageFromGallery(state);
                           //               Navigator.pop(context);
                           //             },
                           //             child: Container(
                           //               padding: const EdgeInsets.all(14.0),
                           //               decoration: BoxDecoration(
                           //                 // color: Colors.grey,
                           //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
                           //                   border: Border.all(width: 1,color: Colors.black26)
                           //
                           //               ),
                           //               child: const Text("From Gallary"),
                           //             ),
                           //           )
                           //         ],
                           //       ),
                           //
                           //     ),
                           //
                           //     Padding(
                           //       padding: const EdgeInsets.all(8.0),
                           //       child: Container(
                           //         child: _selectedImage == null
                           //             ? const Text('No image selected')
                           //             : Image.file(_selectedImage!,height: 100,width: 400,),
                           //       ),
                           //     ),
                           //   ],
                           // ): const SizedBox(),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Checkbox(
                                        value: state.isImageAdd,
                                        onChanged: (value) {

                                          state.getIsImageAdd = value!;
                                          setState(() {
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Add Image",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (state.isImageAdd)
                                  Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 10.0,
                                    ),
                                    color: Colors.white,
                                    child: const ImagePickerScreen(
                                      isHeaderShow: false,
                                      isCropperEnable: true,
                                    ),
                                  )
                              ],
                            ),
                          //  const SizedBox(height: 5.0),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: (){
                                       // state.setIsChecked = false;
                                        Navigator.pop(context);
                                       // state.printNative();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFC53030),
                                        foregroundColor: const Color(0xFFFFFFFF),
                                        padding: const EdgeInsets.symmetric(vertical: 0),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text("No"),
                                    ),
                                  ),

                                  horizantalSpace(5.0),
                                 Consumer<ProductOrderState>(builder: (BuildContext context, state, Widget? child) {


                                   return  Expanded(
                                       flex: 2,
                                       child:  ElevatedButton(
                                         onPressed: state.dataInserted == true ? null : () async {
                                           state.setIsChecked = false;
                                           state.PrintOrNot = "pdf";
                                          // if(state.isCashOrCredit == "Cash") {
                                           if(state.paymentType == "Cash") {
                                             if(state.tenderAmount.text.isNotEmpty && state.tenderAmount.text != null && state.paymentType.isNotEmpty){

                                               if (double.parse(state.tenderAmount.text) == double.parse(state.calculateTotalAmount()) ) {
                                                 state.setDataInserted = true;
                                                 setState(() {

                                                 });
                                                 // await state.onFinalOrderSaveToDB()
                                                 //     .whenComplete(() async {
                                                 //   state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                                                 //   await state.productOrderAPICall(
                                                 //       context);
                                                 // });
                                                 state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                                                 await state.productOrderAPICall(context).whenComplete(() async {
                                                 });

                                               } else {
                                                 Fluttertoast.showToast(
                                                     msg: "Please enter valid tender amount");
                                               }
                                             }else {
                                               Fluttertoast.showToast(
                                                   msg: "Please enter amount");
                                             }
                                           }else{
                                             state.setDataInserted = true;
                                             setState(() {
                                             });
                                             // await state.onFinalOrderSaveToDB()
                                             //     .whenComplete(() async {
                                             //   state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                                             //   await state.productOrderAPICall(
                                             //       context);
                                             // });
                                             state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                                             await state.productOrderAPICall(context).whenComplete(() async {
                                             });
                                           }
                                         },
                                         child: const Padding(
                                           padding:  EdgeInsets.all(4),
                                           child: Text("Save Pdf",

                                           ),
                                         ),
                                       )
                                   );
                                 },),
                                  // Expanded(
                                  //  flex: 2,
                                  //   child: SaveButton(
                                  //     buttonName: "Save Pdf",
                                  //     onClick: () async {
                                  //       state.setIsChecked = false;
                                  //       state.PrintOrNot = "pdf";
                                  //       if(state.isCashOrCredit == "Cash") {
                                  //         if(state.tenderAmount.text.isNotEmpty && state.tenderAmount.text != null){
                                  //           if (double.parse(state.tenderAmount.text) == double.parse(state.calculateTotalAmount()) ) {
                                  //
                                  //             await state.onFinalOrderSaveToDB()
                                  //                 .whenComplete(() async {
                                  //               state.getBillImage = Provider
                                  //                   .of<ImagePickerState>(
                                  //                   context, listen: false)
                                  //                   .myPickedImage;
                                  //               await state.productOrderAPICall(
                                  //                   context);
                                  //             });
                                  //
                                  //             // await state.productOrderAPICall(context)
                                  //             //     .whenComplete(() async {
                                  //             //   state.getBillImage = Provider
                                  //             //       .of<ImagePickerState>(
                                  //             //       context, listen: false)
                                  //             //       .myPickedImage;
                                  //             //   await state.onFinalOrderSaveToDB(
                                  //             //       );
                                  //             // });
                                  //           } else {
                                  //             Fluttertoast.showToast(
                                  //                 msg: "Please enter valid tender amount");
                                  //           }
                                  //         }else {
                                  //           Fluttertoast.showToast(
                                  //               msg: "Please enter amount");
                                  //         }
                                  //
                                  //
                                  //       }else{
                                  //         await state.onFinalOrderSaveToDB()
                                  //             .whenComplete(() async {
                                  //           state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                                  //           await state.productOrderAPICall(
                                  //               context);
                                  //         });
                                  //       }
                                  //     //  Navigator.pushNamedAndRemoveUntil(context, indexPath, (route) => false);
                                  //     },
                                  //   ),
                                  // ),
                                //  horizantalSpace(2.0),


                                  // Expanded(
                                  //   flex: 2,
                                  //   child: SaveButton(
                                  //     buttonName: "Save Print",
                                  //     onClick: () async {
                                  //       if(state.comment.text.isNotEmpty) {
                                  //         ShowDialog(context: context).dialog(
                                  //           child: const OrderDetailsAlert(),
                                  //         );
                                  //      //   Navigator.pop(context);
                                  //       } else{
                                  //         Fluttertoast.showToast(msg: "Please enter remarks");
                                  //       }
                                  //
                                  //     },
                                  //   ),
                                  // ),
                                  horizantalSpace(5.0),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        if(state.paymentType.isNotEmpty) {
                                          Navigator.pop(context);
                                          ShowDialog(context: context).dialog(
                                            child: const OrderDetailsAlert(),);
                                          //   Navigator.pop(context);
                                        } else if(state.salesPaymentModeCode.isNotEmpty){
                                          Navigator.pop(context);
                                          ShowDialog(context: context).dialog(
                                            child: const OrderDetailsAlert(),);
                                        }else{
                                          Fluttertoast.showToast(msg: "Please select payment type!!!");
                                        }
                                        },
                                      child: const Text("Save Print"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           // verticalSpace(2.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
   //  final state = Provider.of<ProductOrderState>(context, listen: true);
   //
   // // final statePurchaseOrder = context.watch<PurchaseOrderState>();
   //  //final stateSalesTerm = context.watch<SalesTermState>();
   //  final stateSalesTerm =  Provider.of<SalesTermState>(context, listen: true);
   // // Fluttertoast.showToast(msg: "Build");
   // // _controllersAmount.clear();
   //  for(int i=0; i<stateSalesTerm.termList.length; i++){
   //    _controllers.add(TextEditingController());
   //    _controllersAmount.add(TextEditingController());
   //  }
   // Fluttertoast.showToast(msg:  "build");
    return Consumer<ProductOrderState>(builder: (BuildContext context, state, Widget? child) {

      return Scaffold(
        appBar: AppBar(title:  Text("Product Sales List",style: cardTextStyleHeader,),
          actions:  [
            // InkWell(
            //   onTap: () {
            //
            //     // Navigator.pushNamedAndRemoveUntil(
            //     //     context, productListPath, (route) => false);
            //
            //     Navigator.pop(context, productListPath);
            //   },
            //   child: Container(
            //     child: const Row(
            //       children: [
            //         Text("Add Product",style: TextStyle(fontWeight: FontWeight.w500),),
            //         SizedBox(width: 10.0,),
            //         Icon(Icons.card_travel),
            //         SizedBox(width: 10.0,),
            //       ],
            //     ),
            //   ),
            // ),
            InkWell(
              onTap :(){
                // state.getTotalBillWise = 0.00;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final orderState = Provider.of<ProductOrderState>(context, listen: true);
                    final stateSalesTerm = Provider.of<SalesTermState>(context, listen: true);
                    for(int i=0; i<stateSalesTerm.termList.length; i++){
                      _controllers.add(TextEditingController());
                      _controllersAmount.add(TextEditingController());
                    }
                    orderState.clear();
                    return AlertDialog(
                      title:  const Text('Bill Term',),
                      content: Form(
                        key: state.orderFormKey,
                        child: Container(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child:  Row(
                                  //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,

                                  children: [
                                    const Text("Amount :",style: TextStyle(fontWeight: FontWeight.w700),),
                                    const SizedBox(width: 55,),
                                    Text("${state.calculateTotalAmount()}",style: const TextStyle(fontWeight: FontWeight.w700),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Visibility(
                                visible: true,
                                child: Row(
                                  children: [
                                    Expanded(child: Container(
                                      child: const Text("Description",style: TextStyle(fontWeight: FontWeight.w500),),
                                    )),
                                    Expanded(child: Container(
                                      alignment: Alignment.center,
                                      child: const Text("Rate%",style: TextStyle(fontWeight: FontWeight.w500),),
                                    )),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Container(
                                      child: const Text("Amount",style: TextStyle(fontWeight: FontWeight.w500),),
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              stateSalesTerm.termList.isNotEmpty ?
                              SizedBox(
                                height: 140, // Adjust height as needed
                                width: double.maxFinite,
                                child: ListView.builder(
                                    itemCount: stateSalesTerm.termList.length,
                                    itemBuilder: (context, index){
                                      // if(state.bTerm1Amount > 1){
                                      //   _controllersAmount[0].text = state.bTerm1Amount.toStringAsFixed(2);
                                      // } else  if(state.bTerm2Amount > 1){
                                      //   _controllersAmount[1].text = state.bTerm2Amount.toStringAsFixed(2);
                                      // }else  if(state.bTerm3Amount > 1){
                                      //   _controllersAmount[2].text = state.bTerm3Amount.toStringAsFixed(2);
                                      // }



                                      return Container(
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex:2,
                                                child: Container(
                                                  child: Text(stateSalesTerm.termList[index].pTDesc,style: const TextStyle(fontSize: 14.0),),
                                                )),


                                            Expanded(
                                                flex:1,
                                                child: Container (
                                                  child: TextFormField(
                                                    maxLength: 2,
                                                    controller: _controllers[index],
                                                    onTap: () {
                                                      // state.getDisAmountRate  =  0.00;
                                                      // Fluttertoast.showToast(msg: index[0].toString());
                                                    },
                                                    onChanged: (value) {
                                                      state.orderFormKey.currentState!.validate();
                                                      double temt = 0.00;
                                                      if(index == 0)
                                                      {
                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          String disValue = value;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double temt = 0.00;
                                                          double disAmt = (double.parse(state.calculateTotalAmount()) * double.parse(disValue)) / 100;
                                                          double totalAmt = double.parse(state.calculateTotalAmount()) - disAmt;
                                                          double netAmt =  double.parse(state.calculateTotalAmount()) - totalAmt;
                                                          _controllersAmount[0].text = "- ${disAmt.toStringAsFixed(2)}";
                                                          temt = totalAmt;
                                                          state.getBTerm1Rate = double.parse(disValue);
                                                          state.setBillDiscountRateAmount = totalAmt;
                                                          state.getBTerm1Amount =  netAmt;
                                                          state.getBTerm1 = stateSalesTerm.termList[index].pTCode;
                                                          if(_controllers[index].text.isEmpty){
                                                            _controllersAmount[0].text = "";

                                                            state.setBillDiscountRate = 0.00;
                                                          }
                                                          state.getBSign1 = stateSalesTerm.termList[index].sign;
                                                        } else  if(stateSalesTerm.termList[index].sign == "+"){
                                                          String disValue = value;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }

                                                          if(state.bTerm1Rate > 0){
                                                            //  Fluttertoast.showToast(msg: state.billDiscountRate.toString());
                                                          }else{
                                                            state.setBillDiscountRateAmount = 0.00;
                                                            state.setBillVatAmount = 0.00;
                                                            state.setBillDiscountAmount = 0.00;
                                                          }
                                                          if(state.billDiscountRateAmount > 0){
                                                            double disAmt = state.billDiscountRateAmount * double.parse(disValue) / 100;
                                                            double totalAmt = state.billDiscountRateAmount - disAmt;
                                                            double netAmt =  state.billDiscountRateAmount - totalAmt;
                                                            _controllersAmount[0].text = "+ ${disAmt.toStringAsFixed(2)}";
                                                            state.getBTerm1Rate = double.parse(disValue);
                                                            state.getBTerm1Amount = netAmt;
                                                            state.getBTerm1 = stateSalesTerm.termList[index].pTCode;
                                                          }else{
                                                            double disAmt = (double.parse(state.calculateTotalAmount()) * double.parse(disValue)) / 100;
                                                            double totalAmt = double.parse(state.calculateTotalAmount()) - disAmt;
                                                            double netAmt =  double.parse(state.calculateTotalAmount()) - totalAmt;
                                                            _controllersAmount[0].text = "+ ${disAmt.toStringAsFixed(2)}";
                                                            state.getBTerm1Rate = double.parse(disValue);
                                                            state.getBTerm1Amount = netAmt;
                                                            state.getBTerm1 = stateSalesTerm.termList[index].pTCode;
                                                          }
                                                          if(_controllers[index].text == ""){
                                                            _controllersAmount[0].text = "";
                                                          }
                                                          state.getBSign1 = stateSalesTerm.termList[index].sign;
                                                        }

                                                      }else if(index == 1){
                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          String disValue = value;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double temt = 0.00;
                                                          double disAmt = (double.parse(state.calculateTotalAmount()) * double.parse(disValue)) / 100;
                                                          double totalAmt = double.parse(state.calculateTotalAmount()) - disAmt;
                                                          double netAmt =  double.parse(state.calculateTotalAmount()) - totalAmt;
                                                          _controllersAmount[index].text = "- ${disAmt.toStringAsFixed(2)}";
                                                          temt = totalAmt;
                                                          state.getBTerm2Rate = double.parse(disValue);
                                                          state.setBillDiscountRateAmount = totalAmt;
                                                          state.getBTerm2Amount =  netAmt;
                                                          state.getBTerm2 = stateSalesTerm.termList[index].pTCode;
                                                          if(_controllers[index].text.isEmpty){
                                                            _controllersAmount[index].text = "";
                                                            state.setBillDiscountRate = 0.00;
                                                          }
                                                          state.getBSign2 = stateSalesTerm.termList[index].sign;
                                                        }else if(stateSalesTerm.termList[index].sign == "+"){
                                                          String disValue = value;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          if(state.bTerm1Rate > 0){
                                                          }else{
                                                            state.setBillDiscountRateAmount = 0.00;
                                                            state.setBillVatAmount = 0.00;
                                                            state.setBillDiscountAmount = 0.00;
                                                          }
                                                          if(state.billDiscountRateAmount > 0){
                                                            double disAmt = state.billDiscountRateAmount * double.parse(disValue) / 100;
                                                            double totalAmt = state.billDiscountRateAmount - disAmt;
                                                            double netAmt =  state.billDiscountRateAmount - totalAmt;
                                                            _controllersAmount[index].text = "+ ${disAmt.toStringAsFixed(2)}";
                                                            state.getBTerm2Rate = double.parse(disValue);
                                                            state.getBTerm2Amount = netAmt;
                                                            state.getBTerm2 = stateSalesTerm.termList[index].pTCode;
                                                          }else{
                                                            double disAmt = (double.parse(state.calculateTotalAmount()) * double.parse(disValue)) / 100;
                                                            double totalAmt = double.parse(state.calculateTotalAmount()) - disAmt;
                                                            double netAmt =  double.parse(state.calculateTotalAmount()) - totalAmt;
                                                            _controllersAmount[index].text = "+ ${disAmt.toStringAsFixed(2)}";
                                                            state.getBTerm2Rate = double.parse(disValue);
                                                            state.getBTerm2Amount = netAmt;
                                                            state.getBTerm2 = stateSalesTerm.termList[index].pTCode;
                                                          }
                                                          if(_controllers[index].text == ""){
                                                            _controllersAmount[index].text = "";
                                                          }
                                                          state.getBSign2 = stateSalesTerm.termList[index].sign;
                                                        }

                                                      } else if(index == 2){
                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          String disValue = value;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          double temt = 0.00;
                                                          double disAmt = (double.parse(state.calculateTotalAmount()) * double.parse(disValue)) / 100;
                                                          double totalAmt = double.parse(state.calculateTotalAmount()) - disAmt;
                                                          double netAmt =  double.parse(state.calculateTotalAmount()) - totalAmt;
                                                          _controllersAmount[2].text = "- ${disAmt.toStringAsFixed(2)}";
                                                          temt = totalAmt;
                                                          state.getBTerm3Rate = double.parse(disValue);
                                                          state.setBillDiscountRateAmount = totalAmt;
                                                          state.getBTerm3Amount =  netAmt;
                                                          state.getBTerm3 = stateSalesTerm.termList[index].pTCode;
                                                          if(_controllers[index].text.isEmpty){
                                                            _controllersAmount[2].text = "";
                                                            state.setBillDiscountRate = 0.00;
                                                          }
                                                          state.getBSign3 = stateSalesTerm.termList[index].sign;
                                                        }else if(stateSalesTerm.termList[index].sign == "+"){
                                                          String disValue = value;
                                                          if(value == ""){
                                                            disValue ="0";
                                                          }
                                                          if(_controllers[index].text == ""){
                                                            _controllersAmount[2].text = "";
                                                          }
                                                          if(state.bTerm1Rate > 0){
                                                          }else{
                                                            state.setBillDiscountRateAmount = 0.00;
                                                            state.setBillVatAmount = 0.00;
                                                            state.setBillDiscountAmount = 0.00;
                                                          }
                                                          if(state.billDiscountRateAmount > 0){
                                                            double disAmt = state.billDiscountRateAmount * double.parse(disValue) / 100;
                                                            double totalAmt = state.billDiscountRateAmount - disAmt;
                                                            double netAmt =  state.billDiscountRateAmount - totalAmt;
                                                            _controllersAmount[2].text = "+ ${disAmt.toStringAsFixed(2)}";
                                                            state.getBTerm3Rate = double.parse(disValue);
                                                            state.getBTerm3Amount = netAmt;
                                                            state.getBTerm3 = stateSalesTerm.termList[index].pTCode;
                                                          }else{
                                                            double disAmt = (double.parse(state.calculateTotalAmount()) * double.parse(disValue)) / 100;
                                                            double totalAmt = double.parse(state.calculateTotalAmount()) - disAmt;
                                                            double netAmt =  double.parse(state.calculateTotalAmount()) - totalAmt;
                                                            _controllersAmount[2].text = "+ ${disAmt.toStringAsFixed(2)}";
                                                            state.getBTerm3Rate = double.parse(disValue);
                                                            state.getBTerm3Amount = netAmt;
                                                            state.getBTerm3 = stateSalesTerm.termList[index].pTCode;
                                                          }
                                                          state.getBSign3 = stateSalesTerm.termList[index].sign;
                                                        }

                                                      }
                                                      state.calculateBillTerm();
                                                      setState(() {
                                                      });
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
                                                )),
                                            const SizedBox(width: 3,),
                                            Expanded(
                                                flex:2,
                                                child: Container (
                                                  child: TextFormField(
                                                    controller: _controllersAmount[index],
                                                    onTap: () {
                                                    },
                                                    validator: (value) {
                                                    },
                                                    onChanged: (value) {
                                                      state.orderFormKey.currentState!.validate();
                                                      if(index == 0){
                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          if(value == ""){
                                                            value ="0";
                                                          }
                                                          state.getBTerm1Amount = double.parse(value);
                                                          state.getBSign1 = stateSalesTerm.termList[index].sign;
                                                          state.getBTerm1 = stateSalesTerm.termList[index].pTCode;
                                                        }else  if(stateSalesTerm.termList[index].sign == "+"){
                                                          if(value == ""){
                                                            value ="0";
                                                          }
                                                          state.getBTerm1Amount = double.parse(value);
                                                          state.getBSign1 = stateSalesTerm.termList[index].sign;
                                                          state.getBTerm1 = stateSalesTerm.termList[index].pTCode;
                                                        }


                                                      }else if(index == 1){
                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          if(value == ""){
                                                            value ="0";
                                                          }
                                                          state.getBTerm2Amount = double.parse(value);
                                                          state.getBSign2 = stateSalesTerm.termList[index].sign;
                                                          state.getBTerm2 = stateSalesTerm.termList[index].pTCode;
                                                        }else  if(stateSalesTerm.termList[index].sign == "+"){
                                                          if(value == ""){
                                                            value ="0";
                                                          }
                                                          state.getBTerm2Amount = double.parse(value);
                                                          state.getBSign2 = stateSalesTerm.termList[index].sign;
                                                          state.getBTerm2 = stateSalesTerm.termList[index].pTCode;
                                                        }

                                                      }else if(index == 2){
                                                        if(stateSalesTerm.termList[index].sign == "-"){
                                                          if(value == ""){
                                                            value ="0";
                                                          }
                                                          state.getBTerm3Amount = double.parse(value);
                                                          state.getBSign3 = stateSalesTerm.termList[index].sign;
                                                          state.getBTerm3 = stateSalesTerm.termList[index].pTCode;
                                                        }else  if(stateSalesTerm.termList[index].sign == "+"){
                                                          if(value == ""){
                                                            value ="0";
                                                          }
                                                          state.getBTerm3Amount = double.parse(value);
                                                          state.getBSign3 = stateSalesTerm.termList[index].sign;
                                                          state.getBTerm3 = stateSalesTerm.termList[index].pTCode;
                                                        }
                                                      }
                                                      state.calculateBillTerm();
                                                      setState(() {
                                                      });
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
                                                )),
                                            const SizedBox(width: 5,),

                                          ],
                                        ),

                                      );
                                    }
                                ),
                              ):const SizedBox(),
                              const SizedBox(height: 10,),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total :",style: cardTextStyleProductHeader,),
                                  Text(state.totalBillWise == 0.0 ? state.calculateTotalAmount() : state.totalBillWise.toString(),style: cardTextStyleProductHeader,),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      actions: [
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
                                    // state.getBTerm1Amount = 0.0;
                                    // state.getBTerm2Amount = 0.0;
                                    // state.getBTerm3Amount = 0.0;
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              horizantalSpace(10.0),
                              Expanded(
                                child: SaveButton(
                                  buttonName: "CONFIRM",
                                  onClick: () async {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                child:  Row(
                  children: [
                    Text("Bill Wise",style: cardTextStyleHeader,),
                    const SizedBox(width: 10.0,),
                    const Icon(Icons.report),
                    const SizedBox(width: 10.0,),
                  ],
                ),
              ),
            )
          ],

        ),
        bottomNavigationBar: Container(
          decoration: ContainerDecoration.decoration(
              color: borderColor, bColor: borderColor
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // color: Colors.orange,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, right: 10.0, left: 10.0, bottom: 5.0),
                      child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text("Total",style: cardTextStyleSalePurchase,),
                              ),
                              const Expanded(
                                child: Text(":"),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${state.calculateTotalAmount()}",style: cardTextStyleSalePurchase,
                                ),
                              ),
                            ],
                          )
                      )

                  ),
                ),
                state.bTerm1Amount > 1 || state.bTerm2Amount > 1?
                Column(
                  children: [
                    Container(
                      // color: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 10.0, left: 10.0, bottom: 5.0),
                        child: state.discBill2 > 0 ?Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Discount",style: cardTextStyleSalePurchase,),
                                ),
                                const Expanded(
                                  child: Text(":"),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(

                                    '- ${state.discBill2.toStringAsFixed(2)}',style: cardTextStyleSalePurchase,
                                  ),
                                ),
                              ],
                            )
                        ) : SizedBox(),

                      ),
                    ),
                    Container(
                      // color: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 10.0, left: 10.0, bottom: 5.0),
                        child : state.vatBill2 > 0 ? Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text("Vat",style: cardTextStyleSalePurchase,),
                                ),
                                const Expanded(
                                  child: Text(":"),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '+ ${state.vatBill2.toStringAsFixed(2)}',style: cardTextStyleSalePurchase,
                                  ),
                                ),
                              ],
                            )
                        ) : SizedBox(),

                      ),
                    ),
                    Container(
                      // color: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 10.0, left: 10.0, bottom: 0.0),
                        child: OrderProductShowList(
                          titleText: "Net Total",
                          titleStyle: productTitleTextStyle,
                          detailsText: (double.parse(state.calculateTotalAmount()) - state.discBill2 + state.vatBill2).toStringAsFixed(2),
                          detailStyle: productTitleTextStyle,
                        ),
                      ),
                    ),
                  ],
                ) : const SizedBox(),

                ElevatedButton(

                  onPressed: (){
                    state.getComment="";
                    state.getTenderAmount="";
                    state.getIsCashOrCredit="Credit";
                    _showSaveOrderAlertDialog(context,state);
                  },
                  child:  Text("Confirm Sales",style:  cardTextStyleHeader),
                ),
              ],
            ),
          ),
        ),
        body: state.allTempOrderList.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: state.allTempOrderList.length,
          itemBuilder: (context, index) {
            TempProductOrderModel indexData = state.allTempOrderList[index];
             //Fluttertoast.showToast(msg: indexData.altUnit.toString());
            // String vatAmount = (double.parse(indexData.rate)*double.parse(indexData.quantity)* 0.13).toStringAsFixed(2);
            // state.setVatAmt = double.parse(indexData.totalAmount);

            if(indexData.sign1 == "-"){
              discAmount = double.parse(indexData.pTerm1Amount);
            } else if(indexData.sign1 == "+"){
              vatAmount = double.parse(indexData.pTerm1Amount);
            }
            if(indexData.sign2 == "-"){
              discAmount = double.parse(indexData.pTerm2Amount);
            } else if(indexData.sign2 == "+"){
              vatAmount = double.parse(indexData.pTerm2Amount);
            }
            if(indexData.sign3 == "-"){
              discAmount = double.parse(indexData.pTerm3Amount);
            } else if(indexData.sign3 == "+"){
              vatAmount = double.parse(indexData.pTerm3Amount);
            }

            return Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Product: ${indexData.pName}',
                              style: cardTextStyleProductHeader,
                            ),
                            verticalSpace(10.0),
                            RowDataWidget(
                              title: "Qty",
                              value: indexData.quantity,
                              valueAlign: TextAlign.end,
                            ),
                            RowDataWidget(
                              title: "Price",
                              value: "${(double.parse(indexData.rate)).toStringAsFixed(2)}",
                              valueAlign: TextAlign.end,
                            ),
                            RowDataWidget(
                              title: "Amount",
                              titleBold: true,
                              valueBold: true,
                              valueAlign: TextAlign.end,
                              value:
                              "${(double.parse(indexData.rate) * double.parse(indexData.quantity)).toStringAsFixed(2)}",
                            ),
                            RowDataWidget(
                              title: "Discount",
                              valueAlign: TextAlign.end,
                              value: discAmount.toStringAsFixed(2),
                            ),
                            RowDataWidget(
                              title: "V.AMOUNT",
                              valueAlign: TextAlign.end,
                              value: vatAmount.toStringAsFixed(2),
                            ),

                            verticalSpace(5.0),
                            const CustomDottedDivider(
                              color: Colors.black,
                            ),
                            verticalSpace(5.0),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(children: [
                                Expanded(
                                  child: Text(
                                    "Total",
                                    style: cardTextStyleProductHeader,
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    ' : ',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    indexData.totalAmount,
                                    textAlign: TextAlign.end,
                                    style: cardTextStyleProductHeader,
                                  ),
                                ),
                              ]),
                            ),
                          ]),
                    ),



                    // IconButton(
                    //   onPressed: () async {
                    //     setState((){
                    //
                    //     });
                        // bool? confirmDelete = await showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return AlertDialog(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //       title: const Text("Remove Product"),
                        //       content: const Text(
                        //           "Are you sure you want to remove this product?"),
                        //       actions: [
                        //         TextButton(
                        //           onPressed: () => Navigator.of(context).pop(false),
                        //           child: Text("Cancel",
                        //               style: TextStyle(color: Colors.grey[600])),
                        //         ),
                        //         TextButton(
                        //           onPressed: () => Navigator.of(context).pop(true),
                        //           child: const Text("Yes",
                        //               style: TextStyle(color: Colors.red)),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // );
                        // if (confirmDelete == true) {
                        //   state.getTotalBillWise = 0.0;
                        //   await state.dublicateProduct(
                        //     productID: indexData.id.toString(),
                        //   );
                        //   setState(() {});
                        //   //  Navigator.pop(context);
                        //   // stateQR.deleteTempOrderProduct(productID: item.productCode,orderId:item.orderId);
                        // }
                    //  },
                    //   icon: const Icon(
                    //     EvaIcons.trash2Outline,
                    //     color: Colors.red,
                    //   ),
                    //   iconSize: 20,
                    // ),

                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              ShowAlert(context).alert(
                                child: ConfirmationWidget(
                                  title: 'Are you sure ?',
                                  description:
                                  'You want to delete this product.',
                                  onConfirm: () async {
                                    try {
                                      state.getTotalBillWise = 0.0;
                                      await state.dublicateProduct(
                                        productID: indexData.id.toString(),
                                      );
                                      setState(() {});
                                      Navigator.pop(context);
                                    } catch (e) {
                                      print("Error: $e"); // Log the error for debugging
                                    }
                                  },
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.delete_forever,
                              color: errorColor,
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: IconButton(
                              onPressed: () {
                                ShowAlert(context).alert(
                                    child: EditOrderProductDetails(
                                      productDetail: indexData,
                                    ));
                              },
                              icon: Icon(Icons.edit, color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
            : const NoDataWidget(),
        floatingActionButton: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context, productListPath);
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child:  Center(
                          child: Text(
                            'Add New Item',
                            style: cardTextStyleHeader,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
       // floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        //floatingActionButton: ScrollFab(scrollController),
        // ),
      );
    },);
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
              style: cardTextStyleProductHeader,
            )),
        const Expanded(child: Text(' : ', textAlign: TextAlign.center)),
        // if (showChild == true)
        Expanded(
          flex: valueFlex ?? 1,
          child: Text(
            value,
            textAlign: valueAlign ?? TextAlign.start,
            style: cardTextStyleSalePurchase,
          ),
        ),
        // if (showChild == false)
        //   Expanded(flex: valueFlex ?? 1, child: child ?? horizantalSpace(0.0)),
      ]),
    );
  }
}

class EditOrderProductDetails extends StatefulWidget {
  final TempProductOrderModel productDetail;

  const EditOrderProductDetails({super.key, required this.productDetail});

  @override
  State<EditOrderProductDetails> createState() =>
      _EditOrderProductDetailsState();
}

class _EditOrderProductDetailsState extends State<EditOrderProductDetails> {
  late final _updateQty = TextEditingController(text: "0");
  late final _updateRate = TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
    _updateQty.text = widget.productDetail.quantity;
    _updateRate.text = widget.productDetail.rate;
  }

  @override
  void dispose() {
    _updateQty.dispose();
    _updateRate.dispose();
    super.dispose();
  }

  calculateValue() {
    if (_updateQty.text.isEmpty || _updateRate.text.isEmpty) {
      return "0.00";
    } else {
      return (double.parse(_updateQty.text) * double.parse(_updateRate.text))
          .toStringAsFixed(2);
    }
  }

  ///// edit of the selected item
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductOrderState>();
    TempProductOrderModel productDetail = widget.productDetail;
    return CustomAlertWidget(
      title: productDetail.pName,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Current Value",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(height: 0.5, color: hintColor),
            verticalSpace(5.0),
            OrderProductShowList(
              titleText: 'Quantity ',
              detailsText: productDetail.quantity,
            ),
            OrderProductShowList(
              titleText: 'Rate ',
              detailsText: productDetail.rate,
            ),
            OrderProductShowList(
              titleText: 'Balance ',
              detailsText: productDetail.totalAmount,
            ),
            verticalSpace(5.0),
            Container(height: 0.5, color: hintColor),
            verticalSpace(5.0),
            const Text(
              "Update Value",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            verticalSpace(5.0),
            Container(height: 0.5, color: hintColor),
            verticalSpace(10.0),
            Row(children: [
              Expanded(
                child: TextFieldFormat(
                  textFieldName: "Quantity",
                  textFormField: TextFormField(
                    controller: _updateQty,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) async {
                      await calculateValue();
                      setState(() {});
                    },
                    maxLength: 10,
                    maxLines: 1,
                    decoration: TextFormDecoration.decoration(hintText: ""),
                  ),
                ),
              ),
              Expanded(
                child: TextFieldFormat(
                  textFieldName: "Rate",
                  textFormField: TextFormField(
                    controller: _updateRate,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) async {
                      await calculateValue();
                      setState(() {});
                    },
                    maxLength: 10,
                    maxLines: 1,
                    decoration: TextFormDecoration.decoration(hintText: ""),
                  ),
                ),
              ),
            ]),
            OrderProductShowList(
              titleText: 'Amount ',
              titleStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black,
              ),
              detailsText: calculateValue(),
              detailStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade200,
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        Navigator.pop(context);
                        await state.updateTempOrderProductDetail(
                          productID: productDetail.pCode,
                          rate: _updateRate.text.trim(),
                          quantity: _updateQty.text.trim(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class OrderDetailsAlert extends StatefulWidget {
  const OrderDetailsAlert({super.key});

  @override
  State<OrderDetailsAlert> createState() => _OrderDetailsAlertState();
}

class _OrderDetailsAlertState extends State<OrderDetailsAlert> {

  bool dataInserted = false;

  @override
  Widget build(BuildContext context) {
     //final stateQR = context.read()<ProductOrderState>();
     final stateQR = Provider.of<ProductOrderState>(context,listen: true);
    final double subtotal = stateQR.allTempOrderList.fold(
      0.0,
          (sum, item) =>
      sum + (double.tryParse(item.rate) ?? 0) * (double.tryParse(item.quantity) ?? 0),
    );
     stateQR.getSubTotal = subtotal;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Center(child: Text('Order Invoice',  style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A5568),
              fontSize: 16,
            ),),),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A5568),
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A5568),
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Rate',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A5568),
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A5568),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DottedLine(),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5, // Limit height to 50% of screen
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                shrinkWrap: true, // Allows ListView to size itself
                physics: const BouncingScrollPhysics(),
                itemCount: stateQR.allTempOrderList.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = stateQR.allTempOrderList[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.pName,
                            style: const TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.quantity,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            double.parse(item.rate).toStringAsFixed(2),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4A5568),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.totalAmount,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const DottedLine(),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Sub Total: Rs ${subtotal.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  fontSize: 12,
                ),
              ),
            ),
          ),
          if(stateQR.paymentType != "Cash")
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Credit Total: Rs ${double.parse(stateQR.tenderAmount.text).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  fontSize: 12,
                ),
              ),
            ),
          ),
          if(stateQR.paymentType != "Cash")
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Total: Rs ${(subtotal - double.parse(stateQR.tenderAmount.text)).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),

          const Align(
            alignment: Alignment.center,
            child: Text(
              'Thank You For Your Business',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                fontSize: 12,
              ),
            ),
          ),
          //end drop
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFED7D7),
                      foregroundColor: const Color(0xFFC53030),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'CANCEL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<ProductOrderState>(builder: (BuildContext context, state, Widget? child) {

                  return  Expanded(
                    child: ElevatedButton(

                      onPressed: dataInserted == true ? null : () async {
                        dataInserted = false;
                        state.PrintOrNot = "print";
                        if(state.isCashOrCredit == "Cash") {

                          if(state.tenderAmount.text.isNotEmpty && state.tenderAmount.text != null){
                            if (double.parse(state.tenderAmount.text) == double.parse(state.calculateTotalAmount()) ) {
                              // await state.onFinalOrderSaveToDB()
                              //     .whenComplete(() async {
                              //   state.getBillImage = Provider
                              //       .of<ImagePickerState>(
                              //       context, listen: false)
                              //       .myPickedImage;
                              //   await state.productOrderAPICall(context);
                              // });
                              Navigator.pop(context);
                              state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                              await state.productOrderAPICall(context).whenComplete(() async {
                              });
                            } else {
                              Fluttertoast.showToast(msg: "Please enter valid tender amount");
                            }
                          }else {
                            Fluttertoast.showToast(msg: "Please enter amount");
                          }


                        }else{
                         // Fluttertoast.showToast(msg: "mfffsg");
                          dataInserted = true;
                          setState(() {

                          });
                          // Fluttertoast.showToast(msg: state.referenceId);
                          // await state.onFinalOrderSaveToDB()
                          //     .whenComplete(() async {
                          //   state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                          //   await state.productOrderAPICall(context).whenComplete(() async {
                          //   });
                          // });
                          Navigator.pop(context);
                          state.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                          await state.productOrderAPICall(context).whenComplete(() async {
                          });


                        }
                        // await stateQR.onFinalOrderSaveToDB()
                        //     .whenComplete(() async {
                        //   stateQR.getBillImage = Provider.of<ImagePickerState>(context, listen: false).myPickedImage;
                        //   await stateQR.productOrderAPICall(context);
                        // });

                        // stateQR.setIsChecked = false;
                        // stateQR.PrintOrNot = "print";
                        // await stateQR.onFinalOrderSaveToDB()
                        //     .whenComplete(() async {
                        //   await stateQR.productOrderAPICall(context);
                        // });

                        // await stateQR.onFinalOrderSaveToDB().whenComplete(() async {
                        //   await stateQR.productOrderAPICall(context);
                        // });
                        // await stateQR.getAllTempProductOrderList();
                        // Navigator.pushNamedAndRemoveUntil(
                        //   context,
                        //   indexPath,
                        //       (route) => false,
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:  const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('SAVE & PRINT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },)

              ],
            ),
          ),
        ],
      ),
    );
  }
}
