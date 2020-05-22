import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ticketspartyapp/blocs/authentication_bloc/bloc.dart';
import 'package:ticketspartyapp/models/ticket.dart';
import 'package:ticketspartyapp/utils/data_repository.dart';

import './bloc.dart';

class ValidationBloc extends Bloc<ValidationEvent, ValidationState> {
  AuthenticationBloc authenticationBloc;
  int eventID;

  ValidationBloc(this.authenticationBloc, this.eventID);

  @override
  ValidationState get initialState => InitialValidationState();

  @override
  Stream<ValidationState> mapEventToState(
    ValidationEvent event,
  ) async* {
    if (event is FoundQR) {
      yield LoadingTicket(event.key);
      var result = await DataRepository.getTicket(
          authenticationBloc: authenticationBloc, key: event.key);
      if (result is Ticket) {
        if (result.eventID == eventID) {
          yield ShowingTicket(result);
        } else {
          yield ShowingError("Bilet na inne wydarzenie");
        }
      } else {
        yield ShowingError(result);
      }
    } else if (event is ValidationStarted) {
      yield ValidatingTicket(event.ticket);
      bool success = await DataRepository.validateTicket(
          authenticationBloc: authenticationBloc, key: event.ticket.hash);
      if (success) {
        yield WaitingForQR();
      } else {
        print("Error");
      }
    } else if (event is BackToScanning) {
      yield WaitingForQR();
    }
  }
}
