import 'package:flutter_test/flutter_test.dart';
import 'package:marmot_flutter/marmot_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nostrrdr/src/features/auth/data/datasource/auth_datasource.dart';

void main() {
  late AuthDataSourceImpl authDataSource;
  late MockFunctions mockFunctions;

  setUp(() {
    mockFunctions = MockFunctions();
    authDataSource = AuthDataSourceImpl(
      loginFn: mockFunctions.login,
      createIdentityFn: mockFunctions.createIdentity,
    );
  });

  group('AuthDataSource', () {
    final tAccount = Account(
      pubkey: 'pubkey',
      lastSyncedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('nsecLogin should call login function', () async {
      when(
        () => mockFunctions.login(
          nsecOrHexPrivkey: any(named: 'nsecOrHexPrivkey'),
        ),
      ).thenAnswer((_) async => tAccount);

      final result = await authDataSource.nsecLogin('nsec123');

      expect(result, tAccount);
      verify(() => mockFunctions.login(nsecOrHexPrivkey: 'nsec123')).called(1);
    });

    test('createIdentity should call createIdentity function', () async {
      when(
        () => mockFunctions.createIdentity(),
      ).thenAnswer((_) async => tAccount);
      final result = await authDataSource.createIdentity();

      expect(result, tAccount);
      verify(() => mockFunctions.createIdentity()).called(1);
    });
  });
}

class MockFunctions extends Mock {
  Future<Account> login({required String nsecOrHexPrivkey});
  Future<Account> createIdentity();
}
