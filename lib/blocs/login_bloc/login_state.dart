import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class WaitingForSubmitLogin extends LoginState {}

class ValidatingLogin extends LoginState {}

class LoadingLogin extends LoginState {}

class ErrorLogin extends LoginState {
  final String reason;

  ErrorLogin(this.reason);
}

class SuccessLogin extends LoginState {}
