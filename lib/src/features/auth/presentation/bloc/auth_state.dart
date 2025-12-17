import 'package:equatable/equatable.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final marmot.Account account;
  const AuthAuthenticated(this.account);

  @override
  List<Object?> get props => [account];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
