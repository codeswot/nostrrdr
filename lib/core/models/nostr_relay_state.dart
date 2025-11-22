import 'package:freezed_annotation/freezed_annotation.dart';

part 'nostr_relay_state.freezed.dart';

@freezed
class NostrRelayState with _$NostrRelayState {
  const factory NostrRelayState({
    required String relay,
    @Default(false) bool connected,
    String? error,
  }) = _NostrRelayState;
}
