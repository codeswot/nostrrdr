import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_bloc.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_event.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_state.dart';

void main() {
  group('AppBloc', () {
    late Storage storage;

    setUp(() {
      storage = MockStorage();
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
    });

    test('initial state is correct', () {
      expect(AppBloc().state, const AppState());
    });

    group('AppActivePubKeyChanged', () {
      blocTest<AppBloc, AppState>(
        'emits [AppState] with updated activePubKey',
        build: () => AppBloc(),
        act: (bloc) => bloc.add(const AppActivePubKeyChanged('test-pub-key')),
        expect: () => const [AppState(activePubKey: 'test-pub-key')],
      );
    });

    group('AppThemeModeChanged', () {
      blocTest<AppBloc, AppState>(
        'emits [AppState] with updated themeMode',
        build: () => AppBloc(),
        act: (bloc) => bloc.add(const AppThemeModeChanged(AppThemeMode.dark)),
        expect: () => const [AppState(themeMode: AppThemeMode.dark)],
      );
    });

    group('Hydration', () {
      test('fromJson returns correct state', () {
        final bloc = AppBloc();
        final json = {
          'active_pub_key': 'test-pub-key',
          'theme_mode': 1, // AppThemeMode.dark index
        };
        final state = bloc.fromJson(json);
        expect(
          state,
          const AppState(
            activePubKey: 'test-pub-key',
            themeMode: AppThemeMode.dark,
          ),
        );
      });

      test('toJson returns correct json', () {
        final bloc = AppBloc();
        const state = AppState(
          activePubKey: 'test-pub-key',
          themeMode: AppThemeMode.dark,
        );
        final json = bloc.toJson(state);
        expect(json, {'active_pub_key': 'test-pub-key', 'theme_mode': 1});
      });
    });
  });
}

class MockStorage extends Mock implements Storage {}
