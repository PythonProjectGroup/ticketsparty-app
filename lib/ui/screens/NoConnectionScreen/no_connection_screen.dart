import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_event.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Could not connect to server\nPress Button to try again"),
          RaisedButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
            },
            child: Text("Try Again"),
          )
        ],
      ),
    ));
  }
}
