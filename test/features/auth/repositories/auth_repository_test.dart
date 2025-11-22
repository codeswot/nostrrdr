import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostrrdr/features/auth/repositories/auth_repository.dart';

class FakeFlutterSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll({
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    _storage.clear();
  }

  @override
  Future<bool> containsKey({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _storage.containsKey(key);
  }

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<Map<String, String>> readAll({
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return Map.from(_storage);
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    }
  }

  @override
  Future<bool> isCupertinoProtectedDataAvailable() async {
    return true;
  }

  @override
  void registerListener({
    required String key,
    required void Function(String?) listener,
  }) {}

  @override
  Future<void> unregisterAllListeners() async {}

  @override
  void unregisterAllListenersForKey({required String key}) {}

  @override
  void unregisterListener({
    required String key,
    required void Function(String?) listener,
  }) {}

  Future<void> resetCache() async {}

  Future<void> clearSensitiveString(String value) async {}

  @override
  AndroidOptions get aOptions => const AndroidOptions();

  @override
  IOSOptions get iOptions => const IOSOptions();

  @override
  LinuxOptions get lOptions => const LinuxOptions();

  @override
  MacOsOptions get mOptions => const MacOsOptions();

  @override
  WindowsOptions get wOptions => const WindowsOptions();

  @override
  WebOptions get webOptions => const WebOptions();

  @override
  Stream<bool>? get onCupertinoProtectedDataAvailabilityChanged {
    return null;
  }
}

void main() {
  group('AuthRepository', () {
    late FakeFlutterSecureStorage fakeStorage;
    late AuthRepository repository;

    setUp(() {
      fakeStorage = FakeFlutterSecureStorage();
      repository = AuthRepository(fakeStorage);
    });

    group('registerNewAccount', () {
      test('generates new keys and stores them in secure storage', () async {
        final result = await repository.registerNewAccount();

        expect(result.nsec, isNotEmpty);
        expect(result.npub, isNotEmpty);
        expect(result.nsec.startsWith('nsec1'), isTrue);
        expect(result.npub.startsWith('npub1'), isTrue);

        expect(await fakeStorage.read(key: 'nsec_key'), isNotEmpty);
        expect(await fakeStorage.read(key: 'npub_key'), isNotEmpty);
        expect(await fakeStorage.read(key: 'hex_private_key'), isNotEmpty);
        expect(await fakeStorage.read(key: 'hex_public_key'), isNotEmpty);
        expect(await fakeStorage.read(key: 'auth_method'), equals('nsec'));
      });

      test('returns tuple with nsec and npub', () async {
        final result = await repository.registerNewAccount();

        expect(result.nsec, startsWith('nsec1'));
        expect(result.npub, startsWith('npub1'));
      });

      test('stores both hex and bech32 formats', () async {
        await repository.registerNewAccount();

        final hexPrivateKey = await fakeStorage.read(key: 'hex_private_key');
        final hexPublicKey = await fakeStorage.read(key: 'hex_public_key');
        final nsec = await fakeStorage.read(key: 'nsec_key');
        final npub = await fakeStorage.read(key: 'npub_key');

        expect(hexPrivateKey, isNotEmpty);
        expect(hexPublicKey, isNotEmpty);
        expect(nsec, isNotEmpty);
        expect(npub, isNotEmpty);
      });
    });

    group('loginWithNsec', () {
      test('accepts nsec format and logs in', () async {
        // Register first to get valid nsec
        final registered = await repository.registerNewAccount();
        final result = await repository.loginWithNsec(registered.nsec);

        expect(result.nsec, isNotEmpty);
        expect(result.npub, isNotEmpty);
        expect(result.npub, equals(registered.npub));
      });

      test('throws exception for invalid nsec format', () {
        expect(() => repository.loginWithNsec('invalid_nsec'), throwsException);
      });

      test('throws exception for invalid hex format', () {
        expect(() => repository.loginWithNsec('xyz' * 20), throwsException);
      });

      test('stores auth method as nsec', () async {
        final registered = await repository.registerNewAccount();
        await repository.loginWithNsec(registered.nsec);

        final authMethod = await fakeStorage.read(key: 'auth_method');
        expect(authMethod, equals('nsec'));
      });
    });

    group('loginWithAmber', () {
      test('accepts npub format and logs in', () async {
        // Register first to get valid npub
        final registered = await repository.registerNewAccount();
        final result = await repository.loginWithAmber(registered.npub);

        expect(result, isNotEmpty);
        expect(result, startsWith('npub1')); // Should return NPUB format
        expect(result, equals(registered.npub)); // Should match original
      });

      test('throws exception for invalid npub format', () {
        expect(
          () => repository.loginWithAmber('invalid_npub'),
          throwsException,
        );
      });

      test('stores auth method as amber', () async {
        final registered = await repository.registerNewAccount();
        await repository.loginWithAmber(registered.npub);

        final authMethod = await fakeStorage.read(key: 'auth_method');
        expect(authMethod, equals('amber'));
      });

      test(
        'does not overwrite nsec when only logging with amber public key',
        () async {
          // For amber login, we don't store nsec since we only have public key
          // Create a fresh storage for this test
          final freshStorage = FakeFlutterSecureStorage();
          final freshRepository = AuthRepository(freshStorage);

          final publicKey = 'b' * 64;
          await freshRepository.loginWithAmber(publicKey);
          final nsec = await freshStorage.read(key: 'nsec_key');
          expect(nsec, isNull);
        },
      );
    });

    group('restoreSession', () {
      test('returns stored npub public key', () async {
        final registered = await repository.registerNewAccount();

        final result = await repository.restoreSession();

        expect(result, equals(registered.npub));
        expect(result, startsWith('npub1'));
      });

      test('returns null when no session exists', () async {
        final result = await repository.restoreSession();

        expect(result, isNull);
      });

      test('converts hex to npub if only hex is stored', () async {
        final hexPublicKey = 'b' * 64;
        await fakeStorage.write(key: 'hex_public_key', value: hexPublicKey);

        final result = await repository.restoreSession();

        expect(result, isNotNull);
        expect(result, startsWith('npub1'));
      });
    });

    group('logout', () {
      test('clears all authentication data', () async {
        await repository.registerNewAccount();
        await repository.logout();

        expect(await fakeStorage.read(key: 'nsec_key'), isNull);
        expect(await fakeStorage.read(key: 'npub_key'), isNull);
        expect(await fakeStorage.read(key: 'hex_private_key'), isNull);
        expect(await fakeStorage.read(key: 'hex_public_key'), isNull);
        expect(await fakeStorage.read(key: 'auth_method'), isNull);
      });
    });

    group('Getter methods', () {
      test('getAuthMethod returns auth method', () async {
        await repository.registerNewAccount();

        final result = await repository.getAuthMethod();

        expect(result, equals('nsec'));
      });

      test('getPublicKey returns public key', () async {
        await repository.registerNewAccount();
        final expectedKey = await fakeStorage.read(key: 'hex_public_key');

        final result = await repository.getPublicKey();

        expect(result, equals(expectedKey));
      });

      test('getNpub returns npub', () async {
        await repository.registerNewAccount();
        final expectedNpub = await fakeStorage.read(key: 'npub_key');

        final result = await repository.getNpub();

        expect(result, equals(expectedNpub));
      });

      test('getNsec returns nsec', () async {
        await repository.registerNewAccount();
        final expectedNsec = await fakeStorage.read(key: 'nsec_key');

        final result = await repository.getNsec();

        expect(result, equals(expectedNsec));
      });
    });

    group('Persistent login', () {
      test('session persists after registration', () async {
        final registered = await repository.registerNewAccount();

        // Simulate app restart by creating new repository with same storage
        final newRepository = AuthRepository(fakeStorage);
        final restoredKey = await newRepository.restoreSession();

        // Should return NPUB format
        expect(restoredKey, equals(registered.npub));
        expect(restoredKey, startsWith('npub1'));
      });

      test('session persists after nsec login', () async {
        final registered = await repository.registerNewAccount();

        // Clear state and create new repository
        fakeStorage._storage.clear();
        final loginResult = await repository.loginWithNsec(registered.nsec);

        final newRepository = AuthRepository(fakeStorage);
        final restoredKey = await newRepository.restoreSession();

        // Should return NPUB format
        expect(restoredKey, equals(loginResult.npub));
        expect(restoredKey, startsWith('npub1'));
      });

      test('session persists after amber login', () async {
        final registered = await repository.registerNewAccount();
        final npub = registered.npub;

        // Clear state and create new repository
        fakeStorage._storage.clear();
        await repository.loginWithAmber(npub);

        final newRepository = AuthRepository(fakeStorage);
        final restoredKey = await newRepository.restoreSession();

        // Should return NPUB format
        expect(restoredKey, equals(npub));
        expect(restoredKey, startsWith('npub1'));
      });

      test('all auth data persists after logout', () async {
        await repository.registerNewAccount();

        // Logout
        await repository.logout();

        // Simulate app restart
        final newRepository = AuthRepository(fakeStorage);
        final restoredKey = await newRepository.restoreSession();

        expect(restoredKey, isNull);
      });
    });
  });
}
