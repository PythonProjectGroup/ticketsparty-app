import 'package:equatable/equatable.dart';
import 'package:ticketspartyapp/models/ticket.dart';

abstract class ValidationState extends Equatable {
  const ValidationState();
}

class InitialValidationState extends ValidationState {
  @override
  List<Object> get props => [];
}

class WaitingForQR extends ValidationState {
  @override
  List<Object> get props => [];
}

class ShowingTicket extends ValidationState {
  final Ticket ticket;

  ShowingTicket(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class ValidatingTicket extends ValidationState {
  final Ticket ticket;

  ValidatingTicket(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class ShowingError extends ValidationState {
  final String errorMessage;

  ShowingError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class LoadingTicket extends ValidationState {
  final String key;

  LoadingTicket(this.key);

  @override
  List<Object> get props => [key];
}
