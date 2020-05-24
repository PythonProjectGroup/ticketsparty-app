import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_event.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('resources/404.png')
              )
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Could not connect to server\nPress Button to try again",
                      style: TextStyle(color: Colors.white, fontSize: 30),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                              AppStarted());
                        },
                        child: Text("Try Again"),
                      ),
                    )
                  ],
                ),
              ),
            ),
      ),
    ));
  }
}
