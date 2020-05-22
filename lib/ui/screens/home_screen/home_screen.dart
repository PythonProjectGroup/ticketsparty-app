import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/ui/screens/add_event_screen/add_event_screen.dart';
import 'package:ticketspartyapp/ui/screens/home_screen/event_tile.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> events = List<Event>();

  Future loadEvents() async {
    var loadedEvents = await DataRepository.getEventsWithKey(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
    setState(() {
      events = loadedEvents;
    });
  }

  @override
  void initState() {
    loadEvents();
    super.initState();
  }

  void addKey() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEventScreen()),
    );
    loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addKey,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              return new EventTile(
                event: events[index],
              );
            }),
      ),
    );
  }
}
