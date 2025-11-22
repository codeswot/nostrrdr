import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/providers/storage_provider.dart';
import 'package:nostrrdr/features/auth/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(storage);
});

class AuthStateNotifier extends StateNotifier<AsyncValue<String?>> {
  final AuthRepository _repository;

  AuthStateNotifier(this._repository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final publicKey = await _repository.restoreSession();
      state = AsyncValue.data(publicKey);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<({String nsec, String npub})> registerNewAccount() async {
    try {
      state = const AsyncValue.loading();
      final result = await _repository.registerNewAccount();
      state = AsyncValue.data(result.npub);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<({String nsec, String npub})> loginWithNsec(String nsecOrHex) async {
    try {
      state = const AsyncValue.loading();
      final result = await _repository.loginWithNsec(nsecOrHex);
      state = AsyncValue.data(result.npub);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> loginWithAmber(String npubOrHex) async {
    try {
      state = const AsyncValue.loading();
      final pk = await _repository.loginWithAmber(npubOrHex);
      state = AsyncValue.data(pk);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    try {
      state = const AsyncValue.loading();
      await _repository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<String?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repository);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (pk) => pk != null,
    orElse: () => false,
  );
});

final currentPublicKeyProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (pk) => pk,
    orElse: () => null,
  );
});

final currentNpubProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (npub) => npub,
    orElse: () => null,
  );
});
