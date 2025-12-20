import 'package:flutter_test/flutter_test.dart';
import 'package:marmot_flutter/marmot_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nostrrdr/src/features/auth/data/datasource/auth_datasource.dart';
import 'package:nostrrdr/src/features/auth/domain/entities/auth_user.dart';

void main() {
  late AuthDataSourceImpl authDataSource;
  late MockFunctions mockFunctions;
  final date = DateTime.now();

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
      lastSyncedAt: date,
      createdAt: date,
      updatedAt: date,
    );

    final tAuthUser = AuthUser(
      pubKey: 'pubkey',
      lastSyncedAt: date,
      createdAt: date,
      updatedAt: date,
    );

    test('nsecLogin should call login function', () async {
      when(
        () => mockFunctions.login(
          nsecOrHexPrivkey: any(named: 'nsecOrHexPrivkey'),
        ),
      ).thenAnswer((_) async => tAccount);

      final result = await authDataSource.nsecLogin('nsec123');

      expect(result, tAuthUser);
      verify(() => mockFunctions.login(nsecOrHexPrivkey: 'nsec123')).called(1);
    });

    test('createIdentity should call createIdentity function', () async {
      when(
        () => mockFunctions.createIdentity(),
      ).thenAnswer((_) async => tAccount);
      final result = await authDataSource.createIdentity();

      expect(result, tAuthUser);
      verify(() => mockFunctions.createIdentity()).called(1);
    });
  });
}

class MockFunctions extends Mock {
  Future<Account> login({required String nsecOrHexPrivkey});
  Future<Account> createIdentity();
}
