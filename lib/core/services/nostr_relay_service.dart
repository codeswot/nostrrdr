import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nostrrdr/core/models/nostr_event.dart';
import 'package:nostrrdr/core/services/logger_service.dart';

class NostrRelayService {
  static const List<String> defaultRelays = [
    'wss://relay.damus.io',
    'wss://nostr-pub.wellorder.net',
    'wss://relay.snort.social',
  ];

  final List<String> relays;
  final Map<String, WebSocketChannel> _connections = {};
  final Map<String, StreamController<dynamic>> _streamControllers = {};

  NostrRelayService({List<String>? relayUrls})
    : relays = relayUrls ?? defaultRelays;

  Future<void> connect() async {
    for (final relayUrl in relays) {
      try {
        if (_connections.containsKey(relayUrl)) continue;

        LoggerService.debug('Connecting to relay: $relayUrl');
        final channel = WebSocketChannel.connect(Uri.parse(relayUrl));
        _connections[relayUrl] = channel;

        final controller = StreamController<dynamic>.broadcast();
        _streamControllers[relayUrl] = controller;

        channel.stream.listen(
          (event) {
            controller.add(event);
          },
          onError: (error) {
            LoggerService.error(
              'Relay connection error: $relayUrl',
              error,
              null,
            );
            controller.addError(error);
          },
          onDone: () {
            LoggerService.debug('Relay disconnected: $relayUrl');
          },
        );

        LoggerService.debug('Connected to relay: $relayUrl');
      } catch (e, st) {
        LoggerService.error('Failed to connect to relay: $relayUrl', e, st);
      }
    }
  }

  Future<List<NostrEvent>> queryEvents(List<Filter> filters) async {
    final subId = 'query_${DateTime.now().millisecondsSinceEpoch}';
    final req = ['REQ', subId, ...filters.map((f) => f.toJson())];

    final payload = jsonEncode(req);
    final events = <NostrEvent>[];
    final completer = Completer<List<NostrEvent>>();
    int eoseCount = 0;
    int connectedRelays = 0;

    final subscriptions = <StreamSubscription>[];

    for (final relayUrl in relays) {
      final controller = _streamControllers[relayUrl];
      final channel = _connections[relayUrl];
      if (channel == null || controller == null) continue;

      connectedRelays++;
      LoggerService.debug('Querying relay: $relayUrl with subId: $subId');

      try {
        channel.sink.add(payload);

        final subscription = controller.stream.listen(
          (message) {
            try {
              final data = jsonDecode(message as String);
              if (data is List && data.isNotEmpty) {
                final type = data[0];
                final subscriptionId = data[1];

                if (subscriptionId == subId) {
                  if (type == 'EVENT') {
                    final eventData = data[2];
                    events.add(NostrEvent.fromJson(eventData));
                  } else if (type == 'EOSE') {
                    eoseCount++;
                    if (eoseCount >= connectedRelays) {
                      if (!completer.isCompleted) completer.complete(events);
                    }
                  }
                }
              }
            } catch (e) {
              LoggerService.error('Error parsing relay message', e, null);
            }
          },
          onError: (error) {
            LoggerService.error('Relay stream error', error, null);
          },
        );
        subscriptions.add(subscription);
      } catch (e) {
        LoggerService.error('Failed to query relay: $relayUrl', e, null);
      }
    }

    if (connectedRelays == 0) {
      return [];
    }

    Future.delayed(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        LoggerService.debug('Query timeout, returning ${events.length} events');
        completer.complete(events);
      }
    });

    try {
      return await completer.future;
    } finally {
      for (final sub in subscriptions) {
        sub.cancel();
      }
      final close = jsonEncode(['CLOSE', subId]);
      for (final relayUrl in relays) {
        _connections[relayUrl]?.sink.add(close);
      }
    }
  }

  Future<void> publishEvent(NostrEvent event) async {
    final eventJson = [
      'EVENT',
      {
        'id': event.id,
        'pubkey': event.pubkey,
        'created_at': event.createdAt,
        'kind': event.kind,
        'tags': event.tags,
        'content': event.content,
        'sig': event.sig,
      },
    ];

    final payload = jsonEncode(eventJson);

    final failedRelays = <String>[];

    for (final relayUrl in relays) {
      try {
        final channel = _connections[relayUrl];
        if (channel == null) {
          LoggerService.warning('Relay not connected: $relayUrl');
          failedRelays.add(relayUrl);
          continue;
        }

        LoggerService.debug('Publishing event to relay: $relayUrl');
        channel.sink.add(payload);
        LoggerService.debug('Event published to relay: $relayUrl');
      } catch (e, st) {
        LoggerService.error('Failed to publish to relay: $relayUrl', e, st);
        failedRelays.add(relayUrl);
      }
    }

    if (failedRelays.isNotEmpty) {
      LoggerService.warning(
        'Event not published to ${failedRelays.length} relays: $failedRelays',
      );
    }
  }

  void disconnect() {
    for (final channel in _connections.values) {
      try {
        channel.sink.close();
      } catch (e) {
        LoggerService.error('Error closing relay connection', e, null);
      }
    }
    _connections.clear();

    for (final controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
  }
}
