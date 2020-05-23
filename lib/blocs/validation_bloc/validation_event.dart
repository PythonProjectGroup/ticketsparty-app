import 'package:equatable/equatable.dart';
import 'package:ticketspartyapp/models/ticket.dart';

abstract class ValidationEvent extends Equatable {
  const ValidationEvent();
}

class FoundTicket extends ValidationEvent {
  final String key;

  FoundTicket(this.key);

  @override
  List<Object> get props => [key];
}

class ValidationStarted extends ValidationEvent {
  final Ticket ticket;

  ValidationStarted(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class BackToScanning extends ValidationEvent {
  @override
  List<Object> get props => [];
}
