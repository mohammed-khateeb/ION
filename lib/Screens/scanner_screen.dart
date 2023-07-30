import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Models/Responses/httpresponse.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../Controller/charger_controller.dart';
import '../Utils/main_utils.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isCalledApi = false; // Flag to track if API has been called

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery
        .of(context)
        .size
        .width < 400 ||
        MediaQuery
            .of(context)
            .size
            .height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!isCalledApi) {
        setState(() {
          result = scanData;
          isCalledApi = true;
        });
        if (result != null) {
          if (int.tryParse(result!.code!) == null) {
            Navigator.pop(context);
            MainUtils.showErrorAlertDialog(context,
                getTranslated(context, "invalid_pin")!);
            return;
          }
          startCharge(context, int.parse(result!.code!));
        }
      }
    });
  }

        void _onPermissionSet(BuildContext context, QRViewController ctrl, bool
        p)
    {
      log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
      if (!p) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('no Permission')),
        );
      }
    }

    @override
    void dispose() {
      controller?.dispose();
      super.dispose();
    }


    startCharge(BuildContext context, int pin) async {
      MainUtils.showWaitingProgressDialog();
      HttpResponse response = await context.read<ChargerController>()
          .startCharger(pin);
      MainUtils.hideWaitingProgressDialog();
      Navigator.pop(context);
      if (response.isSuccess == true) {
        MainUtils.showSuccessAlertDialog(context,response.message!);
      }
      else {
        MainUtils.showErrorAlertDialog(context,response.message!);
      }
    }
  }