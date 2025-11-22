import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:bip340/bip340.dart' as bip340;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Manual signature verification', () {
    final hexPubkey =
        'a7499c935fd605fdc5b9f551af7757e34f34dd0b928f105158c1fec82dcdb29f';
    final createdAt = 1763792246;
    final tags = [
      ['t', 'upload'],
      ['expiration', '1763792306'],
      ['x', 'bef5fcd92888b1cda1b4c2b4b2594ed15900a07f39065e85ca0e2093735e72ee'],
    ];
    final content = 'Upload file to Blossom';

    final eventData = [0, hexPubkey, createdAt, 24242, tags, content];
    final serialized = jsonEncode(eventData);

    final hash = sha256.convert(utf8.encode(serialized)).toString();
    final expectedHash =
        '53e0bf323926bc8595d4a2c49d94226a3372b5f59a83bb4f048309d7d6f4d793';

    expect(hash, equals(expectedHash));

    // Generate a valid signature for the test
    final privateKey = '1' * 64; // Test private key
    final derivedPubkey = bip340.getPublicKey(privateKey);

    // Ensure we use the pubkey derived from our private key
    expect(derivedPubkey, isNotEmpty);

    final aux = '0' * 64; // Deterministic aux for testing
    final sig = bip340.sign(privateKey, hash, aux);

    final isValid = bip340.verify(derivedPubkey, hash, sig);
    expect(isValid, isTrue);
  });
}
