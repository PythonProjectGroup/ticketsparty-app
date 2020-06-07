import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/bloc.dart';
import 'package:ticketspartyapp/utils/user_repository.dart';

import './bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  String email;
  String password;
  String name;
  final AuthenticationBloc authenticationBloc;

  RegisterBloc({@required this.authenticationBloc});

  @override
  RegisterState get initialState => WaitingForSubmitRegister();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is SubmitRegister) {
      yield* _mapSubmitToState();
    }
  }


  Stream<RegisterState> _mapSubmitToState() async* {
    yield LoadingRegister();
    try {
      final result = await UserRepository.register(
          password: password, email: email, name: name);
      if (result != null) {
        final token =
            await UserRepository.login(password: password, email: email);
        await UserRepository.persistTokenAndRefresh(token);
        await new Future.delayed(Duration(seconds: 2));
        authenticationBloc
            .add(LoggedIn(token: token.item2, refresh: token.item1));
        yield SuccessRegister();
      } else {
        yield ErrorRegister("Jakiś błąd");
      }
    } catch (e, s) {
      yield ErrorRegister("$e $s");
    }
  }
}
