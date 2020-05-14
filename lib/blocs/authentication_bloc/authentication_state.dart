import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];

  get token => null;
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final String authToken;
  get token => authToken;

  AuthenticationAuthenticated({@required this.authToken});
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
