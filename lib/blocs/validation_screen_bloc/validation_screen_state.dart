import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ValidationScreenState extends Equatable {
  final bool scanning;
  final bool showingTicket;

  ValidationScreenState(
      {@required this.scanning, @required this.showingTicket});

  factory ValidationScreenState.initial() {
    return ValidationScreenState(scanning: true, showingTicket: false);
  }

  factory ValidationScreenState.foundTicket() {
    return ValidationScreenState(scanning: false, showingTicket: true);
  }

  ValidationScreenState copyWith({
    bool scanning,
    bool showingTicket,
  }) {
    return ValidationScreenState(
        scanning: scanning ?? this.scanning,
        showingTicket: showingTicket ?? this.showingTicket);
  }

  @override
  List<Object> get props => [scanning, showingTicket];
}
