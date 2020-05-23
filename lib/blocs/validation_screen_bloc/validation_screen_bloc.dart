import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ticketspartyapp/blocs/validation_screen_bloc/validation_screen_state.dart';

import './bloc.dart';

class ValidationScreenBloc
    extends Bloc<ValidationScreenEvent, ValidationScreenState> {
  @override
  ValidationScreenState get initialState => ValidationScreenState.initial();

  @override
  Stream<ValidationScreenState> mapEventToState(
    ValidationScreenEvent event,
  ) async* {
    if (event is OpenSheetPressed) {
      yield state.copyWith(showingTicket: true);
    } else if (event is FoundQR) {
      yield ValidationScreenState.foundTicket();
    } else if (event is CloseSheetPressed) {
      yield ValidationScreenState.initial();
    }
  }
}
