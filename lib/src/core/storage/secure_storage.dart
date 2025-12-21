import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class SecureStorageKeyManager {
  static const _keyName = 'app_state_encryption_key';
  final Logger _logger = Logger('SecureStorageKeyManager');
  final FlutterSecureStorage _secureStorage;

  SecureStorageKeyManager({FlutterSecureStorage? storage})
    : _secureStorage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(enforceBiometrics: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  Future<List<int>> getEncryptionKey() async {
    try {
      final storedKey = await _secureStorage.read(key: _keyName);

      if (storedKey != null) {
        return base64Decode(storedKey);
      } else {
        final newKey = _generateRandomKey();
        await _secureStorage.write(key: _keyName, value: base64Encode(newKey));
        return newKey;
      }
    } catch (e) {
      _logger.severe('Error retrieving encryption key: $e');
      rethrow;
    }
  }

  List<int> _generateRandomKey() {
    final random = Random.secure();
    return List<int>.generate(32, (i) => random.nextInt(256));
  }
}
