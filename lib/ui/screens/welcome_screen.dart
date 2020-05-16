import 'package:flutter/material.dart';
import 'package:ticketspartyapp/ui/screens/login_screen/login_screen.dart';
import 'package:ticketspartyapp/ui/screens/register_screen/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<bool> onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ),
            child: Text("Login"),
          ),
          RaisedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterScreen())),
            child: Text("Register"),
          ),
        ],
      )),
    );
  }
}
