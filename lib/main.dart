import 'package:flutter/material.dart';
import 'package:nostrrdr/src/app/app.dart';
import 'package:nostrrdr/src/app/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(NostrDrApp());
}
