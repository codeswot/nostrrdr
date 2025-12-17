import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class NsecLoginRequested extends AuthEvent {
  final String nsec;
  const NsecLoginRequested(this.nsec);

  @override
  List<Object?> get props => [nsec];
}

class CreateIdentityRequested extends AuthEvent {
  const CreateIdentityRequested();
}
