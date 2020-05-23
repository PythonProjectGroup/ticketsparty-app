import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketspartyapp/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:ticketspartyapp/ui/screens/home_screen/home_screen.dart';
import 'package:ticketspartyapp/ui/screens/welcome_screen.dart';

import 'blocs/authentication_bloc/bloc.dart';
import 'ui/screens/NoConnectionScreen/no_connection_screen.dart';
import 'ui/screens/splash_screen.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc()
          ..add(AppStarted());
      },
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashScreen();
          }
          if (state is AuthenticationAuthenticated) {
            print("Przechodzę do home");
            return BlocProvider(
                create: (BuildContext context) => HomeScreenBloc(),
                child: HomeScreen());
          }
          if (state is AuthenticationUnauthenticated) {
            return WelcomeScreen();
          }
          if (state is AuthenticationNotPossible) {
            return NoConnectionScreen();
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
