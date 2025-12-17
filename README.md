# NostrDR: Decentralized Social Book Reader
*Built on the Marmot Protocol*

## 1. Overview
NostrDR is a lightweight, fast, and secure book reader designed for the Nostr ecosystem. It combines a sleek, minimalist reading experience with powerful social features, allowing users to form "Study Groups," track progress together, and incentivize reading through Bitcoin Lightning zaps.

## 2. Technical Stack
- **Frontend**: Flutter (Cross-platform mobile/desktop app)
- **Architecture**: Feature-First + BLoC
- **State Management**: BLoC
- **Routing**: `auto_route`
- **Dependency Injection**: `get_it` `injectable`
- **Backend/Protocol**: [Marmot Protocol](https://github.com/marmot-protocol/marmot) (Serverless, decentralized storage & messaging)
- **SDK**: [Marmot Rust SDK](https://github.com/marmot-protocol/mdk) (Integrated via FFI/Flutter Rust Bridge)
- **Testing Strategy**: Test-first approach, clean minimal unit tests, and integration tests.
