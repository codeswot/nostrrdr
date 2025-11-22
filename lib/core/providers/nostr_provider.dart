import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/config/app_config.dart';
import 'package:nostrrdr/core/models/nostr_relay_state.dart';

final nostrRelaysProvider =
    StateNotifierProvider<NostrRelaysNotifier, List<NostrRelayState>>((ref) {
  return NostrRelaysNotifier();
});

class NostrRelaysNotifier extends StateNotifier<List<NostrRelayState>> {
  NostrRelaysNotifier()
      : super(
          AppConfig.defaultRelays
              .map((relay) => NostrRelayState(relay: relay))
              .toList(),
        );

  void updateRelayStatus(String relay, bool connected, {String? error}) {
    state = state.map((r) {
      if (r.relay == relay) {
        return r.copyWith(connected: connected, error: error);
      }
      return r;
    }).toList();
  }

  bool get isConnected => state.any((relay) => relay.connected);
}

final userPublicKeyProvider = StateProvider<String?>((ref) => null);

final authMethodProvider = StateProvider<AuthMethod?>((ref) => null);

enum AuthMethod { nsec, amber }
