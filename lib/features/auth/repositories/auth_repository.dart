import 'package:amberflutter/amberflutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nostrrdr/core/services/nostr_key_service.dart';

class AuthRepository {
  final FlutterSecureStorage _storage;

  const AuthRepository(this._storage);

  Future<({String nsec, String npub})> registerNewAccount() async {
    await logout();

    final hexPrivateKey = NostrKeyService.generateNewPrivateKey();
    final hexPublicKey = NostrKeyService.derivePublicKey(hexPrivateKey);

    final nsec = NostrKeyService.encodePrivateKey(hexPrivateKey);
    final npub = NostrKeyService.encodePublicKey(hexPublicKey);

    // Store keys and EXPLICITLY set auth method to 'nsec'
    await Future.wait([
      _storage.write(key: 'hex_private_key', value: hexPrivateKey),
      _storage.write(key: 'hex_public_key', value: hexPublicKey),
      _storage.write(key: 'nsec_key', value: nsec),
      _storage.write(key: 'npub_key', value: npub),
      _storage.write(key: 'auth_method', value: 'nsec'),
    ]);

    return (nsec: nsec, npub: npub);
  }

  Future<({String nsec, String npub})> loginWithNsec(String nsecOrHex) async {
    await logout();

    String hexPrivateKey;

    if (nsecOrHex.startsWith('nsec')) {
      if (!NostrKeyService.isValidNsec(nsecOrHex)) {
        throw Exception('Invalid NSEC format');
      }
      hexPrivateKey = NostrKeyService.decodePrivateKey(nsecOrHex);
    } else if (NostrKeyService.isValidHexKey(nsecOrHex)) {
      hexPrivateKey = nsecOrHex;
    } else {
      throw Exception('Invalid private key format. Use NSEC or 64-char hex.');
    }

    final hexPublicKey = NostrKeyService.derivePublicKey(hexPrivateKey);
    final nsec = NostrKeyService.encodePrivateKey(hexPrivateKey);
    final npub = NostrKeyService.encodePublicKey(hexPublicKey);

    // Store keys and EXPLICITLY set auth method to 'nsec'
    await Future.wait([
      _storage.write(key: 'hex_private_key', value: hexPrivateKey),
      _storage.write(key: 'hex_public_key', value: hexPublicKey),
      _storage.write(key: 'nsec_key', value: nsec),
      _storage.write(key: 'npub_key', value: npub),
      _storage.write(key: 'auth_method', value: 'nsec'),
    ]);

    return (nsec: nsec, npub: npub);
  }

  Future<String> loginWithAmber(String npubOrHex) async {
    await logout();

    String hexPublicKey;
    String npub;

    if (npubOrHex.startsWith('npub')) {
      if (!NostrKeyService.isValidNpub(npubOrHex)) {
        throw Exception('Invalid NPUB format');
      }
      npub = npubOrHex;
      hexPublicKey = NostrKeyService.decodePublicKey(npubOrHex);
    } else if (NostrKeyService.isValidHexKey(npubOrHex)) {
      hexPublicKey = npubOrHex;
      npub = NostrKeyService.encodePublicKey(hexPublicKey);
    } else {
      throw Exception('Invalid public key format. Use NPUB or 64-char hex.');
    }

    await Future.wait([
      _storage.write(key: 'hex_public_key', value: hexPublicKey),
      _storage.write(key: 'npub_key', value: npub),
      _storage.write(key: 'auth_method', value: 'amber'),
    ]);

    return npub;
  }

  Future<String?> restoreSession() async {
    final npub = await _storage.read(key: 'npub_key');
    if (npub != null) {
      return npub;
    }
    final hexKey = await _storage.read(key: 'hex_public_key');
    if (hexKey != null && NostrKeyService.isValidHexKey(hexKey)) {
      return NostrKeyService.encodePublicKey(hexKey);
    }
    return null;
  }

  Future<void> logout() async {
    await Future.wait([
      _storage.delete(key: 'nsec_key'),
      _storage.delete(key: 'npub_key'),
      _storage.delete(key: 'hex_private_key'),
      _storage.delete(key: 'hex_public_key'),
      _storage.delete(key: 'auth_method'),
    ]);
  }

  Future<String?> getAuthMethod() async {
    return await _storage.read(key: 'auth_method');
  }

  Future<String?> getPublicKey() async {
    return await _storage.read(key: 'hex_public_key');
  }

  Future<String?> getNpub() async {
    return await _storage.read(key: 'npub_key');
  }

  Future<String?> getNsec() async {
    return await _storage.read(key: 'nsec_key');
  }

  Future<String?> getHexPublicKey() async {
    return await _storage.read(key: 'hex_public_key');
  }

  Future<String?> getHexPrivateKey() async {
    return await _storage.read(key: 'hex_private_key');
  }

  Future<String> sign(String messageHash, {String? eventJson}) async {
    final authMethod = await getAuthMethod();

    if (authMethod == 'amber') {
      try {
        final amber = Amberflutter();
        final hexPubkey = await getHexPublicKey();
        if (hexPubkey == null) {
          throw Exception('No public key found for Amber signing');
        }

        if (eventJson == null) {
          throw Exception('Amber signing requires full event JSON');
        }

        final response = await amber.signEvent(
          currentUser: hexPubkey,
          eventJson: eventJson,
        );

        final signature = response['signature']?.toString();
        if (signature == null || signature.isEmpty) {
          throw Exception('Amber returned empty signature');
        }

        return signature;
      } catch (e) {
        throw Exception('Amber signing failed: $e');
      }
    } else {
      final hexPrivateKey = await _storage.read(key: 'hex_private_key');
      if (hexPrivateKey == null) {
        throw Exception('No private key found');
      }
      return NostrKeyService.sign(hexPrivateKey, messageHash);
    }
  }
}
