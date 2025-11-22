import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/models/nostr_event.dart';
import 'package:nostrrdr/core/services/logger_service.dart';
import 'package:nostrrdr/core/services/nostr_key_service.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';
import 'package:path_provider/path_provider.dart';

class PlaygroundScreen extends ConsumerStatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  ConsumerState<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends ConsumerState<PlaygroundScreen> {
  final List<String> _logs = [];
  bool _isRunning = false;

  void _log(String message) {
    setState(() {
      _logs.add(
        '${DateTime.now().toIso8601String().split('T')[1].substring(0, 8)}: $message',
      );
    });
    LoggerService.debug('[Playground] $message');
  }

  Future<void> _runTest() async {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _logs.clear();
    });

    try {
      _log('Starting test...');

      // 1. Auth
      final npub = ref.read(currentNpubProvider);
      if (npub == null) {
        _log('Error: Not authenticated');
        return;
      }
      _log('Authenticated as: $npub');
      final hexPubkey = NostrKeyService.decodePublicKey(npub);
      _log('Hex Pubkey: $hexPubkey');

      // Verify auth method and keys
      final authRepository = ref.read(authRepositoryProvider);
      final authMethod = await authRepository.getAuthMethod();
      final storedHexPubkey = await authRepository.getHexPublicKey();

      _log('Auth Method: $authMethod');
      _log('Stored Hex Pubkey: $storedHexPubkey');
      _log('Decoded Hex Pubkey from npub: $hexPubkey');

      if (storedHexPubkey != hexPubkey) {
        _log('ERROR: Stored pubkey does not match npub!');
        _log('This means keys are corrupted in storage');
        return;
      }

      if (authMethod == 'nsec') {
        try {
          final hexPrivkey = await authRepository.getHexPrivateKey();
          if (hexPrivkey != null) {
            final derivedPubkey = NostrKeyService.derivePublicKey(hexPrivkey);
            _log('Derived pubkey from stored privkey: $derivedPubkey');
            if (derivedPubkey != hexPubkey) {
              _log(
                'CRITICAL ERROR: Private key does not derive to public key!',
              );
              _log('You need to re-login with your NSEC');
              return;
            }
            _log('✓ Keys are valid and match');
          }
        } catch (e) {
          _log('Error verifying private key: $e');
          return;
        }
      } else if (authMethod == 'amber') {
        _log('Using Amber for signing (no local private key)');
      }

      // 2. Create Dummy File
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/test_upload_${DateTime.now().millisecondsSinceEpoch}.txt',
      );
      await file.writeAsString('Hello Nostr! This is a test upload.');
      _log('Created dummy file: ${file.path}');

      // 3. Upload to Blossom
      _log('Uploading to Blossom...');
      final blossomService = ref.read(blossomServiceProvider);
      final url = await blossomService.uploadFile(file, npub);

      if (url == null) {
        _log('Error: Upload failed');
        return;
      }
      _log('Upload successful: $url');

      // 4. Verify Download
      _log('Downloading file to verify...');
      final downloadDir = await getTemporaryDirectory();
      final downloadPath =
          '${downloadDir.path}/downloaded_${DateTime.now().millisecondsSinceEpoch}.txt';
      final downloadedFile = await blossomService.downloadFile(
        url,
        downloadPath,
      );
      if (downloadedFile == null) {
        _log('Error: Download failed');
        return;
      }

      final downloadedBytes = await downloadedFile.readAsBytes();
      _log('Downloaded ${downloadedBytes.length} bytes');

      // Calculate hashes
      final originalBytes = await file.readAsBytes();
      final originalHash = _calculateSha256(originalBytes);
      final downloadedHash = _calculateSha256(downloadedBytes);

      _log('Original hash:   $originalHash');
      _log('Downloaded hash: $downloadedHash');

      if (originalHash == downloadedHash) {
        _log('✓ SUCCESS: Hashes match! File integrity verified.');
      } else {
        _log('✗ FAILURE: Hashes do not match!');
        return;
      }

      // 5. Publish Metadata
      _log('Publishing metadata...');
      final authRepo = ref.read(authRepositoryProvider);
      final relayService = ref.read(nostrRelayServiceProvider);

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final dTag = 'test_doc_${DateTime.now().millisecondsSinceEpoch}';
      final tags = [
        ['d', dTag],
        ['title', 'Test Document'],
        ['url', url],
        ['m', 'text/plain'],
      ];
      final content = jsonEncode({
        'title': 'Test Document',
        'url': url,
        'type': 'text/plain',
      });

      final eventId = NostrEventBuilder.createEventId(
        1063,
        hexPubkey,
        now,
        tags,
        content,
      );

      // Note: Amber signing will fail here without full event JSON
      // This playground example only signs a hash
      final sig = await authRepo.sign(eventId);

      final event = NostrEvent(
        id: eventId,
        pubkey: hexPubkey,
        createdAt: now,
        kind: 1063,
        tags: tags,
        content: content,
        sig: sig,
      );

      await relayService.publishEvent(event);
      _log('Published event: ${event.id}');

      // 6. Wait
      _log('Waiting 3 seconds for propagation...');
      await Future.delayed(const Duration(seconds: 3));

      // 7. Query
      _log('Querying relay...');
      final filter = Filter(kinds: [1063], authors: [hexPubkey], limit: 10);
      _log('Filter: ${jsonEncode(filter.toJson())}');

      final events = await relayService.queryEvents([filter]);
      _log('Fetched ${events.length} events');

      bool found = false;
      for (final e in events) {
        _log('Event: ${e.id} (d=${_extractDTag(e.tags)})');
        if (e.id == eventId) {
          found = true;
          _log('SUCCESS: Found our published event!');
          break;
        }
      }

      if (!found) {
        _log('FAILURE: Could not find our published event.');
      }
    } catch (e, st) {
      _log('Error: $e');
      LoggerService.error('Playground test failed', e, st);
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  String? _extractDTag(List<List<String>> tags) {
    for (final tag in tags) {
      if (tag.length >= 2 && tag[0] == 'd') {
        return tag[1];
      }
    }
    return null;
  }

  String _calculateSha256(List<int> bytes) {
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Playground')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isRunning ? null : _runTest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: _isRunning
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('RUN SYNC TEST'),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    _logs[index],
                    style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
