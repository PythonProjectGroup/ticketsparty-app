import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/bloc.dart';
import 'package:ticketspartyapp/blocs/register_bloc/bloc.dart';
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
  RegisterBloc registerBloc;

  @override
  void didChangeDependencies() {
    _formKey = GlobalKey<FormState>();
    registerBloc = RegisterBloc(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _emailController.addListener(() {
      print(_emailController.text);
      registerBloc.email = _emailController.text;
    });
    _passwordController.addListener(() {
      registerBloc.password = _passwordController.text;
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
              print("DIALOG");
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
        body: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Form(
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
                    if (!Validators.isValidEmail(value)) {
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
                BlocBuilder<RegisterBloc, RegisterState>(
                  bloc: registerBloc,
                  builder: (BuildContext context, state) {
                    if (state is LoadingRegister) {
                      return CircularProgressIndicator();
                    } else {
                      return RaisedButton(
                        onPressed: trySubmit,
                        child: Text("register"),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
