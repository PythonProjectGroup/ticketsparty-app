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
  ValidationState get initialState => WaitingForQR();

  @override
  Stream<ValidationState> mapEventToState(
    ValidationEvent event,
  ) async* {
    if (event is FoundTicket) {
      yield LoadingTicket(event.key);
      try {
        var result = await DataRepository.getTicket(
            authenticationBloc: authenticationBloc, key: event.key);
        if (result is Ticket) {
          if (result.eventID == eventID) {
            result.hash = event.key;
            yield ShowingTicket(result, ValidationStatus.Waiting);
          } else {
            yield ShowingError("Bilet na inne wydarzenie");
          }
        } else {
          yield ShowingError(result);
        }
      } catch (error) {
        yield ShowingError("Server Connection error");
      }
    } else if (event is ValidationStarted) {
      yield ShowingTicket(event.ticket, ValidationStatus.Loading);
      try {
        await Future.delayed(const Duration(seconds: 2), () {});
        bool success = await DataRepository.validateTicket(
            authenticationBloc: authenticationBloc, key: event.ticket.hash);
        if (success) {
          yield ShowingTicket(event.ticket, ValidationStatus.Success);
        } else {
          yield ShowingTicket(event.ticket, ValidationStatus.Failure);
        }
      } catch (error) {
        yield ShowingTicket(event.ticket, ValidationStatus.Failure);
      }
    } else if (event is BackToScanning) {
      yield WaitingForQR();
    }
  }
}
