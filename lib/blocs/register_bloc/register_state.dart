import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
}

class WaitingForSubmitRegister extends RegisterState {}



class LoadingRegister extends RegisterState {}

class ErrorRegister extends RegisterState {
  final String reason;

  ErrorRegister(this.reason);
}

class SuccessRegister extends RegisterState {}
