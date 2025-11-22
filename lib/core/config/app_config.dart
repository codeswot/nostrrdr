class AppConfig {
  static const List<String> defaultRelays = [
    'wss://relay.damus.io',
    'wss://nostr.wine',
    'wss://relay.snort.social',
    'wss://nos.lol',
  ];

  // Event Kinds (Nostr NIP-01)
  static const int eventKindReadingProgress = 30001; // Parametrized Replaceable
  static const int eventKindDocumentMetadata = 1063; // File Metadata

  static const String appName = 'Nostr Document Reader';
  static const String appVersion = '1.0.0';

  static const String documentsFolder = 'documents';
  static const String thumbnailsFolder = 'thumbnails';

  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration readingProgressSyncInterval = Duration(seconds: 30);
}
