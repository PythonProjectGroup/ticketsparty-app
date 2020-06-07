import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/bloc.dart';
import 'package:ticketspartyapp/blocs/register_bloc/bloc.dart';
import 'package:ticketspartyapp/ui/screens/login_screen/login_screen.dart';
import 'package:ticketspartyapp/ui/shared_widgets/text_form_input.dart';
import 'package:ticketspartyapp/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> _formKey;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _repeatPasswordController;
  TextEditingController _nameController;
  RegisterBloc registerBloc;

  @override
  void didChangeDependencies() {
    _formKey = GlobalKey<FormState>();
    registerBloc = RegisterBloc(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _nameController = TextEditingController();
    _emailController.addListener(() {
      print(_emailController.text);
      registerBloc.email = _emailController.text;
    });
    _passwordController.addListener(() {
      registerBloc.password = _passwordController.text;
    });
    _nameController.addListener(() {
      registerBloc.name = _nameController.text;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    registerBloc.close();
    super.dispose();
  }

  void trySubmit() {
    if (_formKey.currentState.validate()) {
      registerBloc.add(SubmitRegister());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
          bloc: registerBloc,
          listener: (BuildContext context, state) {
            if (state is ErrorRegister) {
              showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                        title: new Text('Login error'),
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
            if (state is AuthenticationAuthenticated) {
              Navigator.of(context).pop();
            }
          },
        )
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Hero(
                      tag: "main_text",
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "Zarejestruj się",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Hero(
                        tag: "second_text",
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "Zarejestruj się, aby móc korzystać z aplikacji",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormInput(
                      controller: _emailController,
                      name: "email",
                      obscure: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'I gdzie mam Ci niby spam wysyłać';
                        }
                        if (!Validators.isValidEmail(
                            value.toString().trim())) {
                          return "emaila na oczy chyba żeś nie widział";
                        }
                        return null;
                      },
                    ),
                    TextFormInput(
                      name: "hasło",
                      controller: _passwordController,
                      obscure: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'o czymś zapomniałeś';
                        }

                        if (Validators.isValidPassword(value)) {
                          return "Brutforcem w 5 minut";
                        }
                        return null;
                      },
                    ),
                    TextFormInput(
                      name: "potwierdź hasło",
                      controller: _repeatPasswordController,
                      obscure: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'A jak machnąłeś literówkę? weź sprawdź';
                        }
                        if (value != _passwordController.text) {
                          return "Różne wpisałeś ";
                        }
                        return null;
                      },
                    ),
                    TextFormInput(
                      name: "imię i nazwisko",
                      controller: _nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Na kogo wypisać fakturkę?';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Column(
                  children: [
                    BlocBuilder<RegisterBloc, RegisterState>(
                      bloc: registerBloc,
                      builder: (BuildContext context, state) {
                        if (state is LoadingRegister) {
                          return CircularProgressIndicator();
                        } else {
                          return Hero(
                            tag: "register_button",
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 40),
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
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          Text("Masz już konto?"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () =>
                              {
                                Navigator.pop(context),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                ),
                              },
                              child: Text(
                                "Zaloguj się",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
