import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/models/nostr_event.dart';
import 'package:nostrrdr/core/services/logger_service.dart';
import 'package:nostrrdr/core/services/nostr_key_service.dart';
import 'package:nostrrdr/core/services/nostr_relay_service.dart';
import 'package:nostrrdr/features/auth/repositories/auth_repository.dart';

class ProfileRepository {
  final NostrRelayService _relayService;
  final AuthRepository _authRepository;
  final AppDatabase _database;

  ProfileRepository(this._relayService, this._authRepository, this._database);

  Stream<Profile?> watchProfile(String npub) {
    return _database.watchProfile(npub);
  }

  Future<void> refreshProfile(String npub) async {
    try {
      final hexPubkey = NostrKeyService.decodePublicKey(npub);
      final filter = Filter(kinds: [0], authors: [hexPubkey], limit: 1);

      final events = await _relayService.queryEvents([filter]);
      if (events.isEmpty) return;

      // Get the latest event
      events.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final event = events.first;

      final content = jsonDecode(event.content) as Map<String, dynamic>;

      await _database.upsertProfile(
        ProfilesCompanion(
          npub: Value(npub),
          name: Value(content['name'] as String?),
          about: Value(content['about'] as String?),
          picture: Value(content['picture'] as String?),
          nip05: Value(content['nip05'] as String?),
          createdAt: Value(
            DateTime.fromMillisecondsSinceEpoch(event.createdAt * 1000),
          ),
          refreshedAt: Value(DateTime.now()),
        ),
      );
    } catch (e, st) {
      LoggerService.error('Failed to refresh profile', e, st);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? about,
    String? picture,
    String? nip05,
  }) async {
    try {
      final npub = await _authRepository.getNpub();
      if (npub == null) throw Exception('Not authenticated');

      final hexPubkey = NostrKeyService.decodePublicKey(npub);

      // Fetch existing profile from DB to merge updates
      final existingProfile = await _database.getProfile(npub);

      final content = {
        if (existingProfile?.name != null) 'name': existingProfile!.name,
        if (existingProfile?.about != null) 'about': existingProfile!.about,
        if (existingProfile?.picture != null)
          'picture': existingProfile!.picture,
        if (existingProfile?.nip05 != null) 'nip05': existingProfile!.nip05,
        if (name != null) 'name': name,
        if (about != null) 'about': about,
        if (picture != null) 'picture': picture,
        if (nip05 != null) 'nip05': nip05,
      };

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final eventContent = jsonEncode(content);

      final eventId = NostrEventBuilder.createEventId(
        0,
        hexPubkey,
        now,
        [],
        eventContent,
      );

      final eventMap = {
        'id': eventId,
        'pubkey': hexPubkey,
        'created_at': now,
        'kind': 0,
        'tags': [],
        'content': eventContent,
      };

      final sig = await _authRepository.sign(
        eventId,
        eventJson: jsonEncode(eventMap),
      );

      final event = NostrEvent(
        id: eventId,
        pubkey: hexPubkey,
        createdAt: now,
        kind: 0,
        tags: [],
        content: eventContent,
        sig: sig,
      );

      await _relayService.publishEvent(event);

      // Optimistically update local DB
      await _database.upsertProfile(
        ProfilesCompanion(
          npub: Value(npub),
          name: Value(content['name']),
          about: Value(content['about']),
          picture: Value(content['picture']),
          nip05: Value(content['nip05']),
          createdAt: Value(DateTime.fromMillisecondsSinceEpoch(now * 1000)),
          refreshedAt: Value(DateTime.now()),
        ),
      );

      LoggerService.debug('Profile updated successfully');
    } catch (e, st) {
      LoggerService.error('Failed to update profile', e, st);
      rethrow;
    }
  }
}
