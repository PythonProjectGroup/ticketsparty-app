import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      try {
        bool success = await DataRepository.addEventKey(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            key: scanData);
        if (success) {
          Navigator.pop(context);
        } else {
          scaffold.currentState
              .showSnackBar(SnackBar(content: Text("Błąd dodania eventu")));
          controller.resumeCamera();
        }
      } catch (error) {
        scaffold.currentState
            .showSnackBar(SnackBar(content: Text("Błąd dodania eventu")));
        controller.resumeCamera();
      }
    });
  }
}
