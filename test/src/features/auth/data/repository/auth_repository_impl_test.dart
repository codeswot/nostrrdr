import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;
import 'package:nostrrdr/src/core/errors/exeptions.dart';
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/features/auth/data/datasource/auth_datasource.dart';
import 'package:nostrrdr/src/features/auth/data/repository/auth_repository_impl.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthDataSource mockAuthDataSource;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(authDataSource: mockAuthDataSource);
  });

  group('createIdentity', () {
    final tAccount = MockAccount();

    test(
      'should return Account when the call to data source is successful',
      () async {
        when(
          () => mockAuthDataSource.createIdentity(),
        ).thenAnswer((_) async => tAccount);

        final result = await repository.createIdentity();

        verify(() => mockAuthDataSource.createIdentity());
        expect(result, equals(Right(tAccount)));
      },
    );

    test(
      'should return AppFailure when the call to data source throws an exception',
      () async {
        when(
          () => mockAuthDataSource.createIdentity(),
        ).thenThrow(AppException());

        final result = await repository.createIdentity();

        verify(() => mockAuthDataSource.createIdentity());
        expect(
          result,
          equals(const Left(AppFailure('Failed to create identity'))),
        );
      },
    );
    test(
      'should return AppFailure when the call to data source throws a generic exception',
      () async {
        when(() => mockAuthDataSource.createIdentity()).thenThrow(Exception());

        final result = await repository.createIdentity();

        verify(() => mockAuthDataSource.createIdentity());
        expect(
          result,
          equals(const Left(AppFailure('Failed to create identity'))),
        );
      },
    );
  });

  group('nsecLogin', () {
    const tNsec = 'nsec123456';
    final tAccount = MockAccount();

    test(
      'should return Account when the call to data source is successful',
      () async {
        when(
          () => mockAuthDataSource.nsecLogin(any()),
        ).thenAnswer((_) async => tAccount);

        final result = await repository.nsecLogin(tNsec);

        verify(() => mockAuthDataSource.nsecLogin(tNsec));
        expect(result, equals(Right(tAccount)));
      },
    );

    test(
      'should return AppFailure when the call to data source throws an exception',
      () async {
        when(
          () => mockAuthDataSource.nsecLogin(any()),
        ).thenThrow(AppException());

        final result = await repository.nsecLogin(tNsec);

        verify(() => mockAuthDataSource.nsecLogin(tNsec));
        expect(result, equals(const Left(AppFailure('Failed to login'))));
      },
    );

    test(
      'should return AppFailure when the call to data source throws a generic exception',
      () async {
        when(() => mockAuthDataSource.nsecLogin(any())).thenThrow(Exception());

        final result = await repository.nsecLogin(tNsec);

        verify(() => mockAuthDataSource.nsecLogin(tNsec));
        expect(result, equals(const Left(AppFailure('Failed to login'))));
      },
    );
  });
}

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockAccount extends Mock implements marmot.Account {}
