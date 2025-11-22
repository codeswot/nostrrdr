import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/providers/database_provider.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/profile/repositories/profile_repository.dart';
import 'package:nostrrdr/features/sync/providers/sync_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final relayService = ref.watch(nostrRelayServiceProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final database = ref.watch(databaseProvider);
  return ProfileRepository(relayService, authRepository, database);
});

final profileProvider = StreamProvider.autoDispose<Profile?>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  final npub = ref.watch(currentNpubProvider);

  if (npub == null) return const Stream.empty();

  repository.refreshProfile(npub);

  return repository.watchProfile(npub);
});

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;
  ProfileController(this._repository) : super(const AsyncValue.data(null));

  Future<void> updateProfile({
    String? name,
    String? about,
    String? nip05,
    String? picture,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProfile(
        name: name,
        about: about,
        nip05: nip05,
        picture: picture,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return ProfileController(repository);
    });
