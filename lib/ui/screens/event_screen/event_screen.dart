import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

class EventScreen extends StatefulWidget {
  final int eventID;

  const EventScreen({Key key, this.eventID}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  Event event;

  Future getEventInfo() async {
    event = await DataRepository.getEvent(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        id: widget.eventID);
  }

  @override
  void initState() {
    getEventInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.eventID.toString())),
    );
  }
}
