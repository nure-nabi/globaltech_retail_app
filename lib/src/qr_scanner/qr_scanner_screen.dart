
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:retail_app/src/qr_scanner/qr_scanner_state.dart';
import '../../services/sharepref/set_all_pref.dart';
import '../../utils/custom_log.dart';
import '../../widgets/alert/show_alert.dart';
import '../products/products_state.dart';
import '../sales/sales.dart';
import 'qr_productList.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  static const double _defaultScanArea = 250.0;
  static const double _smallScanArea = 200.0;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  bool isProcessing = false;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _initializeContext();
  }

  void _initializeContext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductState>().getContext = context;
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    if (controller == null) return;

    try {
      await controller!.toggleFlash();
      if (mounted) {
        setState(() => isFlashOn = !isFlashOn);
      }
    } catch (e) {
      CustomLog.errorLog(value: 'Error toggling flash: $e');
      _showErrorSnackBar('Unable to toggle flash');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleQRCode(String? code) async {
    if (isProcessing || code == null) return;

    setState(() => isProcessing = true);

    try {
      await _processQRCode(code);
    } catch (e) {
      CustomLog.errorLog(value: e.toString());
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  Future<void> _processQRCode(String code) async {
    await SetAllPref.setQRData(value: code);
    final state = Provider.of<ProductState>(context, listen: false);
    await state.getQRProductListFromDB();

    if (!mounted) return;

    await _showOrderAlert(context);
    await _navigateToProductList();
  }

  Future<void> _showOrderAlert(BuildContext context) async {
    final state = Provider.of<ProductState>(context, listen: false);
    final orderState = Provider.of<ProductOrderState>(context, listen: false);

    await  orderState.clear();

    final product = state.qrProductList.first;
    orderState.getProductDetails = product;
    orderState.getSalesRate = product.salesRate;
    await ShowAlert(context).alert(child: const ProductOrderScreen());
  }

  Future<void> _navigateToProductList() async {
    if (!mounted) return;

    controller?.pauseCamera();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    } else {
      // await Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const QRProductListScreen(),
      //   ),
      // );
    }
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) => _handleQRCode(scanData.code),
      onError: (error) => CustomLog.errorLog(value: 'QR scan error: $error'),
    );
  }

  Widget _buildQrView(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanArea = (size.width > 350 || size.height > 750)
        ? _defaultScanArea
        : _smallScanArea;

    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue,
        borderRadius: 0,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String text,
    required BorderRadius borderRadius,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedTab == index
                ? Colors.red.shade700
                : Colors.transparent,
            borderRadius: borderRadius,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selectedTab == index ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Scan Or Share',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              _buildTabButton(
                index: 0,
                text: 'Scan',
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
              ),
              _buildTabButton(
                index: 1,
                text: 'Share',
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8),
            Icon(
              Icons.qr_code_scanner_rounded,
              size: 40,
              color: Colors.blue,
            ),
            SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget _buildScannerControls() {
    return Consumer<QRScanState>(
      builder: (context, state, _) {
        return Column(
          children: [
            if (state.isLoading)
              const CircularProgressIndicator(color: Colors.white)
            else
              IconButton(
                onPressed: _toggleFlash,
                icon: Icon(
                  isFlashOn ? Icons.flash_off : Icons.flash_on,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Scan to Pay on Merchant outlets',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildQrView(context),
                  Positioned(
                    bottom: 40,
                    child: _buildScannerControls(),
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
