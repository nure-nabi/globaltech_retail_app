import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../themes/colors.dart';


class ImagePickerState extends ChangeNotifier {
  ImagePickerState();

  init() async {
    await clear();
  }

  clear() async {
    _myPickedImage = "";
  }

  late String _myPickedImage = "";
  String get myPickedImage => _myPickedImage;
  set getPickedImage(String value) {
    _myPickedImage = value;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();

  pickImageFromGallery() async {
    debugPrint("\n\nPick Image From Gallery");
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    debugPrint("My Picked Image => $image");

    if (image!.path.isEmpty) {
      return null;
    }
    getPickedImage = await imageFromPath(imagePath: image.path);

    notifyListeners();
  }

  pickImageFromCamera() async {
    debugPrint("\n\nPick Image From Camera");
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    debugPrint("My Picked Image => $image");
    if (image!.path.isEmpty) {
      return null;
    }
    getPickedImage = await imageFromPath(imagePath: image.path);

    notifyListeners();
  }

  imageFromPath({required String imagePath}) async {
    File file = File(imagePath);
    // Uint8List bytes = file.readAsBytesSync();
    Uint8List bytes = await testCompressFile(file);
    String base64Image = base64Encode(bytes);
    debugPrint("My Base64 image =>  $base64Image");
    return base64Image;
  }

  // compress file and get Uint8List
  Future<Uint8List> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 500,
      minHeight: 500,
      quality: 94,
      rotate: 90,
    );

    return result!;
  }

  ///
  /// [ CROPPER IMAGE ]
  Future<void> cropImage({required ImageSource source}) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 10,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Cropper'),
        ],
      );

      if (croppedFile != null) {
        getPickedImage = await imageFromPath(imagePath: croppedFile.path);
      }
    }
    notifyListeners();
  }
}
