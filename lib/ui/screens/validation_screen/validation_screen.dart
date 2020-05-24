import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ticketspartyapp/blocs/validation_bloc/bloc.dart';
import 'package:ticketspartyapp/blocs/validation_screen_bloc/bloc.dart';
import 'package:ticketspartyapp/models/event.dart';

import 'ticket_sheet.dart';

class ValidationScreen extends StatefulWidget {
  final Event event;
  final int eventId;

  ValidationScreen({Key key, this.event, this.eventId}) : super(key: key);

  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  QRViewController controller;
  bool isOpen = false;
  bool torchOn = false;
  bool backCamera = true;
  ValidationBloc validationBloc;
  ValidationScreenBloc validationScreenBloc;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController bottomSheetController;

  @override
  void initState() {
    validationBloc = BlocProvider.of<ValidationBloc>(context);
    validationScreenBloc = BlocProvider.of<ValidationScreenBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    validationBloc.close();
    validationScreenBloc.close();
    super.dispose();
  }

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
    return BlocListener<ValidationScreenBloc, ValidationScreenState>(
      listener: (BuildContext context, ValidationScreenState state) {
        if (state.scanning) {
          controller.resumeCamera();
        } else {
          controller.pauseCamera();
        }
        if (state.showingTicket) {
          if (!isOpen) {
            bottomSheetController = scaffold.currentState
                .showBottomSheet((context) => BottomSheetTicket());
            isOpen = true;
          }
        } else {
          if (isOpen) {
            try {
              bottomSheetController.close();
            } catch (error) {}
            isOpen = false;
          }
        }
      },
      child: BlocBuilder<ValidationScreenBloc, ValidationScreenState>(
          builder: (BuildContext context, state) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  state.showingTicket ? Icons.arrow_downward : Icons
                      .arrow_upward,
                ),
                onPressed: () {
                  if (!state.showingTicket) {
                    validationScreenBloc.add(OpenSheetPressed());
                  } else {
                    validationScreenBloc.add(CloseSheetPressed());
                    validationBloc.add(BackToScanning());
                  }
                },
              ),
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
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          width: 100,
                          height: 100,
                          child: RaisedButton(
                            color: Color(0x30000000),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                                side: BorderSide(color: Colors.white)),
                            onPressed: switchTorch,
                            child: Icon(
                              Icons.flash_on,
                              size: 70,
                              color: torchOn ? Colors.yellow : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Container(
                          width: 100,
                          height: 100,
                          child: RaisedButton(
                            color: Color(0x30000000),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                                side: BorderSide(color: Colors.white)),
                            onPressed: switchCamera,
                            child: Icon(
                              backCamera ? Icons.camera_enhance : Icons
                                  .camera_front,
                              size: 70,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      validationScreenBloc.add(FoundQR());
      validationBloc.add(FoundTicket(scanData));
    });
  }
}
