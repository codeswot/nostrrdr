import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nostrrdr/src/app/app.dart';
import 'package:nostrrdr/src/app/bloc/app_bloc_observer.dart';
import 'package:nostrrdr/src/app/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
  Bloc.observer = AppBlocObserver();
  runApp(NostrDrApp());
}
