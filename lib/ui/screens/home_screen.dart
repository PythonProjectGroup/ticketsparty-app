import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_event.dart';
import 'package:ticketspartyapp/ui/screens/qr_test/qr_test.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () =>
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut()),
              child: Text("LOGOUT"),
            ),
            RaisedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRViewExample()),
              ),
              child: Text("QR"),
            )
          ],
        ),
      ),
    );
  }
}
