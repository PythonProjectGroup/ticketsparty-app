import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/models/event.dart';
import 'package:ticketspartyapp/utils/server_connector.dart';

class DataRepository {
  static Future<List<Event>> getEventsWithKey({
    @required AuthenticationBloc authenticationBloc,
  }) async {
    String url = "/api/eventkeys";

    var response = await ServerConnector.getFromServer(url, authenticationBloc);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      data = data[0];
      print(data);
      data = data["eventkeys"];
      print(data);
      final finalData = json.decode(data) as List;
      print(data);
      return finalData.map((rawPost) {
        return Event(
          id: rawPost["event_id"],
          key: rawPost['key'],
        );
      }).toList();
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
      return false;
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
      return Event(name: " masło");
    } else {
      print(response.body);
      throw Exception('error adding key');
    }
  }
}
