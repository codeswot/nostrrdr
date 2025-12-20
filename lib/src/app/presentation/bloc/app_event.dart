import 'package:equatable/equatable.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_state.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppActivePubKeyChanged extends AppEvent {
  final String? activePubKey;

  const AppActivePubKeyChanged(this.activePubKey);

  @override
  List<Object?> get props => [activePubKey];
}

class AppThemeModeChanged extends AppEvent {
  final AppThemeMode themeMode;

  const AppThemeModeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
