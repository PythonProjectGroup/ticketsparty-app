import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ticketspartyapp/blocs/validation_bloc/validation_bloc.dart';
import 'package:ticketspartyapp/blocs/validation_bloc/validation_event.dart';
import 'package:ticketspartyapp/blocs/validation_bloc/validation_state.dart';
import 'package:ticketspartyapp/models/event.dart';

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
  ValidationBloc validationBloc;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    validationBloc = BlocProvider.of<ValidationBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    validationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ValidationBloc, ValidationState>(
      listener: (BuildContext context, ValidationState state) {
        if (state is LoadingTicket) {
          controller.pauseCamera();
          scaffold.currentState
              .showBottomSheet((context) => BottomSheetTicket());
        } else if (state is WaitingForQR) {
          controller.resumeCamera();
        }
      },
      child: Scaffold(
        key: scaffold,
        body: Column(
          children: <Widget>[
            Expanded(
              child: QRView(
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
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      validationBloc.add(FoundQR(scanData));
    });
  }
}

class BottomSheetTicket extends StatefulWidget {
  const BottomSheetTicket({Key key}) : super(key: key);

  @override
  _BottomSheetTicketState createState() => _BottomSheetTicketState();
}

class _BottomSheetTicketState extends State<BottomSheetTicket> {
  Future<bool> _willPopCallback() async {
    BlocProvider.of<ValidationBloc>(context).add(BackToScanning());
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: BlocListener<ValidationBloc, ValidationState>(
        listener: (BuildContext context, ValidationState state) {
          if (state is WaitingForQR) {
            Navigator.pop(context);
          }
        },
        child: Container(
            height: 300,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: BlocBuilder<ValidationBloc, ValidationState>(
              builder: (BuildContext context, state) {
                if (state is ShowingTicket) {
                  return ListView(
                    children: <Widget>[
                      ListTile(title: Text('Ticket')),
                      Text("Name: ${state.ticket.personName}"),
                      Text(
                          "Number of people: ${state.ticket.numberOfPeople
                              .toString()}"),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton.icon(
                          icon: Icon(Icons.check),
                          label: Text('Check and close'),
                          onPressed: () =>
                          {
                            BlocProvider.of<ValidationBloc>(context)
                                .add(ValidationStarted(state.ticket)),
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton.icon(
                          icon: Icon(Icons.close),
                          label: Text('Close'),
                          onPressed: () =>
                          {
                            BlocProvider.of<ValidationBloc>(context)
                                .add(BackToScanning()),
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is ShowingError) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
      ),
    );
  }
}
