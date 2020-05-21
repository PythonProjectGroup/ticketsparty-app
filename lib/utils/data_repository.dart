import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/models/ticket.dart';
import 'package:ticketspartyapp/utils/server_connector.dart';

class DataRepository {
  static Future<List<Event>> getEventsWithKey({
    @required AuthenticationBloc authenticationBloc,
  }) async {
    String url = "/api/eventkeys";

    var response = await ServerConnector.getFromServer(url, authenticationBloc);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data = data[0]["eventkeys"];
      final finalData = json.decode(data) as List;
      print(finalData);
      var eventsWithKey = finalData.map((rawPost) {
        return Event(
          id: rawPost["event_id"],
          key: rawPost['key'],
        );
      }).toList();
      List<Event> allEvents =
      await getEvents(authenticationBloc: authenticationBloc);
      List<Event> finalEvents = List<Event>();
      for (Event event in allEvents) {
        for (Event eventWithKey in eventsWithKey) {
          if (event.id == eventWithKey.id) {
            event.key = eventWithKey.key;
            finalEvents.add(event);
            eventsWithKey.remove(eventWithKey);
            break;
          }
        }
      }
      return finalEvents;
    } else {
      print(response.body);
      throw Exception('error fetching events');
    }
  }

  static Future<bool> addEventKey(
      {@required AuthenticationBloc authenticationBloc, @required key}) async {
    String url = "/api/eventkeys/$key";

    var response = await ServerConnector.postToServer(url, authenticationBloc);
    if (response.statusCode == 200) {
      print("Dodałem key");
      return false;
    } else {
      print(response.body);
      throw Exception('error adding key');
    }
  }

  static Future<Ticket> getTicket(
      {@required AuthenticationBloc authenticationBloc, @required key}) async {
    String url = "/api/eventkeys/$key";

    var response = await ServerConnector.postToServer(url, authenticationBloc);
    if (response.statusCode == 200) {
      print("Dodałem key");
      return Ticket(personName: "Pan Mateusz Zasraniec", numberOfPeople: 5);
    } else {
      print(response.body);
      throw Exception('error adding key');
    }
  }

  static Future<Event> getEvent(
      {@required AuthenticationBloc authenticationBloc, @required id}) async {
    String url = "/api/events/$id";

    var response = await ServerConnector.getFromServer(url, authenticationBloc);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return Event(
          id: data["id"],
          name: data["event_name"],
          description: data["descriptions"],
          pictureUrl: data["pictures"],
          city: data["city"]);
    } else {
      print(response.body);
      throw Exception('error adding key');
    }
  }

  static Future<List<Event>> getEvents(
      {@required AuthenticationBloc authenticationBloc}) async {
    String url = "/api/events";

    var response = await ServerConnector.getFromServer(url, authenticationBloc);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      var events = data.map((rawPost) {
        return Event(
            id: rawPost["id"],
            name: rawPost["event_name"],
            description: rawPost["descriptions"],
            pictureUrl: rawPost["pictures"],
            city: rawPost["city"]);
      }).toList();
      List<Event> finalEvents = List<Event>();
      for (Event event in events) {
        finalEvents.add(event);
      }
      return finalEvents;
    } else {
      print(response.body);
      throw Exception('error loading all events');
    }
  }
}
