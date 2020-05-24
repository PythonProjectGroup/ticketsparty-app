import 'package:equatable/equatable.dart';

abstract class ValidationScreenEvent extends Equatable {
  const ValidationScreenEvent();
}

class OpenSheetPressed extends ValidationScreenEvent {
  @override
  List<Object> get props => [];
}

class CloseSheetPressed extends ValidationScreenEvent {
  @override
  List<Object> get props => [];
}

class FoundQR extends ValidationScreenEvent {


  @override
  List<Object> get props => [];
}
