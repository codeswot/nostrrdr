import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:nostrrdr/core/models/nostr_event.dart';
import 'package:nostrrdr/core/services/logger_service.dart';
import 'package:nostrrdr/core/services/nostr_key_service.dart';
import 'package:nostrrdr/features/auth/repositories/auth_repository.dart';

class BlossomService {
  static const String defaultBlossomServer = 'https://blossom.primal.net';
  final String blossomServer;
  final AuthRepository _authRepository;
  final http.Client _httpClient = http.Client();

  BlossomService(this._authRepository, {String? server})
    : blossomServer = server ?? defaultBlossomServer;

  Future<String?> uploadFile(File file, String npub) async {
    try {
      LoggerService.debug('Uploading file to Blossom: ${file.path}');

      if (!await file.exists()) {
        LoggerService.error('File does not exist: ${file.path}', null, null);
        return null;
      }

      final bytes = await file.readAsBytes();
      final fileHash = sha256.convert(bytes).toString();

      final url = '$blossomServer/upload';
      final authHeader = await _createAuthHeader(
        'PUT',
        url,
        npub,
        verb: 'upload',
        fileHash: fileHash,
      );

      if (authHeader == null) {
        LoggerService.error('Failed to create auth header', null, null);
        return null;
      }

      final response = await _httpClient.put(
        Uri.parse(url),
        headers: {
          'Authorization': authHeader,
          // 'Content-Type': 'application/pdf', // Blossom might detect or require specific type
        },
        body: bytes,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final blossomUrl = json['url'] as String;
        LoggerService.debug('File uploaded to Blossom: $blossomUrl');
        return blossomUrl;
      } else {
        LoggerService.error(
          'Blossom upload failed with status ${response.statusCode}: ${response.body}',
          null,
          null,
        );
        return null;
      }
    } catch (e, st) {
      LoggerService.error('Failed to upload file to Blossom', e, st);
      return null;
    }
  }

  Future<String?> _createAuthHeader(
    String method,
    String url,
    String npub, {
    String? verb,
    String? fileHash,
  }) async {
    try {
      final hexPubkey = NostrKeyService.decodePublicKey(npub);

      if (!NostrKeyService.isValidHexKey(hexPubkey)) {
        LoggerService.error('Invalid hex pubkey: $hexPubkey', null, null);
        throw Exception('Invalid hex public key format');
      }

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final expiration = now + 60;

      final authVerb = verb ?? method.toLowerCase();
      final tags = [
        ['t', authVerb],
        ['expiration', expiration.toString()],
      ];

      if (fileHash != null) {
        tags.add(['x', fileHash]);
      }

      final content = 'Upload file to Blossom';

      final eventId = NostrEventBuilder.createEventId(
        24242,
        hexPubkey,
        now,
        tags,
        content,
      );

      final eventData = [0, hexPubkey, now, 24242, tags, content];
      final serialized = jsonEncode(eventData);
      LoggerService.debug('Event data for hashing: $serialized');
      LoggerService.debug('Blossom Auth Event ID: $eventId');
      LoggerService.debug('Blossom Hex Pubkey: $hexPubkey');
      LoggerService.debug('Blossom Hex Pubkey Length: ${hexPubkey.length}');
      LoggerService.debug('Blossom Tags: ${jsonEncode(tags)}');

      final eventMap = {
        'id': eventId,
        'pubkey': hexPubkey,
        'created_at': now,
        'kind': 24242,
        'tags': tags,
        'content': content,
      };

      final sig = await _authRepository.sign(
        eventId,
        eventJson: jsonEncode(eventMap),
      );
      LoggerService.debug('Blossom Signature: $sig');

      final event = NostrEvent(
        id: eventId,
        pubkey: hexPubkey,
        createdAt: now,
        kind: 24242,
        tags: tags,
        content: content,
        sig: sig,
      );

      final eventJson = jsonEncode(event.toJson());
      LoggerService.debug('Blossom Auth Event JSON: $eventJson');
      final base64Event = base64Encode(utf8.encode(eventJson));
      return 'Nostr $base64Event';
    } catch (e, st) {
      LoggerService.error('Failed to create Blossom auth header', e, st);
      return null;
    }
  }

  Future<File?> downloadFile(String blossomUrl, String savePath) async {
    try {
      LoggerService.debug('Downloading file from Blossom: $blossomUrl');

      final response = await _httpClient
          .get(Uri.parse(blossomUrl))
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () => throw Exception('Blossom download timeout'),
          );

      if (response.statusCode == 200) {
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        LoggerService.debug('File saved to: $savePath');
        return file;
      } else {
        LoggerService.error(
          'Blossom download failed with status ${response.statusCode}',
          null,
          null,
        );
        return null;
      }
    } catch (e, st) {
      LoggerService.error('Failed to download file from Blossom', e, st);
      return null;
    }
  }

  void close() {
    _httpClient.close();
  }
}
