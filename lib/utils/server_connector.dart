import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ticketspartyapp/blocs/authentication_bloc/bloc.dart';
import 'package:ticketspartyapp/constraints.dart';
import 'package:ticketspartyapp/utils/user_repository.dart';

class ServerConnector {
  static Future getFromServer(
      String request, AuthenticationBloc authBloc) async {
    String token = await UserRepository.getToken();
    final uri = Uri.https(serverUrl, request);
    print(uri);
    print("chce itemy oto mój token: $token");
    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      print("Za pierwszym nie poszło");
      print(response.body);
      if (json.decode(response.body)["code"] == "token_not_valid") {
        var newToken = await UserRepository.getTokenAndVerify();
        if (newToken != null) {
          print("reloaded token");
          var response = await http.get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken'
            },
          );
          if (response.statusCode == 200) {
            authBloc.add(TokenRenewed(token: newToken));
            return response;
          } else if (json.decode(response.body)["code"] == "token_not_valid") {
            authBloc.add(LostAuthentication());
          } else {
            print("Weź sprawdź czy wszystko ok");
            authBloc.add(TokenRenewed(token: newToken));
            return response;
          }
        }
      } else {
        return response;
      }
    }
  }

  static Future postToServer(String request,
      AuthenticationBloc authBloc) async {
    String token = await UserRepository.getToken();
    final uri = Uri.https(serverUrl, request);
    print(uri);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      print("Za pierwszym nie poszło");
      print(response.body);
      if (json.decode(response.body)["code"] == "token_not_valid") {
        var newToken = await UserRepository.getTokenAndVerify();
        if (newToken != null) {
          print("reloaded token");
          var response = await http.post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken'
            },
          );
          if (response.statusCode == 200) {
            authBloc.add(TokenRenewed(token: newToken));
            return response;
          } else if (json.decode(response.body)["code"] == "token_not_valid") {
            authBloc.add(LostAuthentication());
          } else {
            print("Weź sprawdź czy wszystko ok");
            authBloc.add(TokenRenewed(token: newToken));
            return response;
          }
        }
      }
    }
  }

  static Future patchToServer(String request,
      AuthenticationBloc authBloc) async {
    String token = await UserRepository.getToken();
    final uri = Uri.https(serverUrl, request);
    print("chce itemy oto mój token: $token");
    var response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      print("Za pierwszym nie poszło");
      print(response.body);
      if (json.decode(response.body)["code"] == "token_not_valid") {
        var newToken = await UserRepository.getTokenAndVerify();
        if (newToken != null) {
          print("reloaded token");
          var response = await http.patch(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken'
            },
          );
          if (response.statusCode == 200) {
            authBloc.add(TokenRenewed(token: newToken));
            return response;
          } else if (json.decode(response.body)["code"] == "token_not_valid") {
            authBloc.add(LostAuthentication());
          } else {
            print("Weź sprawdź czy wszystko ok");
            authBloc.add(TokenRenewed(token: newToken));
            return response;
          }
        }
      }
    }
  }
}
