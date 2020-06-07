import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: [
                  Hero(
                    tag: "main_text",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "Cześć! Zaloguj się",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Hero(
                      tag: "second_text",
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "Zaloguj się aby móc korzystać z naszej aplikacji.\nKonto możesz założyć na stronie ticketsparty.pl bądź tutaj",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                'resources/welcome_screen.svg',
                height: 200,
                placeholderBuilder: (BuildContext context) => Container(
                  height: 200,
                ),
              ),
              Column(
                children: [
                  Hero(
                    tag: "login_button",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              child: RaisedButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                ),
                                child: Text("Zaloguj się",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Nie masz jeszcze konta?",
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                  Hero(
                    tag: "register_button",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              child: RaisedButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen())),
                                child: Text(
                                  "Zarejestruj się",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
