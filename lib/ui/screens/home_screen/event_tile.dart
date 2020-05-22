import 'package:flutter/material.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/ui/screens/event_screen/event_screen.dart';

class EventTile extends StatelessWidget {
  final Event event;

  const EventTile({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EventScreen(
                        event: event,
                      )),
            ),
        title: Text(event.name),
        leading: Image.network(event.pictureUrl),
      ),
    );
  }
}
