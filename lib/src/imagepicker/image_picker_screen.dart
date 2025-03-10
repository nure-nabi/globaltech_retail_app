import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../themes/colors.dart';
import '../../themes/fonts_style.dart';
import '../../widgets/container_decoration.dart';
import 'image_picker_state.dart';

class ImagePickerScreen extends StatefulWidget {
  final bool isHeaderShow;
  final bool? isPickFromGallery;
  final double? imageHeight, imageWidth;
  final bool? isCropperEnable;

  const ImagePickerScreen({
    super.key,
    required this.isHeaderShow,
    this.isPickFromGallery = true,
    this.isCropperEnable = false,
    this.imageHeight,
    this.imageWidth,
  });

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<ImagePickerState>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImagePickerState>(
      builder: (context, state, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.isHeaderShow) ...[
              Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                    color: primaryColor,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Choose Your Image",
                    style: textFormTitleStyle.copyWith(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 20.0),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      widget.isCropperEnable == true
                          ? state.cropImage(source: ImageSource.camera)
                          : state.pickImageFromCamera();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      decoration: ContainerDecoration.decoration(
                          color: Colors.transparent),
                      child: Text(
                        "From Camera",
                        textAlign: TextAlign.center,
                        style: textFormTitleStyle,
                      ),
                    ),
                  )),
                  if (widget.isPickFromGallery == true) ...[
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        widget.isCropperEnable == true
                            ? state.cropImage(source: ImageSource.gallery)
                            : state.pickImageFromGallery();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        decoration: ContainerDecoration.decoration(
                            color: Colors.transparent),
                        child: Text(
                          "From Gallery",
                          textAlign: TextAlign.center,
                          style: textFormTitleStyle,
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ),

            ///
            if (state.myPickedImage.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Image.memory(
                  base64.decode(state.myPickedImage),
                  height: widget.imageHeight ?? 80.0,
                  width: widget.imageWidth ?? 100.0,
                ),
              ),
          ],
        );
      },
    );
  }
}
