import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/core/usecase/usecase.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/create_identity.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/nsec_login.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:nostrrdr/src/features/auth/presentation/bloc/auth_state.dart';

void main() {
  late AuthBloc bloc;
  late MockNsecLogin mockNsecLogin;
  late MockCreateIdentity mockCreateIdentity;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockNsecLogin = MockNsecLogin();
    mockCreateIdentity = MockCreateIdentity();
    bloc = AuthBloc(
      nsecLoginUseCase: mockNsecLogin,
      createIdentityUseCase: mockCreateIdentity,
    );
  });

  final tAccount = MockAccount();
  const tNsec = 'nsec123456';

  test('initial state is AuthInitial', () {
    expect(bloc.state, AuthInitial());
  });

  group('NsecLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when successful',
      build: () {
        when(
          () => mockNsecLogin(any()),
        ).thenAnswer((_) async => Right(tAccount));
        return bloc;
      },
      act: (bloc) => bloc.add(const NsecLoginRequested(tNsec)),
      expect: () => [AuthLoading(), AuthAuthenticated(tAccount)],
      verify: (_) {
        verify(() => mockNsecLogin(tNsec));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when failure occurs',
      build: () {
        when(
          () => mockNsecLogin(any()),
        ).thenAnswer((_) async => const Left(AppFailure('Login failed')));
        return bloc;
      },
      act: (bloc) => bloc.add(const NsecLoginRequested(tNsec)),
      expect: () => [AuthLoading(), const AuthFailure('Login failed')],
      verify: (_) {
        verify(() => mockNsecLogin(tNsec));
      },
    );
  });

  group('CreateIdentityRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when successful',
      build: () {
        when(
          () => mockCreateIdentity(any()),
        ).thenAnswer((_) async => Right(tAccount));
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateIdentityRequested()),
      expect: () => [AuthLoading(), AuthAuthenticated(tAccount)],
      verify: (_) {
        verify(() => mockCreateIdentity(any(that: isA<NoParams>())));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when failure occurs',
      build: () {
        when(
          () => mockCreateIdentity(any()),
        ).thenAnswer((_) async => const Left(AppFailure('Create ID failed')));
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateIdentityRequested()),
      expect: () => [AuthLoading(), const AuthFailure('Create ID failed')],
      verify: (_) {
        verify(() => mockCreateIdentity(any(that: isA<NoParams>())));
      },
    );
  });
}

class MockNsecLogin extends Mock implements NsecLoginUseCase {}

class MockCreateIdentity extends Mock implements CreateIdentityUseCase {}

class MockAccount extends Mock implements marmot.Account {}
