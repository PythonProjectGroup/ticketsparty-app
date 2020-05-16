import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/authentication_state.dart';
import 'package:ticketspartyapp/blocs/login_bloc/bloc.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: MultiBlocListener(
          listeners: [
            BlocListener<LoginBloc, LoginState>(
              bloc: loginBloc,
              listener: (BuildContext context, state) {
                if (state is ErrorLogin) {
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
          child: Form(
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
                      return 'Please enter login';
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
                        return 'Please enter password';
                      }
                      return null;
                    }),
                BlocBuilder<LoginBloc, LoginState>(
                  bloc: loginBloc,
                  builder: (BuildContext context, state) {
                    if (state is LoadingLogin) {
                      return CircularProgressIndicator();
                    } else {
                      return RaisedButton(
                        onPressed: trySubmit,
                        child: Text("login"),
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
