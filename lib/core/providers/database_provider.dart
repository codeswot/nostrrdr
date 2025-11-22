import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/database/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final documentsRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return database;
});
