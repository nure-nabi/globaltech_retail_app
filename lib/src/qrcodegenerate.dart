import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class QRGeneratorScreen extends StatefulWidget {
  String voucherNo;
  String qty;
  String rate;
   QRGeneratorScreen({Key? key,required this.voucherNo,required this.qty, required this.rate});
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {

  String qrData = "Scan to see product details";
  bool isGenerated = false;

  @override
  void initState() {
    _generateQRCode();
    super.initState();
  }


  void _generateQRCode() {

    setState(() {
      qrData = '''
      Voucher No: ${widget.voucherNo}
      Price: \$${widget.rate}
      Quantity: ${widget.qty}
      Generated on: ${DateTime.now().toString()}
      ''';
      isGenerated = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment QR Generator'),

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Payment QR Code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            RepaintBoundary(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: true,
                  embeddedImage: AssetImage('assets/logo.png'),
                  // optional
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Scan the QR code to pay amount',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
