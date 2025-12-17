import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nostrrdr/src/app/app.dart';
import 'package:nostrrdr/src/app/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  Logger.root.level = Level.ALL;
  runApp(NostrDrApp());
}
