import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        leading: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(event.pictures[0]), fit: BoxFit.cover),
          ),
        ),
        trailing: Text(
            "${event.date.year}.${event.date.month}.${event.date.day}"),
      ),
    );
  }
}
