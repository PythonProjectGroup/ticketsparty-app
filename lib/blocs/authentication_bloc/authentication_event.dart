import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationError extends AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String refresh;

  const LoggedIn({@required this.token, @required this.refresh});

  @override
  List<Object> get props => [token, refresh];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class TokenRenewed extends AuthenticationEvent {
  final String token;

  TokenRenewed({@required this.token});

  @override
  String toString() => 'Token Renewed { token: $token }';
  @override
  List<Object> get props => [token];
}



class LostAuthentication extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}
