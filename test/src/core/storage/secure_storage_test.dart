import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nostrrdr/src/core/storage/secure_storage.dart';

void main() {
  late SecureStorageKeyManager keyManager;
  late MockFlutterSecureStorage mockSecureStorage;
  const keyName = 'app_state_encryption_key';

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    keyManager = SecureStorageKeyManager(storage: mockSecureStorage);
  });

  group('SecureStorageKeyManager', () {
    test('getEncryptionKey returns stored key if it exists', () async {
      final storedKeyBytes = List<int>.generate(32, (index) => index);
      final storedKeyBase64 = base64Encode(storedKeyBytes);

      when(
        () => mockSecureStorage.read(key: keyName),
      ).thenAnswer((_) async => storedKeyBase64);

      final result = await keyManager.getEncryptionKey();

      expect(result, equals(storedKeyBytes));
      verify(() => mockSecureStorage.read(key: keyName)).called(1);
      verifyNever(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      );
    });

    test(
      'getEncryptionKey generates, stores, and returns new key if none exists',
      () async {
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => null);
        when(
          () => mockSecureStorage.write(
            key: keyName,
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async => {});

        final result = await keyManager.getEncryptionKey();

        expect(result.length, 32);
        verify(() => mockSecureStorage.read(key: keyName)).called(1);
        verify(
          () => mockSecureStorage.write(
            key: keyName,
            value: any(named: 'value', that: isA<String>()),
          ),
        ).called(1);
      },
    );

    test('getEncryptionKey rethrows exception if read fails', () async {
      when(
        () => mockSecureStorage.read(key: keyName),
      ).thenThrow(Exception('Read error'));

      expect(() => keyManager.getEncryptionKey(), throwsA(isA<Exception>()));
    });
  });
}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
