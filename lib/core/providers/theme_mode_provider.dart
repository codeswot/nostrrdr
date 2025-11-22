import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppThemeMode {
  system,
  light,
  dark;

  String get displayName {
    switch (this) {
      case AppThemeMode.system:
        return 'System (default)';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  static AppThemeMode fromString(String? value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }
}

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier(this._storage) : super(AppThemeMode.system) {
    _loadThemeMode();
  }

  final FlutterSecureStorage _storage;
  static const _themeModeKey = 'theme_mode';

  Future<void> _loadThemeMode() async {
    final savedMode = await _storage.read(key: _themeModeKey);
    state = AppThemeMode.fromString(savedMode);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = mode;
    await _storage.write(key: _themeModeKey, value: mode.name);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
      final storage = ref.watch(secureStorageProvider);
      return ThemeModeNotifier(storage);
    });

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});
