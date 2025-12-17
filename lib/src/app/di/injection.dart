import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:marmot_flutter/marmot_flutter.dart';
import 'package:nostrrdr/src/app/di/injection.config.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  await initMarmot();
  getIt.init();
}

Future<void> initMarmot() async {
  try {
    await RustLib.init();

    final dir = await getApplicationDocumentsDirectory();
    final dataDir = '${dir.path}/nostrrdr/data';
    final logsDir = '${dir.path}/nostrrdr/logs';

    await Directory(dataDir).create(recursive: true);
    await Directory(logsDir).create(recursive: true);

    final config = await createWhitenoiseConfig(
      dataDir: dataDir,
      logsDir: logsDir,
    );
    await initializeWhitenoise(config: config);
  } catch (e) {
    rethrow;
  }
}
