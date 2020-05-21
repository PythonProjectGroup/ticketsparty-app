import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/models/ticket.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

class ValidationScreen extends StatefulWidget {
  final Event event;

  ValidationScreen({Key key, this.event}) : super(key: key);

  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        controller.pauseCamera();
      });
      Ticket ticket = await DataRepository.getTicket(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          key: scanData);
      scaffold.currentState
          .showBottomSheet((context) => _buildBottomSheet(context, ticket));
    });
  }

  Container _buildBottomSheet(BuildContext context, Ticket ticket) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView(
        children: <Widget>[
          ListTile(title: Text('Ticket')),
          Text("Name: ${ticket.personName}"),
          Text("Number of people: ${ticket.numberOfPeople.toString()}"),
          Container(
            alignment: Alignment.center,
            child: RaisedButton.icon(
              icon: Icon(Icons.check),
              label: Text('Check and close'),
              onPressed: () =>
                  {this.controller.resumeCamera(), Navigator.pop(context)},
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: RaisedButton.icon(
              icon: Icon(Icons.close),
              label: Text('Close'),
              onPressed: () =>
                  {this.controller.resumeCamera(), Navigator.pop(context)},
            ),
          ),
        ],
      ),
    );
  }
}
