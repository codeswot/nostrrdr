# NostrRdr

A lightweight, cross-platform document reader with Nostr synchronization. Read your PDFs anywhere and keep your reading progress synced across all your devices using the Nostr protocol.

## Features

- 📱 **Cross-Platform**: Works on Android, iOS, macOS, Linux, Windows, and Web
- 📖 **PDF Reader**: Smooth PDF viewing with page tracking
- 🔄 **Nostr Sync**: Synchronize your documents and reading progress across devices
- 🔐 **Nostr Authentication**: Login with nsec or Amber (coming soon)
- 📊 **Reading Progress**: Automatic tracking and syncing of your reading position
- 📚 **Offline-First**: All documents stored locally, Nostr used for sync only
- ⏱️ **Smart Sorting**: Documents sorted by recently read

## Architecture

Built using:
- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **PDF Rendering**: pdfrx
- **Routing**: go_router


## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/codeswot/nostrrdr.git
   cd nostrrdr
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation** (for Drift database)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   
   For mobile (Android/iOS):
   ```bash
   flutter run
   ```
   
   For desktop (macOS/Linux/Windows):
   ```bash
   flutter run -d macos    # macOS
   flutter run -d linux    # Linux
   flutter run -d windows  # Windows
   ```
   
   For web:
   ```bash
   flutter run -d chrome
   ```

### Running Tests

```bash
flutter test
```

## Usage

### First Time Setup

1. **Create Account or Login**
   - Create a new Nostr account (generates new keys)
   - Login with existing nsec key

2. **Add Documents**
   - Tap the + button
   - Select a PDF file
   - Document is added to your library

3. **Read & Sync**
   - Open any document to start reading
   - Your progress is automatically tracked   
   - Pull to refresh to sync with Nostr relays

### Nostr Event Kinds

- **Kind 30001**: Reading progress (page number)
- **Kind 1063**: Document metadata

## Project Structure

```
lib/
├── core/
│   ├── database/        # Drift database
│   ├── providers/       # Riverpod providers
│   ├── routing/         # GoRouter configuration
│   ├── services/        # Core services
│   └── theme/           # App theme
├── features/
│   ├── auth/            # Authentication
│   ├── home/            # Library screen
│   ├── profile/         # User profile
│   ├── reader/          # PDF reader
│   └── sync/            # Nostr synchronization
└── main.dart
```

## Configuration

### Nostr Relays

Relays are configured in `lib/features/sync/providers/sync_provider.dart`. The default relays include:
- wss://relay.damus.io
- wss://nos.lol
- wss://relay.nostr.band

You can modify the relay list by editing the `NostrRelayService` configuration.

### Theme

The app uses a glossy purple Material 3 theme with full dark mode support. Theme preference is persisted locally.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Built with [Flutter](https://flutter.dev)
- PDF rendering with [pdfrx](https://pub.dev/packages/pdfrx)
- Nostr protocol integration

## Support

For issues and feature requests, please use the [GitHub Issues](https://github.com/codeswot/nostrrdr/issues) page.
