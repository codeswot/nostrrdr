import 'package:flutter_test/flutter_test.dart';
import 'package:nostrrdr/core/services/nostr_key_service.dart';

void main() {
  group('NostrKeyService', () {
    group('generateRandomHex', () {
      test('generates correct length hex string', () {
        final hex = NostrKeyService.generateRandomHex(32);
        expect(hex.length, equals(64)); // 32 bytes = 64 hex chars
      });

      test('generates valid hex string', () {
        final hex = NostrKeyService.generateRandomHex(32);
        expect(hex, matches(RegExp(r'^[0-9a-f]{64}$')));
      });

      test('generates different values on each call', () {
        final hex1 = NostrKeyService.generateRandomHex(32);
        final hex2 = NostrKeyService.generateRandomHex(32);
        expect(hex1, isNot(equals(hex2)));
      });
    });

    group('generateNewPrivateKey', () {
      test('generates 64-character hex string', () {
        final privateKey = NostrKeyService.generateNewPrivateKey();
        expect(privateKey.length, equals(64));
      });

      test('generates valid hex format', () {
        final privateKey = NostrKeyService.generateNewPrivateKey();
        expect(privateKey, matches(RegExp(r'^[0-9a-f]{64}$')));
      });
    });

    group('encodePrivateKey', () {
      test('encodes hex private key to nsec bech32 format', () {
        final hexKey = '0' * 64;
        final nsec = NostrKeyService.encodePrivateKey(hexKey);
        expect(nsec.startsWith('nsec1'), isTrue);
      });

      test('throws exception for invalid hex length', () {
        expect(() => NostrKeyService.encodePrivateKey('abc'), throwsException);
      });

      test('throws exception for non-hex characters', () {
        expect(
          () => NostrKeyService.encodePrivateKey('g' * 64),
          throwsException,
        );
      });
    });

    group('decodePrivateKey', () {
      test('decodes nsec bech32 to hex private key', () {
        final originalHex = '0' * 64;
        final nsec = NostrKeyService.encodePrivateKey(originalHex);
        final decodedHex = NostrKeyService.decodePrivateKey(nsec);
        expect(decodedHex, equals(originalHex));
      });

      test('throws exception for invalid nsec format', () {
        expect(
          () => NostrKeyService.decodePrivateKey('invalid'),
          throwsException,
        );
      });

      test('throws exception for npub instead of nsec', () {
        final hex = '1' * 64;
        final npub = NostrKeyService.encodePublicKey(hex);
        expect(() => NostrKeyService.decodePrivateKey(npub), throwsException);
      });
    });

    group('derivePublicKey', () {
      test('derives public key from hex private key', () {
        final hexPrivateKey = NostrKeyService.generateNewPrivateKey();
        final publicKey = NostrKeyService.derivePublicKey(hexPrivateKey);
        expect(publicKey, isNotEmpty);
        expect(publicKey.length, equals(64));
      });

      test('produces consistent public key for same private key', () {
        final hexPrivateKey = '1' * 64;
        final pub1 = NostrKeyService.derivePublicKey(hexPrivateKey);
        final pub2 = NostrKeyService.derivePublicKey(hexPrivateKey);
        expect(pub1, equals(pub2));
      });

      test('throws exception for invalid private key format', () {
        expect(() => NostrKeyService.derivePublicKey('abc'), throwsException);
      });

      test('derives different keys from different private keys', () {
        final hex1 = '1' * 64;
        final hex2 = '2' * 64;
        final pub1 = NostrKeyService.derivePublicKey(hex1);
        final pub2 = NostrKeyService.derivePublicKey(hex2);
        expect(pub1, isNot(equals(pub2)));
      });
    });

    group('encodePublicKey', () {
      test('encodes hex public key to npub bech32 format', () {
        final hexKey = 'a' * 64;
        final npub = NostrKeyService.encodePublicKey(hexKey);
        expect(npub.startsWith('npub1'), isTrue);
      });

      test('throws exception for invalid hex length', () {
        expect(() => NostrKeyService.encodePublicKey('abc'), throwsException);
      });

      test('throws exception for non-hex characters', () {
        expect(
          () => NostrKeyService.encodePublicKey('z' * 64),
          throwsException,
        );
      });
    });

    group('decodePublicKey', () {
      test('decodes npub bech32 to hex public key', () {
        final originalHex = 'b' * 64;
        final npub = NostrKeyService.encodePublicKey(originalHex);
        final decodedHex = NostrKeyService.decodePublicKey(npub);
        expect(decodedHex, equals(originalHex));
      });

      test('throws exception for invalid npub format', () {
        expect(
          () => NostrKeyService.decodePublicKey('invalid'),
          throwsException,
        );
      });

      test('throws exception for nsec instead of npub', () {
        final hex = '1' * 64;
        final nsec = NostrKeyService.encodePrivateKey(hex);
        expect(() => NostrKeyService.decodePublicKey(nsec), throwsException);
      });
    });

    group('isValidNsec', () {
      test('returns true for valid nsec', () {
        final hexKey = '3' * 64;
        final nsec = NostrKeyService.encodePrivateKey(hexKey);
        expect(NostrKeyService.isValidNsec(nsec), isTrue);
      });

      test('returns false for invalid nsec', () {
        expect(NostrKeyService.isValidNsec('invalid'), isFalse);
      });

      test('returns false for npub', () {
        final hexKey = '4' * 64;
        final npub = NostrKeyService.encodePublicKey(hexKey);
        expect(NostrKeyService.isValidNsec(npub), isFalse);
      });

      test('returns false for hex string', () {
        expect(NostrKeyService.isValidNsec('5' * 64), isFalse);
      });
    });

    group('isValidNpub', () {
      test('returns true for valid npub', () {
        final hexKey = '6' * 64;
        final npub = NostrKeyService.encodePublicKey(hexKey);
        expect(NostrKeyService.isValidNpub(npub), isTrue);
      });

      test('returns false for invalid npub', () {
        expect(NostrKeyService.isValidNpub('invalid'), isFalse);
      });

      test('returns false for nsec', () {
        final hexKey = '7' * 64;
        final nsec = NostrKeyService.encodePrivateKey(hexKey);
        expect(NostrKeyService.isValidNpub(nsec), isFalse);
      });

      test('returns false for hex string', () {
        expect(NostrKeyService.isValidNpub('8' * 64), isFalse);
      });
    });

    group('isValidHexKey', () {
      test('returns true for valid 64-char hex string', () {
        expect(NostrKeyService.isValidHexKey('9' * 64), isTrue);
      });

      test('returns false for invalid length', () {
        expect(NostrKeyService.isValidHexKey('a' * 63), isFalse);
      });

      test('returns false for non-hex characters', () {
        expect(NostrKeyService.isValidHexKey('g' * 64), isFalse);
      });

      test('returns false for nsec format', () {
        final hexKey = 'b' * 64;
        final nsec = NostrKeyService.encodePrivateKey(hexKey);
        expect(NostrKeyService.isValidHexKey(nsec), isFalse);
      });

      test('returns false for npub format', () {
        final hexKey = 'c' * 64;
        final npub = NostrKeyService.encodePublicKey(hexKey);
        expect(NostrKeyService.isValidHexKey(npub), isFalse);
      });
    });

    group('convertBits', () {
      test('converts from 8 bits to 5 bits', () {
        final data = [255, 128, 64];
        final result = NostrKeyService.convertBits(data, 8, 5);
        expect(result, isNotEmpty);
      });

      test('converts from 5 bits to 8 bits', () {
        final data = [31, 24, 16, 8];
        final result = NostrKeyService.convertBits(data, 5, 8);
        expect(result, isNotEmpty);
      });

      test('roundtrip conversion preserves data', () {
        final original = [255, 128, 64, 32, 16];
        final to5 = NostrKeyService.convertBits(original, 8, 5);
        final back8 = NostrKeyService.convertBits(
          to5,
          5,
          8,
          false,
        ).sublist(0, original.length);
        expect(back8, equals(original));
      });

      test('throws exception for invalid data', () {
        final data = [255, 256]; // 256 > max for 8 bits
        expect(() => NostrKeyService.convertBits(data, 8, 5), throwsException);
      });
    });

    group('Key generation and encoding roundtrip', () {
      test('full flow: generate -> encode -> decode', () {
        final privateKey = NostrKeyService.generateNewPrivateKey();
        final nsec = NostrKeyService.encodePrivateKey(privateKey);
        final decodedKey = NostrKeyService.decodePrivateKey(nsec);
        expect(decodedKey, equals(privateKey));
      });

      test('full flow: derive public key -> encode -> decode', () {
        final privateKey = NostrKeyService.generateNewPrivateKey();
        final publicKey = NostrKeyService.derivePublicKey(privateKey);
        final npub = NostrKeyService.encodePublicKey(publicKey);
        final decodedKey = NostrKeyService.decodePublicKey(npub);
        expect(decodedKey, equals(publicKey));
      });

      test('private and public keys are different', () {
        final privateKey = NostrKeyService.generateNewPrivateKey();
        final publicKey = NostrKeyService.derivePublicKey(privateKey);
        expect(privateKey, isNot(equals(publicKey)));
      });

      test('nsec and npub formats are different', () {
        final privateKey = NostrKeyService.generateNewPrivateKey();
        final publicKey = NostrKeyService.derivePublicKey(privateKey);
        final nsec = NostrKeyService.encodePrivateKey(privateKey);
        final npub = NostrKeyService.encodePublicKey(publicKey);
        expect(nsec, isNot(equals(npub)));
      });
    });
  });
}
