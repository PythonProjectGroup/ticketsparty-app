import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/bloc.dart';
import 'package:ticketspartyapp/blocs/login_bloc/bloc.dart';
import 'package:ticketspartyapp/ui/screens/register_screen/register_screen.dart';
import 'package:ticketspartyapp/ui/shared_widgets/text_form_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  LoginBloc loginBloc;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    loginBloc = LoginBloc(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.addListener(() {
      print(_emailController.text);
      loginBloc.email = _emailController.text;
    });
    _passwordController.addListener(() {
      loginBloc.password = _passwordController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    loginBloc.close();
    super.dispose();
  }

  void trySubmit() {
    if (formKey.currentState.validate()) {
      loginBloc.add(SubmitLogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          bloc: loginBloc,
          listener: (BuildContext context, state) {
            if (state is ErrorLogin) {
              showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                        title: new Text('Błąd logowania'),
                        content: new Text(state.reason),
                        actions: <Widget>[
                          new GestureDetector(
                            onTap: () => Navigator.of(context).pop(false),
                            child: Text("OK"),
                          ),
                        ],
                      ));
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          bloc: BlocProvider.of<AuthenticationBloc>(context),
          listener: (BuildContext context, state) {
            if (state is AuthenticationAuthenticated ||
                state is AuthenticationNotPossible) {
              Navigator.of(context).pop();
            }
          },
        )
      ],
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Hero(
                        tag: "main_text",
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "Zaloguj się",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Hero(
                          tag: "second_text",
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              "Logowanie do aplikacji",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormInput(
                          controller: _emailController,
                          name: "login",
                          obscure: false,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Proszę podaj email';
                            }
                            return null;
                          },
                        ),
                        TextFormInput(
                            controller: _passwordController,
                            name: "hasło",
                            obscure: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Proszę podaj hasło';
                              }
                              return null;
                            }),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      BlocBuilder<LoginBloc, LoginState>(
                        bloc: loginBloc,
                        builder: (BuildContext context, state) {
                          if (state is LoadingLogin) {
                            return CircularProgressIndicator();
                          } else {
                            return Hero(
                              tag: "login_button",
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 60,
                                        child: RaisedButton(
                                          color: Colors.black,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          onPressed: trySubmit,
                                          child: Text(
                                            "Zaloguj się",
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
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Row(
                          children: [
                            Text("Nie masz konta?"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.pop(context),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()),
                                  ),
                                },
                                child: Text(
                                  "Zarejestruj się",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
