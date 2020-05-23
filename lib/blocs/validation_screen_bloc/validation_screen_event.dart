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
  final String data;

  FoundQR(this.data);

  @override
  List<Object> get props => [data];
}
