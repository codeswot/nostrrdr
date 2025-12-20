import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nostrrdr/src/app/app.dart';
import 'package:nostrrdr/src/app/presentation/bloc/app_bloc_observer.dart';
import 'package:nostrrdr/src/app/di/injection.dart';
import 'package:nostrrdr/src/core/storage/secure_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final keyManager = SecureStorageKeyManager(storage: secureStorage);
  final encryptionKey = await keyManager.getEncryptionKey();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
    encryptionCipher: HydratedAesCipher(encryptionKey),
  );

  Bloc.observer = AppBlocObserver();
  runApp(NostrDrApp());
}
