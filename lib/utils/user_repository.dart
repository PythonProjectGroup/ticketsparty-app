import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:ticketspartyapp/constraints.dart';
import 'package:tuple/tuple.dart';


class UserRepository {
  static Future<Tuple2<String, String>> login({
    @required String email,
    @required String password,
  }) async {
    final uri = Uri.https(serverUrl, "/auth/jwt/create/");
    var body = json.encode({
      'email': email,
      'password': password,
    });

    print('Body: $body');
    print("LOGUJE");
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 200) {
      print("CHUJuw sto");
      print(response.body);
      return null;
    }
    print("MAM REESPONSA");
    var data = json.decode(response.body);
    var refresh = data['refresh'];
    var access = data['access'];
    return Tuple2(refresh, access);
  }

  static Future<bool> register({
    @required String email,
    @required String password,
    @required bool isLawyer,
  }) async {
    final uri = Uri.https(serverUrl, "/auth/users/");
    var body = json.encode({
      'email': email,
      'password': password,
      'is_lawyer': true,
    });

    print('Body: $body');
    print("Rejestruje");
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode != 201) {
      print("CHUJuw sto");
      print(response.statusCode);
      print(response.body);
      return null;
    }
    print("MAM REESPONSA");
    return true;
  }

  static Future<void> deleteToken() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: "refresh");
    await storage.delete(key: "auth_key");
    return;
  }

  static Future<void> persistTokenAndRefresh(
      Tuple2<String, String> data) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "refresh", value: data.item1);
    await storage.write(key: "auth_key", value: data.item2);
    return;
  }

  Future<void> persistToken(String token) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "auth_key", value: token);
    return;
  }
  static Future<String> getToken() async {
    return await FlutterSecureStorage().read(key: "auth_key");
  }
  static Future<String> getTokenAndVerify() async {
    final storage = new FlutterSecureStorage();
    var auth = await storage.read(key: "auth_key");
    if (auth != null) {
      final uri = Uri.https(serverUrl, "/auth/jwt/verify/");
      var body = json.encode({
        'token': auth,
      });

      print('Body: $body');

      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode != 200) {
        var refresh = await storage.read(key: "refresh");
        if (refresh != null) {
          final uri = Uri.https(serverUrl, "/auth/jwt/refresh/");
          var body = json.encode({
            'refresh': refresh,
          });
          print('Body: $body');
          var response = await http.post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $auth'
            },
            body: body,
          );
          if (response.statusCode != 200) {
            return null;
          }
          var data = json.decode(response.body);
          auth = data["access"];
          await storage.write(key: "auth_key", value: auth);
          return auth;
        } else {
          return null;
        }
      } else {
        return auth;
      }
    } else {
      return null;
    }
  }
}
