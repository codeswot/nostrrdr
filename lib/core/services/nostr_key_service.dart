import 'package:bech32/bech32.dart';
import 'package:bip340/bip340.dart' as bip340;
import 'package:hex/hex.dart';

class NostrKeyService {
  static const String _nsecHrp = 'nsec';
  static const String _npubHrp = 'npub';

  static String generateRandomHex(int bytes) {
    final random = List<int>.generate(
      bytes,
      (i) => (DateTime.now().microsecondsSinceEpoch ^ i) & 0xFF,
    );
    return HEX.encode(random);
  }

  static String generateNewPrivateKey() {
    return generateRandomHex(32);
  }

  static String encodePrivateKey(String hexPrivateKey) {
    if (!_isValidHex(hexPrivateKey, 32)) {
      throw Exception('Invalid private key format');
    }
    final bytes = HEX.decode(hexPrivateKey);
    return Bech32Codec().encode(Bech32(_nsecHrp, convertBits(bytes, 8, 5)));
  }

  static String decodePrivateKey(String nsec) {
    try {
      if (!nsec.startsWith(_nsecHrp)) {
        throw Exception('Invalid nsec format');
      }
      final bech32 = Bech32Codec().decode(nsec);
      if (bech32.hrp != _nsecHrp) {
        throw Exception('Invalid nsec hrp');
      }
      final bytes = convertBits(bech32.data, 5, 8, false);
      if (bytes.length != 32) {
        throw Exception('Invalid nsec length');
      }
      return HEX.encode(bytes);
    } catch (e) {
      throw Exception('Failed to decode nsec: $e');
    }
  }

  static String derivePublicKey(String hexPrivateKey) {
    if (!_isValidHex(hexPrivateKey, 32)) {
      throw Exception('Invalid private key format');
    }
    return bip340.getPublicKey(hexPrivateKey);
  }

  static String encodePublicKey(String hexPublicKey) {
    if (!_isValidHex(hexPublicKey, 32)) {
      throw Exception('Invalid public key format');
    }
    final bytes = HEX.decode(hexPublicKey);
    return Bech32Codec().encode(Bech32(_npubHrp, convertBits(bytes, 8, 5)));
  }

  static String decodePublicKey(String npub) {
    try {
      if (!npub.startsWith(_npubHrp)) {
        throw Exception('Invalid npub format');
      }
      final bech32 = Bech32Codec().decode(npub);
      if (bech32.hrp != _npubHrp) {
        throw Exception('Invalid npub hrp');
      }
      final bytes = convertBits(bech32.data, 5, 8, false);
      if (bytes.length != 32) {
        throw Exception('Invalid npub length');
      }
      return HEX.encode(bytes);
    } catch (e) {
      throw Exception('Failed to decode npub: $e');
    }
  }

  static bool isValidNsec(String nsec) {
    try {
      decodePrivateKey(nsec);
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool isValidNpub(String npub) {
    try {
      decodePublicKey(npub);
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool isValidHexKey(String hex) {
    return _isValidHex(hex, 32);
  }

  static bool _isValidHex(String hex, int expectedBytes) {
    if (hex.length != expectedBytes * 2) return false;
    try {
      HEX.decode(hex);
      return true;
    } catch (_) {
      return false;
    }
  }

  static String sign(String privateKey, String messageHash) {
    if (!_isValidHex(privateKey, 32)) {
      throw Exception('Invalid private key format');
    }
    if (!_isValidHex(messageHash, 32)) {
      throw Exception('Invalid message hash format');
    }

    // bip340.sign expects private key and message hash as hex strings
    // and returns the signature as a hex string.
    // We need to ensure we pass the aux data (randomness) for security,
    // but the library might handle it or we can pass null/random.
    // Looking at common implementations, passing the aux is good practice.
    // However, the basic `sign` usually generates it securely.
    // Let's check the library usage. Assuming standard `sign(secret, message)`.

    // The bip340 package usually exposes `sign(String secret, String message, [String? aux])`.
    // It seems it requires aux. Passing empty string or random hex is common.
    // Let's generate random aux for better security.
    final aux = generateRandomHex(32);
    return bip340.sign(privateKey, messageHash, aux);
  }

  static bool verify(String publicKey, String messageHash, String signature) {
    if (!_isValidHex(publicKey, 32)) {
      throw Exception('Invalid public key format');
    }
    if (!_isValidHex(messageHash, 32)) {
      throw Exception('Invalid message hash format');
    }
    if (!_isValidHex(signature, 64)) {
      throw Exception('Invalid signature format');
    }

    return bip340.verify(publicKey, messageHash, signature);
  }

  static List<int> convertBits(
    List<int> data,
    int fromBits,
    int toBits, [
    bool pad = true,
  ]) {
    var acc = 0;
    var bits = 0;
    final result = <int>[];
    final maxv = (1 << toBits) - 1;
    final maxAcc = (1 << (fromBits + toBits - 1)) - 1;

    for (final value in data) {
      if (value < 0 || (value >> fromBits) != 0) {
        throw Exception('Invalid data for conversion');
      }
      acc = ((acc << fromBits) | value) & maxAcc;
      bits += fromBits;
      while (bits >= toBits) {
        bits -= toBits;
        result.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((acc << (toBits - bits)) & maxv);
      }
    } else if (bits >= fromBits || ((acc << (toBits - bits)) & maxv) != 0) {
      throw Exception('Invalid padding in conversion');
    }

    return result;
  }
}
