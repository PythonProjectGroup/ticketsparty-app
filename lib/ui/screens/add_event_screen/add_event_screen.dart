import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  QRViewController controller;
  bool torchOn = false;
  bool backCamera = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  void switchTorch() {
    setState(() {
      torchOn = !torchOn;
    });
    controller.toggleFlash();
  }

  void switchCamera() {
    setState(() {
      backCamera = !backCamera;
    });
    controller.flipCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 20,
              borderLength: 50,
              borderWidth: 10,
              cutOutSize: 400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                width: 100,
                height: 100,
                child: RaisedButton(
                  color: Color(0x30000000),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90), side: BorderSide(
                      color: Colors.white
                  )),
                  onPressed: switchTorch,
                  child: Icon(Icons.flash_on, size: 70,
                    color: torchOn ? Colors.yellow : Colors.white,),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Container(
                width: 100,
                height: 100,
                child: RaisedButton(
                  color: Color(0x30000000),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90), side: BorderSide(
                      color: Colors.white
                  )),
                  onPressed: switchCamera,
                  child: Icon(
                    backCamera ? Icons.camera_enhance : Icons.camera_front,
                    size: 70, color: Colors.white,),
                ),
              ),
            ),
          ),
        ],
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
