import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppThemeMode {
  light,
  dark,
  system;

  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}

class AppState extends Equatable {
  final String? activePubKey;
  final AppThemeMode themeMode;

  const AppState({this.activePubKey, this.themeMode = AppThemeMode.system});

  AppState copyWith({
    Object? activePubKey = _undefined,
    AppThemeMode? themeMode,
  }) {
    return AppState(
      activePubKey: activePubKey == _undefined
          ? this.activePubKey
          : activePubKey as String?,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  static const _undefined = Object();

  Map<String, dynamic> toJson() {
    return {'active_pub_key': activePubKey, 'theme_mode': themeMode.index};
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      activePubKey: json['active_pub_key'] as String?,
      themeMode: json['theme_mode'] != null
          ? AppThemeMode.values[json['theme_mode'] as int]
          : AppThemeMode.system,
    );
  }

  @override
  List<Object?> get props => [activePubKey, themeMode];
}
