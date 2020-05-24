import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/bloc.dart';
import 'package:ticketspartyapp/blocs/login_bloc/bloc.dart';
import 'package:ticketspartyapp/utils/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String email;
  String password;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  @override
  LoginState get initialState {
    return WaitingForSubmitLogin();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is SubmitLogin) {
      yield* _mapSubmitToState();
    }
  }

  Stream<LoginState> _mapSubmitToState() async* {
    yield LoadingLogin();
    try {
      final token =
      await UserRepository.login(password: password, email: email);
      if (token != null) {
        await UserRepository.persistTokenAndRefresh(token);
        await new Future.delayed(Duration(seconds: 2));
        authenticationBloc
            .add(LoggedIn(token: token.item2, refresh: token.item1));
        yield SuccessLogin();
      } else {
        yield ErrorLogin("No such user");
      }
    } catch (e, s) {
      authenticationBloc.add(AuthenticationError());
    }
  }

  @override
  Future<void> close() {
    print("ZAMYKAM LOGOWANIE DOWIDZENIA");
    return super.close();
  }
}
