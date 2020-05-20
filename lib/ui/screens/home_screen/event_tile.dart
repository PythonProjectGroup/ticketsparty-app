import 'package:flutter/material.dart';
import 'package:ticketspartyapp/ui/screens/event_screen/event_screen.dart';

class EventTile extends StatelessWidget {
  final String name;
  final id;

  const EventTile({Key key, this.name, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventScreen(
                  eventID: int.parse(name),
                )),
      ),
      title: Text(name),
    );
  }
}
