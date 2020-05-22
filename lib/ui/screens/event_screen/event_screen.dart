import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/blocs/validation_bloc/validation_bloc.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/ui/screens/validation_screen/validation_screen.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  const EventScreen({Key key, this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  Event event;
  bool isLoaded = false;

  Future getEventInfo() async {
    event = await DataRepository.getEvent(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        id: widget.event.id);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    getEventInfo();
    super.initState();
  }

  void proceedToValidation() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BlocProvider<ValidationBloc>(
                    create: (BuildContext context) =>
                        ValidationBloc(
                            BlocProvider.of<AuthenticationBloc>(context),
                            event.id),
                    child: ValidationScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: RaisedButton(
        textColor: Colors.white,
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        onPressed: proceedToValidation,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "VALIDATE",
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
      body: SafeArea(
        child: isLoaded
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  event.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 30),
                ),
                Text(event.description),
                Image.network(event.pictureUrl)
              ],
            ),
          ),
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
