import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nostrrdr/src/core/usecase/usecase.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/create_identity.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/nsec_login.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final NsecLoginUseCase _nsecLoginUseCase;
  final CreateIdentityUseCase _createIdentityUseCase;

  AuthBloc({
    required NsecLoginUseCase nsecLoginUseCase,
    required CreateIdentityUseCase createIdentityUseCase,
  }) : _nsecLoginUseCase = nsecLoginUseCase,
       _createIdentityUseCase = createIdentityUseCase,
       super(AuthInitial()) {
    on<NsecLoginRequested>(_onNsecLoginRequested);
    on<CreateIdentityRequested>(_onCreateIdentityRequested);
  }

  Future<void> _onNsecLoginRequested(
    NsecLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _nsecLoginUseCase(event.nsec);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (account) => emit(AuthAuthenticated(account)),
    );
  }

  Future<void> _onCreateIdentityRequested(
    CreateIdentityRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _createIdentityUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (account) => emit(AuthAuthenticated(account)),
    );
  }
}
