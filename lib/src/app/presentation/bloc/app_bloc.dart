import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_event.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_state.dart';

@lazySingleton
class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppActivePubKeyChanged>(_onActivePubKeyChanged);
    on<AppThemeModeChanged>(_onThemeModeChanged);
  }

  void _onActivePubKeyChanged(
    AppActivePubKeyChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(activePubKey: event.activePubKey));
  }

  void _onThemeModeChanged(AppThemeModeChanged event, Emitter<AppState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return state.toJson();
  }
}
